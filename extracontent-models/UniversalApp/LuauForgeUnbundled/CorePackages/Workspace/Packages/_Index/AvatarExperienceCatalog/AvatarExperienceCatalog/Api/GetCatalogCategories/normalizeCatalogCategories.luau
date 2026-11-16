local normalize = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local normalizeNotEmptyString = normalize.normalizeNotEmptyString

local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogCategories")

local fFlagAXCatalogCategoriesSDUI = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogCategoriesSDUI

local function SearchUuid()
	return HttpService:GenerateGUID(true)
end

local function extractShowCatalogContentActionRequestParams(p2)
	if p2.props and p2.props.OnActivated then
		for k, v6 in p2.props.OnActivated do
			if v6.componentType == "ShowCatalogContentAction" then
				return v6.props and v6.props.requestParams
			end
		end
	end

	return nil
end

local function extractWidgetContext(p2)
	if p2.props and p2.props.OnActivated then
		for k, v6 in p2.props.OnActivated do
			if v6.componentType == "ShowWidgetContentAction" then
				return v6.props and v6.props.requestParams and v6.props.requestParams.context
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

local function splitCommaSeparatedString(value)
	if not value or value == "" then
		return nil
	end

	local v5 = string.split(value, ",")
	local v6 = {}

	for k, v7 in v5 do
		if v7 ~= "" then
			table.insert(v6, v7)
		end
	end

	return #v6 > 0 and v6 or nil
end

local function normalizeAssetTypeIdStrings(p2)
	local v5 = extractShowCatalogContentActionRequestParams(p2)
	local assetTypeIds = v5 and v5.assetTypeIds

	if assetTypeIds == nil or assetTypeIds == "" then
		return nil, nil
	end

	local str, v6 = normalizeString(assetTypeIds)

	if v6 then
		return nil, v6
	end

	return splitCommaSeparatedString(str), nil
end

local function normalizeBundleTypes(p2)
	local v5 = extractShowCatalogContentActionRequestParams(p2)
	local bundleTypeIds = v5 and v5.bundleTypeIds

	if bundleTypeIds == nil or bundleTypeIds == "" then
		return nil, nil
	end

	local str, v6 = normalizeString(bundleTypeIds)

	if v6 then
		return nil, v6
	end

	return splitCommaSeparatedString(str), nil
end

local function normalizeTaxonomy(p2)
	local v5 = extractShowCatalogContentActionRequestParams(p2)
	local taxonomyId = v5 and v5.taxonomyId

	local notEmptyString, v6 = normalizeNotEmptyString(taxonomyId)
	return notEmptyString, v6
end

local function normalizeWidgetContext(p2)
	return extractWidgetContext(p2), nil
end

local function normalizeSearchUuid()
	return HttpService:GenerateGUID(true), nil
end

local function normalizePillTitle(p2)
	local pillTitle = p2.props and p2.props.pillTitle

	if fFlagAXCatalogCategoriesSDUI then
		local notEmptyString, v5 = normalizeNotEmptyString(pillTitle)
		return notEmptyString, v5
	end

	local str, v5 = normalizeString(pillTitle)

	return str, v5
end

local function normalizePillId(p2)
	local pillId = p2.props and p2.props.pillId

	if fFlagAXCatalogCategoriesSDUI then
		local notEmptyString, v5 = normalizeNotEmptyString(pillId)
		return notEmptyString, v5
	end

	local str, v5 = normalizeString(pillId)

	return str, v5
end

local function normalizeTimeToRefresh(p2)
	local timeToRefresh = p2.props and p2.props.timeToRefresh

	if timeToRefresh == nil or timeToRefresh == "" then
		return nil, nil
	end

	if type(timeToRefresh) == "string" then
		timeToRefresh = tonumber(timeToRefresh)
	end

	if timeToRefresh == nil then
		return nil, nil
	end

	local number, v5 = normalizeNumber(timeToRefresh)
	return number, v5
end

local function normalizeCameraFocus(p2)
	local cameraFocus = p2.props and p2.props.cameraFocus
	local notEmptyString, v5 = normalizeNotEmptyString(cameraFocus)
	return notEmptyString, v5
end

local function normalizeCameraZoomRadius(p2)
	local cameraZoomRadius = p2.props and p2.props.cameraZoomRadius

	if cameraZoomRadius == nil or cameraZoomRadius == "" then
		return nil, nil
	end

	if type(cameraZoomRadius) == "string" then
		cameraZoomRadius = tonumber(cameraZoomRadius)
	end

	if cameraZoomRadius == nil then
		return nil, nil
	end

	local number, v5 = normalizeNumber(cameraZoomRadius)
	return number, v5
end

local function normalizeCanAnimateCameraBasedMood(p2)
	local v5 = p2.props and p2.props.canAnimateCameraBasedMood

	if v5 == nil or v5 == "" then
		return nil, nil
	end

	local v6

	if type(v5) ~= "boolean" then
		if type(v5) == "string" then
			if v5 == "True" then
				v5 = true
			elseif v5 == "False" then
				v5 = false
			else
				v6 = "Invalid boolean string value, expected \"True\" or \"False\""
				v5 = nil
			end
		else
			v6 = "Expected boolean or string"
			v5 = nil
		end
	end

	if v6 then
		return nil, v6
	end

	local boolean, v7 = normalizeBoolean(v5)
	return boolean, v7
end

local function normalizeDisableFilters(p2)
	local v5 = p2.props and p2.props.disableFilters

	if v5 == nil or v5 == "" then
		return nil, nil
	end

	local v6

	if type(v5) ~= "boolean" then
		if type(v5) == "string" then
			if v5 == "True" then
				v5 = true
			elseif v5 == "False" then
				v5 = false
			else
				v6 = "Invalid boolean string value, expected \"True\" or \"False\""
				v5 = nil
			end
		else
			v6 = "Expected boolean or string"
			v5 = nil
		end
	end

	if v6 then
		return nil, v6
	end

	local boolean, v7 = normalizeBoolean(v5)
	return boolean, v7
end

local function normalizePageType(p2)
	local pageType = p2.props and p2.props.pageType
	local notEmptyString, v5 = normalizeNotEmptyString(pageType)
	return notEmptyString, v5
end

local function normalizeLooksWidgetContextForOrganicContent(p2)
	local v5 = extractShowCatalogContentActionRequestParams(p2)
	local context = v5 and v5.context

	if context == nil or context == "" then
		return nil, nil
	end

	local str, v6 = normalizeString(context)
	return str, v6
end

local function normalizeTooltipKey(p2)
	local tooltipKey = p2.props and p2.props.tooltipKey
	local notEmptyString, v5 = normalizeNotEmptyString(tooltipKey)
	return notEmptyString, v5
end

local function normalizeTooltipBody(p2)
	local tooltipBody = p2.props and p2.props.tooltipBody
	local notEmptyString, v5 = normalizeNotEmptyString(tooltipBody)
	return notEmptyString, v5
end

local function normalizeTileType(p2)
	local tileType = p2.props and p2.props.tileType
	local notEmptyString, v5 = normalizeNotEmptyString(tileType)
	return notEmptyString, v5
end

local fn

local function fn2(p2)
	if not p2.props or not p2.props.Configs or type(p2.props.Configs) ~= "table" then
		return nil, nil
	end

	local v5 = {}
	local result = {}

	for k, config in p2.props.Configs do
		local v6, v7 = fn(config)

		if v7 then
			table.insert(v5, v7)
		end

		if not v6 or v7 then
			continue
		end

		table.insert(result, v6)
	end

	local v6 = if next(v5) then table.concat(v5, " ") else nil

	return result, v6
end

local function normalizeCategoryOrSubcategory(p2, p3)
	if type(p2) ~= "table" then
		return nil, "Config must be a table"
	end

	local v5 = {}
	local pillId = p2.props and p2.props.pillId
	local v6, v7

	if fFlagAXCatalogCategoriesSDUI then
		v6, v7 = normalizeNotEmptyString(pillId)
	else
		v6, v7 = normalizeString(pillId)
	end

	if v7 then
		table.insert(v5, "Id: " .. v7)
	end

	local pillTitle = p2.props and p2.props.pillTitle
	local v8, v9

	if fFlagAXCatalogCategoriesSDUI then
		v8, v9 = normalizeNotEmptyString(pillTitle)
	else
		v8, v9 = normalizeString(pillTitle)
	end

	if v9 then
		table.insert(v5, "Name: " .. v9)
	end

	local pillTitle2 = p2.props and p2.props.pillTitle
	local v10, v11

	if fFlagAXCatalogCategoriesSDUI then
		v10, v11 = normalizeNotEmptyString(pillTitle2)
	else
		v10, v11 = normalizeString(pillTitle2)
	end

	if v11 then
		table.insert(v5, "LocalizedTitle: " .. v11)
	end

	local pillTitle3 = p2.props and p2.props.pillTitle
	local v12, v13

	if fFlagAXCatalogCategoriesSDUI then
		v12, v13 = normalizeNotEmptyString(pillTitle3)
	else
		v12, v13 = normalizeString(pillTitle3)
	end

	if v13 then
		table.insert(v5, "Title: " .. v13)
	end

	local guid = HttpService:GenerateGUID(true)

	local v14 = nil

	if v14 then
		table.insert(v5, "SearchUuid: " .. v14)
	end

	local v15 = extractShowCatalogContentActionRequestParams(p2)
	local assetTypeIds = v15 and v15.assetTypeIds
	local v16, v17

	if not (assetTypeIds == nil or assetTypeIds == "") then
		local v18
		v18, v16 = normalizeString(assetTypeIds)

		if not v16 then
			v17 = splitCommaSeparatedString(v18)
			v16 = nil
		end
	end

	if v16 then
		table.insert(v5, "AssetTypeIdStrings: " .. v16)
	end

	local v18 = extractShowCatalogContentActionRequestParams(p2)
	local bundleTypeIds = v18 and v18.bundleTypeIds
	local v19, v20

	if not (bundleTypeIds == nil or bundleTypeIds == "") then
		local v21
		v21, v19 = normalizeString(bundleTypeIds)

		if not v19 then
			v20 = splitCommaSeparatedString(v21)
			v19 = nil
		end
	end

	if v19 then
		table.insert(v5, "BundleTypes: " .. v19)
	end

	local v21

	if fFlagAXCatalogCategoriesSDUI then
		local v22 = extractShowCatalogContentActionRequestParams(p2)
		local taxonomyId = v22 and v22.taxonomyId
		local v23
		v21, v23 = normalizeNotEmptyString(taxonomyId)

		if v23 then
			table.insert(v5, "Taxonomy: " .. v23)
		end
	end

	local v22 = extractWidgetContext(p2)
	local v23 = nil

	if v23 then
		table.insert(v5, "WidgetContext: " .. v23)
	end

	local timeToRefresh = p2.props and p2.props.timeToRefresh
	local v24, v25

	if not (timeToRefresh == nil or timeToRefresh == "") then
		if type(timeToRefresh) == "string" then
			timeToRefresh = tonumber(timeToRefresh)
		end

		if timeToRefresh ~= nil then
			v25, v24 = normalizeNumber(timeToRefresh)
		end
	end

	if v24 then
		table.insert(v5, "TimeToRefresh: " .. v24)
	end

	local cameraFocus = p2.props and p2.props.cameraFocus
	local notEmptyString, v26 = normalizeNotEmptyString(cameraFocus)

	if v26 then
		table.insert(v5, "CameraFocus: " .. v26)
	end

	local cameraZoomRadius = p2.props and p2.props.cameraZoomRadius
	local v27, v28

	if not (cameraZoomRadius == nil or cameraZoomRadius == "") then
		if type(cameraZoomRadius) == "string" then
			cameraZoomRadius = tonumber(cameraZoomRadius)
		end

		if cameraZoomRadius ~= nil then
			v28, v27 = normalizeNumber(cameraZoomRadius)
		end
	end

	if v27 then
		table.insert(v5, "CameraZoomRadius: " .. v27)
	end

	local v29

	if not p3.isSubcategory then
		local v30
		v29, v30 = fn2(p2)

		if v30 then
			table.insert(v5, "Subcategories: " .. v30)
		end
	end

	local v30 = p2.props and p2.props.canAnimateCameraBasedMood
	local v31, v32

	if not (v30 == nil or v30 == "") then
		if type(v30) ~= "boolean" then
			if type(v30) == "string" then
				if v30 == "True" then
					v30 = true
				elseif v30 == "False" then
					v30 = false
				else
					v31 = "Invalid boolean string value, expected \"True\" or \"False\""
					v30 = nil
				end
			else
				v31 = "Expected boolean or string"
				v30 = nil
			end
		end

		if not v31 then
			v32, v31 = normalizeBoolean(v30)
		end
	end

	if v31 then
		table.insert(v5, "CanAnimateCameraBasedMood: " .. v31)
	end

	local v33 = p2.props and p2.props.disableFilters
	local v34, v35

	if not (v33 == nil or v33 == "") then
		if type(v33) ~= "boolean" then
			if type(v33) == "string" then
				if v33 == "True" then
					v33 = true
				elseif v33 == "False" then
					v33 = false
				else
					v34 = "Invalid boolean string value, expected \"True\" or \"False\""
					v33 = nil
				end
			else
				v34 = "Expected boolean or string"
				v33 = nil
			end
		end

		if not v34 then
			v35, v34 = normalizeBoolean(v33)
		end
	end

	if v34 then
		table.insert(v5, "DisableFilters: " .. v34)
	end

	local pageType = p2.props and p2.props.pageType
	local notEmptyString2, v36 = normalizeNotEmptyString(pageType)

	if v36 then
		table.insert(v5, "PageType: " .. v36)
	end

	local v37 = extractShowCatalogContentActionRequestParams(p2)
	local context = v37 and v37.context
	local v38, v39

	if not (context == nil or context == "") then
		v39, v38 = normalizeString(context)
	end

	if v38 then
		table.insert(v5, "LooksWidgetContextForOrganicContent: " .. v38)
	end

	local tooltipKey = p2.props and p2.props.tooltipKey
	local notEmptyString3, v40 = normalizeNotEmptyString(tooltipKey)

	if v40 then
		table.insert(v5, "TooltipKey: " .. v40)
	end

	local tooltipBody = p2.props and p2.props.tooltipBody
	local notEmptyString4, v41 = normalizeNotEmptyString(tooltipBody)

	if v41 then
		table.insert(v5, "TooltipBody: " .. v41)
	end

	local tileType = p2.props and p2.props.tileType
	local notEmptyString5, v42 = normalizeNotEmptyString(tileType)

	if v42 then
		table.insert(v5, "TileType: " .. v42)
	end

	if #v5 > 0 then
		return
			nil,
			(p3.isSubcategory and "Subcategory" or "Category") .. " normalization failed: " .. table.concat(v5, "; ")
	end

	if not fFlagAXCatalogCategoriesSDUI then
		v21 = nil
	end

	local v43 = {
		Id = v6,
		Name = v8,
		LocalizedTitle = v10,
		Title = v12,
		SearchUuid = guid,
		AssetTypeIdStrings = v17,
		BundleTypes = v20,
		TaxonomyUuid = v21,
		WidgetContext = v22,
		TimeToRefresh = v25,
		CameraFocus = notEmptyString,
		CameraZoomRadius = v28,
		CanAnimateCameraBasedMood = v32,
		DisableFilters = v35,
		PageType = notEmptyString2,
		LooksWidgetContextForOrganicContent = v39,
		TooltipKey = notEmptyString3,
		TooltipBody = notEmptyString4,
		TileType = notEmptyString5
	}

	if p3.isSubcategory then
		v43.isSubcategory = true
	elseif v29 and #v29 > 0 then
		v43.Subcategories = v29
	end

	return v43, nil
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

	local v5 = {}
	local result = {}

	for k, item in items do
		local v6, v7 = fn3(item)

		if v7 then
			table.insert(v5, v7)
		end

		if not v6 or v7 then
			continue
		end

		table.insert(result, v6)
	end

	local v6 = if next(v5) then table.concat(v5, " ") else nil

	return result, v6
end

local normalizeTableFn = makeNormalizeTableFn({
	Configs = { fn = normalizeConfigs }
})

return function(p2)
	if not p2 or type(p2.Configs) ~= "table" then
		return {}, "Configs field is required and must be a table"
	end

	local tableFn, v5 = normalizeTableFn(p2)

	return tableFn and tableFn.Configs or {}, v5
end
