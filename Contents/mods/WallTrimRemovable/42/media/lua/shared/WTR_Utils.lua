WTR = WTR or {};

local data = {
    WallTrimBase = {
        name = getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_Brown"),
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
};


local function buildData(base, overrides)
    overrides = overrides or {};
    local res = {};
    for k, v in pairs(base) do
        res[k] = v;
        if(overrides[k]) then
            res[k] = overrides[k];
        end
    end
    return res;
end

local function multValues(arr, mult)
    local res = {};
    for k, v in pairs(arr) do
        res[k] = v * mult;
    end
end

WTR.DISASSEMBLABLE_SPRITES = {
    ["walls_interior_detailing_01_36"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
    ["walls_interior_detailing_01_37"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
    ["walls_interior_detailing_01_38"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
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