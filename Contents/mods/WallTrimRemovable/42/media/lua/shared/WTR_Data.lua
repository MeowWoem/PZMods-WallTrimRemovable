WTR = WTR or {};

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

local names = {
    wallTrimDecoWhite =  getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_White"),
};

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
    ["walls_interior_detailing_01_35"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown - Corner Outer
        results = {
            ["Base.UnusableWood"] = 1,
            ["Base.Nails"] = 1,
        },
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim + Decoration - White
    ----------------------------------
    ["walls_interior_detailing_01_0"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_1"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_2"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 4),
        duration = data.WallTrimBase.duration * 4
    }),
    ["walls_interior_detailing_01_3"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White - Corner Outer
        name = names.wallTrimDecoWhite,
    }),

    ----------------------------------
    ----- Wall Trim - White
    ----------------------------------
    ["walls_interior_detailing_01_14"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_15"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_4"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_5"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_6"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_7"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Outer
        name = names.wallTrimDecoWhite,
    }),

    ----------------------------------
    ----- Wall Trim Double - White
    ----------------------------------
    ["walls_interior_detailing_01_26"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 4,
            ["Base.Nails"] = 4,
        },
    }),
    ["walls_interior_detailing_01_27"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 4,
            ["Base.Nails"] = 4,
        },
    }),
    ["walls_interior_detailing_01_16"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_17"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_18"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 4),
        duration = data.WallTrimBase.duration * 4
    }),
    ["walls_interior_detailing_01_19"] = buildData(data.WallTrimBase, { -- Wall Trim Double - White - Corner Outer
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),

    ----------------------------------
    ----- Wall Trim Commercial - White
    ----------------------------------
    ["walls_commercial_02_24"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_commercial_02_25"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_commercial_02_26"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_commercial_02_27"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Outer
        name = names.wallTrimDecoWhite,
    }),

};