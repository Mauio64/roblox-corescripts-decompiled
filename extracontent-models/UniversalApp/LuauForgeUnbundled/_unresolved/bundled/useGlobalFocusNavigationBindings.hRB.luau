local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local useOverlayFocusNavigationBindings

if fFlagEnableSplitPaneAvatarOverlay then
	useOverlayFocusNavigationBindings = require("@luauforge/bundled/hRC").Hooks.useOverlayFocusNavigationBindings
else
	useOverlayFocusNavigationBindings = nil
end

local useGamepadBumperNavigationBindings = require("@luauforge/bundled/hQP").useGamepadBumperNavigationBindings

local fFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation

local fFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour
local useSignalState

if fFlagSplitPaneEducationalTour then
	local SignalsReact = require(CorePackages.Packages.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local getSplitPaneEducationalTourStore

if fFlagSplitPaneEducationalTour then
	getSplitPaneEducationalTourStore = require("@luauforge/bundled/dFR").getSplitPaneEducationalTourStore
else
	getSplitPaneEducationalTourStore = nil
end

local function useGlobalFocusNavigationBindings(p2)
	local eventMap, eventHandlerMap, isBumperNavigationEnabled

	if fFlagAddGamepadBumperNavigation then
		local v5 = useGamepadBumperNavigationBindings(p2)
		eventMap = v5.eventMap
		eventHandlerMap = v5.eventHandlerMap
		isBumperNavigationEnabled = v5.isBumperNavigationEnabled
	else
		isBumperNavigationEnabled = nil
		eventMap = nil
		eventHandlerMap = nil
	end

	local eventMap2, eventHandlers

	if fFlagEnableSplitPaneAvatarOverlay then
		local v5 = useOverlayFocusNavigationBindings()
		eventMap2 = v5.eventMap
		eventHandlers = v5.eventHandlers
	else
		eventMap2 = nil
		eventHandlers = nil
	end

	local v5, v6 = React.useMemo(function()
		local v7 = {}
		local v8 = {}

		if fFlagAddGamepadBumperNavigation and isBumperNavigationEnabled then
			local event = eventMap[Enum.KeyCode.ButtonL1]
			v7[Enum.KeyCode.ButtonL1] = event
			v8[event] = eventHandlerMap[event]
		end

		if fFlagAddGamepadBumperNavigation and isBumperNavigationEnabled then
			local event = eventMap[Enum.KeyCode.ButtonR1]
			v7[Enum.KeyCode.ButtonR1] = event
			v8[event] = eventHandlerMap[event]
		end

		local v9 = if fFlagEnableSplitPaneAvatarOverlay then eventMap2[Enum.KeyCode.ButtonL2] else nil

		if v9 then
			v7[Enum.KeyCode.ButtonL2] = v9
			v8[v9] = eventHandlers[v9]
		end

		local v10 = if fFlagEnableSplitPaneAvatarOverlay then eventMap2[Enum.KeyCode.ButtonR2] else nil

		if v10 then
			v7[Enum.KeyCode.ButtonR2] = v10
			v8[v10] = eventHandlers[v10]
		end

		local v11 = if fFlagEnableSplitPaneAvatarOverlay then eventMap2[Enum.KeyCode.ButtonR3] else nil

		if v11 then
			v7[Enum.KeyCode.ButtonR3] = v11
			v8[v11] = eventHandlers[v11]
		end

		return v7, v8
	end, {
		isBumperNavigationEnabled,
		eventMap,
		eventHandlerMap,
		eventMap2,
		eventHandlers
	})

	local v7 = if fFlagSplitPaneEducationalTour then useSignalState(getSplitPaneEducationalTourStore(false).getIsTourActive) else false

	local v8 = fFlagSplitPaneEducationalTour and v7

	local v9 = {
		isBumperNavigationEnabled = if not v8 then isBumperNavigationEnabled else nil,
		eventMap = nil,
		eventHandlerMap = nil
	}

	if v8 then
		v5 = nil
	end

	v9.eventMap = v5

	if v8 then
		v6 = nil
	end

	v9.eventHandlerMap = v6
	return v9
end

return useGlobalFocusNavigationBindings
