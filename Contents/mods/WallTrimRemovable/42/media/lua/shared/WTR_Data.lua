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
});

local function multValues(arr, mult)
    local res = {};
    for k, v in pairs(arr) do
        res[k] = math.floor(v * mult);
    end
    return res;
end

local names = {
    wallTrimDecoWhite =  getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_White"),
    wallTrimDecoGray =  getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_Grey"),
    wallTrimDecoBeige =  getText("IGUI_WallTrim") .. " - " .. getText("IGUI_Beige"),
    wallTrimDecoLightBlue =  getText("IGUI_WallTrim") .. " - " .. getText("ContextMenu_Light_Blue"),
    wallTrimCeramicGreen =  getText("IGUI_WallTrim") .. " - " .. getText("IGUI_Ceramic") .. " - " .. getText("ContextMenu_Green"),
    wallTrimCeramicBrown =  getText("IGUI_WallTrim") .. " - " .. getText("IGUI_Ceramic") .. " - " .. getText("ContextMenu_Brown"),
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
    ----- Wall Trim - Ceramic - Brown
    ----------------------------------
    ["walls_detailing_01_36"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown
        name = names.wallTrimCeramicBrown,
    }),
    ["walls_detailing_01_45"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown
        name = names.wallTrimCeramicBrown,
    }),
    ["walls_detailing_01_37"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown
        name = names.wallTrimCeramicBrown,
    }),
    ["walls_detailing_01_46"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown
        name = names.wallTrimCeramicBrown,
    }),
    ["walls_detailing_01_38"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown - Corner Inner
        name = names.wallTrimCeramicBrown,
        results = multValues(data.WallTrimCeramicBase.results, 2),
        duration = data.WallTrimCeramicBase.duration * 2
    }),
    ["walls_detailing_01_47"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown - Corner Inner
        name = names.wallTrimCeramicBrown,
        results = multValues(data.WallTrimCeramicBase.results, 2),
        duration = data.WallTrimCeramicBase.duration * 2
    }),
    ["walls_detailing_01_39"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown - Corner Outer
        name = names.wallTrimCeramicBrown,
        results = multValues(data.WallTrimCeramicBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),
    ["walls_detailing_01_55"] = buildData(data.WallTrimCeramicBase, { -- Wall Trim - Ceramic - Brown - Corner Outer
        name = names.wallTrimCeramicBrown,
        results = multValues(data.WallTrimCeramicBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - White
    ----------------------------------
    ["walls_detailing_01_16"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_17"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_18"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_19"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Outer
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - White
    ----------------------------------
    ["walls_detailing_01_56"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_57"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_58"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_59"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Outer
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - White
    ----------------------------------
    ["walls_detailing_01_61"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_62"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_63"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),

    ----------------------------------
    ----- Wall Trim - Brown
    ----------------------------------
    ["walls_detailing_01_80"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown
    }),
    ["walls_detailing_01_81"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown
    }),
    ["walls_detailing_01_82"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Inner
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_83"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Outer
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),
    ["walls_detailing_01_84"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown
    }),
    ["walls_detailing_01_85"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown
    }),
    ["walls_detailing_01_86"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Inner
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_87"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Corner Outer
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - White
    ----------------------------------
    ["walls_detailing_01_21"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_22"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_23"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_29"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_30"] = buildData(data.WallTrimBase, { -- Wall Trim - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_detailing_01_31"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_28"] = buildData(data.WallTrimBase, { -- Wall Trim - White - Corner Outer
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - Gray
    ----------------------------------
    ["walls_detailing_01_24"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
        name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_25"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
                name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_27"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Inner
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_26"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Outer
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - Gray
    ----------------------------------
    ["walls_detailing_01_88"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
        name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_89"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
                name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_91"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Inner
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_90"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Outer
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),

    ----------------------------------
    ----- Wall Trim - Light Blue
    ----------------------------------
    ["walls_detailing_01_104"] = buildData(data.WallTrimBase, { -- Wall Trim - Light Blue
        name = names.wallTrimDecoLightBlue,
    }),
    ["walls_detailing_01_105"] = buildData(data.WallTrimBase, { -- Wall Trim - Light Blue
                name = names.wallTrimDecoLightBlue,
    }),
    ["walls_detailing_01_107"] = buildData(data.WallTrimBase, { -- Wall Trim - Light Blue - Corner Inner
        name = names.wallTrimDecoLightBlue,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_106"] = buildData(data.WallTrimBase, { -- Wall Trim - Light Blue - Corner Outer
        name = names.wallTrimDecoLightBlue,
        results = multValues(data.WallTrimBase.results, 0.5),
        duration = data.WallTrimBase.duration * 0.5
    }),
    
    ----------------------------------
    ----- Wall Trim - Gray
    ----------------------------------
    ["walls_detailing_01_32"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
        name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_33"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray
                name = names.wallTrimDecoGray,
    }),
    ["walls_detailing_01_35"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Inner
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_detailing_01_34"] = buildData(data.WallTrimBase, { -- Wall Trim - Gray - Corner Outer
        name = names.wallTrimDecoGray,
        results = multValues(data.WallTrimBase.results, 0.5),
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
    ["walls_interior_detailing_01_44"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
    ["walls_interior_detailing_01_45"] = buildData(data.WallTrimBase), -- Wall Trim - Brown
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
    ["walls_interior_detailing_01_40"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_41"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - Brown
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
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
    ["walls_interior_detailing_01_12"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_13"] = buildData(data.WallTrimBase, { -- Wall Trim - Brown - Door
        name = names.wallTrimDecoWhite,
        results = {
            ["Base.UnusableWood"] = 2,
            ["Base.Nails"] = 2,
        },
    }),
    ["walls_interior_detailing_01_10"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_11"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
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
    ["walls_interior_detailing_01_8"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_9"] = buildData(data.WallTrimBase, { -- Wall Trim + Decoration - White
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
    ["walls_interior_detailing_01_64"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_65"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_66"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_67"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Outer
        name = names.wallTrimDecoWhite,
    }),

    ----------------------------------
    ----- Wall Trim Commercial - Beige
    ----------------------------------
    ["walls_interior_detailing_01_68"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige
        name = names.wallTrimDecoBeige,
    }),
    ["walls_interior_detailing_01_69"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige
        name = names.wallTrimDecoBeige,
    }),
    ["walls_interior_detailing_01_70"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige - Corner Inner
        name = names.wallTrimDecoBeige,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_71"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige - Corner Outer
        name = names.wallTrimDecoBeige,
    }),

    ----------------------------------
    ----- Wall Trim Commercial - White
    ----------------------------------
    ["walls_interior_detailing_01_72"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_73"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White
        name = names.wallTrimDecoWhite,
    }),
    ["walls_interior_detailing_01_74"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Inner
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_75"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - White - Corner Outer
        name = names.wallTrimDecoWhite,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),

    ----------------------------------
    ----- Wall Trim Commercial - Beige
    ----------------------------------
    ["walls_interior_detailing_01_76"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige
        name = names.wallTrimDecoBeige,
    }),
    ["walls_interior_detailing_01_77"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige
        name = names.wallTrimDecoBeige,
    }),
    ["walls_interior_detailing_01_78"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige - Corner Inner
        name = names.wallTrimDecoBeige,
        results = multValues(data.WallTrimBase.results, 2),
        duration = data.WallTrimBase.duration * 2
    }),
    ["walls_interior_detailing_01_79"] = buildData(data.WallTrimBase, { -- Wall Trim Commercial - Beige - Corner Outer
        name = names.wallTrimDecoBeige,
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


-- TODO: location_shop_zippee_XX_XX
-- TODO: walls_commercial_XX_XX

};