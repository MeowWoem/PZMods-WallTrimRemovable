WTR = WTR or {};

WTR.DISASSEMBLABLE_SPRITES = {
    ["walls_interior_detailing_01_36"] = {
        toolRequired = ItemTag.SAW,
        toolRequired2 = ItemTag.HAMMER,
        duration = 50,
        results = {
            ["Base.Plank"] = 1,
            ["Base.Nail"] = 2,
        },
        anim = "RemoveBarricade",
        animVariable = "CrowbarHigh",
        sound = "BeginRemoveBarricadePlankCrowbar",
        completeSound = "RemoveBarricadePlank",
    },
    ["walls_interior_detailing_01_37"] = {
        toolRequired = ItemTag.CROWBAR,
        duration = 50,
        results = {
            ["Base.Plank"] = 1,
            ["Base.Nail"] = 2,
        },
        anim = "RemoveBarricade",
        animVariable = "CrowbarHigh",
        sound = "BeginRemoveBarricadePlankCrowbar",
        completeSound = "RemoveBarricadePlank",
    },
    ["walls_interior_detailing_01_38"] = {
        toolRequired = ItemTag.CROWBAR,
        duration = 100,
        results = {
            ["Base.Plank"] = 2,
            ["Base.Nail"] = 4,
        },
        anim = "RemoveBarricade",
        animVariable = "CrowbarHigh",
        sound = "BeginRemoveBarricadePlankCrowbar",
        completeSound = "RemoveBarricadePlank",
    },
};

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