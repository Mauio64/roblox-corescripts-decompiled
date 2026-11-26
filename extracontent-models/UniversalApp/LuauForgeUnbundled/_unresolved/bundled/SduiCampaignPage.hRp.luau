local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local module = require("@luauforge/bundled/dKz")
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking
local module2 = require("@luauforge/bundled/dXB")
local useUiStatus = module2.useUiStatus
local uiStatus = module2.UiStatus
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module3 = require("@luauforge/bundled/fJt")
local campaignContentEntryPoint = module3.Components.CampaignContentEntryPoint
local getCampaignConfigKey = module3.Utils.getCampaignConfigKey
local getCampaignScreenSize = module3.Utils.getCampaignScreenSize

local module4 = require("@luauforge/bundled/hRq")
local module5 = require("@luauforge/bundled/fvR")
local module6 = require("@luauforge/bundled/hQS")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeShowCampaignTab = SharedFlags.FFlagAppIaHomeShowCampaignTab
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagSubTabNavigationTTITracking = SharedFlags.FFlagSubTabNavigationTTITracking
local module8 = require("@luauforge/bundled/hRr")

local function CampaignPageLoadedReporter(p2): nil
	local v5 = useRoactService(appNotificationService)
	local v6 = useUiStatus(p2.configKey)
	local v7 = useSignalState(module4.getHasPendingTap)
	React.useEffect(function()
		if not v7 then
			return
		end

		if v6 == uiStatus.Error then
			module4.setHasPendingTap(false)
		elseif v5 and v6 == uiStatus.Resolved then
			module4.setHasPendingTap(false)
			v5:ActionEnabled(Enum.AppShellActionType.CampaignPageLoaded)
		end
	end, { v5, v7, v6 })
	return nil
end

local function SduiCampaignPage(p2)
	if fFlagSubTabNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_" .. appPage.Campaign)
	end

	local v5 = useTokens()
	local color3 = v5.Color.Surface.Surface_0.Color3
	local transparency = v5.Color.Surface.Surface_0.Transparency

	local v6 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local v7 = React.useCallback(function(p3)
		if p3.AbsoluteSize.X > 0 then
			setState(getCampaignScreenSize(p3.AbsoluteSize.X))
		end
	end, {})
	React.useEffect(function()
		if ref.current then
			v7(ref.current)
		end
	end, {})

	local v8 = useSelector(function(p3)
		return p3.TopBar.topBarHeight
	end)

	local v9 = fFlagAppIaScrollAway and module.getScrollAwayEnabled()

	if v6 and p2.screenProps then
		v8 = p2.screenProps.headerHeight
	elseif not v9 then
		v8 = nil
	end

	local topMargin = module6().topMargin

	local subTabsBottomBinding = if v6 and p2.screenProps then p2.screenProps.subTabsBottomBinding else nil

	local v11 = React.useMemo(function()
		if subTabsBottomBinding then
			return subTabsBottomBinding:map(function(p3)
				return p3.Y.Offset
			end)
		end

		return nil
	end, { subTabsBottomBinding })

	local v12 = React.useMemo(function()
		if v9 and v8 and v8 > 0 then
			if v6 and v11 == nil then
				return nil
			end

			return { scrollAwayHeight = v8, headerHeightBinding = v11 }
		end

		return nil
	end, { v9, v8, v11, v6 })

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color3,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		ref = ref,
		[React.Change.AbsoluteSize] = v7
	}
	local tag = React.Tag
	local v15 = if fFlagLuaAppAddTestIdsForArrow then getTestId("page-campaign") else nil
	v14[tag] = v15

	local createElement2 = React.createElement
	local v17 = if v6 then module5.PageWrapper else module5.PageContent

	local v20 = if state then React.createElement(campaignContentEntryPoint, {
		navigation = p2.navigation,
		screenSize = state,
		pageTopPadding = v8,
		feedTopMargin = fFlagAppIaHomeShowCampaignTab and 0 or topMargin,
		scrollAway = v12
	}) else nil
	local v16 = {
		Content = createElement2(
			v17,
			{
				BackgroundColor3 = color3,
				BackgroundTransparency = transparency,
				ZIndex = 1
			},
			{ CampaignContent = v20 }
		),
		CampaignPageLoadedReporter = 0
	}

	local v21 = if module8 and state then React.createElement(CampaignPageLoadedReporter, {
		configKey = getCampaignConfigKey(state)
	}) else nil
	v16.CampaignPageLoadedReporter = v21
	return createElement("Frame", v14, v16)
end

return SduiCampaignPage
