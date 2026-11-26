local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Logging

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local fFlagAXSduiSeeAllPageRequestId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXSduiSeeAllPageRequestId

local buildFocusedSortWidgetInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/buildFocusedSortWidgetInfo")
local hydrateCatalogSortById = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/hydrateCatalogSortById")

local function buildAlreadyHydratedSet(items)
	if not items then
		return nil
	end

	local result = {}

	for k, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		local set = {}

		for k2, v5 in item do
			if typeof(v5) == "table" and v5.failedToHydrate ~= true then
				set[tostring(k2)] = true
			end
		end

		if next(set) ~= nil then
			result[tostring(k)] = set
		end
	end

	if next(result) == nil then
		return nil
	end

	return result
end

local function useApplySduiFocusedSort(data)
	local v5 = useDispatch()
	local useCallback = React.useCallback
	local function fn(data2, p2, p3): boolean
		if not p2 or p2 == "" then
			logging.warn("useApplySduiFocusedSort: missing context for sortId=" .. tostring(data2 and data2.sortId) .. "; SDUI catalog isn't propagating context to ResultsList. Verify FFlagAXMigrateAllTabToSduiDev is on.")

			return false
		end

		local v6 = {
			title = data2.title,
			description = data2.description,
			tooltipText = data2.tooltipText
		}
		local v7

		if fFlagAXSduiSeeAllPageRequestId then
			local v8 = if data.getPageRequestId then data.getPageRequestId() else nil
			v7 = buildFocusedSortWidgetInfo(data2.sortId, p2, v6, v8)
		else
			v7 = buildFocusedSortWidgetInfo(data2.sortId, p2, v6)
		end

		if not v7 then
			logging.warn("useApplySduiFocusedSort: synthesizer returned nil for sortId=" .. tostring(data2.sortId) .. " context=" .. tostring(p2))

			return false
		end

		v5(data.SetWidgetInfo(v7.widgetInfo, v7.requestId, nil, p2))

		local v8 = if data.getHydratedWidgetData then buildAlreadyHydratedSet(data.getHydratedWidgetData()) else nil

		hydrateCatalogSortById(v5, p3, data.SetHydratedWidgetData, data.CatalogWebApi, data2.sortId, v8)

		return true
	end

	local setWidgetInfo = data.SetWidgetInfo
	local setHydratedWidgetData = data.SetHydratedWidgetData
	local catalogWebApi = data.CatalogWebApi
	local getHydratedWidgetData = data.getHydratedWidgetData
	local v7 = if fFlagAXSduiSeeAllPageRequestId then data.getPageRequestId else nil
	return useCallback(fn, {
		v5,
		setWidgetInfo,
		setHydratedWidgetData,
		catalogWebApi,
		getHydratedWidgetData,
		v7
	})
end

return useApplySduiFocusedSort
