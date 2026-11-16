local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
game:GetService("TelemetryService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")

local Cryo = require(CorePackages.Packages.Cryo)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local BaseMenu = UIBlox.App.Menu.BaseMenu
local SystemBar = UIBlox.App.Navigation.SystemBar
local Placement = UIBlox.App.Navigation.Enum.Placement
local Panel3D = UIBlox.Core.VR.Panel3D
local Constants = UIBlox.Core.VR.Constants
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
local VRUtil = VrCommon2.VRUtil
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local v, panelType, registerRoactPanel, v2

if SharedFlags.FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	v = VrSpatialUi.Constants
	panelType = v.PanelType
	registerRoactPanel = VrSpatialUi.registerRoactPanel
	v2 = VrSpatialUi.UIManager
else
	local uiManager = RobloxGui:WaitForChild("Modules"):WaitForChild("UIManager")
	local Constants3 = require(uiManager.Constants)
	panelType = Constants3.PanelType
	registerRoactPanel = require(uiManager.registerRoactPanel)
	v2 = require(uiManager.UIManager)
	v = require(uiManager.Constants)
end

local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
local gameSettings = UserSettings().GameSettings
local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local extended = Roact.PureComponent:extend("TopBarApp")
local VRBarSeparator = require(script.Parent.VRBarSeparator)
local VRBarVoiceIcon = require(script.Parent.VRBarVoiceIcon)
local VRBottomBarAnalytics = require(script.Parent.VRBottomBarAnalytics)
local VRBottomBarType = require(script.Parent.VRBottomBarType)

local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags2.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local v3

if FFlagEnableNewBackpack then
	v3 = require(CorePackages.Workspace.Packages.Backpack)
else
	v3 = require(RobloxGui.Modules.BackpackScript)
end

local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local StarterPlayer = game:GetService("StarterPlayer")

local engineFeature = game:GetEngineFeature("EnableVRBottomBarWorksBehindObjects")

local FFlagVRBottomBarDebugPositionConfig = require(RobloxGui.Modules.Flags.FFlagVRBottomBarDebugPositionConfig)

local FIntVRBottomBarPositionOffsetVerticalNumber = require(RobloxGui.Modules.Flags.FIntVRBottomBarPositionOffsetVerticalNumber)

local FIntVRBottomBarPositionOffsetDepthNumber = require(RobloxGui.Modules.Flags.FIntVRBottomBarPositionOffsetDepthNumber)
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)

local SplashScreenManager = require(CorePackages.Workspace.Packages.SplashScreenManager)
local splashScreenManager = SplashScreenManager.SplashScreenManager

local GetFIntVRScaleGuiDistance = require(RobloxGui.Modules.Flags.GetFIntVRScaleGuiDistance)
local v4 = (GetFIntVRScaleGuiDistance or 100)() * 0.01

local defineFastFlag = game:DefineFastFlag("FixVRBottomBarAnalytics", false)

local function safeRequire(p)
	local success, result = pcall(require, p)

	if success then
		return result
	end

	warn("Failure to Start CoreScript module " .. p.Name .. ".\n" .. result)
end

local v5 = {
	Y = FIntVRBottomBarPositionOffsetVerticalNumber / 100,
	Z = FIntVRBottomBarPositionOffsetDepthNumber / 100
}

local _ = 0.2 + v5.Z / 10

local v6 = {
	Default = { dampingRatio = 1, frequency = 4.5 },
	Slower = { dampingRatio = 1, frequency = 0.66 }
}

local v7 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_menu.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_menu.png",
	onActivated = function()
		VRHub:SetShowTopBar(true)

		if InGameMenuInit.getOpen() then
			InGameMenuInit.closeInGameMenu()
		else
			InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
			VRHub:SetShowMoreMenu(false)
		end

		if defineFastFlag then
			local open = InGameMenuInit.getOpen()
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.MainMenu,
				isToggleOn = open,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-MainMenu")
	end
}

local v8 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_maximize.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_minimize.png",
	onActivated = function()
		if VRHub.ShowTopBar then
			VRHub:SetShowTopBar(false)
			InGameMenuInit.closeInGameMenu()
		else
			VRHub:SetShowTopBar(false)
			VRHub:SetShowTopBar(true)
		end

		if defineFastFlag then
			local showTopBar = VRHub.ShowTopBar
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.ToggleGui,
				isToggleOn = showTopBar,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-ToggleGui")
	end
}

local v9 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	onActivated = function()
		if FFlagEnableNewBackpack then
			if VRHub.ShowTopBar then
				features.toggleVisibility(features.FeatureName.Backpack)
			else
				VRHub:SetShowTopBar(true)
				features.setVisibility(features.FeatureName.Backpack, true)
			end

			if defineFastFlag then
				VRBottomBarAnalytics.sendEventToTelemetryV2({
					integrationId = VRBottomBarType.ButtomName.Inventory,
					isToggleOn = features.getVisibility(features.FeatureName.Backpack),
					source = VRBottomBarType.Source.MoreSubMenu
				})
			end
		else
			if VRHub.ShowTopBar then
				v3.OpenClose()
			else
				VRHub:SetShowTopBar(true)

				if not v3.IsOpen then
					v3.OpenClose()
				end
			end

			if defineFastFlag then
				local isOpen = v3.IsOpen
				VRBottomBarAnalytics.sendEventToTelemetryV2({
					integrationId = VRBottomBarType.ButtomName.Inventory,
					isToggleOn = isOpen,
					source = VRBottomBarType.Source.MoreSubMenu
				})
			end
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Backpack")
	end
}

local v10 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	onActivated = function()
		if VRHub.ShowTopBar then
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
		else
			VRHub:SetShowTopBar(true)

			if not PlayerListManager:GetSetVisible() then
				PlayerListManager:SetVisibility(true)
			end
		end

		if defineFastFlag then
			local setVisible = PlayerListManager:GetSetVisible()
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Leaderboard,
				isToggleOn = setVisible,
				source = VRBottomBarType.Source.MoreSubMenu
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-PlayerList")
	end
}

local v11 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	onActivated = function()
		if VRHub.ShowTopBar then
			if EmotesMenuMaster:isOpen() then
				EmotesMenuMaster:close()
			else
				EmotesMenuMaster:open()
			end
		else
			VRHub:SetShowTopBar(true)

			if not EmotesMenuMaster:isOpen() then
				EmotesMenuMaster:open()
			end
		end

		if defineFastFlag then
			local open = EmotesMenuMaster:isOpen()
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Emotes,
				isToggleOn = open,
				source = VRBottomBarType.Source.MoreSubMenu
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Emotes")
	end
}

local v12 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_chat.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_chat.png",
	onActivated = function()
		if VRHub.ShowTopBar then
			ChatSelector:ToggleVisibility()
			gameSettings.ChatVisible = ChatSelector:GetVisibility()
		else
			VRHub:SetShowTopBar(true)

			if not ChatSelector:GetVisibility() then
				ChatSelector:ToggleVisibility()
				gameSettings.ChatVisible = ChatSelector:GetVisibility()
			end
		end

		if defineFastFlag then
			local chatVisible = gameSettings.ChatVisible
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Chat,
				isToggleOn = chatVisible,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Chat")
	end
}

local v13 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_safety_on.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_safety_on.png",
	onActivated = function()
		VRHub:ToggleSafetyBubble()

		if defineFastFlag then
			local enabled = VRHub.SafetyBubble.enabled
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Safety,
				isToggleOn = enabled,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Safety")
	end
}

local v14 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_safety_off.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_safety_off.png",
	onActivated = function()
		VRHub:ToggleSafetyBubble()

		if defineFastFlag then
			local enabled = VRHub.SafetyBubble.enabled
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Safety,
				isToggleOn = enabled,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Safety")
	end
}

local v15 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leave.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leave.png",
	onActivated = function()
		VRHub:SetShowTopBar(true)
		VRHub:SetShowMoreMenu(false)

		if InGameMenuInit then
			if not InGameMenuInit.getOpen() then
				InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
			end

			InGameMenuInit.openGameLeavePage()
		end

		if defineFastFlag then
			local open = InGameMenuInit.getOpen()
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Leave,
				isToggleOn = open,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-LeaveGame")
	end
}

local v16 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leave_highlighted.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leave_highlighted.png",
	onActivated = v15.onActivated
}

local v17 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_more.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_more.png",
	onActivated = function()
		VRHub:SetShowTopBar(true)
		VRHub:SetShowMoreMenu(not VRHub.ShowMoreMenu)

		if defineFastFlag then
			local showMoreMenu = VRHub.ShowMoreMenu
			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.MoreSubMenu,
				isToggleOn = showMoreMenu,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-More")
	end
}

local v18 = { iconComponent = VRBarSeparator, itemSize = UDim2.new(0, 28, 0, 44) }

local v19 = {
	icon = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Emotes"),
	onActivated = function()
		v11.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-Emotes")
	end
}

local v20 = {
	icon = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Leaderboard"),
	onActivated = function()
		v10.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-PlayerList")
	end
}

local v21 = {
	icon = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Inventory"),
	onActivated = function()
		v9.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-Backpack")
	end
}

local v22 = {
	iconOn = Images["icons/controls/publicAudioJoin"],
	iconOff = Images["icons/controls/publicAudioJoin"],
	text = "Join Voice",
	onActivated = function()
		default.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		default:JoinVoice()
		local shouldShowJoinVoice = default:ShouldShowJoinVoice()
		VRBottomBarAnalytics.sendEventToTelemetryV2({
			integrationId = VRBottomBarType.ButtomName.JoinVoice,
			isToggleOn = shouldShowJoinVoice,
			source = VRBottomBarType.Source.VRBottomBar
		})
	end
}

local function roundOffset(p) -- 2 equivalent calls inferred from this helper
	return p >= 0 and math.floor(p * 10 + 0.5) / 10 or math.ceil(p * 10 - 0.5) / 10
end

function extended:init()
	local v23 = {
		yOffset = v5.Y * v4,
		zOffset = v5.Z * v4,
		moreMenuOpen = false,
		vrMenuOpen = true,
		lookAway = false,
		userGui = 0,
		hidden = 0
	}
	local result

	if VRService.VREnabled then
		local userGui = RobloxGui.Modules.VR.UserGui
		local success
		success, result = pcall(require, userGui)

		if not success then
			warn("Failure to Start CoreScript module " .. userGui.Name .. ".\n" .. result)
			result = nil
		end

		if not result then
			result = Roact.None
		end
	else
		result = Roact.None
	end

	v23.userGui = result
	v23.hidden = not splashScreenManager.isFPSAtTarget()
	self:setState(v23)

	self.backpackHasItems = false
	self.emotesLoaded = false

	function self.onTargetFPSSTateChange(p)
		self:setState({
			hidden = not p
		})
	end
	splashScreenManager.addStatusChangeListener(self.onTargetFPSSTateChange)

	function self.getVoiceIcon()
		return {
			iconImageComponent = function(p)
				return React.createElement(
					VRBarVoiceIcon,
					Cryo.Dictionary.join(p, {
						userId = tostring(Players.LocalPlayer.UserId),
						iconStyle = "MicLight"
					})
				)
			end,
			onActivated = function()
				if self.props.voiceState == Enum.VoiceChatState.Failed then
					self.props.voiceChatServiceManager:RejoinPreviousChannel()
				else
					self.props.voiceChatServiceManager:ToggleMic("VRBottomBar")
				end

				if defineFastFlag then
					local isToggleOn = self.props.voiceState == Enum.VoiceChatState.Joined

					VRBottomBarAnalytics.sendEventToTelemetryV2({
						integrationId = VRBottomBarType.ButtomName.Voice,
						isToggleOn = isToggleOn,
						source = VRBottomBarType.Source.VRBottomBar
					})
				end

				RbxAnalyticsService:ReportCounter("VR-BottomBar-Voice")
			end
		}
	end

	function self.getDebugYOffsetUp()
		return {
			iconOn = "rbxasset://textures/ui/MenuBar/arrow_up.png",
			iconOff = "rbxasset://textures/ui/MenuBar/arrow_up.png",
			onActivated = function()
				self:setState({
					yOffset = self.state.yOffset + 0.1
				})
			end
		}
	end

	function self.getDebugYOffsetDown()
		return {
			iconOn = "rbxasset://textures/ui/MenuBar/arrow_down.png",
			iconOff = "rbxasset://textures/ui/MenuBar/arrow_down.png",
			onActivated = function()
				self:setState({
					yOffset = self.state.yOffset - 0.1
				})
			end
		}
	end

	function self.getDebugZOffsetUp()
		return {
			iconOn = "rbxasset://textures/ui/MenuBar/arrow_left.png",
			iconOff = "rbxasset://textures/ui/MenuBar/arrow_left.png",
			onActivated = function()
				self:setState({
					zOffset = self.state.zOffset + 0.1
				})
			end
		}
	end

	function self.getDebugZOffsetDown()
		return {
			iconOn = "rbxasset://textures/ui/MenuBar/arrow_right.png",
			iconOff = "rbxasset://textures/ui/MenuBar/arrow_right.png",
			onActivated = function()
				self:setState({
					zOffset = self.state.zOffset - 0.1
				})
			end
		}
	end

	function self.getDebugTextLabel()
		return {
			iconComponent = function(props)
				local text = "Y " .. roundOffset(self.state.yOffset) .. ", Z " .. roundOffset(self.state.zOffset) -- inferred equivalent call
				return Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
					TextScaled = true,
					Size = UDim2.fromScale(1, 1),
					[Roact.Children] = props[Roact.Children]
				})
			end,
			itemSize = UDim2.new(0, 44, 0, 44)
		}
	end

	self:setState({
		itemList = { v7, v18, v8, v18, v15 },
		moreItemList = {}
	})

	function self.onShowTopBarChanged()
		if IsSpatialRobloxGuiEnabled then
			return
		end

		if not VRHub.ShowTopBar then
			VRHub:SetShowMoreMenu(false)
		end

		self:setState({ vrMenuOpen = VRHub.ShowTopBar })
	end

	function self.onShowMoreMenuChanged()
		self:setState({ moreMenuOpen = VRHub.ShowMoreMenu })
	end

	function self.updateItemListState()
		local itemList, moreItemList = self:updateItems()
		self:setState({ itemList = itemList, moreItemList = moreItemList })
	end

	function self.onBackpackItemAdded()
		if not self.backpackHasItems then
			self.backpackHasItems = true
			self.updateItemListState()
		end
	end

	function self.onBackpackEmpty()
		if self.backpackHasItems then
			self.backpackHasItems = false
			self.updateItemListState()
		end
	end

	function self.onEmotesLoaded(emotesLoaded)
		if emotesLoaded ~= self.emotesLoaded then
			self.emotesLoaded = emotesLoaded
			self.updateItemListState()
		end
	end

	function self.onVREnabledChanged()
		local result2

		if VRService.VREnabled then
			local userGui = RobloxGui.Modules.VR.UserGui
			local success
			success, result2 = pcall(require, userGui)

			if not success then
				warn("Failure to Start CoreScript module " .. userGui.Name .. ".\n" .. result2)
				result2 = nil
			end

			if not result2 then
				result2 = Roact.None
			end
		else
			result2 = Roact.None
		end

		self:setState({ userGui = result2 })
	end

	function self.onRenderStepped()
		local lookAway = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head).LookVector.Y > -0.2

		if self.state.lookAway ~= lookAway then
			self:setState({ lookAway = lookAway })
		end
	end

	local binding, setFadeTransparency = Roact.createBinding(0)
	self.fadeTransparency = binding
	self.setFadeTransparency = setFadeTransparency
	self.fadeTransparencyMotor = Otter.createSingleMotor(self.fadeTransparency:getValue())
	self.fadeTransparencyMotor:onStep(self.setFadeTransparency)
	self.fadeTransparencyMotor:setGoal(Otter.spring(0, v6.Default))

	function self.getAlignedPanelPart()
		local v24

		if self.state.userGui then
			v24 = self.state.userGui:getPanel()
		end

		local part = v24 and v24:GetPart()

		if
			part
			and (v24:IsPositionLockedType() or v24:IsUIManagerManagedType())
			and (v24:IsVisible() or v24.alwaysUpdatePosition)
		then
			return part
		end
	end

	function self.bottomBarPanelOffsetCallback(p)
		local finalPosition = p.finalPosition
		local cameraHeadScale = p.cameraHeadScale
		local alignedPanelPart = self.getAlignedPanelPart()

		if not alignedPanelPart then
			return finalPosition
		end

		local yOffset = self.state.yOffset
		local zOffset = self.state.zOffset

		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
		local cframe = CFrame.new(0, 0, zOffset * cameraHeadScale - alignedPanelPart.Size.Z * 0.5)
		local worldSpace = alignedPanelPart.CFrame:ToWorldSpace(cframe)

		return (Vector3.new(
			worldSpace.Position.X,
			userCFrameWorldSpace.Position.Y + yOffset * cameraHeadScale,
			worldSpace.Position.Z
		))
	end

	function self.moreMenuPanelOffsetCallback(p)
		local finalPosition = p.finalPosition
		local cameraHeadScale = p.cameraHeadScale
		local alignedPanelPart = self.getAlignedPanelPart()

		if not alignedPanelPart then
			return finalPosition
		end

		local bottomBarPanelOffsetCallback = self.bottomBarPanelOffsetCallback(p)
		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
		local cframe = CFrame.new(bottomBarPanelOffsetCallback, userCFrameWorldSpace.Position)

		local v24 = (0.2 + self.state.zOffset / 10) * v4

		local v25 = FFlagVRBottomBarDebugPositionConfig and (#self.state.itemList - 3) / 2 * v24
			or (#self.state.itemList - 2.5) / 2 * v24

		local worldSpace = cframe:ToWorldSpace((CFrame.new(-v25 * cameraHeadScale, v24 / 2 * cameraHeadScale, -0.025)))

		return (CFrame.new(worldSpace.Position) * alignedPanelPart.CFrame.Rotation):ToWorldSpace((CFrame.new(
			0,
			#self.state.moreItemList * v24 / 2 * cameraHeadScale,
			0.025
		))).Position
	end

	function self.moreMenuPanelTiltCallback(p)
		local panelCFrame = p.panelCFrame
		local alignedPanelPart = self.getAlignedPanelPart()

		if alignedPanelPart then
			return CFrame.new(panelCFrame.Position) * alignedPanelPart.CFrame.Rotation
		end

		return panelCFrame
	end
end

function extended:didMount()
	self.emotesLoaded = EmotesMenuMaster:isEmotesLoaded()
	self.backpackHasItems = v3.IsInventoryEmpty()
	self.updateItemListState()
end

function extended:updateItems()
	local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
	local v23 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
	local coreGuiEnabled2 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
	local coreGuiEnabled3 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	local v24

	if IsSpatialRobloxGuiEnabled then
		v24 = FFlagVRBottomBarDebugPositionConfig
			and {
				self.getDebugYOffsetUp(),
				self.getDebugYOffsetDown(),
				self.getDebugZOffsetUp(),
				self.getDebugZOffsetDown(),
				self.getDebugTextLabel(),
				v18,
				v7,
				v18
			}
			or { v7, v18 }
	else
		v24 = FFlagVRBottomBarDebugPositionConfig and {
			self.getDebugYOffsetUp(),
			self.getDebugYOffsetDown(),
			self.getDebugZOffsetUp(),
			self.getDebugZOffsetDown(),
			self.getDebugTextLabel(),
			v18,
			v7,
			v18,
			v8
		} or { v7, v18, v8 }
	end

	if v23 then
		v23 = not StarterPlayer.UserEmotesEnabled or self.emotesLoaded ~= false
	end

	local backpackHasItems = coreGuiEnabled and self.backpackHasItems

	if coreGuiEnabled2 then
		table.insert(v24, v12)
	end

	if default:ShouldShowJoinVoiceOnDisconnect() then
		table.insert(v24, v22)
	elseif default:ShouldShowJoinVoice() then
		table.insert(v24, v22)
	end

	if self.props.voiceEnabled then
		table.insert(v24, self.getVoiceIcon())
	end

	table.insert(v24, v18)

	if VRHub.SafetyBubble and VRHub.SafetyBubble.enabled then
		table.insert(v24, v13)
	else
		table.insert(v24, v14)
	end

	if VRHub.ShowHighlightedLeaveGameIcon then
		table.insert(v24, v16)
	else
		table.insert(v24, v15)
	end

	local v25 = {}

	if v23 then
		table.insert(v25, v19)
	end

	if coreGuiEnabled3 then
		table.insert(v25, v20)
	end

	if backpackHasItems then
		table.insert(v25, v21)
	end

	if #v25 > 0 then
		table.insert(v24, v17)
	end

	return v24, v25
end

function extended:renderWithStyle(p)
	local v23 = (0.2 + self.state.zOffset / 10) * v4

	local itemList = self.state.itemList
	local moreItemList = self.state.moreItemList
	local v24 = FFlagVRBottomBarDebugPositionConfig and 7 or 1
	local selection

	if self.state.vrMenuOpen then
		selection = self.state.moreMenuOpen and #moreItemList > 0 and #itemList or v24
	else
		selection = FFlagVRBottomBarDebugPositionConfig and 9 or 3
	end

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local partSize

	if IsSpatialRobloxGuiEnabled then
		partSize = Vector2.new(
			(#itemList - 1) * v.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale,
			v.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale
		)
	else
		partSize = Vector2.new((#itemList - 1) * v23, v23)
	end

	local v25 = {
		panelName = "BottomBar",
		partSize = partSize,
		virtualScreenSize = Vector2.new((#itemList - 1) * 50, 50),
		offset = self.state.vrMenuOpen and CFrame.new(0, 0, 0) or CFrame.new(0, -0.5, 0),
		offsetCallback = self.bottomBarPanelOffsetCallback,
		lerp = true,
		tilt = 0,
		anchoring = 0,
		faceCamera = true,
		curvature = 0,
		alwaysOnTop = 0,
		parent = 0,
		zOffset = 1,
		connectPanelManagerFunction = 0
	}
	local anchoring

	if IsSpatialRobloxGuiEnabled then
		anchoring = Constants.AnchoringTypes.PanelManaged
	else
		anchoring = Constants.AnchoringTypes.Head
	end

	v25.anchoring = anchoring

	v25.alwaysOnTop = engineFeature and true or nil
	v25.parent = engineFeature and GuiService.CoreGuiFolder or nil

	v25.connectPanelManagerFunction = IsSpatialRobloxGuiEnabled and function(p2)
		if p2 then
			registerRoactPanel(p2, panelType.BottomBar)
		else
			v2.getInstance():removeRoactPanel(panelType.BottomBar)
		end
	end or nil
	local children = {
		BottomBarPanel3D = createElement(Panel3D, v25, {
			CanvasGroup = Roact.createElement(
				"CanvasGroup",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					GroupTransparency = self.fadeTransparency,
					Size = UDim2.new(1, 0, 1, 0)
				},
				{
					SystemBar = Roact.createElement(SystemBar, {
						itemList = itemList,
						selection = selection,
						placement = Placement.Bottom,
						hidden = self.state.hidden,
						onSafeAreaChanged = function() end,
						size = UDim2.new(1, 0, 1, 0),
						position = UDim2.new(),
						layoutOrder = 1,
						roundCorners = true,
						buttonStroke = true,
						bgTransparency = 0,
						sortOrder = Enum.SortOrder.LayoutOrder
					})
				}
			)
		}),
		MoreMenuPanel3D = 0,
		ShowHighlightedLeaveGameIconToggled = 0,
		ShowTopBarChanged = 0,
		ShowMoreMenuChanged = 0,
		CoreGuiChanged = 0,
		SafetyBubbleToggled = 0,
		BackpackItemAdded = 0,
		BackpackEmpty = 0,
		EmotesLoaded = 0,
		RenderStepped = 0,
		VREnabled = 0
	}

	local moreMenuPanel3D = self.state.moreMenuOpen

	if moreMenuPanel3D then
		local createElement2 = Roact.createElement
		local partSize2

		if IsSpatialRobloxGuiEnabled then
			partSize2 = Vector2.new(
				5 * v.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale,
				#moreItemList * v.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale
			)
		else
			partSize2 = Vector2.new(5 * v23, #moreItemList * v23)
		end

		local v26 = {
			panelName = "MoreMenu",
			partSize = partSize2,
			virtualScreenSize = Vector2.new(250, #moreItemList * 56 + 8),
			offset = self.state.vrMenuOpen and CFrame.new(0, 0, 0) or CFrame.new(0, -0.5, 0),
			offsetCallback = self.moreMenuPanelOffsetCallback,
			lerp = true,
			tilt = 0,
			tiltCallback = self.moreMenuPanelTiltCallback,
			anchoring = 0,
			faceCamera = true,
			alwaysOnTop = 0,
			parent = 0,
			connectPanelManagerFunction = 0,
			zOffset = 2
		}
		local anchoring2

		if IsSpatialRobloxGuiEnabled then
			anchoring2 = Constants.AnchoringTypes.PanelManaged
		else
			anchoring2 = Constants.AnchoringTypes.Head
		end

		v26.anchoring = anchoring2

		v26.alwaysOnTop = engineFeature and true or nil
		v26.parent = engineFeature and GuiService.CoreGuiFolder or nil
		v26.connectPanelManagerFunction = IsSpatialRobloxGuiEnabled and function(p2)
			if p2 then
				registerRoactPanel(p2, panelType.MoreMenu)
			else
				v2.getInstance():removeRoactPanel(panelType.MoreMenu)
			end
		end or nil
		moreMenuPanel3D = createElement2(Panel3D, v26, {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				MoreMenu = Roact.createElement(BaseMenu, {
					anchorPoint = Vector2.new(0.5, 1),
					buttonProps = moreItemList,
					position = UDim2.new(0.5, 0, 1, -8),
					background = p.Theme.BackgroundContrast
				}),
				Caret = Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 1),
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/MenuBar/dropdown-arrow.png",
					ImageColor3 = Color3.fromRGB(25, 27, 29),
					Position = UDim2.new(0.5, 0, 1, 0),
					Size = UDim2.new(0, 24, 0, 10)
				})
			})
		})
	end

	children.MoreMenuPanel3D = moreMenuPanel3D

	children.ShowHighlightedLeaveGameIconToggled = Roact.createElement(ExternalEventConnection, {
		event = VRHub.ShowHighlightedLeaveGameIconToggled.Event,
		callback = self.updateItemListState
	})

	children.ShowTopBarChanged = Roact.createElement(ExternalEventConnection, {
		event = VRHub.ShowTopBarChanged.Event,
		callback = self.onShowTopBarChanged
	})

	children.ShowMoreMenuChanged = Roact.createElement(ExternalEventConnection, {
		event = VRHub.ShowMoreMenuChanged.Event,
		callback = self.onShowMoreMenuChanged
	})

	children.CoreGuiChanged = Roact.createElement(ExternalEventConnection, {
		event = StarterGui.CoreGuiChangedSignal,
		callback = self.updateItemListState
	})

	children.SafetyBubbleToggled = VRHub.SafetyBubble
		and Roact.createElement(ExternalEventConnection, {
			event = VRHub.SafetyBubble.Toggled.Event,
			callback = self.updateItemListState
		})

	children.BackpackItemAdded = Roact.createElement(ExternalEventConnection, {
		event = v3.BackpackItemAdded.Event,
		callback = self.onBackpackItemAdded
	})

	children.BackpackEmpty = Roact.createElement(ExternalEventConnection, {
		event = v3.BackpackEmpty.Event,
		callback = self.onBackpackEmpty
	})

	children.EmotesLoaded = Roact.createElement(ExternalEventConnection, {
		event = EmotesMenuMaster.EmotesLoaded.Event,
		callback = self.onEmotesLoaded
	})

	children.RenderStepped = Roact.createElement(ExternalEventConnection, {
		event = RunService.RenderStepped,
		callback = self.onRenderStepped
	})

	children.VREnabled = Roact.createElement(ExternalEventConnection, {
		event = VRService:GetPropertyChangedSignal("VREnabled"),
		callback = self.onVREnabledChanged
	})
	return createFragment(children)
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithStyle(p)
	end)
end

function extended.didUpdate(data, p, data2)
	if data2.lookAway ~= data.state.lookAway or data2.vrMenuOpen ~= data.state.vrMenuOpen then
		if not data.state.vrMenuOpen and data.state.lookAway then
			data.fadeTransparencyMotor:setGoal(Otter.spring(1, v6.Slower))
		else
			data.fadeTransparencyMotor:setGoal(Otter.spring(0, v6.Default))
		end
	end

	if data.state.moreMenuOpen and #data.state.moreItemList == 0 then
		VRHub:SetShowMoreMenu(false)
	end

	if p.voiceEnabled ~= data.props.voiceEnabled then
		data.updateItemListState()
	elseif data2.yOffset ~= data.state.yOffset or data2.zOffset ~= data.state.zOffset then
		data.updateItemListState()
	end
end

function extended.willUnmount(p)
	p.fadeTransparencyMotor:stop()
end

return RoactRodux.UNSTABLE_connect2(nil, nil)(extended)
