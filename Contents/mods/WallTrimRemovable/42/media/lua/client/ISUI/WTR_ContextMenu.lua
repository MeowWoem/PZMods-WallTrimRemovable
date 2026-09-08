--***********************************************************
--**                       AMENOPHIS                       **
--***********************************************************

local ContextMenu = {};

local ghc = getCore():getGoodHighlitedColor();
local bhc = getCore():getBadHighlitedColor();

local function onDisassemble(playerObj, worldObjects, disassemblable, data, tool, tool2, key)

    if(tool) then
        ISInventoryPaneContextMenu.equipWeapon(tool, true, not tool2, playerObj:getPlayerNum());
    end

    if(tool2) then
        ISInventoryPaneContextMenu.equipWeapon(tool2, false, false, playerObj:getPlayerNum());
    end

    local sq = disassemblable.object:getSquare();
    
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, sq));
	ISTimedActionQueue.add(WTR.Disassemble:new(playerObj, disassemblable, data, sq, tool, tool2, key, true));

end

function ContextMenu.createMenu(player, context, worldObjects, test)
    local playerObj = getSpecificPlayer(player);
    local playerInv = playerObj:getInventory();
    if playerObj:isAsleep() then return; end

    local zoom = getCore():getZoom(player);
	local wz = playerObj:getZ();
	local wx = IsoUtils.XToIso(getMouseX() * zoom, getMouseY() * zoom, wz);
	local wy = IsoUtils.YToIso(getMouseX() * zoom, getMouseY() * zoom, wz);

	local square = getCell():getGridSquare(math.floor(wx), math.floor(wy), wz);


    local disassemblables = WTR.getDisassemblables(square:getObjects());

    local count = 0;
    
    for _ in pairs(disassemblables) do
        count = count + 1;
    end

    if(count == 0) then return; end

    local disassembleText = getText("ContextMenu_Disassemble");
    local disassembleOption = nil;
    local disassembleSubMenu = nil;

    for _, opt in ipairs(context.options) do
        if opt.name == disassembleText then
            disassembleOption = opt;
            break
        end
    end

    local disassembleMenuExist = false;

    if disassembleOption then
        disassembleSubMenu = context:getSubMenu(disassembleOption.subOption);
        disassembleMenuExist = true;
    else
        disassembleSubMenu = ISContextMenu:getNew(context);
    end

    for key, disassemblable in pairs(disassemblables) do

        local data = WTR.DISASSEMBLABLE_SPRITES[key];

        local tool = nil;
        local tool2 = nil;
        if(data.toolRequired) then
            tool = playerInv:getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired);
        end
        if(data.toolRequired2) then
            tool2 = playerInv:getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired2);
        end

        local option = disassembleSubMenu:addOption(data.name, playerObj, onDisassemble, worldObjects, disassemblable, data, tool, tool2, key);
        local tooltipFont = ISToolTip.GetFont();
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);

        local lines = {
            {
                key = "name",
                txt = getText("IGUI_Name")
            },
            {
                key = "toolRequired",
                txt = getText("IGUI_Tool")
            },
            {
                key = "toolRequired2",
                txt = getText("IGUI_Tool")
            },
        };

        local col1Width = 0;

        for i, v in ipairs(lines) do
            local textWid = getTextManager():MeasureStringX(tooltipFont, string.format("%s%s ", v.txt, getText("IGUI_WTR_Colon")));
            col1Width = math.max(col1Width, textWid + 10);
        end

        for i, v in ipairs(lines) do
            local text = "";
            if(v.key ~= "toolRequired2" or (v.key == "toolRequired2" and data[v.key])) then
                text = string.format("%s <RGB:1,1,1> %s%s ", text, v.txt, getText("IGUI_WTR_Colon"));
            end
            if((v.key == "toolRequired" or (v.key == "toolRequired2" and data[v.key])) and instanceof(data[v.key], "ItemTag")) then
               
                local itemsWithTag = getScriptManager():getItemsTag(data[v.key]);
                local r, g, b = ghc:getR(), ghc:getG(), ghc:getB();
                if(playerInv:getCountTag(data[v.key]) == 0) then
                    r, g, b = bhc:getR(), bhc:getG(), bhc:getB();
                end
                local alreadyInList = {};
                local offset = 0;
                for i = 1, itemsWithTag:size() do
                    local item = itemsWithTag:get(i - 1);
                    if(not alreadyInList[item:getDisplayName()]) then
                        alreadyInList[item:getDisplayName()] = true;
                    else
                        offset = offset + 1;
                    end
                end
                alreadyInList = {};
                local j = 1;
                for i = 1, itemsWithTag:size() do
                    local item = itemsWithTag:get(i - 1);
                    if(not alreadyInList[item:getDisplayName()]) then
                        text = string.format("%s <SETX:%d> <INDENT:%d> <RGB:%.2f,%.2f,%.2f>%s", text, col1Width, col1Width, r, g, b, item:getDisplayName());
                        if(j < itemsWithTag:size() - offset) then
                            text = text .. " <LINE> ";
                        end
                        alreadyInList[item:getDisplayName()] = true;
                        j = j + 1;
                    end
                end
            elseif(v.key ~= "toolRequired2") then
                text = string.format("%s <SETX:%d> <INDENT:%d>%s", text, col1Width, col1Width, data[v.key]);
            end
            if(v.key ~= "toolRequired2" or (v.key == "toolRequired2" and data[v.key])) then
                text = text .. " <LINE> <INDENT:0> ";
            end
            
            toolTip.description = toolTip.description .. text;
        end
    
        toolTip:setTexture(key);
        option.toolTip = toolTip;

        if(not tool or (data.toolRequired2 and not tool2)) then
            option.notAvailable = true;
        end
    end

    if(not disassembleMenuExist) then
        disassembleOption = context:addOption(disassembleText, nil, nil);
        disassembleOption.iconTexture = getTexture("Item_Hammer");
        context:addSubMenu(disassembleOption, disassembleSubMenu);
    end


end

Events.OnFillWorldObjectContextMenu.Add(ContextMenu.createMenu);

return ContextMenu;