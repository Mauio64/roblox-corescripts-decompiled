local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local normalizeNumber = normalize.normalizeNumber
local normalizeStringToBoolean = normalize.normalizeStringToBoolean
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeNormalizeListFn = normalize.makeNormalizeListFn
local makeNormalizeUnionFn = normalize.makeNormalizeUnionFn
local makeNormalizeValueFn = normalize.makeNormalizeValueFn
local makeRequired = normalize.makeRequired

local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")

local function makeNormalizeResponsiveValueFn(p2)
	return makeNormalizeTableFn({
		default = p2,
		xSmall = p2,
		small = p2,
		medium = p2,
		large = p2,
		xLarge = p2,
		x2Large = p2,
		landscape = p2,
		portrait = p2
	})
end

local function makeNormalizedThemeValueFn(p2)
	return makeNormalizeTableFn({ default = p2, light = p2, dark = p2 })
end

local normalizeTableFn = makeNormalizeTableFn({
	default = normalizeNumber,
	xSmall = normalizeNumber,
	small = normalizeNumber,
	medium = normalizeNumber,
	large = normalizeNumber,
	xLarge = normalizeNumber,
	x2Large = normalizeNumber,
	landscape = normalizeNumber,
	portrait = normalizeNumber
})

local normalizeTableFn2 = makeNormalizeTableFn({
	r = makeRequired(normalizeNumber),
	g = makeRequired(normalizeNumber),
	b = makeRequired(normalizeNumber)
})

local normalizeTableFn3 = makeNormalizeTableFn({
	x = makeRequired(normalizeNumber),
	y = makeRequired(normalizeNumber)
})
local normalizeTableFn4 = makeNormalizeTableFn({
	default = normalizeTableFn3,
	xSmall = normalizeTableFn3,
	small = normalizeTableFn3,
	medium = normalizeTableFn3,
	large = normalizeTableFn3,
	xLarge = normalizeTableFn3,
	x2Large = normalizeTableFn3,
	landscape = normalizeTableFn3,
	portrait = normalizeTableFn3
})
local normalizeTableFn5 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ImageBackground" })),
	color = normalizeTableFn2,
	resourceIdentifier = makeNormalizeTableFn({
		default = normalizeString,
		xSmall = normalizeString,
		small = normalizeString,
		medium = normalizeString,
		large = normalizeString,
		xLarge = normalizeString,
		x2Large = normalizeString,
		landscape = normalizeString,
		portrait = normalizeString
	}),
	anchorPoint = normalizeTableFn4,
	position = normalizeTableFn4,
	transparency = normalizeTableFn
})

local normalizeTableFn6 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	color = makeRequired(normalizeTableFn2)
})

local normalizeTableFn7 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	number = makeRequired(normalizeNumber)
})

local normalizeListFn = makeNormalizeListFn((makeNormalizeUnionFn({
	normalizeTableFn5,
	(makeNormalizeTableFn({
		type = makeRequired(makeNormalizeValueFn({ "GradientBackground" })),
		colorSequence = makeRequired(makeNormalizeListFn(normalizeTableFn6)),
		rotation = normalizeNumber,
		transparency = makeNormalizeUnionFn({ normalizeNumber, makeNormalizeListFn(normalizeTableFn7) }),
		offset = normalizeTableFn3
	}))
})))
local normalizeTableFn8 = makeNormalizeTableFn({
	default = normalizeListFn,
	light = normalizeListFn,
	dark = normalizeListFn
})

local normalizeTableFn9 = makeNormalizeTableFn({ backgroundLayers = normalizeTableFn8 })

local normalizeTableFn10 = makeNormalizeTableFn({
	backgroundLayers = normalizeTableFn8,
	thumbnailAspectRatio = makeNormalizeUnionFn({
		makeNormalizeValueFn({ "Wide", "Tall", "Square" }),
		function(p2)
			if p2 then
				return (tonumber(p2))
			end

			return nil
		end
	})
})

local normalizeListFn2 = makeNormalizeListFn((makeNormalizeTableFn({
	contentType = makeNormalizeValueFn({
		"ItemName",
		"AgentName",
		"Price",
		"PriceRange"
	})
})))

local normalizeTableFn11 = makeNormalizeTableFn({
	continueBrowsingTitle = normalizeString,
	shouldUseDefaultTemplatesAcrossTabs = normalizeString,
	creatorNameTileFooterEnabled = normalizeString,
	hydrateOnlyVisibleItems = normalizeStringToBoolean,
	disableOrganicContentFetch = normalizeStringToBoolean
})

local normalizeTableFn12 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "Carousel" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn9,
	cardStyle = normalizeTableFn10,
	itemFooters = normalizeListFn2,
	previewRows = normalizeTableFn,
	previewColumns = normalizeTableFn
})

local normalizeTableFn13 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ItemGroup" })),
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn9,
	cardStyle = normalizeTableFn10,
	itemFooters = normalizeListFn2,
	previewRows = normalizeTableFn,
	previewColumns = normalizeTableFn
})
local v5

if fFlagAXHeroUnitActionButton then
	v5 = makeNormalizeTableFn({
		action = makeRequired(makeNormalizeValueFn({ "OpenRobloxPlus", "OpenFreeRobloxPlus" })),
		localizedText = { fn = normalizeNotEmptyString }
	})
end

local normalizeTableFn14 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "HeroUnit" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn9,
	cardStyle = normalizeTableFn10,
	itemFooters = normalizeListFn2,
	previewRows = normalizeTableFn,
	previewColumns = normalizeTableFn,
	availableUntil = normalizeString,
	button = v5
})

local normalizeTableFn15 = makeNormalizeTableFn({
	customizedDataMap = normalizeTableFn11,
	defaultItemCarouselTemplate = normalizeTableFn12,
	defaultItemGroupTemplate = normalizeTableFn13,
	defaultTemplate = normalizeTableFn13
})

local normalizeListFn3 = makeNormalizeListFn(makeNormalizeUnionFn({
	makeNormalizeTableFn({
		id = makeRequired(normalizeNumber),
		type = makeRequired(makeNormalizeValueFn({ "Bundle" }))
	}),
	makeNormalizeTableFn({
		id = makeRequired(normalizeNumber),
		type = makeRequired(makeNormalizeValueFn({ "Asset" }))
	}),
	(makeNormalizeTableFn({
		id = makeRequired(normalizeString),
		type = makeRequired(makeNormalizeValueFn({ "Look" })),
		displayProperties = makeNormalizeTableFn({
			animatedAvatarEmoteAssetIds = normalizeString
		})
	}))
}))

local normalizeTableFn16 = makeNormalizeTableFn({
	id = makeRequired(normalizeString),
	type = makeRequired(normalizeString),
	content = makeRequired(normalizeListFn3),
	template = makeRequired(makeNormalizeUnionFn({
		normalizeTableFn13,
		normalizeTableFn12,
		normalizeTableFn14
	})),
	tagId = normalizeString
})

local function normalizeWidgets(items)
	if typeof(items) ~= "table" then
		return nil, nil
	end

	local v6 = {}
	local tableFns = {}

	for k, item in items do
		local tableFn, v7 = normalizeTableFn16(item)
		table.insert(v6, v7)

		tableFns[tostring(tonumber(k) + 1)] = tableFn
	end

	local v7 = if next(v6) then table.concat(v6, " ") else nil

	return tableFns, v7
end

return (makeNormalizeTableFn({
	configuration = normalizeTableFn15,
	widgets = normalizeWidgets
}))
