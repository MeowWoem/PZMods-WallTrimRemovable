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
	local sq = getSquare(x, y, z);
	self:walkTo(x, y, z);

    local res = WTR.getDisassemblableFromTable(self.character, self.disassemblables, self.objIndex, true);

    local hasToolRequirement = true;
    local hasTool2Requirement = true;
    if(res.data.toolRequired and not res.tool) then hasToolRequirement = false; end
    if(res.data.toolRequired2 and not res.tool2) then hasTool2Requirement = false; end

    if(res.disassemblable and res.data and hasToolRequirement and hasTool2Requirement and res.key) then
        if(res.data.toolRequired) then
            ISInventoryPaneContextMenu.equipWeapon(res.tool, true, not res.tool2, self.character:getPlayerNum());
        end
        if(res.data.toolRequired2) then
            ISInventoryPaneContextMenu.equipWeapon(res.tool2, false, false, self.character:getPlayerNum());
        end
        ISTimedActionQueue.add(WTR.Disassemble:new(self.character, res.disassemblable, res.data, sq, res.tool, res.tool2, res.key));
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

    if(self.lastSq ~= sq) then
        self.objIndex = 1;
        self.maxIndex = 1;

        self.lastSq = sq;
    end

    self.disassemblables = WTR.getDisassemblables(sq:getObjects());

    local res = WTR.getDisassemblableFromTable(self.character, self.disassemblables, self.objIndex, false);

    self.maxIndex = res.total;

    local hasToolRequirement = true;
    local hasTool2Requirement = true;
    if(res.data and res.data.toolRequired and not res.tool) then hasToolRequirement = false; end
    if(res.data and res.data.toolRequired2 and not res.tool2) then hasTool2Requirement = false; end

	local isCouldSee = sq:isCouldSee(self.character:getPlayerNum());

	return hasToolRequirement and hasTool2Requirement and res.total > 0 and isCouldSee;
end

function DisassembleCursor:isRunningAction()
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
    return actionQueue and actionQueue.queue and actionQueue.queue[1];
end

function DisassembleCursor:render(x, y, z, square)
	if self:isRunningAction() then return; end

    local res = WTR.getDisassemblableFromTable(self.character, self.disassemblables, self.objIndex, true);

    if(res.disassemblable and self:isValid(square)) then
        WTR.highlightDisassemblable(res.disassemblable, x, y, z);
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

function DisassembleCursor:rotateKey(key)
	if getCore():isKey("Rotate building", key) then
		self.objIndex = self.objIndex - 1;
		if self.objIndex == 0 then
			self.objIndex = self.maxIndex;
		end
	end
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
    
    o.lastSq = nil;

    o.objIndex = 1;
    o.maxIndex = 1;

	return o;
end
