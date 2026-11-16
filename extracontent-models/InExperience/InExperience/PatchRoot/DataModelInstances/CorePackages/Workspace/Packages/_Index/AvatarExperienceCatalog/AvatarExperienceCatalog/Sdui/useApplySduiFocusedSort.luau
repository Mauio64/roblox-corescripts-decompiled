local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
require(parent.AvatarExperienceRodux)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiSeeAllPageRequestId = AvatarExperienceFlags.FFlagAXSduiSeeAllPageRequestId

local buildFocusedSortWidgetInfo = require(script.Parent.buildFocusedSortWidgetInfo)
local hydrateCatalogSortById = require(script.Parent.hydrateCatalogSortById)

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

		for k2, v in item do
			if typeof(v) == "table" and v.failedToHydrate ~= true then
				set[tostring(k2)] = true
			end
		end

		if next(set) ~= nil then
			result[tostring(k)] = set
		end
	end

	return if next(result) ~= nil then result else nil
end

local function useApplySduiFocusedSort(data)
	local v = useDispatch()
	local useCallback = React.useCallback
	local function fn(data2, p: string?, p2): boolean
		if not p or p == "" then
			Logging.warn("useApplySduiFocusedSort: missing context for sortId=" .. tostring(data2 and data2.sortId) .. "; SDUI catalog isn't propagating context to ResultsList. Verify FFlagAXMigrateAllTabToSduiDev is on.")

			return false
		end

		local v2 = {
			title = data2.title,
			description = data2.description,
			tooltipText = data2.tooltipText
		}
		local v3

		if FFlagAXSduiSeeAllPageRequestId then
			local v4

			if data.getPageRequestId then
				v4 = data.getPageRequestId()
			end

			v3 = buildFocusedSortWidgetInfo(data2.sortId, p, v2, v4)
		else
			v3 = buildFocusedSortWidgetInfo(data2.sortId, p, v2)
		end

		if not v3 then
			Logging.warn("useApplySduiFocusedSort: synthesizer returned nil for sortId=" .. tostring(data2.sortId) .. " context=" .. tostring(p))

			return false
		end

		v(data.SetWidgetInfo(v3.widgetInfo, v3.requestId, nil, p))
		local v4

		if data.getHydratedWidgetData then
			v4 = buildAlreadyHydratedSet(data.getHydratedWidgetData())
		end

		hydrateCatalogSortById(v, p2, data.SetHydratedWidgetData, data.CatalogWebApi, data2.sortId, v4)

		return true
	end

	local setWidgetInfo = data.SetWidgetInfo
	local setHydratedWidgetData = data.SetHydratedWidgetData
	local catalogWebApi = data.CatalogWebApi
	local getHydratedWidgetData = data.getHydratedWidgetData
	local v2

	if FFlagAXSduiSeeAllPageRequestId then
		v2 = data.getPageRequestId
	end

	return useCallback(fn, {
		v,
		setWidgetInfo,
		setHydratedWidgetData,
		catalogWebApi,
		getHydratedWidgetData,
		v2
	})
end

return useApplySduiFocusedSort
