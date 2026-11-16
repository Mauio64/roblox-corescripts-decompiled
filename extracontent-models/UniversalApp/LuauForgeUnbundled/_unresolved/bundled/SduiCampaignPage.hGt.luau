local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local module = require("@luauforge/bundled/dHu")
local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP
local useTTINavigationTracking = require("@luauforge/bundled/fwS").useTTINavigationTracking
require("@luauforge/bundled/dUe")
local module2 = require("@luauforge/bundled/hGu")
local campaignContentEntryPoint = module2.Components.CampaignContentEntryPoint
local getCampaignScreenSize = module2.Utils.getCampaignScreenSize

local module3 = require("@luauforge/bundled/fox")
local module4 = require("@luauforge/bundled/hFW")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagSubTabNavigationTTITracking = SharedFlags.FFlagSubTabNavigationTTITracking

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

	local topMargin = module4().topMargin

	local subTabsBottomBinding = if v6 and p2.screenProps then p2.screenProps.subTabsBottomBinding else nil

	local v10 = React.useMemo(function()
		if subTabsBottomBinding then
			return subTabsBottomBinding:map(function(p3)
				return p3.Y.Offset
			end)
		end

		return nil
	end, { subTabsBottomBinding })

	local v11 = React.useMemo(function()
		if v9 and v8 and v8 > 0 then
			if v6 and v10 == nil then
				return nil
			end

			return { scrollAwayHeight = v8, headerHeightBinding = v10 }
		end

		return nil
	end, { v9, v8, v10, v6 })

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color3,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		ref = ref,
		[React.Change.AbsoluteSize] = v7
	}
	local tag = React.Tag
	local v14 = if fFlagLuaAppAddTestIdsForArrow then getTestId("page-campaign") else nil
	v13[tag] = v14

	local createElement2 = React.createElement
	local v16 = if v6 then module3.PageWrapper else module3.PageContent

	local v19 = if state then React.createElement(campaignContentEntryPoint, {
		navigation = p2.navigation,
		screenSize = state,
		pageTopPadding = v8,
		feedTopMargin = topMargin,
		scrollAway = v11
	}) else nil
	return createElement("Frame", v13, {
		Content = createElement2(
			v16,
			{
				BackgroundColor3 = color3,
				BackgroundTransparency = transparency,
				ZIndex = 1
			},
			{ CampaignContent = v19 }
		)
	})
end

return SduiCampaignPage
