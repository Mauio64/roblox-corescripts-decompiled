local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
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

local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget

local function makeNormalizeResponsiveValueFn(p1) -- line: 30
	-- upvalues: makeNormalizeTableFn (copy)
	return makeNormalizeTableFn({
		default = p1,
		xSmall = p1,
		small = p1,
		medium = p1,
		large = p1,
		xLarge = p1,
		x2Large = p1,
		landscape = p1,
		portrait = p1
	})
end
local function makeNormalizedThemeValueFn(p2) -- line: 44
	-- upvalues: makeNormalizeTableFn (copy)
	return makeNormalizeTableFn({
		default = p2,
		light = p2,
		dark = p2
	})
end

local v18 = makeNormalizeTableFn({
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
local v19 = makeNormalizeTableFn({
	r = makeRequired(normalizeNumber),
	g = makeRequired(normalizeNumber),
	b = makeRequired(normalizeNumber)
})
local v20 = makeNormalizeTableFn({
	x = makeRequired(normalizeNumber),
	y = makeRequired(normalizeNumber)
})
local v21 = makeNormalizeTableFn({
	default = v20,
	xSmall = v20,
	small = v20,
	medium = v20,
	large = v20,
	xLarge = v20,
	x2Large = v20,
	landscape = v20,
	portrait = v20
})
local v22 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ImageBackground" })),
	color = v19,
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
	anchorPoint = v21,
	position = v21,
	transparency = v18
})
local v23 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	color = makeRequired(v19)
})
local v24 = makeNormalizeTableFn({
	time = makeRequired(normalizeNumber),
	number = makeRequired(normalizeNumber)
})
local v25 = makeNormalizeListFn((makeNormalizeUnionFn({
	v22,
	(makeNormalizeTableFn({
		type = makeRequired(makeNormalizeValueFn({ "GradientBackground" })),
		colorSequence = makeRequired(makeNormalizeListFn(v23)),
		rotation = normalizeNumber,
		transparency = makeNormalizeUnionFn({
			normalizeNumber,
			makeNormalizeListFn(v24)
		}),
		offset = v20
	}))
})))
local v26 = makeNormalizeTableFn({
	default = v25,
	light = v25,
	dark = v25
})
local v27 = makeNormalizeTableFn({
	backgroundLayers = v26
})
local v28 = makeNormalizeUnionFn({
	makeNormalizeValueFn({
		"Wide",
		"Tall",
		"Square"
	}),
	function(p3) -- line: 105
		if p3 then
			return (tonumber(p3))
		end

		return nil
	end
})
local v29 = makeNormalizeTableFn({
	backgroundLayers = v26,
	thumbnailAspectRatio = v28
})
local v30 = makeNormalizeListFn((makeNormalizeTableFn({
	contentType = makeNormalizeValueFn({
		"ItemName",
		"AgentName",
		"Price",
		"PriceRange"
	})
})))
local v31 = makeNormalizeTableFn({
	continueBrowsingTitle = normalizeString,
	shouldUseDefaultTemplatesAcrossTabs = normalizeString,
	creatorNameTileFooterEnabled = normalizeString,
	hydrateOnlyVisibleItems = normalizeStringToBoolean,
	disableOrganicContentFetch = normalizeStringToBoolean
})
local v32 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "Carousel" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = v27,
	cardStyle = v29,
	itemFooters = v30,
	previewRows = v18,
	previewColumns = v18
})
local v33 = makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "ItemGroup" })),
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = v27,
	cardStyle = v29,
	itemFooters = v30,
	previewRows = v18,
	previewColumns = v18
})
local v34 = if not FFlagAXHeroWidget then nil else makeNormalizeTableFn({
	type = makeRequired(makeNormalizeValueFn({ "HeroUnit" })),
	numItemsToShow = normalizeNumber,
	seeAllButton = normalizeBoolean,
	title = normalizeString,
	localizedTitle = normalizeString,
	description = normalizeString,
	localizedDescription = normalizeString,
	widgetStyle = v27,
	cardStyle = v29,
	itemFooters = v30,
	previewRows = v18,
	previewColumns = v18,
	availableUntil = normalizeString
})
local v35 = makeNormalizeTableFn({
	customizedDataMap = v31,
	defaultItemCarouselTemplate = v32,
	defaultItemGroupTemplate = v33,
	defaultTemplate = v33
})
local v36 = makeNormalizeListFn(makeNormalizeUnionFn({
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
local v37 = makeNormalizeTableFn({
	id = makeRequired(normalizeString),
	type = makeRequired(normalizeString),
	content = makeRequired(v36),
	template = if not FFlagAXHeroWidget then makeRequired(makeNormalizeUnionFn({
		v33,
		v32
	})) else makeRequired(makeNormalizeUnionFn({
		v33,
		v32,
		v34
	})),
	tagId = normalizeString
})

local function normalizeWidgets(p4) -- line: 225
	-- upvalues: v37 (copy)
	if typeof(p4) ~= "table" then
		return nil, nil
	end

	local t1 = {}
	local t2 = {}

	for v45, v46 in p4 do
		local v47, v48 = v37(v46)

		table.insert(t2, v48)
		t1[tostring(tonumber(v45) + 1)] = v47
	end

	local v49 = nil

	if next(t2) then
		v49 = table.concat(t2, " ")
	end

	return t1, v49
end

return (makeNormalizeTableFn({
	configuration = v35,
	widgets = normalizeWidgets
}))
