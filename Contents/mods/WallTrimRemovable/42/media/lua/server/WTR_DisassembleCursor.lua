--***********************************************************
--**                       AMENOPHIS                       **
--***********************************************************

require "BuildingObjects/ISBuildingObject";

local DisassembleCursor = ISBuildingObject:derive("DisassembleCursor");

WTR = WTR or {};
WTR.DisassembleCursor = DisassembleCursor;

local ghc = getCore():getGoodHighlitedColor();
local bhc = getCore():getBadHighlitedColor();


function DisassembleCursor:create(x, y, z, north, sprite)
	local playerObj = self.character;
	local sq = getSquare(x, y, z);
	self:walkTo(x, y, z);

    local disassemblable = nil;
    local data = nil;
    local tool = nil;
    local tool2 = nil;
    local key = nil;

    local i = 1;
    for k, v in pairs(self.disassemblables) do

        if(i == self.objIndex) then
            disassemblable = v;
            data =  WTR.DISASSEMBLABLE_SPRITES[k];
            if(data.toolRequired) then
                tool = playerObj:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired);
            end
            if(data.toolRequired2) then
                tool2 = playerObj:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired2);
            end
            key = k;
        end

        i = i + 1;
    end

    local hasToolRequirement = true;
    local hasTool2Requirement = true;
    if(data.toolRequired and not tool) then hasToolRequirement = false; end
    if(data.toolRequired2 and not tool2) then hasTool2Requirement = false; end

    if(disassemblable and data and hasToolRequirement and hasTool2Requirement and key) then
        if(data.toolRequired) then
            ISInventoryPaneContextMenu.equipWeapon(tool, true, not tool2, playerObj:getPlayerNum());
        end
        if(data.toolRequired2) then
            ISInventoryPaneContextMenu.equipWeapon(tool2, false, false, playerObj:getPlayerNum());
        end
        ISTimedActionQueue.add(WTR.Disassemble:new(playerObj, disassemblable, data, sq, tool, key));
    end
end

function DisassembleCursor:walkTo(x, y, z)
	local playerObj = self.character;
	local sq = getSquare(x, y, z);
    if playerObj:getCurrentSquare() == sq then
        return true;
    end

    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, sq));
	return true;
end


function DisassembleCursor:isValid(square)
	return self:isValidArea(square:getX(), square:getY(), square:getZ());
end

function DisassembleCursor:isValidArea(x, y, z, renderMode)
	renderMode = renderMode or false;
	local playerInv = self.character:getInventory();
    if(self.tool and not playerInv:contains(self.tool)) then return false; end
    if(self.tool2 and not playerInv:contains(self.tool2)) then return false; end
	local sq = getCell():getGridSquare(x, y, z);
	if not sq then return false; end



    self.disassemblables = WTR.getDisassemblables(sq:getObjects());

    local count = 0;
    
    for _ in pairs(self.disassemblables) do
        count = count + 1;
    end
	
	local isCouldSee = sq:isCouldSee(self.character:getPlayerNum());

	return count > 0 and isCouldSee;
end

function DisassembleCursor:isRunningAction()
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
    return actionQueue and actionQueue.queue and actionQueue.queue[1];
end

function DisassembleCursor:render(x, y, z, square)
	if self:isRunningAction() then return; end

    local disassemblable = nil;
    local index = nil;

    local i = 1;

    for k, v in pairs(self.disassemblables) do

        if(i == self.objIndex) then
            disassemblable = v;
            index = i;
            local data =  WTR.DISASSEMBLABLE_SPRITES[k];
            if(data.toolRequired) then
                self.tool = self.character:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired);
            end
            if(data.toolRequired2) then
                self.tool2 = self.character:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, data.toolRequired2);
            end
            break
        end

        i = i + 1;
    end

    if(disassemblable and self:isValid(square)) then
        local aSprite = disassemblable.object:getAttachedAnimSprite():get(index - 1);
        local spriteRender = aSprite:getParentSprite();
		local r,g,b,a = 1.0,0.0,0.0,0.8;
		spriteRender:RenderGhostTileColor(x, y, z, r, g, b, a);
    end

	local bValid = self:isValidArea(x, y, z, true);
	if bValid then
		renderIsoRect(x + 1, y + 1, z, 1, ghc:getR(), ghc:getG(), ghc:getB(), 0.5, 1);
	else
		renderIsoRect(x + 1, y + 1, z, 1, bhc:getR(), bhc:getG(), bhc:getB(), 0.5, 1);
	end

    
end

function DisassembleCursor:onJoypadPressButton(joypadIndex, joypadData, button)
	if button == Joypad.AButton or button == Joypad.BButton then
		return ISBuildingObject.onJoypadPressButton(self, joypadIndex, joypadData, button);
	end
end

function DisassembleCursor:getAPrompt()
	return getText("ContextMenu_Disassemble");
end

function DisassembleCursor:getYPrompt()
	return nil;
end

function DisassembleCursor:getLBPrompt()
	return nil;
end

function DisassembleCursor:getRBPrompt()
	return nil;
end

function DisassembleCursor:new(character, tool, tool2)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o:init();
	o.character = character;
	o.tool = tool;
	o.tool2 = tool2;
	o.player = character:getPlayerNum();
	o.skipBuildAction = true;
	o.noNeedHammer = true;
	o.renderFloorHelper = true;

    o.disassemblables = nil;
    
    o.objIndex = 1;

	return o;
end
