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
local FFlagAddTopBarPoliciesToUniversalPolicies = SharedFlags.FFlagAddTopBarPoliciesToUniversalPolicies
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local v47 = game:DefineFastFlag("AppChatEnabledChromeDropdownFtuxTooltip", false)
local v48 = game:DefineFastFlag("AvatarSwitcherFtuxTooltip", false)
local v49 = game:DefineFastFlag("InExperienceShopFtuxTooltip", false) and SharedFlags.FFlagEnableInExperienceShop
local InExperienceShopFtuxTooltip = nil

if v49 then
	InExperienceShopFtuxTooltip = require(Chrome.Integrations.InExperienceShop.InExperienceShopFtuxTooltip)
end

local v51 = game:DefineFastInt("UnibarConnectTooltipPriority", 2000)
local v52 = GetFFlagEnableAppChatInExperience() and (v47 and GetShouldShowPlatformChatBasedOnPolicy())
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local SELFIE_VIEW_ID = Constants.SELFIE_VIEW_ID
local v56 = MappedSignal.new(PlayerListManager:GetSetVisibleChangedEvent().Event, function() -- line: 87
	-- upvalues: PlayerListManager (copy)
	return PlayerListManager:GetSetVisible()
end)
local v57 = Service:register({
	id = "leaderboard",
	label = "CoreScripts.TopBar.Leaderboard",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 95
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

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 106
			-- upvalues: PlayerListManager (copy)
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 115
		-- upvalues: v56 (copy)
		return v56:get()
	end or v56,
	components = {
		Icon = function(_) -- line: 119
			-- upvalues: CommonIcon (copy), v56 (copy)
			return CommonIcon("icons/controls/leaderboardOff", "icons/controls/leaderboardOn", v56)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v57, Enum.CoreGuiType.PlayerList)

local v58 = MappedSignal.new(EmotesMenuMaster.EmotesMenuToggled.Event, function() -- line: 126
	-- upvalues: EmotesMenuMaster (copy)
	return EmotesMenuMaster:isOpen()
end)
local v59 = Service:register({
	id = "emotes",
	label = "CoreScripts.TopBar.Emotes",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 133
		-- upvalues: EmotesMenuMaster (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), ChromeIntegrationUtils (copy)
		if EmotesMenuMaster:isOpen() then
			EmotesMenuMaster:close()

			return
		end

		if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			EmotesMenuMaster:open()

			return
		end

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 140
			-- upvalues: EmotesMenuMaster (copy)
			EmotesMenuMaster:open()
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 148
		-- upvalues: v58 (copy)
		return v58:get()
	end or v58,
	components = {
		Icon = function(_) -- line: 152
			-- upvalues: CommonIcon (copy), v58 (copy)
			return CommonIcon("icons/controls/emoteOff", "icons/controls/emoteOn", v58)
		end
	}
})
local u60 = false
local MenuIsVisible = EmotesMenuMaster.MenuIsVisible

function updateEmoteAvailability() -- line: 161
	-- upvalues: u60 (ref), MenuIsVisible (ref), v59 (copy)
	if u60 and MenuIsVisible then
		v59.availability:available()

		return
	end

	v59.availability:unavailable()
end

ChromeUtils.setCoreGuiAvailability(v59, Enum.CoreGuiType.EmotesMenu, function(p5) -- line: 169
	-- upvalues: u60 (ref)
	u60 = p5
	updateEmoteAvailability()
end)
EmotesMenuMaster.MenuVisibilityChanged.Event:Connect(function() -- line: 174
	-- upvalues: MenuIsVisible (ref), EmotesMenuMaster (copy)
	MenuIsVisible = EmotesMenuMaster.MenuIsVisible
	updateEmoteAvailability()
end)

local v62 = if FFlagEnableNewBackpack then nil else MappedSignal.new(v23.StateChanged.Event, function() -- line: 180
	-- upvalues: v23 (copy)
	return v23.IsOpen
end)
local v63 = nil

if FFlagChromeActivatedMappedSignal then
	if FFlagEnableNewBackpack then
		local v64 = Signal.new()

		v22.onVisibilityChanged(v22.FeatureName.Backpack, function() -- line: 189
			-- upvalues: v64 (copy)
			v64:fire()

			return nil
		end)
		v63 = MappedSignal.new(v64, function() -- line: 193
			-- upvalues: v22 (copy)
			return v22.getVisibility(v22.FeatureName.Backpack)
		end)
	else
		v63 = v62
	end
end

local v65 = Service:register({
	id = "backpack",
	label = "CoreScripts.TopBar.Inventory",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 204
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

			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 212
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

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 224
			-- upvalues: v23 (copy)
			v23:OpenClose()
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 233
		-- upvalues: FFlagEnableNewBackpack (copy), v22 (copy), v62 (copy)
		if FFlagEnableNewBackpack then
			return v22.getVisibility(v22.FeatureName.Backpack)
		end

		return v62:get()
	end or v63,
	components = {
		Icon = function(_) -- line: 240
			-- upvalues: CommonIcon (copy), v42 (copy), v62 (copy)
			return CommonIcon("icons/menu/inventoryOff", not v42 and "icons/menu/inventory" or "icons/menu/inventoryOn", v62)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v65, Enum.CoreGuiType.Backpack)

local v66 = Service:register({
	id = "respawn",
	label = "CoreScripts.InGameMenu.QuickActions.Respawn",
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 255
		-- upvalues: RespawnUtils (copy)
		RespawnUtils.respawnPage()
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 260
		-- upvalues: RespawnUtils (copy)
		return RespawnUtils.respawnPageOpenSignal:get()
	end or RespawnUtils.respawnPageOpenSignal,
	components = {
		Icon = function(_) -- line: 264
			-- upvalues: CommonIcon (copy)
			return CommonIcon("icons/actions/respawn")
		end
	}
})

function updateRespawn(p10) -- line: 270
	-- upvalues: v66 (copy)
	if p10 then
		v66.availability:available()

		return
	end

	v66.availability:unavailable()
end

task.defer(function() -- line: 278
	-- upvalues: RobloxGui (copy)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	SettingsHub.RespawnBehaviourChangedEvent.Event:connect(updateRespawn)
	updateRespawn(SettingsHub:GetRespawnBehaviour())
end)

local v67 = Service:currentSubMenu()
local v68 = MappedSignal.new(v67:signal(), function() -- line: 285
	-- upvalues: v67 (copy)
	return v67:get() == "nine_dot"
end)

if Service:orderAlignment():get() == Enum.HorizontalAlignment.Right then
	v68:connect(function(p11) -- line: 290
		-- upvalues: PlayerListManager (copy)
		PlayerListManager:SetMinimized(p11)
	end)
end

function HamburgerButton(p12) -- line: 295
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), v68 (copy), useMappedSignal (copy), v52 (copy), CommonFtuxTooltip (copy), v51 (copy), GetFFlagIsSquadEnabled (copy), GetFStringConnectTooltipLocalStorageKey (copy), GetFIntRobloxConnectFtuxShowDelayMs (copy), GetFIntRobloxConnectFtuxDismissDelayMs (copy), FFlagAddTopBarPoliciesToUniversalPolicies (copy), useAppPolicy (copy), React (copy), FFlagEnableSideSheet (copy), SelectionCursorProvider (copy), MenuIcon (copy), ImageSetLabel (copy), Images (copy), SelfieView (copy), Service (copy), SELFIE_VIEW_ID (copy), v48 (copy), AvatarSwitcherFtuxTooltip (copy), v49 (copy), InExperienceShopFtuxTooltip (ref)
	local toggleTransition = p12.toggleTransition
	local v83 = useStyle()
	local ICON_SIZE, MEDIUM_ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v84 = UnibarStyle.use()

		ICON_SIZE = v84.ICON_SIZE
		MEDIUM_ICON_SIZE = v84.MEDIUM_ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
		MEDIUM_ICON_SIZE = Constants.MEDIUM_ICON_SIZE
	end

	local v87 = not not v68 and (useMappedSignal(v68) or false)
	local v88 = if not v52 then nil else CommonFtuxTooltip({
		id = "CONNECT_TOOLTIP",
		priority = v51,
		isIconVisible = p12.visible,
		headerKey = not GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Heading.CheckOutRobloxConnect" or "CoreScripts.FTUX.Heading.CheckOutRobloxParty",
		bodyKey = not GetFFlagIsSquadEnabled() and "CoreScripts.FTUX.Label.ChatWithYourFriendsAnytime" or "CoreScripts.FTUX.Label.PartyWithYourFriendsAnytime",
		localStorageKey = GetFStringConnectTooltipLocalStorageKey(),
		showDelay = GetFIntRobloxConnectFtuxShowDelayMs(),
		dismissDelay = GetFIntRobloxConnectFtuxDismissDelayMs()
	})
	local v89 = if not FFlagAddTopBarPoliciesToUniversalPolicies then nil else useAppPolicy(function(p13) -- line: 333
		return p13.getShowBadgeOver12()
	end)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
		BackgroundColor3 = v83.Theme.BackgroundOnHover.Color,
		BackgroundTransparency = toggleTransition:map(function(p14) -- line: 342
			-- upvalues: v83 (copy)
			return 1 - (1 - v83.Theme.BackgroundOnHover.Transparency) * p14
		end)
	}, {
		React.createElement("UICorner", {
			Name = "Corner",
			CornerRadius = UDim.new(1, 0)
		}),
		if not FFlagEnableSideSheet then nil else React.createElement(SelectionCursorProvider, {}, {
			Icon = React.createElement(MenuIcon, {
				showBadgeOver12 = v89
			})
		}),
		if FFlagEnableSideSheet then nil else React.createElement(ImageSetLabel, {
			Name = "Overflow",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = Images["icons/common/hamburgermenu"],
			Size = toggleTransition:map(function(p15) -- line: 364
				-- upvalues: ICON_SIZE (ref)
				local v94 = 1 - p15

				return UDim2.new(0, ICON_SIZE * v94, 0, ICON_SIZE * v94)
			end),
			ImageColor3 = v83.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p16) -- line: 370
				-- upvalues: v83 (copy)
				return p16 * v83.Theme.IconEmphasis.Transparency
			end)
		}),
		if FFlagEnableSideSheet then nil else React.createElement(ImageSetLabel, {
			Name = "Close",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = Images["icons/navigation/close"],
			Size = toggleTransition:map(function(p17) -- line: 382
				-- upvalues: MEDIUM_ICON_SIZE (ref)
				return UDim2.new(0, MEDIUM_ICON_SIZE * p17, 0, MEDIUM_ICON_SIZE * p17)
			end),
			ImageColor3 = v83.Theme.IconEmphasis.Color,
			ImageTransparency = toggleTransition:map(function(p18) -- line: 387
				-- upvalues: v83 (copy)
				return (1 - p18) * v83.Theme.IconEmphasis.Transparency
			end)
		}),
		if not SelfieView.useCameraOn() or (Service:isWindowOpen(SELFIE_VIEW_ID) or v87) then nil else React.createElement(SelfieView.CameraStatusDot, {
			Name = "CameraStatusDot",
			ZIndex = 2,
			Position = UDim2.new(1, -4, 1, -7)
		}),
		v88,
		if not v48 then nil else React.createElement(AvatarSwitcherFtuxTooltip, {
			visible = p12.visible
		}),
		if not v49 then nil else React.createElement(InExperienceShopFtuxTooltip, {
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
	isActivated = if not FFlagChromeActivatedMappedSignal then if not v41 then nil else function() -- line: 424
		-- upvalues: v68 (copy)
		return v68:get()
	end else v68,
	components = {
		Icon = function(p19) -- line: 429
			-- upvalues: React (copy)
			return React.createElement(HamburgerButton, p19)
		end
	}
})
