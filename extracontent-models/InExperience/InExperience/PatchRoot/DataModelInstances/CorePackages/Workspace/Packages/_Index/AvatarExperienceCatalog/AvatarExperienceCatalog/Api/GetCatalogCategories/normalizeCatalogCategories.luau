local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local normalizeNotEmptyString = normalize.normalizeNotEmptyString

local HttpService = game:GetService("HttpService")

require(AvatarExperienceCatalog.Models.CatalogCategories)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local function SearchUuid() -- 1 equivalent call inferred from this helper
	return HttpService:GenerateGUID(true)
end

local function extractShowCatalogContentActionRequestParams(p)
	if p.props and p.props.OnActivated then
		for _, v in p.props.OnActivated do
			if v.componentType == "ShowCatalogContentAction" then
				return v.props and v.props.requestParams
			end
		end
	end

	return nil
end

local function extractWidgetContext(p)
	if p.props and p.props.OnActivated then
		for _, v in p.props.OnActivated do
			if v.componentType == "ShowWidgetContentAction" then
				return v.props and v.props.requestParams and v.props.requestParams.context
			end
		end
	end

	return nil
end

local function stringToBoolean(value)
	if type(value) == "boolean" then
		return value, nil
	end

	if type(value) ~= "string" then
		return nil, "Expected boolean or string"
	end

	if value == "True" then
		return true, nil
	elseif value == "False" then
		return false, nil
	end

	return nil, "Invalid boolean string value, expected \"True\" or \"False\""
end

local function splitCommaSeparatedString(value: string?)
	if not value or value == "" then
		return nil
	end

	local v = string.split(value, ",")
	local v2 = {}

	for _, v3 in v do
		if v3 ~= "" then
			table.insert(v2, v3)
		end
	end

	return #v2 > 0 and v2 or nil
end

local function normalizeAssetTypeIdStrings(p)
	local v = extractShowCatalogContentActionRequestParams(p)
	local assetTypeIds = v and v.assetTypeIds

	if assetTypeIds == nil or assetTypeIds == "" then
		return nil, nil
	end

	local str, v2 = normalizeString(assetTypeIds)

	if v2 then
		return nil, v2
	end

	return splitCommaSeparatedString(str), nil
end

local function normalizeBundleTypes(p)
	local v = extractShowCatalogContentActionRequestParams(p)
	local bundleTypeIds = v and v.bundleTypeIds

	if bundleTypeIds == nil or bundleTypeIds == "" then
		return nil, nil
	end

	local str, v2 = normalizeString(bundleTypeIds)

	if v2 then
		return nil, v2
	end

	return splitCommaSeparatedString(str), nil
end

local function normalizeTaxonomy(p)
	local v = extractShowCatalogContentActionRequestParams(p)
	local taxonomyId = v and v.taxonomyId

	local notEmptyString, v2 = normalizeNotEmptyString(taxonomyId)
	return notEmptyString, v2
end

local function normalizeWidgetContext(p) -- 1 equivalent call inferred from this helper
	return extractWidgetContext(p), nil
end

local function normalizeSearchUuid() -- 1 equivalent call inferred from this helper
	return SearchUuid(), nil -- inferred equivalent call
end

local function normalizePillTitle(p)
	local pillTitle = p.props and p.props.pillTitle

	if FFlagAXCatalogCategoriesSDUI then
		local notEmptyString, v = normalizeNotEmptyString(pillTitle)
		return notEmptyString, v
	end

	local str, v = normalizeString(pillTitle)

	return str, v
end

local function normalizePillId(p)
	local pillId = p.props and p.props.pillId

	if FFlagAXCatalogCategoriesSDUI then
		local notEmptyString, v = normalizeNotEmptyString(pillId)
		return notEmptyString, v
	end

	local str, v = normalizeString(pillId)

	return str, v
end

local function normalizeTimeToRefresh(p)
	local timeToRefresh = p.props and p.props.timeToRefresh

	if timeToRefresh == nil or timeToRefresh == "" then
		return nil, nil
	end

	if type(timeToRefresh) == "string" then
		timeToRefresh = tonumber(timeToRefresh)
	end

	if timeToRefresh == nil then
		return nil, nil
	end

	local number, v = normalizeNumber(timeToRefresh)
	return number, v
end

local function normalizeCameraFocus(p) -- 1 equivalent call inferred from this helper
	local cameraFocus = p.props and p.props.cameraFocus
	local notEmptyString, v = normalizeNotEmptyString(cameraFocus)
	return notEmptyString, v
end

local function normalizeCameraZoomRadius(p)
	local cameraZoomRadius = p.props and p.props.cameraZoomRadius

	if cameraZoomRadius == nil or cameraZoomRadius == "" then
		return nil, nil
	end

	if type(cameraZoomRadius) == "string" then
		cameraZoomRadius = tonumber(cameraZoomRadius)
	end

	if cameraZoomRadius == nil then
		return nil, nil
	end

	local number, v = normalizeNumber(cameraZoomRadius)
	return number, v
end

local function normalizeCanAnimateCameraBasedMood(p)
	local v = p.props and p.props.canAnimateCameraBasedMood

	if v == nil or v == "" then
		return nil, nil
	end

	local v2

	if type(v) ~= "boolean" then
		if type(v) == "string" then
			if v == "True" then
				v = true
			elseif v == "False" then
				v = false
			else
				v2 = "Invalid boolean string value, expected \"True\" or \"False\""
				v = nil
			end
		else
			v2 = "Expected boolean or string"
			v = nil
		end
	end

	if v2 then
		return nil, v2
	end

	local boolean, v3 = normalizeBoolean(v)
	return boolean, v3
end

local function normalizeDisableFilters(p)
	local v = p.props and p.props.disableFilters

	if v == nil or v == "" then
		return nil, nil
	end

	local v2

	if type(v) ~= "boolean" then
		if type(v) == "string" then
			if v == "True" then
				v = true
			elseif v == "False" then
				v = false
			else
				v2 = "Invalid boolean string value, expected \"True\" or \"False\""
				v = nil
			end
		else
			v2 = "Expected boolean or string"
			v = nil
		end
	end

	if v2 then
		return nil, v2
	end

	local boolean, v3 = normalizeBoolean(v)
	return boolean, v3
end

local function normalizePageType(p) -- 1 equivalent call inferred from this helper
	local pageType = p.props and p.props.pageType
	local notEmptyString, v = normalizeNotEmptyString(pageType)
	return notEmptyString, v
end

local function normalizeLooksWidgetContextForOrganicContent(p)
	local v = extractShowCatalogContentActionRequestParams(p)
	local context = v and v.context

	if context == nil or context == "" then
		return nil, nil
	end

	local str, v2 = normalizeString(context)
	return str, v2
end

local function normalizeTooltipKey(p) -- 1 equivalent call inferred from this helper
	local tooltipKey = p.props and p.props.tooltipKey
	local notEmptyString, v = normalizeNotEmptyString(tooltipKey)
	return notEmptyString, v
end

local function normalizeTooltipBody(p) -- 1 equivalent call inferred from this helper
	local tooltipBody = p.props and p.props.tooltipBody
	local notEmptyString, v = normalizeNotEmptyString(tooltipBody)
	return notEmptyString, v
end

local function normalizeTileType(p) -- 1 equivalent call inferred from this helper
	local tileType = p.props and p.props.tileType
	local notEmptyString, v = normalizeNotEmptyString(tileType)
	return notEmptyString, v
end

local fn

local function fn2(p)
	if not p.props or not p.props.Configs or type(p.props.Configs) ~= "table" then
		return nil, nil
	end

	local v = {}
	local result = {}

	for _, config in p.props.Configs do
		local v2, v3 = fn(config)

		if v3 then
			table.insert(v, v3)
		end

		if not v2 or v3 then
			continue
		end

		table.insert(result, v2)
	end

	local v2

	if next(v) then
		v2 = table.concat(v, " ")
	end

	return result, v2
end

local function normalizeCategoryOrSubcategory(p, p2)
	if type(p) ~= "table" then
		return nil, "Config must be a table"
	end

	local v = {}
	local pillId = p.props and p.props.pillId
	local id, v2

	if FFlagAXCatalogCategoriesSDUI then
		id, v2 = normalizeNotEmptyString(pillId)
	else
		id, v2 = normalizeString(pillId)
	end

	if v2 then
		table.insert(v, "Id: " .. v2)
	end

	local pillTitle = p.props and p.props.pillTitle
	local name, v3

	if FFlagAXCatalogCategoriesSDUI then
		name, v3 = normalizeNotEmptyString(pillTitle)
	else
		name, v3 = normalizeString(pillTitle)
	end

	if v3 then
		table.insert(v, "Name: " .. v3)
	end

	local pillTitle2 = p.props and p.props.pillTitle
	local localizedTitle, v4

	if FFlagAXCatalogCategoriesSDUI then
		localizedTitle, v4 = normalizeNotEmptyString(pillTitle2)
	else
		localizedTitle, v4 = normalizeString(pillTitle2)
	end

	if v4 then
		table.insert(v, "LocalizedTitle: " .. v4)
	end

	local pillTitle3 = p.props and p.props.pillTitle
	local title, v5

	if FFlagAXCatalogCategoriesSDUI then
		title, v5 = normalizeNotEmptyString(pillTitle3)
	else
		title, v5 = normalizeString(pillTitle3)
	end

	if v5 then
		table.insert(v, "Title: " .. v5)
	end

	local searchUuid, v6 = normalizeSearchUuid() -- inferred equivalent call

	if v6 then
		table.insert(v, "SearchUuid: " .. v6)
	end

	local v7 = extractShowCatalogContentActionRequestParams(p)
	local assetTypeIds = v7 and v7.assetTypeIds
	local v8, assetTypeIdStrings

	if not (assetTypeIds == nil or assetTypeIds == "") then
		local v9
		v9, v8 = normalizeString(assetTypeIds)

		if not v8 then
			assetTypeIdStrings = splitCommaSeparatedString(v9)
			v8 = nil
		end
	end

	if v8 then
		table.insert(v, "AssetTypeIdStrings: " .. v8)
	end

	local v9 = extractShowCatalogContentActionRequestParams(p)
	local bundleTypeIds = v9 and v9.bundleTypeIds
	local v10, bundleTypes

	if not (bundleTypeIds == nil or bundleTypeIds == "") then
		local v11
		v11, v10 = normalizeString(bundleTypeIds)

		if not v10 then
			bundleTypes = splitCommaSeparatedString(v11)
			v10 = nil
		end
	end

	if v10 then
		table.insert(v, "BundleTypes: " .. v10)
	end

	local taxonomyUuid

	if FFlagAXCatalogCategoriesSDUI then
		local v11 = extractShowCatalogContentActionRequestParams(p)
		local taxonomyId = v11 and v11.taxonomyId
		local v12
		taxonomyUuid, v12 = normalizeNotEmptyString(taxonomyId)

		if v12 then
			table.insert(v, "Taxonomy: " .. v12)
		end
	end

	local widgetContext, v11 = normalizeWidgetContext(p) -- inferred equivalent call

	if v11 then
		table.insert(v, "WidgetContext: " .. v11)
	end

	local timeToRefresh = p.props and p.props.timeToRefresh
	local v12, timeToRefresh2

	if not (timeToRefresh == nil or timeToRefresh == "") then
		if type(timeToRefresh) == "string" then
			timeToRefresh = tonumber(timeToRefresh)
		end

		if timeToRefresh ~= nil then
			timeToRefresh2, v12 = normalizeNumber(timeToRefresh)
		end
	end

	if v12 then
		table.insert(v, "TimeToRefresh: " .. v12)
	end

	local cameraFocus, v13 = normalizeCameraFocus(p) -- inferred equivalent call

	if v13 then
		table.insert(v, "CameraFocus: " .. v13)
	end

	local cameraZoomRadius = p.props and p.props.cameraZoomRadius
	local v14, cameraZoomRadius2

	if not (cameraZoomRadius == nil or cameraZoomRadius == "") then
		if type(cameraZoomRadius) == "string" then
			cameraZoomRadius = tonumber(cameraZoomRadius)
		end

		if cameraZoomRadius ~= nil then
			cameraZoomRadius2, v14 = normalizeNumber(cameraZoomRadius)
		end
	end

	if v14 then
		table.insert(v, "CameraZoomRadius: " .. v14)
	end

	local subcategories

	if not p2.isSubcategory then
		local v15
		subcategories, v15 = fn2(p)

		if v15 then
			table.insert(v, "Subcategories: " .. v15)
		end
	end

	local v15 = p.props and p.props.canAnimateCameraBasedMood
	local v16, canAnimateCameraBasedMood

	if not (v15 == nil or v15 == "") then
		if type(v15) ~= "boolean" then
			if type(v15) == "string" then
				if v15 == "True" then
					v15 = true
				elseif v15 == "False" then
					v15 = false
				else
					v16 = "Invalid boolean string value, expected \"True\" or \"False\""
					v15 = nil
				end
			else
				v16 = "Expected boolean or string"
				v15 = nil
			end
		end

		if not v16 then
			canAnimateCameraBasedMood, v16 = normalizeBoolean(v15)
		end
	end

	if v16 then
		table.insert(v, "CanAnimateCameraBasedMood: " .. v16)
	end

	local v17 = p.props and p.props.disableFilters
	local v18, disableFilters

	if not (v17 == nil or v17 == "") then
		if type(v17) ~= "boolean" then
			if type(v17) == "string" then
				if v17 == "True" then
					v17 = true
				elseif v17 == "False" then
					v17 = false
				else
					v18 = "Invalid boolean string value, expected \"True\" or \"False\""
					v17 = nil
				end
			else
				v18 = "Expected boolean or string"
				v17 = nil
			end
		end

		if not v18 then
			disableFilters, v18 = normalizeBoolean(v17)
		end
	end

	if v18 then
		table.insert(v, "DisableFilters: " .. v18)
	end

	local pageType, v19 = normalizePageType(p) -- inferred equivalent call

	if v19 then
		table.insert(v, "PageType: " .. v19)
	end

	local v20 = extractShowCatalogContentActionRequestParams(p)
	local context = v20 and v20.context
	local v21, looksWidgetContextForOrganicContent

	if not (context == nil or context == "") then
		looksWidgetContextForOrganicContent, v21 = normalizeString(context)
	end

	if v21 then
		table.insert(v, "LooksWidgetContextForOrganicContent: " .. v21)
	end

	local tooltipKey, v22 = normalizeTooltipKey(p) -- inferred equivalent call

	if v22 then
		table.insert(v, "TooltipKey: " .. v22)
	end

	local tooltipBody, v23 = normalizeTooltipBody(p) -- inferred equivalent call

	if v23 then
		table.insert(v, "TooltipBody: " .. v23)
	end

	local tileType, v24 = normalizeTileType(p) -- inferred equivalent call

	if v24 then
		table.insert(v, "TileType: " .. v24)
	end

	if #v > 0 then
		return
			nil,
			(p2.isSubcategory and "Subcategory" or "Category") .. " normalization failed: " .. table.concat(v, "; ")
	end

	if not FFlagAXCatalogCategoriesSDUI then
		taxonomyUuid = nil
	end

	local v25 = {
		Id = id,
		Name = name,
		LocalizedTitle = localizedTitle,
		Title = title,
		SearchUuid = searchUuid,
		AssetTypeIdStrings = assetTypeIdStrings,
		BundleTypes = bundleTypes,
		TaxonomyUuid = taxonomyUuid,
		WidgetContext = widgetContext,
		TimeToRefresh = timeToRefresh2,
		CameraFocus = cameraFocus,
		CameraZoomRadius = cameraZoomRadius2,
		CanAnimateCameraBasedMood = canAnimateCameraBasedMood,
		DisableFilters = disableFilters,
		PageType = pageType,
		LooksWidgetContextForOrganicContent = looksWidgetContextForOrganicContent,
		TooltipKey = tooltipKey,
		TooltipBody = tooltipBody,
		TileType = tileType
	}

	if p2.isSubcategory then
		v25.isSubcategory = true
	elseif subcategories and #subcategories > 0 then
		v25.Subcategories = subcategories
	end

	return v25, nil
end

fn = function(config)
	return normalizeCategoryOrSubcategory(config, { isSubcategory = true })
end

local function fn3(item)
	return normalizeCategoryOrSubcategory(item, { isSubcategory = false })
end

local function normalizeConfigs(items)
	if type(items) ~= "table" then
		return {}, "Configs field must be a table"
	end

	local v = {}
	local result = {}

	for _, item in items do
		local v2, v3 = fn3(item)

		if v3 then
			table.insert(v, v3)
		end

		if not v2 or v3 then
			continue
		end

		table.insert(result, v2)
	end

	local v2

	if next(v) then
		v2 = table.concat(v, " ")
	end

	return result, v2
end

local normalizeTableFn = makeNormalizeTableFn({
	Configs = { fn = normalizeConfigs }
})

return function(p)
	if not p or type(p.Configs) ~= "table" then
		return {}, "Configs field is required and must be a table"
	end

	local tableFn, v = normalizeTableFn(p)

	return tableFn and tableFn.Configs or {}, v
end
