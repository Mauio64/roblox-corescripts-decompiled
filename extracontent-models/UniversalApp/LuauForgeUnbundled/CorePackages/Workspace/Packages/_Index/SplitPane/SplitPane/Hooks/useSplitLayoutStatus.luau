local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local fFlagEnableSplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagEnableSplitPaneTelemetry
local fFlagEnableSplitPaneStackFallbackFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagEnableSplitPaneStackFallbackFix
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactNavigation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local viewState = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Navigation").ViewState
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Constants
local SplitPaneContext = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Context/SplitPaneContext")

local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local useInitializeSplitPaneTelemetrySession = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useInitializeSplitPaneTelemetrySession")
local computeSplitEligibility = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/computeSplitEligibility")
local SplitPaneVariant = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitPaneVariant")
local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local splitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local tempRnSwitchNavigatorName = constants.TempRnSwitchNavigatorName

local function useSplitLayoutStatus(list, p2)
	local store = SplitPaneStore.getStore()
	local v5 = SignalsReact.useSignalState(store.getIsBreakpointEnabled)
	local v6

	if fFlagEnableSplitPaneStackFallbackFix then
		v6 = SignalsReact.useSignalState(store.getWasSplitPaneAvailable)
	else
		v6 = false
	end

	local v7 = SignalsReact.useSignalState(store.getSupportPaneMode)

	local v8 = computeSplitEligibility(list)
	local v9 = v5 and v8

	local v10 = React.useContext(SplitPaneContext).renderSupportContent ~= nil
	local v11

	if list[1] == nil or list[1].descriptor == nil or list[1].descriptor.state == nil then
		v11 = false
	else
		v11 = list[1].descriptor.state.routeName == tempRnSwitchNavigatorName
	end

	local v12 = {}
	local v13 = nil
	local v14 = false

	local v15 = SplitPaneVariant.isPaneCollapsedByDefault()
		and not SplitPaneVariant.shouldAutoExpandOnSupportOpen()
		and v7 == supportPaneMode.Collapsed

	if v9 then
		for i = #list, 1, -1 do
			local options = list[i].descriptor.options
			local splitPaneEligibility = options.splitPaneEligibility

			if v15 and splitPaneEligibility == splitPaneSlot.Support then
				splitPaneEligibility = nil
			end

			if splitPaneEligibility == splitPaneSlot.Support then
				table.insert(v12, 1, i)
			elseif
				(not (options.transparent or options.overlayEnabled) or splitPaneEligibility ~= nil)
				and #v12 > 0
			then
				v13 = i
				break
			end
		end
	elseif not v5 and (not fFlagEnableSplitPaneStackFallbackFix or v6) then
		for k, item in list do
			if
				item.descriptor.options.splitPaneEligibility == splitPaneSlot.Support
				and item.viewState ~= viewState.Closing
			then
				v14 = true
				break
			end
		end
	end

	local v16 = #v12
	local v17 = not (v13 == nil) and v16 > 0
	local v18 = p2 >= 1
	local v19 = v14 or v17 or v9 and v10 and v18
	local v20 = nil

	if v9 then
		for i = #list, 1, -1 do
			local options = list[i].descriptor.options
			local splitPaneEligibility = options.splitPaneEligibility

			if v15 and splitPaneEligibility == splitPaneSlot.Support then
				splitPaneEligibility = nil
			end

			if
				splitPaneEligibility ~= splitPaneSlot.Support
				and (not (options.transparent or options.overlayEnabled) or splitPaneEligibility ~= nil)
			then
				v20 = i
				break
			end
		end
	end

	React.useEffect(function()
		if not v11 then
			return
		end

		local isSplitEligible = store.getIsSplitEligible(false)
		store.setIsSplitEligible(v8)

		if not isSplitEligible or v8 then
			return
		end

		local descriptor = list[1].descriptor

		if descriptor == nil or descriptor.navigation == nil then
			return
		end

		local navigation = descriptor.navigation

		for i = #list, 2, -1 do
			local descriptor2 = list[i].descriptor

			if descriptor2 == nil then
				continue
			end

			local splitPaneEligibility = descriptor2.options.splitPaneEligibility

			if not (splitPaneEligibility ~= nil and splitPaneEligibility ~= splitPaneSlot.Content) then
				continue
			end

			local key = if descriptor2.state ~= nil then descriptor2.state.key or nil else nil

			if key ~= nil then
				navigation.dispatch(RoactNavigation.StackActions.pop({
					key = key,
					prune = false,
					immediate = true
				}))
			end
		end
	end, { v11, v8, list, store })

	React.useEffect(function()
		if v19 then
			return
		end

		if v11 then
			store.setTemporarySupportPaneMode(nil)
		end

		for k, item in list do
			if
				item.viewState == viewState.Closing
				and (not fFlagEnableSplitPaneStackFallbackFix or v6)
				and item.descriptor.options.splitPaneEligibility == splitPaneSlot.Support
			then
				item.setClosed()
			end
		end
	end, { v11, v19, list, store, v6 })

	if fFlagEnableSplitPaneTelemetry then
		useInitializeSplitPaneTelemetrySession(v11)
	end

	return {
		isSplitLayoutEnabled = v19,
		isRouteActiveOnPane = v17,
		paneIndices = v12,
		contentTopCandidate = v20,
		splitPrimaryIndex = v13,
		supportPaneMode = v7,
		isRootAppStack = v11,
		isSplitEnabled = v9,
		wasSplitPaneAvailable = v6
	}
end

return useSplitLayoutStatus
