game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local components = parent.Components
local presentation = components.Presentation
local chrome = parent.Parent.Chrome

local Constants = require(parent.Constants)
local ExperienceAgeRatingPolicy = require(parent.ExperienceAgeRatingPolicy)
local ExperienceAgeRatingBadge = require(CorePackages.Workspace.Packages.InExperienceTopBar.ExperienceAgeRatingBadge)

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagExperienceAgeRatingBadge = InExperienceTopBar.Flags.FFlagExperienceAgeRatingBadge

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Foundation = require(CorePackages.Packages.Foundation)
local Display = require(CorePackages.Workspace.Packages.Display)
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
require(CorePackages.Workspace.Packages.Songbird)
local SwitchServer = require(CorePackages.Workspace.Packages.SwitchServer)
local Traversal = CoreScriptsRoactCommon.Traversal
local UIBlox = require(CorePackages.Packages.UIBlox)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local FFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
local FFlagGamepadNavigationDialogABTest = require(parent.Flags.FFlagGamepadNavigationDialogABTest)
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar
local FFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua
local FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating
local v = FFlagExperienceAgeRatingBadge and FFlagShowGameAgeRating
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local v2 = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop
local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local v3 = isSideSheetEnabled and (FFlagShowSwitchServerButton or isPioneerLaunch())
local ShopGlobalIcon = InExperienceShop.ShopGlobalIcon
local FFlagTopBarShopIconV2 = require(parent.Flags.FFlagTopBarShopIconV2)
local ShopIcon

if FFlagTopBarShopIconV2 then
	ShopIcon = require(components.Presentation.ShopIcon)
else
	ShopIcon = nil
end

local View = Foundation.View
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider

local GamepadConnector = require(components.GamepadConnector)
local GamepadNavigationDialog = require(presentation.GamepadNavigationDialog)
local HealthBar = CoreGuiCommon.Components.HealthBar
local MenuIcon = require(parent.ComponentsV2.MenuIcon)
local MenuIconContext = require(components.MenuIconContext)
local MenuNavigationToggleDialog = require(presentation.GamepadMenu.MenuNavigationToggleDialog)
local TraversalBackButton = require(components.TraversalBackButton)
local PlaytestModeTooltip = require(presentation.PlaytestModeTooltip)
local v4

if isInExperienceUIVREnabled then
	v4 = require(components.VRBottomUnibar)
else
	v4 = require(parent2.VR.VRBottomBar.VRBottomBar)
end

local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildModeLaunch = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.BuildModeLaunch)
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local UnpublishedPlaytestModeTooltip = BuildExperience.UnpublishedPlaytestModeTooltip
local Analytics

if game:GetEngineFeature("InGameChromeSignalAPI") then
	Analytics = require(chrome.ChromeShared.Analytics)
else
	Analytics = nil
end

local JoinVoiceBinder

if game:GetEngineFeature("VoiceChatSupported") and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	JoinVoiceBinder = require(chrome.Integrations.JoinVoiceBinder)
else
	JoinVoiceBinder = nil
end

local PartyMicBinder = require(chrome.Integrations.Party.PartyMicBinder)
local Unibar = require(chrome.ChromeShared.Unibar)
local VoiceChatServiceManager = require(parent2.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceStateContext = require(parent2.VoiceChat.VoiceStateContext)
local Service

if v2 then
	Service = require(chrome.Service)
else
	Service = nil
end

local Constants2

if v2 then
	Constants2 = require(chrome.ChromeShared.Unibar.Constants)
else
	Constants2 = nil
end

local CommonIcon

if v2 then
	CommonIcon = require(chrome.Integrations.CommonIcon)
else
	CommonIcon = nil
end

local useMappedSignal

if v2 then
	local Chrome = require(CorePackages.Workspace.Packages.Chrome)
	useMappedSignal = Chrome.Hooks.useMappedSignal
else
	useMappedSignal = nil
end

local mappedSignal

if v2 and Service and Constants2 then
	local ChromeUtils = require(chrome.ChromeShared.Service.ChromeUtils)
	mappedSignal = ChromeUtils.MappedSignal.new(Service:onIntegrationStatusChanged(), function()
		return Service:isWindowOpen(Constants2.IN_EXPERIENCE_SHOP_ID)
	end)
else
	mappedSignal = nil
end

local toggleInExperienceShopWindow

if v2 then
	local ShopWindowLayout = require(chrome.Integrations.InExperienceShop.ShopWindowLayout)
	toggleInExperienceShopWindow = ShopWindowLayout.toggleInExperienceShopWindow
else
	toggleInExperienceShopWindow = nil
end

local SwitchServerConfirmation = SwitchServer.SwitchServerConfirmation
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore

local function getShopGlobalIconEnabled(p)
	if not v2 then
		return false
	end

	local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if getShopGlobalIconStore then
		return (getShopGlobalIconStore(p).getEnabled(p))
	end

	return false
end

local function getShopGlobalStatusIndicatorEnabled(p)
	if not v2 then
		return false
	end

	local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if getShopGlobalIconStore then
		return (getShopGlobalIconStore(p).getStatusIndicatorEnabled(p))
	end

	return false
end

local function handleShopGlobalIconActivated()
	if not v2 then
		return
	end

	if FFlagCenterInExperienceShopWindow then
		if toggleInExperienceShopWindow then
			toggleInExperienceShopWindow()
		end
	elseif Service and Constants2 then
		Service:toggleWindow(Constants2.IN_EXPERIENCE_SHOP_ID)
	end
end

local function canShowAssistantBuild() -- 1 equivalent call inferred from this helper
	return BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end

local function getShouldEnableSwitchServer(p)
	if not v3 then
		return false
	end

	local getSwitchServerStore = GetSwitchServerStore

	if getSwitchServerStore then
		return (getSwitchServerStore(p).shouldEnableSwitchServer(p))
	end

	return false
end

local function getIsConfirmationOpen(p)
	if not v3 then
		return false
	end

	local getSwitchServerStore = GetSwitchServerStore

	if getSwitchServerStore then
		return (getSwitchServerStore(p).isConfirmationOpen(p))
	end

	return false
end

local function TopBarApp(_)
	local v5

	if FFlagShowGameAgeRating then
		v5 = UniversalAppPolicy.useAppPolicy(function(p)
			return p.getShowGameAgeRating()
		end)
	else
		v5 = UniversalAppPolicy.useAppPolicy(function(p)
			return p.getShowBadgeOver12()
		end)
	end

	local v6 = SignalsReact.useSignalState(function(p)
		return CoreGuiCommon.Stores.GetKeepOutAreasStore(p)
	end)

	local v7 = SignalsReact.useSignalState(function(p)
		return Display.GetDisplayStore(p).getUIScale(p)
	end)
	local v8, showStatusIndicator, onActivated, isActive

	if v2 and not FFlagTopBarShopIconV2 then
		v8 = SignalsReact.useSignalState(getShopGlobalIconEnabled)
		showStatusIndicator = SignalsReact.useSignalState(getShopGlobalStatusIndicatorEnabled)
		onActivated = handleShopGlobalIconActivated
		React.useEffect(function()
			return InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon() or function() end
		end, {})
		isActive = (useMappedSignal or function() end)(mappedSignal)
	end

	local ref = React.useRef(nil)
	local spatial = isSpatial()
	local setSpatial

	if FFlagExperienceAgeRatingBadge then
		spatial, setSpatial = React.useState(spatial)
	else
		setSpatial = nil
	end

	local eligible = ExperienceAgeRatingPolicy.isEligible(v5, true, true, spatial)
	local ref2 = React.useRef(nil)

	local showTopBar = GamepadConnector:getShowTopBar()
	local v9, v10 = React.useBinding(showTopBar:get())

	React.useEffect(function()
		if not isSpatial() then
			GamepadConnector:connectToTopbar()
		end

		local vREnabledChangedConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
			if FFlagExperienceAgeRatingBadge then
				setSpatial(isSpatial())
			end

			if isSpatial() then
				GamepadConnector:disconnectFromTopbar()
			else
				GamepadConnector:connectToTopbar()
			end
		end)

		local connection = showTopBar:connect(function()
			v10(showTopBar:get())
		end)
		return function()
			if vREnabledChangedConnection then
				vREnabledChangedConnection:Disconnect()
			end

			GamepadConnector:disconnectFromTopbar()

			if v6 then
				v6.cleanup()
			end

			connection:disconnect()
		end
	end, {})

	local v11 = React.useCallback(function(p)
		v6.setKeepOutArea(Constants.TopBarKeepOutAreaId, p.AbsolutePosition, p.AbsoluteSize)
	end, { v6 })

	local v12 = Constants.ScreenSideOffset * v7
	local v13 = Constants.TopBarHeight * v7
	local buttonSize = Constants.TopBarButtonHeight * v7
	local v14 = Constants.TopBarTopMargin * v7
	local v15, v16, setConfirmationOpen

	if v3 then
		v15 = SignalsReact.useSignalState(getShouldEnableSwitchServer)
		v16 = SignalsReact.useSignalState(getIsConfirmationOpen)
		setConfirmationOpen = GetSwitchServerStore(false).setConfirmationOpen
	end

	local createElement = React.createElement
	local v17 = {
		tag = "anchor-top-left auto-x row gap-small",
		Size = UDim2.fromOffset(0, buttonSize),
		onAbsoluteSizeChanged = 0,
		onAbsolutePositionChanged = 0,
		Position = 0,
		Visible = 0
	}
	local onAbsoluteSizeChanged

	if not v then
		onAbsoluteSizeChanged = v11
	end

	v17.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	local onAbsolutePositionChanged

	if not v then
		onAbsolutePositionChanged = v11
	end

	v17.onAbsolutePositionChanged = onAbsolutePositionChanged
	local position

	if not v then
		position = UDim2.new(0, v12, 0, v14)
	end

	v17.Position = position
	v17.Visible = v9
	local menuIcon

	if not isSideSheetEnabled then
		local createElement2 = React.createElement
		local createElement3 = React.createElement
		local buttonSize2

		if v then
			buttonSize2 = buttonSize
		end

		menuIcon = createElement2(SelectionCursorProvider, {}, {
			Icon = createElement3(MenuIcon, {
				buttonSize = buttonSize2,
				showBadgeOver12 = v5 and not eligible,
				menuIconRef = ref2,
				unibarMenuRef = ref
			})
		})
	end

	local traversalBackButton

	if FFlagAddTraversalBackButton then
		traversalBackButton = React.createElement(TraversalBackButton)
	end

	local v18 = {
		MenuIcon = menuIcon,
		TraversalBackButton = traversalBackButton,
		UnibarFrame = React.createElement(MenuIconContext.Provider, {
			value = { menuIconRef = ref2, replacesAgeRating = eligible }
		}, { React.createElement(Unibar, {
				layoutOrder = 2,
				onMinWidthChanged = function() end,
				onAreaChanged = function() end,
				menuRef = ref
			}) }),
		ShopIcon = 0,
		ShopGlobalIcon = 0
	}
	local shopIcon

	if FFlagTopBarShopIconV2 and v2 then
		shopIcon = React.createElement(ShopIcon, { buttonSize = buttonSize, layoutOrder = 3 })
	end

	v18.ShopIcon = shopIcon
	local shopGlobalIcon

	if not (FFlagTopBarShopIconV2 or not v2 or not v8 or ShopGlobalIcon == nil) then
		local createElement2 = React.createElement
		local icon

		if not (FFlagExperienceShopNewIconography or not (CommonIcon and mappedSignal)) then
			icon = CommonIcon("BuildingStore", nil, mappedSignal)
		end

		shopGlobalIcon = createElement2(ShopGlobalIcon, {
			buttonSize = buttonSize,
			layoutOrder = 3,
			showStatusIndicator = showStatusIndicator,
			onActivated = onActivated,
			isActive = isActive,
			icon = icon
		})
	end

	v18.ShopGlobalIcon = shopGlobalIcon
	local v19 = createElement(View, v17, v18)

	local createElement2 = React.createElement
	local v20 = {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 6
	}

	local createElement3 = React.createElement
	local menuNavigationToggleDialog

	if FFlagAddMenuNavigationToggleDialog then
		menuNavigationToggleDialog = React.createElement(MenuNavigationToggleDialog, {
			Position = UDim2.fromScale(0.5, 0.1),
			GamepadConnector = GamepadConnector
		})
	end

	local gamepadNavigationDialog

	if FFlagGamepadNavigationDialogABTest then
		gamepadNavigationDialog = React.createElement(GamepadNavigationDialog)
	end

	local switchServerConfirmation

	if v15 and v16 then
		switchServerConfirmation = React.createElement(SwitchServerConfirmation, {
			setSwitchServerConfirmationOpen = setConfirmationOpen
		})
	end

	local children = {
		Popups = createElement3(View, { tag = "size-full" }, {
			MenuNavigationToggleDialog = menuNavigationToggleDialog,
			GamepadNavigationDialog = gamepadNavigationDialog,
			SwitchServerConfirmation = switchServerConfirmation
		}),
		Binders = 0,
		PlaytestTooltip = 0,
		UnpublishedPlaytestTooltip = 0,
		TopBarFrame = 0,
		VRBottomBar = 0
	}

	local createElement4 = React.createElement
	local fragment = React.Fragment
	local joinVoiceBinder

	if JoinVoiceBinder then
		joinVoiceBinder = React.createElement(JoinVoiceBinder)
	end

	local partyMicBinder

	if GetFFlagEnableCrossExpVoice() then
		partyMicBinder = React.createElement(PartyMicBinder)
	end

	local chromeAnalytics

	if Analytics then
		chromeAnalytics = React.createElement(Analytics)
	end

	children.Binders = createElement4(fragment, {}, {
		JoinVoiceBinder = joinVoiceBinder,
		PartyMicBinder = partyMicBinder,
		ChromeAnalytics = chromeAnalytics
	})
	local playtestTooltip

	if FFlagEnablePlaytestModeUnibar then
		playtestTooltip = React.createElement(PlaytestModeTooltip, { anchorRef = ref })
	end

	children.PlaytestTooltip = playtestTooltip
	local unpublishedPlaytestTooltip

	if FFlagEnableTeamTestLua then
		unpublishedPlaytestTooltip = React.createElement(UnpublishedPlaytestModeTooltip, {
			anchorRef = ref,
			isVisible = v9
		})
	end

	children.UnpublishedPlaytestTooltip = unpublishedPlaytestTooltip

	local createElement5 = React.createElement
	local v21 = { Size = UDim2.new(1, 0, 0, v13) }

	if v then
		local createElement6 = React.createElement
		local v22 = {
			tag = "row align-y-center gap-small auto-x",
			Size = UDim2.fromOffset(0, buttonSize),
			Position = UDim2.new(0, v12, 0, v14),
			onAbsoluteSizeChanged = v11,
			onAbsolutePositionChanged = v11
		}
		local ageRating

		if eligible then
			ageRating = React.createElement(ExperienceAgeRatingBadge, {
				universeId = tostring(game.GameId),
				layoutOrder = 1
			})
		end

		v19 = createElement6(View, v22, { Controls = v19, AgeRating = ageRating })
	end

	local createElement6 = React.createElement
	local v22 = {
		tag = "anchor-top-right auto-x",
		Size = UDim2.fromOffset(0, buttonSize),
		Position = UDim2.new(1, -v12, 0, v14)
	}
	local buildPillMenu

	if FFlagAppNavMyStatsTab and canShowAssistantBuild() then -- inferred equivalent call
		buildPillMenu = React.createElement(BuildPillMenuPortalHost)
	end

	children.TopBarFrame = createElement5(View, v21, {
		TopLeftFrame = v19,
		TopRightFrame = createElement6(View, v22, {
			BuildPillMenu = buildPillMenu,
			HealthBar = React.createElement(HealthBar)
		})
	})
	local vrBottomBar

	if VRService.VREnabled then
		vrBottomBar = React.createElement(VoiceStateContext.Provider, {}, {
			VRBottomBar = VoiceStateContext.withVoiceState(function(p)
				local createElement7 = React.createElement
				local v23 = {
					voiceChatServiceManager = default,
					voiceEnabled = p.voiceEnabled,
					voiceState = p.voiceState,
					showBadgeOver12 = 0
				}
				local showBadgeOver

				if isInExperienceUIVREnabled then
					showBadgeOver = v5
				end

				v23.showBadgeOver12 = showBadgeOver
				return createElement7(v4, v23)
			end)
		})
	end

	children.VRBottomBar = vrBottomBar
	return createElement2("ScreenGui", v20, children)
end

return TopBarApp
