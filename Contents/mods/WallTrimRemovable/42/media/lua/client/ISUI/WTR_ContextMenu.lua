--***********************************************************
--**                       AMENOPHIS                       **
--***********************************************************

local ContextMenu = {};

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

        local option = disassembleSubMenu:addOption("WALL TRIM", playerObj, onDisassemble, worldObjects, disassemblable, data, tool, tool2, key);

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