local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local tabs = Foundation.Tabs
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/dXA")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/Navigation")
local module2 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceWrapper = module2.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module3 = require("@luauforge/bundled/hPC")

local module4 = require("@luauforge/bundled/hQC")

local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local module5 = require("@luauforge/bundled/dKz")
local visibilityControl = module5.VisibilityControl
local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources

local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTabAnalytics = SharedFlags.FFlagAppIaHomeSubTabAnalytics
local fFlagAppIaStatusBar = SharedFlags.FFlagAppIaStatusBar
local fFlagFixHomeHeaderForDeviceSafeInsets = SharedFlags.FFlagFixHomeHeaderForDeviceSafeInsets
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagSubTabFixMissingProfileWidget = SharedFlags.FFlagSubTabFixMissingProfileWidget
local fFlagSubTabNavigationTTITracking = SharedFlags.FFlagSubTabNavigationTTITracking
local fFlagAppIaHomeShowCampaignTab = SharedFlags.FFlagAppIaHomeShowCampaignTab
local fFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab

local campaignEligibility = if fFlagAppIaHomeShowCampaignTab then require("@luauforge/bundled/fJt").CampaignEligibility else nil

local defineFastFlag = game:DefineFastFlag("AppHeaderBarSinkInput", false)
local defineFastFlag2 = game:DefineFastFlag("AppIaHomeSubTabFrame", false)
local defineFastFlag3 = game:DefineFastFlag("AppIaHomeSubTabUnderlineFix", false)
local v5 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFix", false) and defineFastFlag2

local defineFastFlag4 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFixDefaultHeight", false)
local fFlagAppIaHomeSubTabScrollAwayFull = SharedFlags.FFlagAppIaHomeSubTabScrollAwayFull
local fFlagSubTabSizeSmall = SharedFlags.FFlagSubTabSizeSmall
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground
local module7 = require("@luauforge/bundled/fHU")
local module8 = require("@luauforge/bundled/fHw")

local module9 = require("@luauforge/bundled/hPF")
local module10 = require("@luauforge/bundled/hRr")
local module11 = require("@luauforge/bundled/ehR")

local v6 = if module10 then require("@luauforge/bundled/hRq") else nil

local fFlagAppIaHomeCampaignTabNewBadge = SharedFlags.FFlagAppIaHomeCampaignTabNewBadge
local badgeVariant = if fFlagAppIaHomeCampaignTabNewBadge then Foundation.Enums.BadgeVariant else nil
local useCampaignTabNewBadge

if fFlagAppIaHomeCampaignTabNewBadge then
	useCampaignTabNewBadge = require("@luauforge/bundled/fJt").Hooks.useCampaignTabNewBadge
else
	useCampaignTabNewBadge = nil
end

local trackStart

if fFlagSubTabNavigationTTITracking then
	trackStart = require("@luauforge/bundled/fCP").TimeToInteractiveTracker.trackStart
else
	trackStart = nil
end

local v7 = module4()
local v8

if fFlagAppIaHomeSubTabAnalytics then
	v8 = {}
	v8[appPage.Home] = Enum.AppShellActionType.TapHomePageTab
	v8[appPage.Games] = Enum.AppShellActionType.TapGamePageTab
else
	v8 = nil
end

if module10 then
	v8[appPage.Campaign] = Enum.AppShellActionType.TapCampaignPageTab
end

local function fn(p2)
	return module.GetDisplayStore(p2).getTopBarHeight(p2)
end

local forwardRef = React.forwardRef(function(p2, ref)
	local v9 = useLocalization({
		Charts = "CommonUI.Features.Label.Charts",
		ForYou = "CommonUI.Features.Label.ForYou",
		NewBadge = fFlagAppIaHomeCampaignTabNewBadge and "Feature.Catalog.Label.New" or nil
	})

	local v10 = if fFlagAppIaHomeSubTabAnalytics then useRoactService(appNotificationService) else nil
	local state = p2.navigation.state
	local routeName = state.routes[state.index].routeName

	local v11 = if fFlagAppIaHomeCampaignTabNewBadge then useCampaignTabNewBadge(routeName) else nil
	local v12

	if fFlagAppIaHomeCampaignTabNewBadge then
		v12 = React.useMemo(function()
			if v11 then
				return {
					type = "Badge",
					text = v9.NewBadge,
					variant = badgeVariant.Standard
				}
			end

			return nil
		end, { v11, v9.NewBadge })
	else
		v12 = nil
	end

	local function fn2(p3)
		if fFlagAppIaHomeSubTabAnalytics then
			if p3 == routeName then
				return
			end

			if fFlagSubTabNavigationTTITracking then
				trackStart("NavigateTo_" .. p3, true)
			end

			p2.navigation.navigate(p3)
			local v13 = v8[p3]

			if v13 then
				v10:ActionTaken(v13)
			end

			if module10 then
				v6.setHasPendingTap(p3 == appPage.Campaign)
			end
		else
			if fFlagSubTabNavigationTTITracking then
				trackStart("NavigateTo_" .. p3, true)
			end

			p2.navigation.navigate(p3)
		end
	end

	local v15 = React.useCallback(fn2, {
		p2.navigation,
		if fFlagAppIaHomeSubTabAnalytics then v10 else nil
	})
	local v16

	if fFlagAppIaHomeShowCampaignTab then
		v16 = useSignalState(campaignEligibility.getIsEligible)
	else
		v16 = false
	end

	local v17

	if fFlagAppIaHomeShowCampaignTab then
		v17 = useSignalState(campaignEligibility.getTabTitle)
	else
		v17 = nil
	end

	local v18 = fFlagAppIaHomeShowCampaignTab and v16 and v17 ~= nil
	local v19

	if defineFastFlag3 then
		local useMemo = React.useMemo
		local function fn3()
			local v20 = {
				{ id = appPage.Home, text = v9.ForYou }
			}

			if not fFlagEnableIsChartsInSubTab or flyoutSidePanelIXP.isChartsInSubTab() then
				table.insert(v20, { id = appPage.Games, text = v9.Charts })
			end

			if fFlagAppIaHomeShowCampaignTab and v18 then
				local v21 = {
					id = appPage.Campaign,
					text = v17,
					trailing = if fFlagAppIaHomeCampaignTabNewBadge then v12 else nil
				}
				table.insert(v20, v21)
			end

			return v20
		end

		local forYou = v9.ForYou
		local charts = v9.Charts
		local v21 = if fFlagAppIaHomeShowCampaignTab then v18 else nil
		local v22 = if fFlagAppIaHomeShowCampaignTab then v17 else nil
		v19 = useMemo(fn3, {
			forYou,
			charts,
			v21,
			v22,
			if fFlagAppIaHomeCampaignTabNewBadge then v12 else nil
		})
	else
		v19 = {
			{ id = appPage.Home, text = v9.ForYou }
		}
	end

	if
		(not fFlagEnableIsChartsInSubTab or flyoutSidePanelIXP.isChartsInSubTab())
		and not defineFastFlag3
	then
		table.insert(v19, { id = appPage.Games, text = v9.Charts })
	end

	if fFlagAppIaHomeShowCampaignTab and v18 and v17 and not defineFastFlag3 then
		local v20 = {
			id = appPage.Campaign,
			text = v17,
			trailing = if fFlagAppIaHomeCampaignTabNewBadge then v12 else nil
		}
		table.insert(v19, v20)
	end

	local v20 = useDesignTokens()
	local v21 = nil
	local v22 = nil
	local ref2 = nil
	local v23 = nil

	if module9 then
		v23 = module11.useThemeBackground() ~= nil
	elseif fFlagAppThemeHalloween2026HomeBackground and not module9 then
		v21 = module7.useHomeThemeBackgroundImage()
		local v24
		v22, v24 = React.useBinding(UDim2.fromScale(1, 0))

		ref2 = React.useRef(nil)

		React.useEffect(function()
			local parent = if ref2.current then ref2.current.Parent else nil

			if not (parent and parent:IsA("GuiObject")) then
				return nil
			end

			local function updateSize()
				v24(UDim2.fromOffset(parent.AbsoluteSize.X, parent.AbsoluteSize.Y))
			end

			v24(UDim2.fromOffset(parent.AbsoluteSize.X, parent.AbsoluteSize.Y))

			local absoluteSizeChangedConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end, { v21 })
	end

	local v24 = useSelector(function(p3)
		return p3.FormFactor
	end)
	local v25

	if fFlagSubTabFixMissingProfileWidget then
		v25 = useAppPolicy(function(p3)
			return p3.useGridPageLayout()
		end)
	end

	local v26 = if v24 == formFactor.COMPACT then fillBehavior.Fill else fillBehavior.Fit
	local v27

	if fFlagAppIaStatusBar then
		v27 = useSelector(function(p3)
			return p3.TopBar.statusBarHeight
		end)
	end

	local v28

	if fFlagFixHomeHeaderForDeviceSafeInsets then
		local v29 = useDeviceInsets()
		v28 = not module.shouldUseDeviceSafeInsets and 0 or v29.top
	else
		v28 = 0
	end

	local v29 = if v5 then useSignalState(fn) else nil

	local state2 = nil
	local v30 = nil
	local v31 = nil

	local v32 = nil
	local v33 = nil
	local v34 = nil
	local v35 = nil
	local v36 = nil
	local v37 = nil
	local v38

	if v5 then
		local v39 = useTokens()
		local v40

		if defineFastFlag4 then
			v40 = (if fFlagSubTabSizeSmall then v39.Padding.Small else v39.Padding.Medium) * 2 + v39.Size.Size_600
		else
			v40 = 0
		end

		local state3, setState = React.useState(v40)
		v33 = React.useCallback(function(p3)
			if p3 then
				setState(p3.AbsoluteSize.Y)
			end
		end, {})
		state2 = v29 + state3
		local v41 = not fFlagAppIaStatusBar and 0 or v27
		v35 = if fFlagAppIaHomeSubTabScrollAwayFull then state2 - v41 else v29 - v41
		local v42
		v32, v42 = React.useBinding(0)
		v38 = v42
		React.useEffect(function()
			v38(state2)
		end, { state2 })

		if fFlagAppIaHomeSubTabScrollAwayFull then
			if fFlagAppIaScrollAway and module5.getScrollAwayEnabled() then
				v37 = visibilityControl.getHeaderBinding():map(function(p3)
					return UDim2.new(0, 0, 0, (p3 - 1) * state3)
				end)
			else
				v37 = UDim2.fromScale(0, 0)
			end
		end

		if fFlagAppIaScrollAway and module5.getScrollAwayEnabled() then
			v34 = visibilityControl.getHeaderBinding():map(function(p3)
				local v43 = if fFlagAppIaHomeSubTabScrollAwayFull then v29 + (p3 - 1) * (state2 - v41) else v41 + p3 * (v29 - v41)
				return UDim2.new(0, 0, 0, v43)
			end)
		else
			v34 = UDim2.new(0, 0, 0, v29)
		end

		v36 = visibilityControl.getHeaderBinding():map(function(p3)
			local v43 = if fFlagAppIaHomeSubTabScrollAwayFull then v41 + p3 * (state2 - v41) else v41 + p3 * (v29 - v41) + state3
			return UDim2.new(0, 0, 0, v43)
		end)
	elseif fFlagAppIaScrollAway then
		local setState
		state2, setState = React.useState(0)
		v30 = setState
		local v39
		v32, v39 = React.useBinding(0)
		v38 = v39
		v31 = React.useCallback(function(p3)
			v30(p3.AbsoluteSize.Y)
			v38(p3.AbsoluteSize.Y)
		end, {})
	end

	local v39

	if fFlagEnableClassicThemeHeaderBackground then
		v39 = visibilityControl.getHeaderBinding()
	end

	local createElement = React.createElement
	local v42 = if defineFastFlag2 then v20.LuaApps.App.Page.BackgroundColor else nil

	local v43 = if defineFastFlag2 then v23 and 1 or v20.LuaApps.App.Page.BackgroundTransparency else nil
	local v41 = {
		BackgroundColor3 = v42,
		BackgroundTransparency = v43,
		BorderSizePixel = defineFastFlag2 and 0 or nil,
		Size = 0,
		backgroundStyle = 0,
		tag = 0,
		ref = 0
	}

	local v44 = if defineFastFlag2 then UDim2.fromScale(1, 1) else nil
	v41.Size = v44
	v41.backgroundStyle = not defineFastFlag2 and {
		Color3 = v20.LuaApps.App.Page.BackgroundColor,
		Transparency = v23 and 1 or v20.LuaApps.App.Page.BackgroundTransparency
	} or nil

	v41.tag = not defineFastFlag2 and {
		["size-full"] = true,
		col = not fFlagAppIaScrollAway
	} or nil

	v41.ref = ref

	local v45 = if v21 then React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = -2,
		Size = UDim2.fromScale(1, 0),
		ZIndex = 0,
		ref = ref2
	}, {
		Image = React.createElement(module7.HomeThemeBackgroundImage, {
			image = v21,
			Size = v22
		})
	}) else nil

	local v46 = if defineFastFlag2 and not fFlagAppIaScrollAway then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil

	local createElement2 = React.createElement
	local v48 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.HeaderView,
		frameProps = {
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = defineFastFlag2 and -1 or nil,
			Size = UDim2.fromScale(1, 0),
			ZIndex = 2
		}
	}
	local v50

	if fFlagAppIaStatusBar then
		local createElement3 = React.createElement

		local v53 = if defineFastFlag2 then v20.LuaApps.App.Page.BackgroundColor else nil

		if v21 or v23 then
			v39 = 0
		elseif not (fFlagEnableClassicThemeHeaderBackground and defineFastFlag2) then
			v39 = nil
		end

		local v52 = {
			BackgroundColor3 = v53,
			BackgroundTransparency = v39,
			BorderSizePixel = defineFastFlag2 and 0 or nil,
			backgroundStyle = not defineFastFlag2 and {
				Color3 = v20.LuaApps.App.Page.BackgroundColor,
				Transparency = 0
			} or nil,
			ClipsDescendants = (v21 or v23) and true or nil,
			Position = 0,
			Size = 0,
			ZIndex = 2
		}

		local v54 = if fFlagFixHomeHeaderForDeviceSafeInsets then UDim2.fromOffset(0, -v28) else nil
		v52.Position = v54

		v52.Size = UDim2.new(1, 0, 0, v27 + (not fFlagFixHomeHeaderForDeviceSafeInsets and 0 or v28))
		local v56

		if v21 then
			local createElement4 = React.createElement
			local homeThemeBackgroundImage = module7.HomeThemeBackgroundImage

			local v58 = if fFlagFixHomeHeaderForDeviceSafeInsets then UDim2.fromOffset(0, v28) else nil
			v56 = createElement4(homeThemeBackgroundImage, {
				image = v21,
				Position = v58,
				Size = v22
			})
		end

		local v57 = if v23 then React.createElement(module11.ThemeBackgroundHeaderSlot) else nil
		v50 = createElement3(defineFastFlag2 and "Frame" or view, v52, {
			ThemeBackgroundImage = v56,
			ThemeBackgroundSlot = v57
		})
	end

	local v51

	if v5 then
		local createElement3 = React.createElement
		local v53 = {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v20.LuaApps.App.Page.BackgroundColor,
			BorderSizePixel = 0,
			ClipsDescendants = (v21 or v23) and true or nil,
			Position = v36,
			Size = UDim2.new(1, 0, 0, state2),
			ZIndex = 0
		}
		local v55

		if v21 then
			v55 = React.createElement(module7.HomeThemeBackgroundImage, {
				image = v21,
				Size = v22,
				Position = v36:map(function(p3)
					return UDim2.fromOffset(0, state2 - p3.Y.Offset)
				end)
			})
		end

		local v56 = if v23 then React.createElement(module11.ThemeBackgroundHeaderSlot) else nil
		v51 = createElement3("Frame", v53, {
			ThemeBackgroundImage = v55,
			ThemeBackgroundSlot = v56
		})
	end

	local createElement3 = React.createElement

	local v54 = if not (v5 or not defineFastFlag2) then Enum.AutomaticSize.Y else nil

	local v55 = if defineFastFlag2 then v20.LuaApps.App.Page.BackgroundColor else nil
	local v53 = {
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		AutomaticSize = v54,
		BackgroundColor3 = v55,
		BackgroundTransparency = v5 and 1 or nil,
		BorderSizePixel = defineFastFlag2 and 0 or nil
	}
	local udim

	if v5 then
		udim = UDim2.new(1, 0, 0, state2)
	elseif defineFastFlag2 then
		udim = UDim2.fromScale(1, 0)
	end

	v53.Size = udim

	local absoluteSize = React.Change.AbsoluteSize
	local v56 = if not (v5 or not (defineFastFlag2 and fFlagAppIaScrollAway)) then v31 else nil
	v53[absoluteSize] = v56

	local tag = React.Tag
	local v57 = if defineFastFlag2 then compositionTags.ContentRegion.Header else nil
	v53[tag] = v57

	local v58 = if not defineFastFlag2 then `col size-full-0 auto-y {compositionTags.ContentRegion.Header}` else nil
	v53.tag = v58

	v53.backgroundStyle = not defineFastFlag2
		and { Color3 = v20.LuaApps.App.Page.BackgroundColor, Transparency = 0 }
		or nil

	if defineFastFlag2 or not fFlagAppIaScrollAway then
		v31 = nil
	end

	v53.onAbsoluteSizeChanged = v31

	local v59 = if not (v5 or not defineFastFlag2) then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil

	local createElement4 = React.createElement

	local v62 = if not (v5 or not (defineFastFlag2 or defineFastFlag)) then Enum.AutomaticSize.Y else nil
	local v61 = {
		AutomaticSize = v62,
		BackgroundTransparency = (defineFastFlag2 or defineFastFlag) and 1 or nil,
		Position = 0,
		Size = 0,
		tag = 0,
		LayoutOrder = 1,
		Text = 0,
		AutoButtonColor = 0,
		Selectable = 0
	}

	if not fFlagAppIaHomeSubTabScrollAwayFull then
		v37 = if v5 then UDim2.fromScale(0, 0) else nil
	end

	v61.Position = v37
	local udim2

	if v5 then
		udim2 = UDim2.new(1, 0, 0, v29)
	elseif defineFastFlag2 or defineFastFlag then
		udim2 = UDim2.fromScale(1, 0)
	end

	v61.Size = udim2

	v61.tag = not (defineFastFlag2 or defineFastFlag) and "size-full-0 auto-y" or nil

	v61.Text = defineFastFlag and "" or nil
	v61.AutoButtonColor = if defineFastFlag then false else nil
	v61.Selectable = if defineFastFlag then false else nil

	local createElement5 = React.createElement

	if not fFlagSubTabFixMissingProfileWidget then
		v25 = nil
	end

	local v67 = {
		sideMarginOverride = 0,
		useGridPageLayout = v25,
		enableHeaderImageBackground = fFlagEnableClassicThemeHeaderBackground and true or nil,
		transparentBackground = v21 and true or nil,
		profileSource = 0
	}
	local v68

	if fFlagSubTabFixMissingProfileWidget and fFlagLuaAppEnableChartsPageProfileLink then
		if routeName == appPage.Games then
			v68 = sources.ChartsPageSelfWidget
		elseif fFlagAppIaHomeShowCampaignTab and routeName == appPage.Campaign then
			v68 = sources.CampaignPageSelfWidget
		else
			v68 = sources.HomePageSelfWidget
		end
	end

	v67.profileSource = v68
	local children2 = {
		UIListLayout = v59,
		AppHeaderBar = createElement4(
			defineFastFlag and "TextButton" or defineFastFlag2 and "Frame" or view,
			v61,
			{ PersonalizationTopBar = createElement5(module3, v67) }
		),
		SubTabs = 0
	}

	local createElement6 = React.createElement
	local v71 = if defineFastFlag2 then Enum.AutomaticSize.Y else nil
	local v70 = {}
	v70.AutomaticSize = v71
	v70.BackgroundTransparency = defineFastFlag2 and 1 or nil

	if not v5 then
		v34 = nil
	end

	v70.Position = v34
	local v72 = if defineFastFlag2 then UDim2.fromScale(1, 0) else nil
	v70.Size = v72
	v70.tag = not defineFastFlag2 and "size-full-0 auto-y" or nil
	v70.LayoutOrder = 2
	v70.ref = if v5 then v33 else nil
	local absoluteSize2 = React.Change.AbsoluteSize

	if not v5 then
		v33 = nil
	end

	v70[absoluteSize2] = v33

	local createElement7 = React.createElement
	local v76 = {
		activeTabId = routeName,
		onActivated = v15,
		tabs = v19,
		size = 0,
		fillBehavior = 0,
		testId = "--discovery-home-subtabs"
	}

	local v77 = if fFlagSubTabSizeSmall then inputSize.Small else inputSize.Medium
	v76.size = v77
	v76.fillBehavior = v26
	children2.SubTabs = createElement6(defineFastFlag2 and "Frame" or view, v70, {
		Tabs = createElement7(tabs, v76)
	})
	local children = {
		ThemeBackground = v45,
		UIListLayout = v46,
		HeaderFocusRoot = createElement2(focusNavigableSurfaceWrapper, v48, {
			StatusBarBackground = v50,
			HeaderBackground = v51,
			Header = createElement3(defineFastFlag2 and "Frame" or view, v53, children2)
		}),
		HomeSubTabNavigator = 0
	}

	local createElement8 = React.createElement
	local v79 = { navigation = p2.navigation, screenProps = 0 }
	local v80

	if fFlagAppIaScrollAway then
		v80 = {
			headerHeight = state2,
			headerHeightBinding = v32,
			scrollAwayHeight = 0,
			subTabsBottomBinding = 0
		}

		if not v5 then
			v35 = nil
		end

		v80.scrollAwayHeight = v35

		if not v5 then
			v36 = nil
		end

		v80.subTabsBottomBinding = v36
	end

	v79.screenProps = v80
	children.HomeSubTabNavigator = createElement8(v7, v79)
	local element = createElement(defineFastFlag2 and "Frame" or view, v41, children)

	if fFlagAppThemeHalloween2026HomeBackground and not module9 then
		return React.createElement(module8.Provider, { value = v21 }, element)
	end

	return element
end)

forwardRef.router = v7.router

return forwardRef
