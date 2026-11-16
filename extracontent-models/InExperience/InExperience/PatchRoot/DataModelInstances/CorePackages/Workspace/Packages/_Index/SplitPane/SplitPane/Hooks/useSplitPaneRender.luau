local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Responsive = require(parent.Responsive)
local AppSplitView = require(parent.AppSplitView)
local NavigationRodux = require(parent.NavigationRodux)
local Constants = NavigationRodux.Constants
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)

local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local isSupportPaneScreen = require(script.Parent.Parent.Utils.isSupportPaneScreen)
local SplitPaneVariant = require(script.Parent.Parent.Utils.SplitPaneVariant)
local SplitPaneTelemetry = require(script.Parent.Parent.Telemetry.SplitPaneTelemetry)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPaneTelemetry = SharedFlags.FFlagEnableSplitPaneTelemetry
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAXPauseSceneWhenSplitPaneCollapsed = SharedFlags2.FFlagAXPauseSceneWhenSplitPaneCollapsed
local SharedFlags3 = require(parent.SharedFlags)
local FFlagFixSplitPaneGamepadLayoutJitter = SharedFlags3.FFlagFixSplitPaneGamepadLayoutJitter
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSplitPaneAvatarOnlyAlwaysExpanded = SharedFlags4.FFlagSplitPaneAvatarOnlyAlwaysExpanded

local supportPaneInputRules = require(script.Parent.Parent.Utils.supportPaneInputRules)

local usePreferredInput = Responsive.usePreferredInput

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function resolveTemporarySupportPaneMode(current: number, p: number, p2, flag: boolean)
	local v

	if current > 0 then
		v = p == 0
	else
		v = false
	end

	local v2

	if current == 0 then
		v2 = p > 0
	else
		v2 = false
	end

	local v3 = not v2 and p > 0

	if v2 then
		if FFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
			return SupportPaneMode.Expanded, true
		end

		local v4

		if SplitPaneVariant.shouldAutoExpandOnSupportOpen() then
			v4 = supportPaneInputRules.resolveOpenedMode(p2)
		else
			v4 = supportPaneInputRules.resolveInputChangedMode(p2)
		end

		return v4, true
	end

	if v then
		return nil, true
	end

	if flag and v3 then
		if FFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
			return SupportPaneMode.Expanded, true
		end

		return supportPaneInputRules.resolveInputChangedMode(p2), true
	end

	return nil, false
end

local function useSplitPaneRender(list, p, list2, flag: boolean)
	local store = SplitPaneStore.getStore()

	local v = flag and #list2 or 0
	local isRootAppStack

	if list[1] == nil or list[1].descriptor == nil or list[1].descriptor.state == nil then
		isRootAppStack = false
	else
		isRootAppStack = list[1].descriptor.state.routeName == TempRnSwitchNavigatorName
	end

	local ref = React.useRef(0)
	local v2 = usePreferredInput()

	if FFlagFixSplitPaneGamepadLayoutJitter and isRootAppStack then
		local current = ref.current
		local v3

		if current > 0 then
			v3 = v == 0
		else
			v3 = false
		end

		local v4

		if current == 0 then
			v4 = v > 0
		else
			v4 = false
		end

		if not v4 then
			local _ = v > 0
		end

		local v5, flag2

		if v4 then
			if FFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
				v5 = SupportPaneMode.Expanded
			elseif SplitPaneVariant.shouldAutoExpandOnSupportOpen() then
				v5 = supportPaneInputRules.resolveOpenedMode(v2)
			else
				v5 = supportPaneInputRules.resolveInputChangedMode(v2)
			end

			flag2 = true
		else
			flag2 = if v3 then true else false
		end

		if flag2 then
			store.setTemporarySupportPaneMode(v5)
		end
	end

	local supportPaneMode = SignalsReact.useSignalState(store.getSupportPaneMode)
	local supportWidth = SignalsReact.useSignalState(store.getSupportWidth)
	local isBreakpointEnabled = SignalsReact.useSignalState(store.getIsBreakpointEnabled)

	local v3 = React.useContext(SplitPaneContext)

	local clone = table.clone(p)
	local supportSlotChildren = {}
	local overlaySlotChildren = {}

	if flag then
		for _, item in list2 do
			local key = list[item].descriptor.key
			local v4 = clone[key]

			if v4 == nil then
				continue
			end

			clone[key] = nil
			supportSlotChildren[key] = v4
		end
	end

	if isBreakpointEnabled then
		local v4 = 0

		for k, item in list do
			local options = item.descriptor.options

			if options ~= nil and options.splitPaneEligibility ~= nil then
				v4 = k
			end
		end

		for k, item in list do
			local options = item.descriptor.options

			if
				options == nil
				or not options.transparent
				or options.overlayEnabled
				or options.splitPaneEligibility ~= nil
			then
				continue
			end

			local key = item.descriptor.key
			local v5 = clone[key]

			if v5 == nil then
				continue
			end

			clone[key] = nil

			if v4 < k then
				overlaySlotChildren[key] = v5
			end
		end
	end

	if FFlagAXPauseSceneWhenSplitPaneCollapsed then
		React.useEffect(function()
			if isRootAppStack then
				store.setHasSupportRoute(v > 0)
			end
		end, { isRootAppStack, v, store })
		React.useEffect(function()
			return function()
				if isRootAppStack then
					store.setHasSupportRoute(false)
				end
			end
		end, { isRootAppStack, store })
	end

	React.useEffect(function()
		local current = ref.current
		ref.current = v

		if not isRootAppStack then
			return
		end

		local v4

		if current == 0 then
			v4 = v > 0
		else
			v4 = false
		end

		if v4 and FFlagEnableSplitPaneTelemetry then
			SplitPaneTelemetry.logSupportRouteOpened()
		end

		local temporarySupportPaneMode, v5 = resolveTemporarySupportPaneMode(current, v, v2, true)

		if v5 then
			store.setTemporarySupportPaneMode(temporarySupportPaneMode)
		end
	end, { isRootAppStack, v, store, supportPaneMode, v2 })
	local v4

	if v > 0 then
		v4 = list2[v]
	end

	local v5 = v4 == nil and {} or list[v4].descriptor.options
	local navigation

	if v4 ~= nil then
		navigation = list[v4].descriptor.navigation
	end

	local hasDetailOnTop = v4 ~= nil
	local supportRouteKeys = {}

	if flag then
		for _, item in list do
			if not isSupportPaneScreen(item) then
				continue
			end

			local state = item.descriptor.state

			if state ~= nil and state.key ~= nil then
				table.insert(supportRouteKeys, state.key)
			end
		end
	end

	local supportContentProps = {
		hostNavigation = navigation,
		hasDetailOnTop = hasDetailOnTop,
		paneCount = v,
		splitPaneExpandable = v5.splitPaneExpandable,
		splitPaneCollapsible = v5.splitPaneCollapsible,
		supportRouteKeys = supportRouteKeys
	}

	local v6 = v5.splitPaneCollapsible == true or not hasDetailOnTop

	if v6 then
		v6 = not (hasDetailOnTop and v > 1)
	end

	return {
		primarySlotChildren = clone,
		supportSlotChildren = supportSlotChildren,
		overlaySlotChildren = overlaySlotChildren,
		supportContentProps = supportContentProps,
		supportWidth = supportWidth,
		supportMinWidth = store.getMinSupportWidth(),
		supportMaxWidth = store.getMaxSupportWidth(),
		onSupportPaneWidthChanged = store.setSupportWidth,
		supportPaneMode = supportPaneMode,
		supportPaneResizable = v3.supportPaneResizable == true,
		supportResizerAbovePane = not v6,
		isBreakpointEnabled = isBreakpointEnabled,
		isRootAppStack = isRootAppStack,
		renderSupportContent = v3.renderSupportContent,
		onContentRegionRectChanged = v3.onContentRegionRectChanged
	}
end

return useSplitPaneRender
