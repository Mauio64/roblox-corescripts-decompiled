local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/AppBlox").FullscreenPageWithSafeArea
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Navigation").useNavigation
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Display")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SignalsReact").useSignalState
local FFlagSocialTabsPageDockedPanelSafeArea = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Flags/FFlagSocialTabsPageDockedPanelSafeArea")
local fFlagSocialTabsPageSplitPaneLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagSocialTabsPageSplitPaneLayout

local SocialTabsHeader = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/SocialTabsHeader")
local SocialTabBar = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/SocialTabBar")
local SocialTabsContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Contexts/SocialTabsContext")
local useLocalizedTabs = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useLocalizedTabs")

require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")

local function SocialTabsPageComponent(props)
	local renderNavigator = props.renderNavigator
	local renderHeader = props.renderHeader
	local tabConfig = props.tabConfig
	local profileId = props.profileId
	local title = props.title
	local initialTabId = props.initialTabId
	local pageWidth = props.pageWidth
	local fillContainer = if fFlagSocialTabsPageSplitPaneLayout then props.fillContainer else nil
	local topInset = if fFlagSocialTabsPageSplitPaneLayout then props.topInset else nil
	local hideBackButton = if fFlagSocialTabsPageSplitPaneLayout then props.hideBackButton else nil

	local v5 = React.useMemo(function()
		return { profileId = profileId, title = title }
	end, { profileId, title })

	local v6 = useLocalizedTabs(tabConfig)
	local v7 = useTokens()
	local v8 = useNavigation()

	local v9 = if FFlagSocialTabsPageDockedPanelSafeArea then useSignalState(Display.GetDisplayStore().getDeviceSafePadding) else nil

	local ref = React.useRef(false)

	local v10 = React.useCallback(function()
		v8.goBack()
	end, { v8 })

	React.useEffect(function()
		if ref.current or (not initialTabId or #tabConfig == 0) then
			return
		end

		local flag = false

		for k, v12 in tabConfig do
			if v12.id == initialTabId then
				flag = true
				break
			end
		end

		local v12 = if flag then initialTabId else tabConfig[1].id

		if v8.state.routes[v8.state.index].routeName ~= v12 then
			v8.navigate(v12)
		end

		ref.current = true
	end, { initialTabId, tabConfig, v8 })

	local createElement = React.createElement
	local v12 = {
		tag = "col size-full",
		padding = topInset and { top = UDim.new(0, topInset) } or nil
	}

	local createElement2 = React.createElement

	local v16 = if renderHeader then renderHeader() else React.createElement(SocialTabsHeader, {
		layoutOrder = 1,
		hideBackButton = hideBackButton
	})
	local element = createElement(view, v12, {
		HeaderSection = createElement2(
			view,
			{ tag = "col size-full-0 auto-y bg-surface-0", LayoutOrder = 1 },
			{
				Header = v16,
				TabBar = React.createElement(SocialTabBar, { layoutOrder = 2, tabs = v6 })
			}
		),
		TabContent = React.createElement(view, {
			tag = "fill size-full-0",
			LayoutOrder = 2
		}, {
			Navigator = renderNavigator()
		})
	})
	local color3, v17, v18

	if pageWidth == nil then
		color3 = v7.Color.Surface.Surface_0.Color3
		v17 = v7.Color.Surface.Surface_0.Transparency
		v18 = { SocialTabsPageContent = element }
	else
		local v19 = { affordance = stateLayerAffordance.None }

		color3 = v7.Color.Surface.Surface_0.Color3
		v17 = 1
		v18 = { ScrimClickHandler = 0 }
		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local v24 = {
			tag = {
				["col anchor-top-right bg-surface-0"] = true,
				["position-top-right padding-top-xxlarge"] = not FFlagSocialTabsPageDockedPanelSafeArea
			},
			Position = 0,
			Size = 0,
			padding = 0,
			stateLayer = 0,
			onActivated = 0
		}

		local v25 = if FFlagSocialTabsPageDockedPanelSafeArea then UDim2.new(1, v9.right, 0, -v9.top) else nil
		v24.Position = v25

		local v26 = if FFlagSocialTabsPageDockedPanelSafeArea then UDim2.new(0, pageWidth, 1, v9.top + v9.bottom) else UDim2.new(0, pageWidth, 1, 0)
		v24.Size = v26

		v24.padding = FFlagSocialTabsPageDockedPanelSafeArea and {
			top = UDim.new(0, v9.top + v7.Padding.XXLarge),
			right = UDim.new(0, v9.right),
			bottom = UDim.new(0, v9.bottom)
		} or nil

		v24.stateLayer = v19
		function v24.onActivated() end

		v18.ScrimClickHandler = createElement3(
			view,
			{ tag = "size-full", stateLayer = v19, onActivated = v10 },
			{
				Panel = createElement4(view, v24, { Content = element })
			}
		)
	end

	return React.createElement(SocialTabsContext.Provider, { value = v5 }, {
		Page = React.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				useFullScalePage = fillContainer,
				BackgroundColor3 = color3,
				BackgroundTransparency = v17
			},
			v18
		)
	})
end

return SocialTabsPageComponent
