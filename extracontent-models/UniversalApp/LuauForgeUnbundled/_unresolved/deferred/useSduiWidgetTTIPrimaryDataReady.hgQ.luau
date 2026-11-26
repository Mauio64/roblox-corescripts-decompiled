local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore
local selectHydratedWidgetData = AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData

local fFlagAXSduiWidgetsTTITracking = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSduiWidgetsTTITracking

local widgetsPercievedTTIManager = require("@luauforge/bundled/gLF").WidgetsPercievedTTIManager

local function useSduiWidgetTTIPrimaryDataReady(data)
	local searchUuid = data.searchUuid
	local resultsAreSduiEnabled = data.resultsAreSduiEnabled
	local identifier = data.identifier

	local v5 = useSelector(selectHydratedWidgetData)

	local catalogPageRequestIdStore = getCatalogPageRequestIdStore(false)

	local v7 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			local pageRequestIdMap = catalogPageRequestIdStore.getPageRequestIdMap(p2)

			if identifier == nil then
				return nil
			end

			return pageRequestIdMap[identifier]
		end)
	end, { identifier, catalogPageRequestIdStore })))

	local ref = React.useRef(nil)

	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if not (resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking and v7 ~= nil) then
			return
		end

		if searchUuid == nil or searchUuid == "" then
			return
		end

		if ref2.current == nil or ref2.current.pageRequestId ~= v7 then
			ref2.current = { pageRequestId = v7, hydratedWidgetData = v5 }

			return
		end

		if v5 == nil or next(v5) == nil or v5 == ref2.current.hydratedWidgetData then
			return
		end

		local v8 = searchUuid .. "|" .. v7

		if ref.current == v8 then
			return
		end

		ref.current = v8
		widgetsPercievedTTIManager.L2.primaryDataReady()
	end, { v5, v7, searchUuid, resultsAreSduiEnabled })
end

return useSduiWidgetTTIPrimaryDataReady
