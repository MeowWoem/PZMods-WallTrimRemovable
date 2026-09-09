WTR = WTR or {};

local ghc = getCore():getGoodHighlitedColor();
local bhc = getCore():getBadHighlitedColor();

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

-- TODO : Skill Required
local data = {
    WallTrimBase = {
        name = getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_Brown"),
        toolRequired = ItemTag.CROWBAR,
        duration = 50,
        results = {
            ["Base.Plank"] = 1,
            ["Base.Nails"] = 2,
        },
        anim = "RemoveBarricade",
        animVariable = "CrowbarHigh",
        sound = "BeginRemoveBarricadePlankCrowbar",
        completeSound = "RemoveBarricadePlank",
    },
};

data.WallTrimCeramicBase = buildData(data.WallTrimBase, {
    name = getText("IGUI_WallTrim") .. " - " .. getText("IGUI_Ceramic") .. " - " .. getText("ContextMenu_White"),
    results = {
        ["Base.ClayTile"] = 2
    }
})

local function multValues(arr, mult)
    local res = {};
    for k, v in pairs(arr) do
        res[k] = math.floor(v * mult);
    end
end

WTR.DISASSEMBLABLE_SPRITES = {
    -- ["walls_detailing_01_46"] = buildData(data.WallTrimBase), -- JUST FOR TESTING PURPOSE
    -- ["overlay_grime_wall_01_17"] = buildData(data.WallTrimBase), -- JUST FOR TESTING PURPOSE

    ----------------------------------
    ----- Wall Trim - Ceramic - White
    ----------------------------------

    ["walls_detailing_01_13"] = buildData(data.WallTrimCeramicBase), -- Wall Trim - Ceramic - White
    ["walls_detailing_01_14"] = buildData(data.WallTrimCeramicBase), -- Wall Trim - Ceramic - White
    ["walls_detailing_01_15"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - White - Corner Inner
        results = multValues(data.WallTrimCeramicBase.results, 2),
        duration = data.WallTrimCeramicBase.duration * 2
    }),
    ["walls_detailing_01_20"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - White - Corner Outer
        results = multValues(data.WallTrimCeramicBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - Brown
    ----------------------------------
    ["walls_interior_detailing_01_46"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Door
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_47"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Door
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_36"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
    ["walls_interior_detailing_01_37"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
    ["walls_interior_detailing_01_38"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Inner
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_39"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Outer
        results = {
            ["Base.UnusableWood"] = 1,
            ["Base.Nails"] = 1,
        },
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim + Decoration - Brown
    ----------------------------------
    ["walls_interior_detailing_01_42"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown - Door
        results = multValues(data.WallTrimBase.results, 1),
        duration = data.WallTrimBase.duration * 1
    }),
    ["walls_interior_detailing_01_43"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown - Door
        results = multValues(data.WallTrimBase.results, 1),
        duration = data.WallTrimBase.duration * 1
    }),
    ["walls_interior_detailing_01_32"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_33"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_34"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown - Corner Inner
        results = multValues(data.WallTrimBase.results, 4),
        duration = data.WallTrimBase.duration * 4
    }),
    -- I dont know if Corner Out exists for this style
    -- ["walls_interior_detailing_01_XX"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown - Corner Outer
    --     results = {
    --         ["Base.UnusableWood"] = 1,
    --         ["Base.Nails"] = 1,
    --     },
    --     duration = data.WallTrimBase.duration * 0.5
    -- }),


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