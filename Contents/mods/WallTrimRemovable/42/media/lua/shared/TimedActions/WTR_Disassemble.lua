--***********************************************************
--**                       AMENOPHIS                       **
--***********************************************************

require "TimedActions/ISBaseTimedAction";
require "MWSGrassGrowingShared";

local Disassemble = ISBaseTimedAction:derive("Disassemble");

WTR = WTR or {};
WTR.Disassemble = Disassemble;


function Disassemble:isValid()
    
    local hasToolRequirement = true;
    local hasTool2Requirement = true;
    if(self.data.toolRequired and not self.tool) then hasToolRequirement = false; end
    if(self.data.toolRequired2 and not self.tool2) then hasTool2Requirement = false; end
    return hasToolRequirement and hasTool2Requirement;
end

function Disassemble:update()
    --self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function Disassemble:start()

    if(self.tool) then
        self.tool:setJobType(getText("ContextMenu_Disassemble"));
        self.tool:setJobDelta(0.0);
    end
    self:setActionAnim(self.data.anim);
    if(self.data.animVariable) then
        self:setAnimVariable(self.data.anim, self.data.animVariable);
    end
    if(self.data.sound) then
        self.sound = self.character:playSound(self.data.sound);
    end

    self:setOverrideHandModels(self.character:getPrimaryHandItem(), nil);

end

function Disassemble:waitToStart()
	self.character:faceThisObject(self.isoObj);
	return self.character:shouldBeTurning();
end

function Disassemble:stop()
    if(self.tool) then
        self.tool:setJobDelta(0.0);
    end
    if self.sound then
		self.character:getEmitter():stopSound(self.sound);
		self.sound = nil;
	end
    ISBaseTimedAction.stop(self);
end

function Disassemble:perform()
    if(self.tool) then
        self.tool:setJobDelta(0.0);
    end
    if self.sound then
		self.character:getEmitter():stopSound(self.sound);
		self.sound = nil;
	end

    if(self.data.completeSound) then
        self.character:playSound(self.data.completeSound);
    end

    ISBaseTimedAction.perform(self);
end

function Disassemble:complete()

    -- self.isoObj:RemoveAttachedAnim(self.disassemblable.index - 1);

    -- TODO: send server command with square coordinates and disassemblable key and index to all client
    -- then do a RemoveAttachedAnim on clients

    if(self.enableCursor) then
        local bo = WTR.DisassembleCursor:new(self.character, self.tool, self.tool2);
	    getCell():setDrag(bo, bo.player);
    end
    return true;
end

function Disassemble:getDuration()
    if self.character:isTimedActionInstant() then
        return 1;
    end

    return self.data.duration;
end

function Disassemble:new(character, disassemblable, data, sq, tool, tool2, key, enableCursor)

    if(enableCursor == nil) then enableCursor = false; end

    local o = ISBaseTimedAction.new(self, character);

    o.disassemblable = disassemblable;
    o.isoObj = disassemblable.object;
    o.character = character;
    o.data = data;
    o.tool = tool;
    o.tool2 = tool2;
    o.key = key;
    o.sq = sq or disassemblable.object:getSquare() or character:getCurrentSquare();
    o.enableCursor = enableCursor;
    o.maxTime = o:getDuration();
    o.sound = nil;

    return o;
end