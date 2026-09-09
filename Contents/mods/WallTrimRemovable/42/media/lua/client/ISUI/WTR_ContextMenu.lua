--***********************************************************
--**                       AMENOPHIS                       **
--***********************************************************

local ContextMenu = {};

local goodHighlightColor = getCore():getGoodHighlitedColor();
local badHighlightColor = getCore():getBadHighlitedColor();

local function onDisassemble(playerObj, worldObjects, disassemblable, data, tool, tool2, key)
    if(tool) then
        ISInventoryPaneContextMenu.equipWeapon(tool, true, not tool2, playerObj:getPlayerNum());
    end

    if(tool2) then
        ISInventoryPaneContextMenu.equipWeapon(tool2, false, false, playerObj:getPlayerNum());
    end

    local square = disassemblable.object:getSquare();
    
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square));
    ISTimedActionQueue.add(WTR.Disassemble:new(playerObj, disassemblable, data, square, tool, tool2, key, true));
end

local function buildTooltipDescription(data, playerInv, col1Width)
    local description = "";

    local lines = {
        { key = "name", txt = getText("IGUI_Name") },
        { key = "toolRequired", txt = getText("IGUI_Tool") },
        { key = "toolRequired2", txt = getText("IGUI_Tool") },
    };

    for _, line in ipairs(lines) do
        local toolData = data[line.key];
        
        if(line.key ~= "toolRequired2" or toolData) then
            local text = string.format(" <RGB:1,1,1> %s%s ", line.txt, getText("IGUI_WTR_Colon"));

            if((line.key == "toolRequired" or line.key == "toolRequired2") and instanceof(toolData, "ItemTag")) then
                local itemsWithTag = getScriptManager():getItemsTag(toolData);
                local hasTool = playerInv:getCountTag(toolData) > 0;
                local color = hasTool and goodHighlightColor or badHighlightColor;
                local r, g, b = color:getR(), color:getG(), color:getB();

                local uniqueNames = {};
                local nameList = {};

                for i = 0, itemsWithTag:size() - 1 do
                    local itemName = itemsWithTag:get(i):getDisplayName();
                    if(not uniqueNames[itemName]) then
                        uniqueNames[itemName] = true;
                        table.insert(nameList, string.format("<SETX:%d> <INDENT:%d> <RGB:%.2f,%.2f,%.2f>%s", col1Width, col1Width, r, g, b, itemName));
                    end
                end

                text = text .. table.concat(nameList, " <LINE> ");
            elseif(line.key ~= "toolRequired2") then
                text = string.format("%s <SETX:%d> <INDENT:%d>%s", text, col1Width, col1Width, tostring(toolData));
            end

            description = description .. text .. " <LINE> <INDENT:0> ";
        end
    end

    return description;
end

local currentHLDis = nil;
local currentHLSq = nil;

function ContextMenu.createMenu(player, context, worldObjects, test)
    local playerObj = getSpecificPlayer(player);
    if(playerObj:isAsleep()) then return; end

    local playerInv = playerObj:getInventory();

    local zoom = getCore():getZoom(player);
    local wz = playerObj:getZ();
    local wx = IsoUtils.XToIso(getMouseX() * zoom, getMouseY() * zoom, wz);
    local wy = IsoUtils.YToIso(getMouseX() * zoom, getMouseY() * zoom, wz);

    local square = getCell():getGridSquare(math.floor(wx), math.floor(wy), wz);
    if(not square) then return; end

    local disassemblables = WTR.getDisassemblables(square:getObjects());
    
    local hasDisassemblables = false;
    for _ in pairs(disassemblables) do
        hasDisassemblables = true;
        break
    end
    if(not hasDisassemblables) then return; end

    local disassembleText = getText("ContextMenu_Disassemble");
    local disassembleOption = nil;
    local disassembleSubMenu = nil;

    for _, opt in ipairs(context.options) do
        if(opt.name == disassembleText) then
            disassembleOption = opt;
            break
        end
    end

    local disassembleMenuExist = disassembleOption ~= nil;

    if(disassembleMenuExist) then
        disassembleSubMenu = context:getSubMenu(disassembleOption.subOption);
    else
        disassembleSubMenu = ISContextMenu:getNew(context);
    end

    local tooltipFont = ISToolTip.GetFont();
    local col1Width = 0;
    local labelLines = { getText("IGUI_Name"), getText("IGUI_Tool") };
    
    for _, txt in ipairs(labelLines) do
        local textWid = getTextManager():MeasureStringX(tooltipFont, string.format("%s%s ", txt, getText("IGUI_WTR_Colon")));
        col1Width = math.max(col1Width, textWid + 10);
    end

    local index = 1;
    for key, disassemblable in pairs(disassemblables) do
        local data = WTR.DISASSEMBLABLE_SPRITES[key];

        local tool = data.toolRequired and playerInv:getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired) or nil;
        local tool2 = data.toolRequired2 and playerInv:getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired2) or nil;

        local option = disassembleSubMenu:addOption(data.name, playerObj, onDisassemble, worldObjects, disassemblable, data, tool, tool2, key);
        
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        toolTip:setTexture(key);
        toolTip.description = buildTooltipDescription(data, playerInv, col1Width);
        
        option.toolTip = toolTip;

        option.onHighlightParams = { disassemblable, badHighlightColor };
        option.onHighlight = function(_, menu, isHighlighted, object, color)
            
            if(currentHLDis ~= disassemblable) then
                currentHLDis = disassemblable;
                currentHLSq = square;
            elseif not isHighlighted then
                currentHLDis = nil;
                currentHLSq = nil;
            end
        end

        if(not tool or (data.toolRequired2 and not tool2)) then
            option.notAvailable = true;
        end

        index = index + 1;
    end

    if(not disassembleMenuExist) then
        disassembleOption = context:addOption(disassembleText, nil, nil);
        disassembleOption.iconTexture = getTexture("Item_Hammer");
        context:addSubMenu(disassembleOption, disassembleSubMenu);
    end
end

local function OnPostRender()
    
    if(currentHLDis and currentHLSq) then
        WTR.highlightDisassemblable(currentHLDis, currentHLSq:getX(), currentHLSq:getY(), currentHLSq:getZ());
    end
end

Events.OnFillWorldObjectContextMenu.Add(ContextMenu.createMenu);
Events.OnPostRender.Add(OnPostRender);

return ContextMenu;