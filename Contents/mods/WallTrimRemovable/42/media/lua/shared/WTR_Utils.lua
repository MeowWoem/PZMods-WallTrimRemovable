require("WTR_Data");

WTR = WTR or {};

local ghc = getCore():getGoodHighlitedColor();
local bhc = getCore():getBadHighlitedColor();


function WTR.predicateRequiredTool(item, toolRequired)
    if(instanceof(toolRequired, "ItemTag")) then
        return not item:isBroken() and item:hasTag(toolRequired);
    else
        return not item:isBroken() and item:getFullType() == toolRequired;
    end
end

function WTR.getDisassemblablesInternal(arr, obj)

    local sprite = obj:getSprite();
    
    if(obj:getAttachedAnimSpriteCount() == 0) then return arr; end

    local attachedSprites = obj:getAttachedAnimSprite();

    for i = 1, attachedSprites:size() do
        local aSprite = attachedSprites:get(i-1);
        if(WTR.DISASSEMBLABLE_SPRITES[aSprite:getName()]) then
            arr[aSprite:getName()] = {
                object = obj,
                index = i
            };
        end
    end

    return arr;

end

function WTR.getDisassemblables(worldObjects)
    local disassemblables = {};

    if(instanceof(worldObjects, "PZArrayList")) then
        for i = 1, worldObjects:size() do
            local obj = worldObjects:get(i-1);
            if(obj) then
                disassemblables = WTR.getDisassemblablesInternal(disassemblables, obj);
            end

        end
    else
        for _, obj in ipairs(worldObjects) do
            disassemblables = WTR.getDisassemblablesInternal(disassemblables, obj);
        end
    end

    return disassemblables;
end

function WTR.getDisassemblableFromTable(playerObj, t, index, breakOnFound)

    local res = {
        key = nil,
        disassemblable = nil,
        data = nil,
        tool = nil,
        tool2 = nil,
        total = nil,
    };

    local i = 0;
    for k, v in pairs(t) do

        if(i == index - 1) then
            res.disassemblable = v;
            res.data =  WTR.DISASSEMBLABLE_SPRITES[k];
            if(res.data.toolRequired) then
                res.tool = playerObj:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, res.data.toolRequired);
            end
            if(res.data.toolRequired2) then
                res.tool2 = playerObj:getInventory():getFirstEvalArgRecurse(WTR.predicateRequiredTool, res.data.toolRequired2);
            end
            res.key = k;
            if(breakOnFound) then
                break
            end
        end

        i = i + 1;
    end

    if(not breakOnFound) then
        res.total = i;
    end

    return res;
end

function WTR.highlightDisassemblable(disassemblable, x, y, z)
    local aSprite = disassemblable.object:getAttachedAnimSprite():get(disassemblable.index - 1);
    local spriteRender = aSprite:getParentSprite();
    local r,g,b,a = bhc:getR(), bhc:getG(), bhc:getB(), 0.8;
    spriteRender:RenderGhostTileColor(x, y, z, r, g, b, a);
end