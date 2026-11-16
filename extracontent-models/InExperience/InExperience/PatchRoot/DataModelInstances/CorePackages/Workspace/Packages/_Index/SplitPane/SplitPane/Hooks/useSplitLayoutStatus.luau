local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPaneTelemetry = SharedFlags.FFlagEnableSplitPaneTelemetry
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableSplitPaneStackFallbackFix = SharedFlags2.FFlagEnableSplitPaneStackFallbackFix
local RoactNavigation = require(parent.RoactNavigation)
local SignalsReact = require(parent.SignalsReact)
local AppSplitView = require(parent.AppSplitView)
local Navigation = require(parent.Navigation)
local ViewState = Navigation.ViewState
local NavigationRodux = require(parent.NavigationRodux)
local Constants = NavigationRodux.Constants
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)

local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local useInitializeSplitPaneTelemetrySession = require(script.Parent.useInitializeSplitPaneTelemetrySession)
local computeSplitEligibility = require(script.Parent.Parent.Utils.computeSplitEligibility)
local SplitPaneVariant = require(script.Parent.Parent.Utils.SplitPaneVariant)
local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function useSplitLayoutStatus(list, p: number)
	local store = SplitPaneStore.getStore()
	local v = SignalsReact.useSignalState(store.getIsBreakpointEnabled)
	local wasSplitPaneAvailable

	if FFlagEnableSplitPaneStackFallbackFix then
		wasSplitPaneAvailable = SignalsReact.useSignalState(store.getWasSplitPaneAvailable)
	else
		wasSplitPaneAvailable = false
	end

	local supportPaneMode = SignalsReact.useSignalState(store.getSupportPaneMode)

	local v2 = computeSplitEligibility(list)
	local isSplitEnabled = v and v2

	local v3 = React.useContext(SplitPaneContext).renderSupportContent ~= nil
	local isRootAppStack

	if list[1] == nil or list[1].descriptor == nil or list[1].descriptor.state == nil then
		isRootAppStack = false
	else
		isRootAppStack = list[1].descriptor.state.routeName == TempRnSwitchNavigatorName
	end

	local paneIndices = {}
	local splitPrimaryIndex = nil
	local v4 = false

	local v5 = SplitPaneVariant.isPaneCollapsedByDefault()
		and not SplitPaneVariant.shouldAutoExpandOnSupportOpen()
		and supportPaneMode == SupportPaneMode.Collapsed

	if isSplitEnabled then
		for i = #list, 1, -1 do
			local options = list[i].descriptor.options
			local splitPaneEligibility = options.splitPaneEligibility

			if v5 and splitPaneEligibility == SplitPaneSlot.Support then
				splitPaneEligibility = nil
			end

			if splitPaneEligibility == SplitPaneSlot.Support then
				table.insert(paneIndices, 1, i)
			elseif
				(not (options.transparent or options.overlayEnabled) or splitPaneEligibility ~= nil)
				and #paneIndices > 0
			then
				splitPrimaryIndex = i
				break
			end
		end
	elseif not v and (not FFlagEnableSplitPaneStackFallbackFix or wasSplitPaneAvailable) then
		for _, item in list do
			if
				item.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support
				and item.viewState ~= ViewState.Closing
			then
				v4 = true
				break
			end
		end
	end

	local v6 = #paneIndices
	local isRouteActiveOnPane

	if splitPrimaryIndex == nil then
		isRouteActiveOnPane = false
	else
		isRouteActiveOnPane = v6 > 0
	end

	local v7 = p >= 1
	local isSplitLayoutEnabled = v4 or isRouteActiveOnPane or isSplitEnabled and v3 and v7
	local contentTopCandidate = nil

	if isSplitEnabled then
		for i = #list, 1, -1 do
			local options = list[i].descriptor.options
			local splitPaneEligibility = options.splitPaneEligibility

			if v5 and splitPaneEligibility == SplitPaneSlot.Support then
				splitPaneEligibility = nil
			end

			if
				splitPaneEligibility ~= SplitPaneSlot.Support
				and (not (options.transparent or options.overlayEnabled) or splitPaneEligibility ~= nil)
			then
				contentTopCandidate = i
				break
			end
		end
	end

	React.useEffect(function()
		if not isRootAppStack then
			return
		end

		local isSplitEligible = store.getIsSplitEligible(false)
		store.setIsSplitEligible(v2)

		if not isSplitEligible or v2 then
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

			if not (splitPaneEligibility ~= nil and splitPaneEligibility ~= SplitPaneSlot.Content) then
				continue
			end

			local key

			if descriptor2.state ~= nil then
				key = descriptor2.state.key or nil
			end

			if key ~= nil then
				navigation.dispatch(RoactNavigation.StackActions.pop({
					key = key,
					prune = false,
					immediate = true
				}))
			end
		end
	end, { isRootAppStack, v2, list, store })

	React.useEffect(function()
		if isSplitLayoutEnabled then
			return
		end

		if isRootAppStack then
			store.setTemporarySupportPaneMode(nil)
		end

		for _, item in list do
			if
				item.viewState == ViewState.Closing
				and (not FFlagEnableSplitPaneStackFallbackFix or wasSplitPaneAvailable)
				and item.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support
			then
				item.setClosed()
			end
		end
	end, { isRootAppStack, isSplitLayoutEnabled, list, store, wasSplitPaneAvailable })

	if FFlagEnableSplitPaneTelemetry then
		useInitializeSplitPaneTelemetrySession(isRootAppStack)
	end

	return {
		isSplitLayoutEnabled = isSplitLayoutEnabled,
		isRouteActiveOnPane = isRouteActiveOnPane,
		paneIndices = paneIndices,
		contentTopCandidate = contentTopCandidate,
		splitPrimaryIndex = splitPrimaryIndex,
		supportPaneMode = supportPaneMode,
		isRootAppStack = isRootAppStack,
		isSplitEnabled = isSplitEnabled,
		wasSplitPaneAvailable = wasSplitPaneAvailable
	}
end

return useSplitLayoutStatus
