local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local RespawnUtils = require(Chrome.Integrations.RespawnUtils)
local MappedSignal = ChromeUtils.MappedSignal
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome2.UnibarStyle

local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome3.Enums.SideSheetPlacement

local CommonIcon = require(Chrome.Integrations.CommonIcon)
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local AvatarSwitcherFtuxTooltip = require(Chrome.Integrations.AvatarSwitcher.AvatarSwitcherFtuxTooltip)
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(RobloxGui.Modules.BackpackScript)
end

local useMappedSignal = Chrome3.Hooks.useMappedSignal
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags2.GetFFlagIsSquadEnabled

local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local MenuIcon = require(RobloxGui.Modules.TopBar.ComponentsV2.MenuIcon)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider

local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local TooltipContext = require(Chrome.ChromeShared.Unibar.Tooltips.TooltipContext)
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib2.isSpatial

local SelfieView = require(RobloxGui.Modules.SelfieView)

local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)
local GetFIntRobloxConnectFtuxShowDelayMs = require(Chrome.Flags.GetFIntRobloxConnectFtuxShowDelayMs)
local GetFIntRobloxConnectFtuxDismissDelayMs = require(Chrome.Flags.GetFIntRobloxConnectFtuxDismissDelayMs)

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags3.GetFFlagEnableAppChatInExperience
local GetShouldShowPlatformChatBasedOnPolicy = require(Chrome.Flags.GetShouldShowPlatformChatBasedOnPolicy)
local defineFastFlag = game:DefineFastFlag("FixInventoryFilledIcon", false)

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags4.FFlagShowGameAgeRating

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagExperienceAgeRatingBadge = InExperienceTopBar.Flags.FFlagExperienceAgeRatingBadge
local MenuIconContext = require(script.Parent.Parent.Parent.TopBar.Components.MenuIconContext)
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagSideSheetFocusNav = SharedFlags4.FFlagSideSheetFocusNav
local FFlagEnableConsoleExpControls = SharedFlags4.FFlagEnableConsoleExpControls

local defineFastFlag2 = game:DefineFastFlag("AppChatEnabledChromeDropdownFtuxTooltip", false)
local defineFastFlag3 = game:DefineFastFlag("AvatarSwitcherFtuxTooltip", false)
local fFlagEnableInExperienceShop = game:DefineFastFlag("InExperienceShopFtuxTooltip", false)
	and SharedFlags4.FFlagEnableInExperienceShop

local FFlagEnableAnyFreeTrialToolTip = require(CorePackages.Workspace.Packages.InExperienceShop.FFlagEnableAnyFreeTrialToolTip)

local fFlagChromeNineDotActivityIndicator = SharedFlags4.FFlagOfferNineDotActivityIndicator
	and Flags.FFlagChromeNineDotActivityIndicator

local FFlagEnableFreeTrialBlueDot = require(CorePackages.Workspace.Packages.InExperienceShop.FFlagEnableFreeTrialBlueDot)

local fFlagChromeNineDotActivityIndicator2 = FFlagEnableFreeTrialBlueDot and Flags.FFlagChromeNineDotActivityIndicator
local useInExperienceOfferExposure = require(Chrome.Integrations.InExperienceShop.useInExperienceOfferExposure)
local useOfferNineDotActivityIndicator

if fFlagChromeNineDotActivityIndicator then
	useOfferNineDotActivityIndicator = require(Chrome.Integrations.InExperienceShop.useOfferNineDotActivityIndicator)
else
	useOfferNineDotActivityIndicator = nil
end

local useFreeTrialNineDotActivityIndicator

if fFlagChromeNineDotActivityIndicator2 then
	useFreeTrialNineDotActivityIndicator = require(Chrome.Integrations.InExperienceShop.useFreeTrialNineDotActivityIndicator)
else
	useFreeTrialNineDotActivityIndicator = nil
end

local InExperienceShopFtuxTooltip

if fFlagEnableInExperienceShop then
	InExperienceShopFtuxTooltip = require(Chrome.Integrations.InExperienceShop.InExperienceShopFtuxTooltip)
else
	InExperienceShopFtuxTooltip = nil
end

local MenuOfferTooltip = require(Chrome.Integrations.InExperienceShop.MenuOfferTooltip)
local usePublishShopAvailability = require(Chrome.Integrations.InExperienceShop.usePublishShopAvailability)
local FreeTrialToolTip, openInExperienceShopWindow

if FFlagEnableAnyFreeTrialToolTip then
	FreeTrialToolTip = require(CorePackages.Workspace.Packages.InExperienceShop.FreeTrialToolTip)

	local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
	openInExperienceShopWindow = ShopWindowLayout.openInExperienceShopWindow
else
	FreeTrialToolTip = nil
	openInExperienceShopWindow = nil
end

local defineFastInt = game:DefineFastInt("UnibarConnectTooltipPriority", 2000)

local defineFastInt2 = game:DefineFastInt("TrialAvailableTooltipPriority", 1400)

local freeTrialToolTipChrome = FFlagEnableAnyFreeTrialToolTip and function(props)
	local tooltipQueue = React.useContext(TooltipContext)
	return React.createElement(FreeTrialToolTip, {
		anchorRef = props.anchorRef,
		visible = props.visible,
		onOpenShop = props.onOpenShop,
		tooltipQueue = tooltipQueue,
		priority = defineFastInt2
	})
end or nil

local v = GetFFlagEnableAppChatInExperience() and defineFastFlag2 and GetShouldShowPlatformChatBasedOnPolicy()

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP

local SELFIE_VIEW_ID = Constants.SELFIE_VIEW_ID

local isActivated = MappedSignal.new(PlayerListManager:GetSetVisibleChangedEvent().Event, function()
	return PlayerListManager:GetSetVisible()
end)

local v2 = Service:register({
	id = "leaderboard",
	label = "CoreScripts.TopBar.Leaderboard",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		if isInExperienceUIVREnabled or not VRService.VREnabled then
			if PlayerListManager:GetSetVisible() then
				PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
			elseif isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
				PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
			else
				ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
					PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
				end)
			end
		else
			local InGameMenu = require(RobloxGui.Modules.InGameMenu)
			InGameMenu.openPlayersPage()
		end
	end,
	isActivated = isActivated,
	components = {
		Icon = function(_)
			return CommonIcon("icons/controls/leaderboardOff", "icons/controls/leaderboardOn", isActivated)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v2, Enum.CoreGuiType.PlayerList)

local isActivated2 = MappedSignal.new(EmotesMenuMaster.EmotesMenuToggled.Event, function()
	return EmotesMenuMaster:isOpen()
end)

local v3 = Service:register({
	id = "emotes",
	label = "CoreScripts.TopBar.Emotes",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		if EmotesMenuMaster:isOpen() then
			EmotesMenuMaster:close()
		elseif isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			EmotesMenuMaster:open()
		else
			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
				EmotesMenuMaster:open()
			end)
		end
	end,
	isActivated = isActivated2,
	components = {
		Icon = function(_)
			return CommonIcon("icons/controls/emoteOff", "icons/controls/emoteOn", isActivated2)
		end
	}
})

local v4 = false
local MenuIsVisible = EmotesMenuMaster.MenuIsVisible

function updateEmoteAvailability()
	if v4 and MenuIsVisible then
		v3.availability:available()
	else
		v3.availability:unavailable()
	end
end

ChromeUtils.setCoreGuiAvailability(v3, Enum.CoreGuiType.EmotesMenu, function(p)
	v4 = p
	updateEmoteAvailability()
end)

EmotesMenuMaster.MenuVisibilityChanged.Event:Connect(function()
	MenuIsVisible = EmotesMenuMaster.MenuIsVisible
	updateEmoteAvailability()
end)
local v5

if FFlagEnableNewBackpack then
	v5 = nil
else
	v5 = MappedSignal.new(BackpackScript.StateChanged.Event, function()
		return BackpackScript.IsOpen
	end)
end

local isActivated3

if FFlagEnableNewBackpack then
	local v6 = Signal.new()
	features.onVisibilityChanged(features.FeatureName.Backpack, function(): nil
		v6:fire()
		return nil
	end)

	isActivated3 = MappedSignal.new(v6, function()
		return features.getVisibility(features.FeatureName.Backpack)
	end)
else
	isActivated3 = v5
end

if isSideSheetEnabled and FFlagSideSheetFocusNav and FFlagEnableConsoleExpControls then
	isActivated3:connect(function(p)
		Service:setHideShortcutBar("Backpack", p)
	end)
end

local v6 = Service:register({
	id = "backpack",
	label = "CoreScripts.TopBar.Inventory",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		if FFlagEnableNewBackpack then
			if features.getVisibility(features.FeatureName.Backpack) then
				features.toggleVisibility(features.FeatureName.Backpack)
			elseif isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
				features.toggleVisibility(features.FeatureName.Backpack)
			else
				ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
					features.toggleVisibility(features.FeatureName.Backpack)
				end)
			end
		elseif BackpackScript.IsOpen then
			BackpackScript:OpenClose()
		elseif isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			BackpackScript:OpenClose()
		else
			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
				BackpackScript:OpenClose()
			end)
		end
	end,
	isActivated = isActivated3,
	components = {
		Icon = function(_)
			return CommonIcon(
				"icons/menu/inventoryOff",
				defineFastFlag and "icons/menu/inventoryOn" or "icons/menu/inventory",
				v5
			)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v6, Enum.CoreGuiType.Backpack)

local v7 = Service:register({
	id = "respawn",
	label = "CoreScripts.InGameMenu.QuickActions.Respawn",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		RespawnUtils.respawnPage()
	end,
	isActivated = RespawnUtils.respawnPageOpenSignal,
	components = {
		Icon = function(_)
			return CommonIcon("icons/actions/respawn")
		end
	}
})

function updateRespawn(p)
	if p then
		v7.availability:available()
	else
		v7.availability:unavailable()
	end
end

task.defer(function()
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	SettingsHub.RespawnBehaviourChangedEvent.Event:connect(updateRespawn)
	updateRespawn(SettingsHub:GetRespawnBehaviour())
end)

local currentSubMenu = Service:currentSubMenu()
local isActivated4 = MappedSignal.new(currentSubMenu:signal(), function(): boolean
	return currentSubMenu:get() == "nine_dot"
end)

if Service:orderAlignment():get() == Enum.HorizontalAlignment.Right then
	isActivated4:connect(function(p)
		PlayerListManager:SetMinimized(p)
	end)
end

function HamburgerButton(p)
	local toggleTransition = p.toggleTransition
	local v8 = useStyle()
	local ref = React.useRef(nil)

	if
		not RunService:IsStudio()
		or fFlagChromeNineDotActivityIndicator
		or fFlagChromeNineDotActivityIndicator2
		or FFlagEnableAnyFreeTrialToolTip
	then
		usePublishShopAvailability()
	end

	if not RunService:IsStudio() or fFlagChromeNineDotActivityIndicator then
		useInExperienceOfferExposure()
	end

	if fFlagChromeNineDotActivityIndicator then
		useOfferNineDotActivityIndicator()
	end

	if fFlagChromeNineDotActivityIndicator2 then
		useFreeTrialNineDotActivityIndicator()
	end

	local ICON_SIZE, MEDIUM_ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v9 = UnibarStyle.use()
		ICON_SIZE = v9.ICON_SIZE
		MEDIUM_ICON_SIZE = v9.MEDIUM_ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
		MEDIUM_ICON_SIZE = Constants.MEDIUM_ICON_SIZE
	end

	local v9 = isActivated4 and useMappedSignal(isActivated4) or false
	local v10

	if v then
		v10 = CommonFtuxTooltip({
			id = "CONNECT_TOOLTIP",
			priority = defineFastInt,
			isIconVisible = p.visible,
			headerKey = GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Heading.CheckOutRobloxParty" or "CoreScripts.FTUX.Heading.CheckOutRobloxConnect",
			bodyKey = GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Label.PartyWithYourFriendsAnytime" or "CoreScripts.FTUX.Label.ChatWithYourFriendsAnytime",
			localStorageKey = GetFStringConnectTooltipLocalStorageKey(),
			showDelay = GetFIntRobloxConnectFtuxShowDelayMs(),
			dismissDelay = GetFIntRobloxConnectFtuxDismissDelayMs()
		})
	end

	local v11

	if FFlagShowGameAgeRating then
		v11 = useAppPolicy(function(p2)
			return p2.getShowGameAgeRating()
		end)
	else
		v11 = useAppPolicy(function(p2)
			return p2.getShowBadgeOver12()
		end)
	end

	local v12

	if FFlagExperienceAgeRatingBadge then
		v12 = React.useContext(MenuIconContext).replacesAgeRating
	else
		v12 = false
	end

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
		BorderSizePixel = 0,
		ref = 0,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0
	}
	local ref2

	if not (RunService:IsStudio() and not FFlagEnableAnyFreeTrialToolTip) then
		ref2 = ref
	end

	v13.ref = ref2
	v13.BackgroundColor3 = v8.Theme.BackgroundOnHover.Color
	v13.BackgroundTransparency = toggleTransition:map(function(p2)
		return 1 - (1 - v8.Theme.BackgroundOnHover.Transparency) * p2
	end)

	local element = React.createElement("UICorner", {
		Name = "Corner",
		CornerRadius = UDim.new(1, 0)
	})
	local v14

	if isSideSheetEnabled then
		v14 = React.createElement(SelectionCursorProvider, {}, {
			Icon = React.createElement(MenuIcon, {
				showBadgeOver12 = v11 and not v12
			})
		})
	end

	local v15

	if not isSideSheetEnabled then
		v15 = React.createElement(ImageSetLabel, {
			Name = "Overflow",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Image = Images["icons/common/hamburgermenu"],
			Size = toggleTransition:map(function(p2)
				local v16 = 1 - p2
				return UDim2.new(0, ICON_SIZE * v16, 0, ICON_SIZE * v16)
			end),
			ImageColor3 = v8.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p2)
				return p2 * v8.Theme.IconEmphasis.Transparency
			end)
		})
	end

	local v16

	if not isSideSheetEnabled then
		v16 = React.createElement(ImageSetLabel, {
			Name = "Close",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Image = Images["icons/navigation/close"],
			Size = toggleTransition:map(function(p2)
				return UDim2.new(0, MEDIUM_ICON_SIZE * p2, 0, MEDIUM_ICON_SIZE * p2)
			end),
			ImageColor3 = v8.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p2)
				return (1 - p2) * v8.Theme.IconEmphasis.Transparency
			end)
		})
	end

	local v17

	if SelfieView.useCameraOn() and not (Service:isWindowOpen(SELFIE_VIEW_ID) or v9) then
		v17 = React.createElement(SelfieView.CameraStatusDot, {
			Name = "CameraStatusDot",
			Position = UDim2.new(1, -4, 1, -7),
			ZIndex = 2
		})
	end

	local v18

	if defineFastFlag3 then
		v18 = React.createElement(AvatarSwitcherFtuxTooltip, { visible = p.visible })
	end

	local v19

	if fFlagEnableInExperienceShop then
		v19 = React.createElement(InExperienceShopFtuxTooltip, { visible = p.visible })
	end

	local v20

	if not RunService:IsStudio() then
		v20 = React.createElement(MenuOfferTooltip, { anchorRef = ref, visible = p.visible })
	end

	local v21

	if FFlagEnableAnyFreeTrialToolTip then
		v21 = React.createElement(freeTrialToolTipChrome, {
			anchorRef = ref,
			visible = p.visible,
			onOpenShop = openInExperienceShopWindow
		})
	end

	return createElement("Frame", v13, {
		element,
		v14,
		v15,
		v16,
		v17,
		v10,
		v18,
		v19,
		v20,
		v21
	})
end

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Pinned,
	id = "nine_dot",
	label = isSideSheetEnabled and "CoreScripts.TopBar.RobloxMenu" or "CoreScripts.TopBar.MoreMenu",
	sideSheetPlacement = SideSheetPlacement.None,
	hotkeyCodes = isSideSheetEnabled and { Enum.KeyCode.Escape } or nil,
	isActivated = isActivated4,
	components = {
		Icon = function(p)
			return React.createElement(HamburgerButton, p)
		end
	}
})
