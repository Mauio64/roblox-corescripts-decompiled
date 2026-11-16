local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore
local selectHydratedWidgetData = AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking

local fFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity = AvatarExperienceFlags.FFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity

local module3 = require("@luauforge/deferred/gPo")

local function useSduiWidgetTTITileLatency(data)
	local searchUuid = data.searchUuid
	local resultsAreSduiEnabled = data.resultsAreSduiEnabled
	local identifier = data.identifier

	local v5 = useSelector(selectHydratedWidgetData)

	local v6 = module3(searchUuid or "")

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

	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(v6)
	ref4.current = v6
	local ref5, ref6, ref7, ref8

	if fFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity then
		ref5 = React.useRef(v5)
		ref5.current = v5
		ref6 = React.useRef(v7)
		ref6.current = v7
		ref7 = React.useRef(searchUuid)
		ref7.current = searchUuid
		ref8 = React.useRef(resultsAreSduiEnabled)
		ref8.current = resultsAreSduiEnabled
	else
		ref8 = nil
		ref6 = nil
		ref7 = nil
		ref5 = nil
	end

	React.useEffect(function()
		if not (resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking and v6.trackerStartTime ~= nil and v7 ~= nil) then
			return
		end

		if searchUuid == nil or searchUuid == "" then
			return
		end

		if ref3.current == nil or ref3.current.pageRequestId ~= v7 then
			ref3.current = { pageRequestId = v7, hydratedWidgetData = v5 }

			return
		end

		if v5 == nil or next(v5) == nil or v5 == ref3.current.hydratedWidgetData then
			return
		end

		local v8 = searchUuid .. "|" .. v7

		if ref.current == v8 then
			return
		end

		ref.current = v8

		v6.fireTileLoadingLatencyTracker(v6, nil, true)
	end, { v5, v7, searchUuid, resultsAreSduiEnabled, v6.trackerStartTime })
	local v8

	if fFlagAXFixSduiWidgetTTITileLatencyCallbackIdentity then
		v8 = React.useCallback(function(p2)
			if not (ref8.current and fFlagAXSduiWidgetsTTITracking) then
				return
			end

			local current = ref4.current

			if current.trackerStartTime == nil then
				return
			end

			local current2 = ref6.current

			if current2 == nil then
				return
			end

			local current3 = ref7.current

			if current3 == nil or current3 == "" then
				return
			end

			local current4 = ref3.current

			if current4 == nil or current4.pageRequestId ~= current2 then
				return
			end

			local current5 = ref5.current

			if current5 == nil or next(current5) == nil or current5 == current4.hydratedWidgetData then
				return
			end

			local v9 = current3 .. "|" .. current2

			if ref2.current == v9 then
				return
			end

			ref2.current = v9

			current.fireTileLoadingLatencyTracker(current, true, true)
		end, {})
	else
		v8 = React.useCallback(function(p2)
			if not (resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking) then
				return
			end

			local current = ref4.current

			if current.trackerStartTime == nil or v7 == nil or (searchUuid == nil or searchUuid == "") then
				return
			end

			local current2 = ref3.current

			if current2 == nil or current2.pageRequestId ~= v7 or (v5 == nil or next(v5) == nil) then
				return
			end

			if v5 == current2.hydratedWidgetData then
				return
			end

			local v9 = searchUuid .. "|" .. v7

			if ref2.current == v9 then
				return
			end

			ref2.current = v9

			current.fireTileLoadingLatencyTracker(current, true, true)
		end, { v5, v7, searchUuid, resultsAreSduiEnabled })
	end

	if resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking then
		return v8
	end

	return nil
end

return useSduiWidgetTTITileLatency
