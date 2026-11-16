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
local module = require("@luauforge/bundled/dUd")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/Navigation")
local module2 = require("@luauforge/bundled/eeo")
local focusNavigableSurfaceWrapper = module2.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module3 = require("@luauforge/bundled/hEB")

local module4 = require("@luauforge/bundled/hFB")

local compositionTags = require("@luauforge/bundled/gns").CompositionTags
local module5 = require("@luauforge/bundled/dHu")
local visibilityControl = module5.VisibilityControl
local sources = require("@luauforge/bundled/dYV").Analytics.Enums.Sources

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTabAnalytics = SharedFlags.FFlagAppIaHomeSubTabAnalytics
local fFlagAppIaStatusBar = SharedFlags.FFlagAppIaStatusBar
local fFlagFixHomeHeaderForDeviceSafeInsets = SharedFlags.FFlagFixHomeHeaderForDeviceSafeInsets
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagSubTabFixMissingProfileWidget = SharedFlags.FFlagSubTabFixMissingProfileWidget
local fFlagSubTabNavigationTTITracking = SharedFlags.FFlagSubTabNavigationTTITracking
local fFlagAppIaHomeShowCampaignTab = SharedFlags.FFlagAppIaHomeShowCampaignTab
local defineFastFlag = game:DefineFastFlag("AppHeaderBarSinkInput", false)
local defineFastFlag2 = game:DefineFastFlag("AppIaHomeSubTabFrame", false)
local defineFastFlag3 = game:DefineFastFlag("AppIaHomeSubTabUnderlineFix", false)
local v5 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFix", false) and defineFastFlag2

local defineFastFlag4 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFixDefaultHeight", false)
local fFlagAppIaHomeSubTabScrollAwayFull = SharedFlags.FFlagAppIaHomeSubTabScrollAwayFull
local fFlagSubTabSizeSmall = SharedFlags.FFlagSubTabSizeSmall
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground
local module7 = require("@luauforge/bundled/fAf")
local module8 = require("@luauforge/bundled/fzH")

local module9 = require("@luauforge/bundled/hEE")
local module10 = require("@luauforge/bundled/eeu")
local trackStart

if fFlagSubTabNavigationTTITracking then
	trackStart = require("@luauforge/bundled/fvo").TimeToInteractiveTracker.trackStart
else
	trackStart = nil
end

local v6 = module4()
local v7

if fFlagAppIaHomeSubTabAnalytics then
	v7 = {}
	v7[appPage.Home] = Enum.AppShellActionType.TapHomePageTab
	v7[appPage.Games] = Enum.AppShellActionType.TapGamePageTab
else
	v7 = nil
end

local function fn(p2)
	return module.GetDisplayStore(p2).getTopBarHeight(p2)
end

local forwardRef = React.forwardRef(function(p2, ref)
	local v8 = useLocalization({
		Charts = "CommonUI.Features.Label.Charts",
		ForYou = "CommonUI.Features.Label.ForYou",
		Campaign = fFlagAppIaHomeShowCampaignTab and "Feature.Home.Button.Join" or nil
	})

	local v9 = if fFlagAppIaHomeSubTabAnalytics then useRoactService(appNotificationService) else nil
	local state = p2.navigation.state
	local routeName = state.routes[state.index].routeName

	local function fn2(p3)
		if fFlagAppIaHomeSubTabAnalytics then
			if p3 == routeName then
				return
			end

			if fFlagSubTabNavigationTTITracking then
				trackStart("NavigateTo_" .. p3, true)
			end

			p2.navigation.navigate(p3)
			local v10 = v7[p3]

			if v10 then
				v9:ActionTaken(v10)
			end
		else
			if fFlagSubTabNavigationTTITracking then
				trackStart("NavigateTo_" .. p3, true)
			end

			p2.navigation.navigate(p3)
		end
	end

	local v12 = React.useCallback(fn2, { p2.navigation, if fFlagAppIaHomeSubTabAnalytics then v9 else nil })
	local v13

	if defineFastFlag3 then
		v13 = React.useMemo(function()
			local v14 = {
				{ id = appPage.Home, text = v8.ForYou },
				{ id = appPage.Games, text = v8.Charts }
			}

			if fFlagAppIaHomeShowCampaignTab then
				table.insert(v14, { id = appPage.Campaign, text = v8.Campaign })
			end

			return v14
		end, { v8.ForYou, v8.Charts, v8.Campaign })
	else
		v13 = {
			{ id = appPage.Home, text = v8.ForYou },
			{ id = appPage.Games, text = v8.Charts }
		}
	end

	if fFlagAppIaHomeShowCampaignTab and not defineFastFlag3 then
		table.insert(v13, { id = appPage.Campaign, text = v8.Campaign })
	end

	local v14 = useDesignTokens()
	local v15 = nil
	local v16 = nil
	local ref2 = nil
	local v17 = nil

	if module9 then
		v17 = module10.useThemeBackground() ~= nil
	elseif fFlagAppThemeHalloween2026HomeBackground and not module9 then
		v15 = module7.useHomeThemeBackgroundImage()
		local v18
		v16, v18 = React.useBinding(UDim2.fromScale(1, 0))

		ref2 = React.useRef(nil)

		React.useEffect(function()
			local parent = if ref2.current then ref2.current.Parent else nil

			if not (parent and parent:IsA("GuiObject")) then
				return nil
			end

			local function updateSize()
				v18(UDim2.fromOffset(parent.AbsoluteSize.X, parent.AbsoluteSize.Y))
			end

			v18(UDim2.fromOffset(parent.AbsoluteSize.X, parent.AbsoluteSize.Y))

			local absoluteSizeChangedConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end, { v15 })
	end

	local v18 = useSelector(function(p3)
		return p3.FormFactor
	end)
	local v19

	if fFlagSubTabFixMissingProfileWidget then
		v19 = useAppPolicy(function(p3)
			return p3.useGridPageLayout()
		end)
	end

	local v20 = if v18 == formFactor.COMPACT then fillBehavior.Fill else fillBehavior.Fit
	local v21

	if fFlagAppIaStatusBar then
		v21 = useSelector(function(p3)
			return p3.TopBar.statusBarHeight
		end)
	end

	local v22

	if fFlagFixHomeHeaderForDeviceSafeInsets then
		local v23 = useDeviceInsets()
		v22 = not module.shouldUseDeviceSafeInsets and 0 or v23.top
	else
		v22 = 0
	end

	local v23 = if v5 then useSignalState(fn) else nil

	local state2 = nil
	local v24 = nil
	local v25 = nil

	local v26 = nil
	local v27 = nil
	local v28 = nil
	local v29 = nil
	local v30 = nil
	local v31 = nil
	local v32

	if v5 then
		local v33 = useTokens()
		local v34

		if defineFastFlag4 then
			v34 = (if fFlagSubTabSizeSmall then v33.Padding.Small else v33.Padding.Medium) * 2 + v33.Size.Size_600
		else
			v34 = 0
		end

		local state3, setState = React.useState(v34)
		v27 = React.useCallback(function(p3)
			if p3 then
				setState(p3.AbsoluteSize.Y)
			end
		end, {})
		state2 = v23 + state3
		local v35 = not fFlagAppIaStatusBar and 0 or v21
		v29 = if fFlagAppIaHomeSubTabScrollAwayFull then state2 - v35 else v23 - v35
		local v36
		v26, v36 = React.useBinding(0)
		v32 = v36
		React.useEffect(function()
			v32(state2)
		end, { state2 })

		if fFlagAppIaHomeSubTabScrollAwayFull then
			if fFlagAppIaScrollAway and module5.getScrollAwayEnabled() then
				v31 = visibilityControl.getHeaderBinding():map(function(p3)
					return UDim2.new(0, 0, 0, (p3 - 1) * state3)
				end)
			else
				v31 = UDim2.fromScale(0, 0)
			end
		end

		if fFlagAppIaScrollAway and module5.getScrollAwayEnabled() then
			v28 = visibilityControl.getHeaderBinding():map(function(p3)
				local v37 = if fFlagAppIaHomeSubTabScrollAwayFull then v23 + (p3 - 1) * (state2 - v35) else v35 + p3 * (v23 - v35)
				return UDim2.new(0, 0, 0, v37)
			end)
		else
			v28 = UDim2.new(0, 0, 0, v23)
		end

		v30 = visibilityControl.getHeaderBinding():map(function(p3)
			local v37 = if fFlagAppIaHomeSubTabScrollAwayFull then v35 + p3 * (state2 - v35) else v35 + p3 * (v23 - v35) + state3
			return UDim2.new(0, 0, 0, v37)
		end)
	elseif fFlagAppIaScrollAway then
		local setState
		state2, setState = React.useState(0)
		v24 = setState
		local v33
		v26, v33 = React.useBinding(0)
		v32 = v33
		v25 = React.useCallback(function(p3)
			v24(p3.AbsoluteSize.Y)
			v32(p3.AbsoluteSize.Y)
		end, {})
	end

	local v33

	if fFlagEnableClassicThemeHeaderBackground then
		v33 = visibilityControl.getHeaderBinding()
	end

	local createElement = React.createElement
	local v36 = if defineFastFlag2 then v14.LuaApps.App.Page.BackgroundColor else nil

	local v37 = if defineFastFlag2 then v17 and 1 or v14.LuaApps.App.Page.BackgroundTransparency else nil
	local v35 = {
		BackgroundColor3 = v36,
		BackgroundTransparency = v37,
		BorderSizePixel = defineFastFlag2 and 0 or nil,
		Size = 0,
		backgroundStyle = 0,
		tag = 0,
		ref = 0
	}

	local v38 = if defineFastFlag2 then UDim2.fromScale(1, 1) else nil
	v35.Size = v38
	v35.backgroundStyle = not defineFastFlag2 and {
		Color3 = v14.LuaApps.App.Page.BackgroundColor,
		Transparency = v17 and 1 or v14.LuaApps.App.Page.BackgroundTransparency
	} or nil

	v35.tag = not defineFastFlag2 and {
		["size-full"] = true,
		col = not fFlagAppIaScrollAway
	} or nil

	v35.ref = ref

	local v39 = if v15 then React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = -2,
		Size = UDim2.fromScale(1, 0),
		ZIndex = 0,
		ref = ref2
	}, {
		Image = React.createElement(module7.HomeThemeBackgroundImage, {
			image = v15,
			Size = v16
		})
	}) else nil

	local v40 = if defineFastFlag2 and not fFlagAppIaScrollAway then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil

	local createElement2 = React.createElement
	local v42 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.HeaderView,
		frameProps = {
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = defineFastFlag2 and -1 or nil,
			Size = UDim2.fromScale(1, 0),
			ZIndex = 2
		}
	}
	local v44

	if fFlagAppIaStatusBar then
		local createElement3 = React.createElement

		local v47 = if defineFastFlag2 then v14.LuaApps.App.Page.BackgroundColor else nil

		if v15 or v17 then
			v33 = 0
		elseif not (fFlagEnableClassicThemeHeaderBackground and defineFastFlag2) then
			v33 = nil
		end

		local v46 = {
			BackgroundColor3 = v47,
			BackgroundTransparency = v33,
			BorderSizePixel = defineFastFlag2 and 0 or nil,
			backgroundStyle = not defineFastFlag2 and {
				Color3 = v14.LuaApps.App.Page.BackgroundColor,
				Transparency = 0
			} or nil,
			ClipsDescendants = (v15 or v17) and true or nil,
			Position = 0,
			Size = 0,
			ZIndex = 2
		}

		local v48 = if fFlagFixHomeHeaderForDeviceSafeInsets then UDim2.fromOffset(0, -v22) else nil
		v46.Position = v48

		v46.Size = UDim2.new(1, 0, 0, v21 + (not fFlagFixHomeHeaderForDeviceSafeInsets and 0 or v22))
		local v50

		if v15 then
			local createElement4 = React.createElement
			local homeThemeBackgroundImage = module7.HomeThemeBackgroundImage

			local v52 = if fFlagFixHomeHeaderForDeviceSafeInsets then UDim2.fromOffset(0, v22) else nil
			v50 = createElement4(homeThemeBackgroundImage, {
				image = v15,
				Position = v52,
				Size = v16
			})
		end

		local v51 = if v17 then React.createElement(module10.ThemeBackgroundHeaderSlot) else nil
		v44 = createElement3(defineFastFlag2 and "Frame" or view, v46, {
			ThemeBackgroundImage = v50,
			ThemeBackgroundSlot = v51
		})
	end

	local v45

	if v5 then
		local createElement3 = React.createElement
		local v47 = {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v14.LuaApps.App.Page.BackgroundColor,
			BorderSizePixel = 0,
			ClipsDescendants = (v15 or v17) and true or nil,
			Position = v30,
			Size = UDim2.new(1, 0, 0, state2),
			ZIndex = 0
		}
		local v49

		if v15 then
			v49 = React.createElement(module7.HomeThemeBackgroundImage, {
				image = v15,
				Size = v16,
				Position = v30:map(function(p3)
					return UDim2.fromOffset(0, state2 - p3.Y.Offset)
				end)
			})
		end

		local v50 = if v17 then React.createElement(module10.ThemeBackgroundHeaderSlot) else nil
		v45 = createElement3("Frame", v47, {
			ThemeBackgroundImage = v49,
			ThemeBackgroundSlot = v50
		})
	end

	local createElement3 = React.createElement

	local v48 = if not (v5 or not defineFastFlag2) then Enum.AutomaticSize.Y else nil

	local v49 = if defineFastFlag2 then v14.LuaApps.App.Page.BackgroundColor else nil
	local v47 = {
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		AutomaticSize = v48,
		BackgroundColor3 = v49,
		BackgroundTransparency = v5 and 1 or nil,
		BorderSizePixel = defineFastFlag2 and 0 or nil
	}
	local udim

	if v5 then
		udim = UDim2.new(1, 0, 0, state2)
	elseif defineFastFlag2 then
		udim = UDim2.fromScale(1, 0)
	end

	v47.Size = udim

	local absoluteSize = React.Change.AbsoluteSize
	local v50 = if not (v5 or not (defineFastFlag2 and fFlagAppIaScrollAway)) then v25 else nil
	v47[absoluteSize] = v50

	local tag = React.Tag
	local v51 = if defineFastFlag2 then compositionTags.ContentRegion.Header else nil
	v47[tag] = v51

	local v52 = if not defineFastFlag2 then `col size-full-0 auto-y {compositionTags.ContentRegion.Header}` else nil
	v47.tag = v52

	v47.backgroundStyle = not defineFastFlag2
		and { Color3 = v14.LuaApps.App.Page.BackgroundColor, Transparency = 0 }
		or nil

	if defineFastFlag2 or not fFlagAppIaScrollAway then
		v25 = nil
	end

	v47.onAbsoluteSizeChanged = v25

	local v53 = if not (v5 or not defineFastFlag2) then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil

	local createElement4 = React.createElement

	local v56 = if not (v5 or not (defineFastFlag2 or defineFastFlag)) then Enum.AutomaticSize.Y else nil
	local v55 = {
		AutomaticSize = v56,
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
		v31 = if v5 then UDim2.fromScale(0, 0) else nil
	end

	v55.Position = v31
	local udim2

	if v5 then
		udim2 = UDim2.new(1, 0, 0, v23)
	elseif defineFastFlag2 or defineFastFlag then
		udim2 = UDim2.fromScale(1, 0)
	end

	v55.Size = udim2

	v55.tag = not (defineFastFlag2 or defineFastFlag) and "size-full-0 auto-y" or nil

	v55.Text = defineFastFlag and "" or nil
	v55.AutoButtonColor = if defineFastFlag then false else nil
	v55.Selectable = if defineFastFlag then false else nil

	local createElement5 = React.createElement

	if not fFlagSubTabFixMissingProfileWidget then
		v19 = nil
	end

	local v61 = {
		sideMarginOverride = 0,
		useGridPageLayout = v19,
		enableHeaderImageBackground = fFlagEnableClassicThemeHeaderBackground and true or nil,
		transparentBackground = v15 and true or nil,
		profileSource = 0
	}
	local v62

	if fFlagSubTabFixMissingProfileWidget and fFlagLuaAppEnableChartsPageProfileLink then
		if routeName == appPage.Games then
			v62 = sources.ChartsPageSelfWidget
		elseif fFlagAppIaHomeShowCampaignTab and routeName == appPage.Campaign then
			v62 = sources.CampaignPageSelfWidget
		else
			v62 = sources.HomePageSelfWidget
		end
	end

	v61.profileSource = v62
	local children2 = {
		UIListLayout = v53,
		AppHeaderBar = createElement4(
			defineFastFlag and "TextButton" or defineFastFlag2 and "Frame" or view,
			v55,
			{ PersonalizationTopBar = createElement5(module3, v61) }
		),
		SubTabs = 0
	}

	local createElement6 = React.createElement
	local v65 = if defineFastFlag2 then Enum.AutomaticSize.Y else nil
	local v64 = {}
	v64.AutomaticSize = v65
	v64.BackgroundTransparency = defineFastFlag2 and 1 or nil

	if not v5 then
		v28 = nil
	end

	v64.Position = v28
	local v66 = if defineFastFlag2 then UDim2.fromScale(1, 0) else nil
	v64.Size = v66
	v64.tag = not defineFastFlag2 and "size-full-0 auto-y" or nil
	v64.LayoutOrder = 2
	v64.ref = if v5 then v27 else nil
	local absoluteSize2 = React.Change.AbsoluteSize

	if not v5 then
		v27 = nil
	end

	v64[absoluteSize2] = v27

	local createElement7 = React.createElement
	local v70 = {
		activeTabId = routeName,
		onActivated = v12,
		tabs = v13,
		size = 0,
		fillBehavior = 0,
		testId = "--discovery-home-subtabs"
	}

	local v71 = if fFlagSubTabSizeSmall then inputSize.Small else inputSize.Medium
	v70.size = v71
	v70.fillBehavior = v20
	children2.SubTabs = createElement6(defineFastFlag2 and "Frame" or view, v64, {
		Tabs = createElement7(tabs, v70)
	})
	local children = {
		ThemeBackground = v39,
		UIListLayout = v40,
		HeaderFocusRoot = createElement2(focusNavigableSurfaceWrapper, v42, {
			StatusBarBackground = v44,
			HeaderBackground = v45,
			Header = createElement3(defineFastFlag2 and "Frame" or view, v47, children2)
		}),
		HomeSubTabNavigator = 0
	}

	local createElement8 = React.createElement
	local v73 = { navigation = p2.navigation, screenProps = 0 }
	local v74

	if fFlagAppIaScrollAway then
		v74 = {
			headerHeight = state2,
			headerHeightBinding = v26,
			scrollAwayHeight = 0,
			subTabsBottomBinding = 0
		}

		if not v5 then
			v29 = nil
		end

		v74.scrollAwayHeight = v29

		if not v5 then
			v30 = nil
		end

		v74.subTabsBottomBinding = v30
	end

	v73.screenProps = v74
	children.HomeSubTabNavigator = createElement8(v6, v73)
	local element = createElement(defineFastFlag2 and "Frame" or view, v35, children)

	if fFlagAppThemeHalloween2026HomeBackground and not module9 then
		return React.createElement(module8.Provider, { value = v15 }, element)
	end

	return element
end)

forwardRef.router = v6.router

return forwardRef
