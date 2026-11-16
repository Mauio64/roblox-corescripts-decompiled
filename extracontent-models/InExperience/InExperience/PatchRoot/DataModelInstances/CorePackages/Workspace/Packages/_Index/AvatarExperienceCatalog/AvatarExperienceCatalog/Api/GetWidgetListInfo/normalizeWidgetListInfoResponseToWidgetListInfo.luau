local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local normalizeStringToBoolean = normalize.normalizeStringToBoolean
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeNormalizeListFn = normalize.makeNormalizeListFn
local makeNormalizeUnionFn = normalize.makeNormalizeUnionFn
local makeNormalizeValueFn = normalize.makeNormalizeValueFn
local makeRequired = normalize.makeRequired

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function makeNormalizeResponsiveValueFn(p) -- 3 equivalent calls inferred from this helper
	return makeNormalizeTableFn({
		default = p,
		xSmall = p,
		small = p,
		medium = p,
		large = p,
		xLarge = p,
		x2Large = p,
		landscape = p,
		portrait = p
	})
end

local function makeNormalizedThemeValueFn(p) -- 1 equivalent call inferred from this helper
	return makeNormalizeTableFn({ default = p, light = p, dark = p })
end

local normalizeResponsiveValueFn = makeNormalizeResponsiveValueFn(normalizeNumber) -- inferred equivalent call
local normalizeTableFn = makeNormalizeTableFn({
	r = makeRequired(normalizeNumber),
	g = makeRequired(normalizeNumber),
	b = makeRequired(normalizeNumber)
})

local normalizeTableFn2 = makeNormalizeTableFn({
	x = makeRequired(normalizeNumber),
	y = makeRequired(normalizeNumber)
})
local normalizeResponsiveValueFn2 = makeNormalizeResponsiveValueFn(normalizeTableFn2) -- inferred equivalent call
local normalizeTableFn3 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ImageBackground" })),
	color = normalizeTableFn,
	resourceIdentifier = makeNormalizeResponsiveValueFn(normalizeString), -- inferred equivalent call
	anchorPoint = normalizeResponsiveValueFn2,
	position = normalizeResponsiveValueFn2,
	transparency = normalizeResponsiveValueFn
})

local normalizeTableFn4 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	color = makeRequired(normalizeTableFn)
})

local normalizeTableFn5 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	number = makeRequired(normalizeNumber)
})

local normalizedThemeValueFn = makeNormalizedThemeValueFn(makeNormalizeListFn((makeNormalizeUnionFn({ -- inferred equivalent call
	normalizeTableFn3,
	(makeNormalizeTableFn({
		type = makeRequired(makeNormalizeValueFn({ "GradientBackground" })),
		colorSequence = makeRequired(makeNormalizeListFn(normalizeTableFn4)),
		rotation = normalizeNumber,
		transparency = makeNormalizeUnionFn({ normalizeNumber, makeNormalizeListFn(normalizeTableFn5) }),
		offset = normalizeTableFn2
	}))
}))))

local normalizeTableFn6 = makeNormalizeTableFn({ backgroundLayers = normalizedThemeValueFn })

local normalizeTableFn7 = makeNormalizeTableFn({
	backgroundLayers = normalizedThemeValueFn,
	thumbnailAspectRatio = makeNormalizeUnionFn({
		makeNormalizeValueFn({ "Wide", "Tall", "Square" }),
		function(p)
			if p then
				return (tonumber(p))
			end

			return nil
		end
	})
})

local normalizeListFn = makeNormalizeListFn((makeNormalizeTableFn({
	contentType = makeNormalizeValueFn({ "ItemName", "AgentName", "Price", "PriceRange" })
})))

local normalizeTableFn8 = makeNormalizeTableFn({
	continueBrowsingTitle = normalizeString,
	shouldUseDefaultTemplatesAcrossTabs = normalizeString,
	creatorNameTileFooterEnabled = normalizeString,
	hydrateOnlyVisibleItems = normalizeStringToBoolean,
	disableOrganicContentFetch = normalizeStringToBoolean
})

local normalizeTableFn9 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "Carousel" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn6,
	cardStyle = normalizeTableFn7,
	itemFooters = normalizeListFn,
	previewRows = normalizeResponsiveValueFn,
	previewColumns = normalizeResponsiveValueFn
})

local normalizeTableFn10 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ItemGroup" })),
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn6,
	cardStyle = normalizeTableFn7,
	itemFooters = normalizeListFn,
	previewRows = normalizeResponsiveValueFn,
	previewColumns = normalizeResponsiveValueFn
})

local normalizeTableFn11 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "HeroUnit" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = normalizeTableFn6,
	cardStyle = normalizeTableFn7,
	itemFooters = normalizeListFn,
	previewRows = normalizeResponsiveValueFn,
	previewColumns = normalizeResponsiveValueFn,
	availableUntil = normalizeString
})

local normalizeTableFn12 = makeNormalizeTableFn({
	customizedDataMap = normalizeTableFn8,
	defaultItemCarouselTemplate = normalizeTableFn9,
	defaultItemGroupTemplate = normalizeTableFn10,
	defaultTemplate = normalizeTableFn10
})

local normalizeListFn2 = makeNormalizeListFn(makeNormalizeUnionFn({
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
		displayProperties = makeNormalizeTableFn({ animatedAvatarEmoteAssetIds = normalizeString })
	}))
}))

local normalizeTableFn13 = makeNormalizeTableFn({
	id = makeRequired(normalizeString),
	type = makeRequired(normalizeString),
	content = makeRequired(normalizeListFn2),
	template = makeRequired(makeNormalizeUnionFn({ normalizeTableFn10, normalizeTableFn9, normalizeTableFn11 })),
	tagId = normalizeString
})

local function normalizeWidgets(items)
	if typeof(items) ~= "table" then
		return nil, nil
	end

	local v = {}
	local tableFns = {}

	for k, item in items do
		local tableFn, v2 = normalizeTableFn13(item)
		table.insert(v, v2)

		tableFns[tostring(tonumber(k) + 1)] = tableFn
	end

	local v2

	if next(v) then
		v2 = table.concat(v, " ")
	end

	return tableFns, v2
end

return (makeNormalizeTableFn({ configuration = normalizeTableFn12, widgets = normalizeWidgets }))
