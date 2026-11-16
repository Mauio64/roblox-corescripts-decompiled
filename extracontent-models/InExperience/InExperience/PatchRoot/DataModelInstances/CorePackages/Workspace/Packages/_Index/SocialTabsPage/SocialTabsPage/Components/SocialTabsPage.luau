local socialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = socialTabsPage.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local FFlagSocialTabsPageDockedPanelSafeArea = require(socialTabsPage.Flags.FFlagSocialTabsPageDockedPanelSafeArea)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialTabsPageSplitPaneLayout = SharedFlags.FFlagSocialTabsPageSplitPaneLayout

local SocialTabsHeader = require(socialTabsPage.Components.SocialTabsHeader)
local SocialTabBar = require(socialTabsPage.Components.SocialTabBar)
local SocialTabsContext = require(socialTabsPage.Contexts.SocialTabsContext)
local useLocalizedTabs = require(socialTabsPage.Hooks.useLocalizedTabs)

require(socialTabsPage.Common.Types)

local function SocialTabsPageComponent(props)
	local renderNavigator = props.renderNavigator
	local renderHeader = props.renderHeader
	local tabConfig = props.tabConfig
	local profileId = props.profileId
	local title = props.title
	local initialTabId = props.initialTabId
	local pageWidth = props.pageWidth
	local fillContainer

	if FFlagSocialTabsPageSplitPaneLayout then
		fillContainer = props.fillContainer
	end

	local topInset

	if FFlagSocialTabsPageSplitPaneLayout then
		topInset = props.topInset
	end

	local hideBackButton

	if FFlagSocialTabsPageSplitPaneLayout then
		hideBackButton = props.hideBackButton
	end

	local v = React.useMemo(function()
		return { profileId = profileId, title = title }
	end, { profileId, title })

	local tabs = useLocalizedTabs(tabConfig)
	local v2 = useTokens()
	local v3 = useNavigation()
	local v4

	if FFlagSocialTabsPageDockedPanelSafeArea then
		v4 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	end

	local ref = React.useRef(false)

	local onActivated = React.useCallback(function()
		v3.goBack()
	end, { v3 })

	React.useEffect(function()
		if ref.current or (not initialTabId or #tabConfig == 0) then
			return
		end

		local flag = false

		for _, v5 in tabConfig do
			if v5.id == initialTabId then
				flag = true
				break
			end
		end

		local v5 = if flag then initialTabId else tabConfig[1].id

		if v3.state.routes[v3.state.index].routeName ~= v5 then
			v3.navigate(v5)
		end

		ref.current = true
	end, { initialTabId, tabConfig, v3 })

	local createElement = React.createElement
	local v5 = {
		tag = "col size-full",
		padding = topInset and { top = UDim.new(0, topInset) } or nil
	}

	local createElement2 = React.createElement
	local header

	if renderHeader then
		header = renderHeader()
	else
		header = React.createElement(SocialTabsHeader, {
			layoutOrder = 1,
			hideBackButton = hideBackButton
		})
	end

	local element = createElement(View, v5, {
		HeaderSection = createElement2(View, {
			tag = "col size-full-0 auto-y bg-surface-0",
			LayoutOrder = 1
		}, {
			Header = header,
			TabBar = React.createElement(SocialTabBar, { layoutOrder = 2, tabs = tabs })
		}),
		TabContent = React.createElement(View, { tag = "fill size-full-0", LayoutOrder = 2 }, {
			Navigator = renderNavigator()
		})
	})
	local color3, backgroundTransparency, v6

	if pageWidth == nil then
		color3 = v2.Color.Surface.Surface_0.Color3
		backgroundTransparency = v2.Color.Surface.Surface_0.Transparency
		v6 = { SocialTabsPageContent = element }
	else
		local stateLayer = { affordance = StateLayerAffordance.None }

		color3 = v2.Color.Surface.Surface_0.Color3
		backgroundTransparency = 1
		v6 = { ScrimClickHandler = 0 }
		local createElement3 = React.createElement

		local createElement4 = React.createElement
		local v7 = {
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
		local position

		if FFlagSocialTabsPageDockedPanelSafeArea then
			position = UDim2.new(1, v4.right, 0, -v4.top)
		end

		v7.Position = position
		local size

		if FFlagSocialTabsPageDockedPanelSafeArea then
			size = UDim2.new(0, pageWidth, 1, v4.top + v4.bottom)
		else
			size = UDim2.new(0, pageWidth, 1, 0)
		end

		v7.Size = size

		v7.padding = FFlagSocialTabsPageDockedPanelSafeArea and {
			top = UDim.new(0, v4.top + v2.Padding.XXLarge),
			right = UDim.new(0, v4.right),
			bottom = UDim.new(0, v4.bottom)
		} or nil

		v7.stateLayer = stateLayer
		function v7.onActivated() end

		v6.ScrimClickHandler = createElement3(
			View,
			{ tag = "size-full", stateLayer = stateLayer, onActivated = onActivated },
			{
				Panel = createElement4(View, v7, { Content = element })
			}
		)
	end

	return React.createElement(SocialTabsContext.Provider, { value = v }, {
		Page = React.createElement(
			FullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				useFullScalePage = fillContainer,
				BackgroundColor3 = color3,
				BackgroundTransparency = backgroundTransparency
			},
			v6
		)
	})
end

return SocialTabsPageComponent
