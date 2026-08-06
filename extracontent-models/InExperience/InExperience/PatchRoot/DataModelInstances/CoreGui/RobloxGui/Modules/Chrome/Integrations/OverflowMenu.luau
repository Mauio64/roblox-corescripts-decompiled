local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local RespawnUtils = require(Chrome.Integrations.RespawnUtils)
local MappedSignal = ChromeUtils.MappedSignal
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local AvatarSwitcherFtuxTooltip = require(Chrome.Integrations.AvatarSwitcher.AvatarSwitcherFtuxTooltip)
local VRService = game:GetService("VRService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local v22 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v23 = if FFlagEnableNewBackpack then nil else require(RobloxGui.Modules.BackpackScript)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local MenuIcon = require(RobloxGui.Modules.TopBar.ComponentsV2.MenuIcon)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local SelfieView = require(RobloxGui.Modules.SelfieView)
local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)
local GetFIntRobloxConnectFtuxShowDelayMs = require(Chrome.Flags.GetFIntRobloxConnectFtuxShowDelayMs)
local GetFIntRobloxConnectFtuxDismissDelayMs = require(Chrome.Flags.GetFIntRobloxConnectFtuxDismissDelayMs)
local GetFFlagEnableAppChatInExperience = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAppChatInExperience
local GetShouldShowPlatformChatBasedOnPolicy = require(Chrome.Flags.GetShouldShowPlatformChatBasedOnPolicy)
local v41 = game:DefineFastFlag("FixIntegrationActivated1", false)
local v42 = game:DefineFastFlag("FixInventoryFilledIcon", false)
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local v46 = game:DefineFastFlag("AppChatEnabledChromeDropdownFtuxTooltip", false)
local v47 = game:DefineFastFlag("AvatarSwitcherFtuxTooltip", false)
local v48 = game:DefineFastFlag("InExperienceShopFtuxTooltip", false) and SharedFlags.FFlagEnableInExperienceShop
local InExperienceShopFtuxTooltip = nil

if v48 then
	InExperienceShopFtuxTooltip = require(Chrome.Integrations.InExperienceShop.InExperienceShopFtuxTooltip)
end

local v50 = game:DefineFastInt("UnibarConnectTooltipPriority", 2000)
local v51 = GetFFlagEnableAppChatInExperience() and (v46 and GetShouldShowPlatformChatBasedOnPolicy())
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local SELFIE_VIEW_ID = Constants.SELFIE_VIEW_ID
local v55 = MappedSignal.new(PlayerListManager:GetSetVisibleChangedEvent().Event, function() -- line: 86
	-- upvalues: PlayerListManager (copy)
	return PlayerListManager:GetSetVisible()
end)
local v56 = Service:register({
	id = "leaderboard",
	label = "CoreScripts.TopBar.Leaderboard",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 94
		-- upvalues: isInExperienceUIVREnabled (copy), VRService (copy), RobloxGui (copy), PlayerListManager (copy), isSpatial (copy), InExperienceUIVRIXP (copy), ChromeIntegrationUtils (copy)
		if not isInExperienceUIVREnabled and VRService.VREnabled then
			require(RobloxGui.Modules.InGameMenu).openPlayersPage()

			return
		end

		if PlayerListManager:GetSetVisible() then
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())

			return
		end

		if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())

			return
		end

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 105
			-- upvalues: PlayerListManager (copy)
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 114
		-- upvalues: v55 (copy)
		return v55:get()
	end or v55,
	components = {
		Icon = function(_) -- line: 118
			-- upvalues: CommonIcon (copy), v55 (copy)
			return CommonIcon("icons/controls/leaderboardOff", "icons/controls/leaderboardOn", v55)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v56, Enum.CoreGuiType.PlayerList)

local v57 = MappedSignal.new(EmotesMenuMaster.EmotesMenuToggled.Event, function() -- line: 125
	-- upvalues: EmotesMenuMaster (copy)
	return EmotesMenuMaster:isOpen()
end)
local v58 = Service:register({
	id = "emotes",
	label = "CoreScripts.TopBar.Emotes",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 132
		-- upvalues: EmotesMenuMaster (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), ChromeIntegrationUtils (copy)
		if EmotesMenuMaster:isOpen() then
			EmotesMenuMaster:close()

			return
		end

		if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			EmotesMenuMaster:open()

			return
		end

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 139
			-- upvalues: EmotesMenuMaster (copy)
			EmotesMenuMaster:open()
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 147
		-- upvalues: v57 (copy)
		return v57:get()
	end or v57,
	components = {
		Icon = function(_) -- line: 151
			-- upvalues: CommonIcon (copy), v57 (copy)
			return CommonIcon("icons/controls/emoteOff", "icons/controls/emoteOn", v57)
		end
	}
})
local u59 = false
local MenuIsVisible = EmotesMenuMaster.MenuIsVisible

function updateEmoteAvailability() -- line: 160
	-- upvalues: u59 (ref), MenuIsVisible (ref), v58 (copy)
	if u59 and MenuIsVisible then
		v58.availability:available()

		return
	end

	v58.availability:unavailable()
end

ChromeUtils.setCoreGuiAvailability(v58, Enum.CoreGuiType.EmotesMenu, function(p5) -- line: 168
	-- upvalues: u59 (ref)
	u59 = p5
	updateEmoteAvailability()
end)
EmotesMenuMaster.MenuVisibilityChanged.Event:Connect(function() -- line: 173
	-- upvalues: MenuIsVisible (ref), EmotesMenuMaster (copy)
	MenuIsVisible = EmotesMenuMaster.MenuIsVisible
	updateEmoteAvailability()
end)

local v61 = if FFlagEnableNewBackpack then nil else MappedSignal.new(v23.StateChanged.Event, function() -- line: 179
	-- upvalues: v23 (copy)
	return v23.IsOpen
end)
local v62 = nil

if FFlagChromeActivatedMappedSignal then
	if FFlagEnableNewBackpack then
		local v63 = Signal.new()

		v22.onVisibilityChanged(v22.FeatureName.Backpack, function() -- line: 188
			-- upvalues: v63 (copy)
			v63:fire()

			return nil
		end)
		v62 = MappedSignal.new(v63, function() -- line: 192
			-- upvalues: v22 (copy)
			return v22.getVisibility(v22.FeatureName.Backpack)
		end)
	else
		v62 = v61
	end
end

local v64 = Service:register({
	id = "backpack",
	label = "CoreScripts.TopBar.Inventory",
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 203
		-- upvalues: FFlagEnableNewBackpack (copy), v22 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), ChromeIntegrationUtils (copy), v23 (copy)
		if FFlagEnableNewBackpack then
			if v22.getVisibility(v22.FeatureName.Backpack) then
				v22.toggleVisibility(v22.FeatureName.Backpack)

				return
			end

			if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
				v22.toggleVisibility(v22.FeatureName.Backpack)

				return
			end

			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 211
				-- upvalues: v22 (copy)
				v22.toggleVisibility(v22.FeatureName.Backpack)
			end)

			return
		end

		if v23.IsOpen then
			v23:OpenClose()

			return
		end

		if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			v23:OpenClose()

			return
		end

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 223
			-- upvalues: v23 (copy)
			v23:OpenClose()
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 232
		-- upvalues: FFlagEnableNewBackpack (copy), v22 (copy), v61 (copy)
		if FFlagEnableNewBackpack then
			return v22.getVisibility(v22.FeatureName.Backpack)
		end

		return v61:get()
	end or v62,
	components = {
		Icon = function(_) -- line: 239
			-- upvalues: CommonIcon (copy), v42 (copy), v61 (copy)
			return CommonIcon("icons/menu/inventoryOff", not v42 and "icons/menu/inventory" or "icons/menu/inventoryOn", v61)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v64, Enum.CoreGuiType.Backpack)

local v65 = Service:register({
	id = "respawn",
	label = "CoreScripts.InGameMenu.QuickActions.Respawn",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 254
		-- upvalues: RespawnUtils (copy)
		RespawnUtils.respawnPage()
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 259
		-- upvalues: RespawnUtils (copy)
		return RespawnUtils.respawnPageOpenSignal:get()
	end or RespawnUtils.respawnPageOpenSignal,
	components = {
		Icon = function(_) -- line: 263
			-- upvalues: CommonIcon (copy)
			return CommonIcon("icons/actions/respawn")
		end
	}
})

function updateRespawn(p10) -- line: 269
	-- upvalues: v65 (copy)
	if p10 then
		v65.availability:available()

		return
	end

	v65.availability:unavailable()
end

task.defer(function() -- line: 277
	-- upvalues: RobloxGui (copy)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	SettingsHub.RespawnBehaviourChangedEvent.Event:connect(updateRespawn)
	updateRespawn(SettingsHub:GetRespawnBehaviour())
end)

local v66 = Service:currentSubMenu()
local v67 = MappedSignal.new(v66:signal(), function() -- line: 284
	-- upvalues: v66 (copy)
	return v66:get() == "nine_dot"
end)

if Service:orderAlignment():get() == Enum.HorizontalAlignment.Right then
	v67:connect(function(p11) -- line: 289
		-- upvalues: PlayerListManager (copy)
		PlayerListManager:SetMinimized(p11)
	end)
end

function HamburgerButton(p12) -- line: 294
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), v67 (copy), useMappedSignal (copy), v51 (copy), CommonFtuxTooltip (copy), v50 (copy), GetFFlagIsSquadEnabled (copy), GetFStringConnectTooltipLocalStorageKey (copy), GetFIntRobloxConnectFtuxShowDelayMs (copy), GetFIntRobloxConnectFtuxDismissDelayMs (copy), useAppPolicy (copy), React (copy), FFlagEnableSideSheet (copy), SelectionCursorProvider (copy), MenuIcon (copy), ImageSetLabel (copy), Images (copy), SelfieView (copy), Service (copy), SELFIE_VIEW_ID (copy), v47 (copy), AvatarSwitcherFtuxTooltip (copy), v48 (copy), InExperienceShopFtuxTooltip (ref)
	local toggleTransition = p12.toggleTransition
	local v82 = useStyle()
	local ICON_SIZE, MEDIUM_ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v83 = UnibarStyle.use()

		ICON_SIZE = v83.ICON_SIZE
		MEDIUM_ICON_SIZE = v83.MEDIUM_ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
		MEDIUM_ICON_SIZE = Constants.MEDIUM_ICON_SIZE
	end

	local v86 = not not v67 and (useMappedSignal(v67) or false)
	local v87 = if not v51 then nil else CommonFtuxTooltip({
		id = "CONNECT_TOOLTIP",
		priority = v50,
		isIconVisible = p12.visible,
		headerKey = not GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Heading.CheckOutRobloxConnect" or "CoreScripts.FTUX.Heading.CheckOutRobloxParty",
		bodyKey = not GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Label.ChatWithYourFriendsAnytime" or "CoreScripts.FTUX.Label.PartyWithYourFriendsAnytime",
		localStorageKey = GetFStringConnectTooltipLocalStorageKey(),
		showDelay = GetFIntRobloxConnectFtuxShowDelayMs(),
		dismissDelay = GetFIntRobloxConnectFtuxDismissDelayMs()
	})
	local v88 = useAppPolicy(function(p13) -- line: 331
		return p13.getShowBadgeOver12()
	end)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
		BackgroundColor3 = v82.Theme.BackgroundOnHover.Color,
		BackgroundTransparency = toggleTransition:map(function(p14) -- line: 339
			-- upvalues: v82 (copy)
			return 1 - (1 - v82.Theme.BackgroundOnHover.Transparency) * p14
		end)
	}, {
		React.createElement("UICorner", {
			Name = "Corner",
			CornerRadius = UDim.new(1, 0)
		}),
		if not FFlagEnableSideSheet then nil else React.createElement(SelectionCursorProvider, {}, {
			Icon = React.createElement(MenuIcon, {
				showBadgeOver12 = v88
			})
		}),
		if FFlagEnableSideSheet then nil else React.createElement(ImageSetLabel, {
			Name = "Overflow",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = Images["icons/common/hamburgermenu"],
			Size = toggleTransition:map(function(p15) -- line: 361
				-- upvalues: ICON_SIZE (ref)
				local v93 = 1 - p15

				return UDim2.new(0, ICON_SIZE * v93, 0, ICON_SIZE * v93)
			end),
			ImageColor3 = v82.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p16) -- line: 367
				-- upvalues: v82 (copy)
				return p16 * v82.Theme.IconEmphasis.Transparency
			end)
		}),
		if FFlagEnableSideSheet then nil else React.createElement(ImageSetLabel, {
			Name = "Close",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = Images["icons/navigation/close"],
			Size = toggleTransition:map(function(p17) -- line: 379
				-- upvalues: MEDIUM_ICON_SIZE (ref)
				return UDim2.new(0, MEDIUM_ICON_SIZE * p17, 0, MEDIUM_ICON_SIZE * p17)
			end),
			ImageColor3 = v82.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p18) -- line: 384
				-- upvalues: v82 (copy)
				return (1 - p18) * v82.Theme.IconEmphasis.Transparency
			end)
		}),
		if not SelfieView.useCameraOn() or (Service:isWindowOpen(SELFIE_VIEW_ID) or v86) then nil else React.createElement(SelfieView.CameraStatusDot, {
			Name = "CameraStatusDot",
			ZIndex = 2,
			Position = UDim2.new(1, -4, 1, -7)
		}),
		v87,
		if not v47 then nil else React.createElement(AvatarSwitcherFtuxTooltip, {
			visible = p12.visible
		}),
		if not v48 then nil else React.createElement(InExperienceShopFtuxTooltip, {
			visible = p12.visible
		})
	})
end

return Service:register({
	id = "nine_dot",
	initialAvailability = Service.AvailabilitySignal.Pinned,
	label = not FFlagEnableSideSheet and "CoreScripts.TopBar.MoreMenu" or "CoreScripts.TopBar.RobloxMenu",
	sideSheetPlacement = SideSheetPlacement.None,
	hotkeyCodes = if not FFlagEnableSideSheet then nil else { Enum.KeyCode.Escape },
	isActivated = if not FFlagChromeActivatedMappedSignal then if not v41 then nil else function() -- line: 421
		-- upvalues: v67 (copy)
		return v67:get()
	end else v67,
	components = {
		Icon = function(p19) -- line: 426
			-- upvalues: React (copy)
			return React.createElement(HamburgerButton, p19)
		end
	}
})
