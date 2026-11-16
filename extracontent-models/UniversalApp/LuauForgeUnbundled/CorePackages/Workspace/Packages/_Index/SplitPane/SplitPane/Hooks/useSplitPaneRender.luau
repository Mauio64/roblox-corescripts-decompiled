local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Constants
local SplitPaneContext = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Context/SplitPaneContext")

local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local isSupportPaneScreen = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/isSupportPaneScreen")
local SplitPaneVariant = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitPaneVariant")
local SplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneTelemetry")
local fFlagEnableSplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagEnableSplitPaneTelemetry
local fFlagAXPauseSceneWhenSplitPaneCollapsed = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagAXPauseSceneWhenSplitPaneCollapsed
local fFlagFixSplitPaneGamepadLayoutJitter = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagFixSplitPaneGamepadLayoutJitter
local fFlagSplitPaneAvatarOnlyAlwaysExpanded = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagSplitPaneAvatarOnlyAlwaysExpanded

local supportPaneInputRules = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/supportPaneInputRules")

local usePreferredInput = Responsive.usePreferredInput

local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local tempRnSwitchNavigatorName = constants.TempRnSwitchNavigatorName

local function resolveTemporarySupportPaneMode(current, p2, p3, p4)
	local v5 = current > 0 and p2 == 0
	local v6 = current == 0 and p2 > 0
	local v7 = not v6 and p2 > 0

	if v6 then
		if fFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
			return supportPaneMode.Expanded, true
		end

		return
			if SplitPaneVariant.shouldAutoExpandOnSupportOpen() then supportPaneInputRules.resolveOpenedMode(p3) else supportPaneInputRules.resolveInputChangedMode(p3),
			true
	end

	if v5 then
		return nil, true
	end

	if p4 and v7 then
		if fFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
			return supportPaneMode.Expanded, true
		end

		return supportPaneInputRules.resolveInputChangedMode(p3), true
	end

	return nil, false
end

local function useSplitPaneRender(list, p2, list2, p3)
	local store = SplitPaneStore.getStore()

	local v5 = p3 and #list2 or 0
	local v6

	if list[1] == nil or list[1].descriptor == nil or list[1].descriptor.state == nil then
		v6 = false
	else
		v6 = list[1].descriptor.state.routeName == tempRnSwitchNavigatorName
	end

	local ref = React.useRef(0)
	local v7 = usePreferredInput()

	if fFlagFixSplitPaneGamepadLayoutJitter and v6 then
		local current = ref.current
		local v8 = current > 0 and v5 == 0
		local v9 = current == 0 and v5 > 0

		if not v9 then
			local v10 = v5 > 0
		end

		local v10, flag

		if v9 then
			if fFlagSplitPaneAvatarOnlyAlwaysExpanded and SplitPaneVariant.isSupportPaneAlwaysExpanded() then
				v10 = supportPaneMode.Expanded
			elseif SplitPaneVariant.shouldAutoExpandOnSupportOpen() then
				v10 = supportPaneInputRules.resolveOpenedMode(v7)
			else
				v10 = supportPaneInputRules.resolveInputChangedMode(v7)
			end

			flag = true
		else
			flag = if v8 then true else false
		end

		if flag then
			store.setTemporarySupportPaneMode(v10)
		end
	end

	local v8 = SignalsReact.useSignalState(store.getSupportPaneMode)
	local v9 = SignalsReact.useSignalState(store.getSupportWidth)
	local v10 = SignalsReact.useSignalState(store.getIsBreakpointEnabled)

	local v11 = React.useContext(SplitPaneContext)

	local clone = table.clone(p2)
	local v12 = {}
	local v13 = {}

	if p3 then
		for k, item in list2 do
			local key = list[item].descriptor.key
			local v14 = clone[key]

			if v14 == nil then
				continue
			end

			clone[key] = nil
			v12[key] = v14
		end
	end

	if v10 then
		local v14 = 0

		for k, item in list do
			local options = item.descriptor.options

			if options ~= nil and options.splitPaneEligibility ~= nil then
				v14 = k
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
			local v15 = clone[key]

			if v15 == nil then
				continue
			end

			clone[key] = nil

			if v14 < k then
				v13[key] = v15
			end
		end
	end

	if fFlagAXPauseSceneWhenSplitPaneCollapsed then
		React.useEffect(function()
			if v6 then
				store.setHasSupportRoute(v5 > 0)
			end
		end, { v6, v5, store })
		React.useEffect(function()
			return function()
				if v6 then
					store.setHasSupportRoute(false)
				end
			end
		end, { v6, store })
	end

	React.useEffect(function()
		local current = ref.current
		ref.current = v5

		if not v6 then
			return
		end

		local v14 = current == 0 and v5 > 0

		if v14 and fFlagEnableSplitPaneTelemetry then
			SplitPaneTelemetry.logSupportRouteOpened()
		end

		local temporarySupportPaneMode, v15 = resolveTemporarySupportPaneMode(current, v5, v7, true)

		if v15 then
			store.setTemporarySupportPaneMode(temporarySupportPaneMode)
		end
	end, { v6, v5, store, v8, v7 })

	local v14 = if v5 > 0 then list2[v5] else nil
	local v15 = v14 == nil and {} or list[v14].descriptor.options

	local navigation = if v14 ~= nil then list[v14].descriptor.navigation else nil
	local v16 = v14 ~= nil
	local v17 = {}

	if p3 then
		for k, item in list do
			if not isSupportPaneScreen(item) then
				continue
			end

			local state = item.descriptor.state

			if state ~= nil and state.key ~= nil then
				table.insert(v17, state.key)
			end
		end
	end

	local v18 = {
		hostNavigation = navigation,
		hasDetailOnTop = v16,
		paneCount = v5,
		splitPaneExpandable = v15.splitPaneExpandable,
		splitPaneCollapsible = v15.splitPaneCollapsible,
		supportRouteKeys = v17
	}

	local v19 = v15.splitPaneCollapsible == true or not v16

	if v19 then
		v19 = not (v16 and v5 > 1)
	end

	return {
		primarySlotChildren = clone,
		supportSlotChildren = v12,
		overlaySlotChildren = v13,
		supportContentProps = v18,
		supportWidth = v9,
		supportMinWidth = store.getMinSupportWidth(),
		supportMaxWidth = store.getMaxSupportWidth(),
		onSupportPaneWidthChanged = store.setSupportWidth,
		supportPaneMode = v8,
		supportPaneResizable = v11.supportPaneResizable == true,
		supportResizerAbovePane = not v19,
		isBreakpointEnabled = v10,
		isRootAppStack = v6,
		renderSupportContent = v11.renderSupportContent,
		onContentRegionRectChanged = v11.onContentRegionRectChanged
	}
end

return useSplitPaneRender
