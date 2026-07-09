local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Signals = require(CorePackages.Packages.Signals)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore
local selectHydratedWidgetData = AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking
local FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity = AvatarExperienceFlags.FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity
local useTileLoadingLatencyInitializer = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileLoadingLatencyInitializer)

local function useSduiWidgetTTITileLatency(t1: {[any]: any}) -- line: 47
	-- upvalues: useSelector (copy), selectHydratedWidgetData (copy), useTileLoadingLatencyInitializer (copy), getCatalogPageRequestIdStore (copy), React (copy), Signals (copy), useSignalState (copy), FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity (copy), FFlagAXSduiWidgetsTTITracking (copy)
	local searchUuid = t1.searchUuid
	local resultsAreSduiEnabled = t1.resultsAreSduiEnabled
	local identifier = t1.identifier
	local v19 = useSelector(selectHydratedWidgetData)
	local v20 = useTileLoadingLatencyInitializer(searchUuid or "")
	local v21 = getCatalogPageRequestIdStore(false)
	local v22 = React.useMemo(function() -- line: 62
		-- upvalues: Signals (copy), v21 (copy), identifier (copy)
		return Signals.createComputed(function(p1) -- line: 63
			-- upvalues: v21 (copy), identifier (copy)
			local v46 = v21.getPageRequestIdMap(p1)

			if identifier ~= nil then
				return v46[identifier]
			end

			return nil
		end)
	end, {
		identifier,
		v21
	})
	local v23 = useSignalState(v22)
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27 = React.useRef(v20)

	v27.current = v20

	local u28 = nil
	local u29 = nil
	local u30 = nil
	local u31 = nil

	if FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity then
		u28 = React.useRef(v19)
		u28.current = v19
		u29 = React.useRef(v23)
		u29.current = v23
		u30 = React.useRef(searchUuid)
		u30.current = searchUuid
		u31 = React.useRef(resultsAreSduiEnabled)
		u31.current = resultsAreSduiEnabled
	end

	React.useEffect(function() -- line: 96
		-- upvalues: resultsAreSduiEnabled (copy), FFlagAXSduiWidgetsTTITracking (copy), v20 (copy), v23 (copy), searchUuid (copy), v26 (copy), v19 (copy), v24 (copy)
		if not resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
			return
		end

		if v20.trackerStartTime == nil then
			return
		end

		if v23 == nil then
			return
		end

		if searchUuid == nil or searchUuid == "" then
			return
		end

		if v26.current == nil or v26.current.pageRequestId ~= v23 then
			v26.current = {
				pageRequestId = v23,
				hydratedWidgetData = v19
			}

			return
		end

		if v19 == nil or next(v19) == nil then
			return
		end

		if v19 == v26.current.hydratedWidgetData then
			return
		end

		local v33 = searchUuid .. "|" .. v23

		if v33 == v24.current then
			return
		end

		v24.current = v33
		v20.fireTileLoadingLatencyTracker(v20, nil, true)
	end, {
		v19,
		v23,
		searchUuid,
		resultsAreSduiEnabled,
		v20.trackerStartTime
	})

	local v32 = if not FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity then React.useCallback(function(_: string?) -- line: 191
		-- upvalues: resultsAreSduiEnabled (copy), FFlagAXSduiWidgetsTTITracking (copy), v27 (copy), v23 (copy), searchUuid (copy), v26 (copy), v19 (copy), v25 (copy)
		if not resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
			return
		end

		local current = v27.current

		if current.trackerStartTime == nil then
			return
		end

		if v23 == nil then
			return
		end

		if searchUuid == nil or searchUuid == "" then
			return
		end

		local current2 = v26.current

		if current2 == nil or current2.pageRequestId ~= v23 then
			return
		end

		if v19 == nil or next(v19) == nil then
			return
		end

		if v19 == current2.hydratedWidgetData then
			return
		end

		local v44 = searchUuid .. "|" .. v23

		if v44 == v25.current then
			return
		end

		v25.current = v44
		current:fireTileLoadingLatencyTracker(true, true)
	end, {
		v19,
		v23,
		searchUuid,
		resultsAreSduiEnabled
	}) else React.useCallback(function(_: string?) -- line: 148
		-- upvalues: u31 (ref), FFlagAXSduiWidgetsTTITracking (copy), v27 (copy), u29 (ref), u30 (ref), v26 (copy), u28 (ref), v25 (copy)
		if not u31.current or not FFlagAXSduiWidgetsTTITracking then
			return
		end

		local current = v27.current

		if current.trackerStartTime == nil then
			return
		end

		local current3 = u29.current

		if current3 == nil then
			return
		end

		local current4 = u30.current

		if current4 == nil or current4 == "" then
			return
		end

		local current5 = v26.current

		if current5 == nil or current3 ~= current5.pageRequestId then
			return
		end

		local current6 = u28.current

		if current6 == nil or next(current6) == nil then
			return
		end

		if current6 == current5.hydratedWidgetData then
			return
		end

		local v40 = current4 .. "|" .. current3

		if v40 == v25.current then
			return
		end

		v25.current = v40
		current:fireTileLoadingLatencyTracker(true, true)
	end, {})

	if not resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
		return nil
	end

	return v32
end

return useSduiWidgetTTITileLatency
