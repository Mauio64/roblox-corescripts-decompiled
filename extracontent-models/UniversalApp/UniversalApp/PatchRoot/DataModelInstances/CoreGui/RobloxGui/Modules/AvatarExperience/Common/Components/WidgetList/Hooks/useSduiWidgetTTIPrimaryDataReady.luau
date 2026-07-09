local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Signals = require(CorePackages.Packages.Signals)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore
local selectHydratedWidgetData = AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData
local FFlagAXSduiWidgetsTTITracking = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSduiWidgetsTTITracking
local WidgetsPercievedTTIManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).WidgetsPercievedTTIManager

local function useSduiWidgetTTIPrimaryDataReady(t1: {[any]: any}) -- line: 44
	-- upvalues: useSelector (copy), selectHydratedWidgetData (copy), getCatalogPageRequestIdStore (copy), React (copy), Signals (copy), useSignalState (copy), FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy)
	local searchUuid = t1.searchUuid
	local resultsAreSduiEnabled = t1.resultsAreSduiEnabled
	local identifier = t1.identifier
	local v16 = useSelector(selectHydratedWidgetData)
	local v17 = getCatalogPageRequestIdStore(false)
	local v18 = React.useMemo(function() -- line: 56
		-- upvalues: Signals (copy), v17 (copy), identifier (copy)
		return Signals.createComputed(function(p1) -- line: 57
			-- upvalues: v17 (copy), identifier (copy)
			local v24 = v17.getPageRequestIdMap(p1)

			if identifier ~= nil then
				return v24[identifier]
			end

			return nil
		end)
	end, {
		identifier,
		v17
	})
	local v19 = useSignalState(v18)
	local v20 = React.useRef(nil)
	local v21 = React.useRef(nil)

	React.useEffect(function() -- line: 69
		-- upvalues: resultsAreSduiEnabled (copy), FFlagAXSduiWidgetsTTITracking (copy), v19 (copy), searchUuid (copy), v21 (copy), v16 (copy), v20 (copy), WidgetsPercievedTTIManager (copy)
		if not resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
			return
		end

		if v19 == nil then
			return
		end

		if searchUuid == nil or searchUuid == "" then
			return
		end

		if v21.current == nil or v21.current.pageRequestId ~= v19 then
			v21.current = {
				pageRequestId = v19,
				hydratedWidgetData = v16
			}

			return
		end

		if v16 == nil or next(v16) == nil then
			return
		end

		if v16 == v21.current.hydratedWidgetData then
			return
		end

		local v22 = searchUuid .. "|" .. v19

		if v22 == v20.current then
			return
		end

		v20.current = v22
		WidgetsPercievedTTIManager.L2.primaryDataReady()
	end, {
		v16,
		v19,
		searchUuid,
		resultsAreSduiEnabled
	})
end

return useSduiWidgetTTIPrimaryDataReady
