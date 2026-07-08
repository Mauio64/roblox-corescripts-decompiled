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
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local VRUtil = require(CorePackages.Workspace.Packages.VrCommon).VRUtil
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local FFlagEnableUIManagerPackgify = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUIManagerPackgify
local GetFFlagEnableVrVoiceParity = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVrVoiceParity
local GetFFlagEnableVrVoiceConnectDisconnect = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVrVoiceConnectDisconnect
local v33 = game:DefineFastFlag("EnableJoinVoiceVrTelemetry", false)
local Constants3, PanelType, registerRoactPanel, UIManager

if FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	Constants3 = VrSpatialUi.Constants
	PanelType = Constants3.PanelType
	registerRoactPanel = VrSpatialUi.registerRoactPanel
	UIManager = VrSpatialUi.UIManager
else
	local UIManager2 = RobloxGui:WaitForChild("Modules"):WaitForChild("UIManager")

	PanelType = require(UIManager2.Constants).PanelType
	registerRoactPanel = require(UIManager2.registerRoactPanel)
	UIManager = require(UIManager2.UIManager)
	Constants3 = require(UIManager2.Constants)
end

local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
local GameSettings = UserSettings().GameSettings
local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local v44 = Roact.PureComponent:extend("TopBarApp")
local VRBarSeparator = require(script.Parent.VRBarSeparator)
local VRBarVoiceIcon = require(script.Parent.VRBarVoiceIcon)
local VRBottomBarAnalytics = require(script.Parent.VRBottomBarAnalytics)
local VRBottomBarType = require(script.Parent.VRBottomBarType)
local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v51 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v52 = if not FFlagEnableNewBackpack then require(RobloxGui.Modules.BackpackScript) else require(CorePackages.Workspace.Packages.Backpack)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local StarterPlayer = game:GetService("StarterPlayer")
local EngineFeature = game:GetEngineFeature("EnableVRBottomBarWorksBehindObjects")
local FFlagVRBottomBarDebugPositionConfig = require(RobloxGui.Modules.Flags.FFlagVRBottomBarDebugPositionConfig)
local FIntVRBottomBarPositionOffsetVerticalNumber = require(RobloxGui.Modules.Flags.FIntVRBottomBarPositionOffsetVerticalNumber)
local FIntVRBottomBarPositionOffsetDepthNumber = require(RobloxGui.Modules.Flags.FIntVRBottomBarPositionOffsetDepthNumber)
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)
local SplashScreenManager = require(CorePackages.Workspace.Packages.SplashScreenManager).SplashScreenManager
local v61 = (require(RobloxGui.Modules.Flags.GetFIntVRScaleGuiDistance) or 100)() * 0.01
local v62 = game:DefineFastFlag("FixVRBottomBarAnalytics", false)

local function safeRequire(p1) -- line: 105
	local ok, result = pcall(require, p1)

	if ok then
		return result
	end

	warn("Failure to Start CoreScript module " .. p1.Name .. ".\n" .. result)
end

local t1 = {
	Y = FIntVRBottomBarPositionOffsetVerticalNumber / 100,
	Z = FIntVRBottomBarPositionOffsetDepthNumber / 100
}
local _ = 0.2 + t1.Z / 10
local t2 = {
	Default = {
		dampingRatio = 1,
		frequency = 4.5
	},
	Slower = {
		dampingRatio = 1,
		frequency = 0.66
	}
}
local t3 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_menu.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_menu.png",
	onActivated = function() -- line: 140
		-- upvalues: VRHub (copy), InGameMenuInit (copy), InGameMenuConstants (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		VRHub:SetShowTopBar(true)

		if not InGameMenuInit.getOpen() then
			InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
			VRHub:SetShowMoreMenu(false)
		else
			InGameMenuInit.closeInGameMenu()
		end

		if v62 then
			local v87 = InGameMenuInit.getOpen()

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.MainMenu,
				isToggleOn = v87,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-MainMenu")
	end
}
local t4 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_maximize.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_minimize.png",
	onActivated = function() -- line: 164
		-- upvalues: VRHub (copy), InGameMenuInit (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(false)
			VRHub:SetShowTopBar(true)
		else
			VRHub:SetShowTopBar(false)
			InGameMenuInit.closeInGameMenu()
		end

		if v62 then
			local ShowTopBar = VRHub.ShowTopBar

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.ToggleGui,
				isToggleOn = ShowTopBar,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-ToggleGui")
	end
}
local t5 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	onActivated = function() -- line: 189
		-- upvalues: FFlagEnableNewBackpack (copy), VRHub (copy), v51 (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), v52 (copy), RbxAnalyticsService (copy)
		if FFlagEnableNewBackpack then
			if not VRHub.ShowTopBar then
				VRHub:SetShowTopBar(true)
				v51.setVisibility(v51.FeatureName.Backpack, true)
			else
				v51.toggleVisibility(v51.FeatureName.Backpack)
			end

			if v62 then
				VRBottomBarAnalytics.sendEventToTelemetryV2({
					integrationId = VRBottomBarType.ButtomName.Inventory,
					isToggleOn = v51.getVisibility(v51.FeatureName.Backpack),
					source = VRBottomBarType.Source.MoreSubMenu
				})
			end
		else
			if not VRHub.ShowTopBar then
				VRHub:SetShowTopBar(true)

				if not v52.IsOpen then
					v52.OpenClose()
				end
			else
				v52.OpenClose()
			end

			if v62 then
				local IsOpen = v52.IsOpen

				VRBottomBarAnalytics.sendEventToTelemetryV2({
					integrationId = VRBottomBarType.ButtomName.Inventory,
					isToggleOn = IsOpen,
					source = VRBottomBarType.Source.MoreSubMenu
				})
			end
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Backpack")
	end
}
local t6 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	onActivated = function() -- line: 229
		-- upvalues: VRHub (copy), PlayerListManager (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)

			if not PlayerListManager:GetSetVisible() then
				PlayerListManager:SetVisibility(true)
			end
		else
			PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
		end

		if v62 then
			local SetVisible = PlayerListManager:GetSetVisible()

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Leaderboard,
				isToggleOn = SetVisible,
				source = VRBottomBarType.Source.MoreSubMenu
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-PlayerList")
	end
}
local t7 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	onActivated = function() -- line: 255
		-- upvalues: VRHub (copy), EmotesMenuMaster (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)

			if not EmotesMenuMaster:isOpen() then
				EmotesMenuMaster:open()
			end
		elseif EmotesMenuMaster:isOpen() then
			EmotesMenuMaster:close()
		else
			EmotesMenuMaster:open()
		end

		if v62 then
			local v91 = EmotesMenuMaster:isOpen()

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Emotes,
				isToggleOn = v91,
				source = VRBottomBarType.Source.MoreSubMenu
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Emotes")
	end
}
local t8 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_chat.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_chat.png",
	onActivated = function() -- line: 285
		-- upvalues: VRHub (copy), ChatSelector (copy), GameSettings (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		if not VRHub.ShowTopBar then
			VRHub:SetShowTopBar(true)

			if not ChatSelector:GetVisibility() then
				ChatSelector:ToggleVisibility()
				GameSettings.ChatVisible = ChatSelector:GetVisibility()
			end
		else
			ChatSelector:ToggleVisibility()
			GameSettings.ChatVisible = ChatSelector:GetVisibility()
		end

		if v62 then
			local ChatVisible = GameSettings.ChatVisible

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Chat,
				isToggleOn = ChatVisible,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-Chat")
	end
}
local t9 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_safety_on.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_safety_on.png",
	onActivated = function() -- line: 313
		-- upvalues: VRHub (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		VRHub:ToggleSafetyBubble()

		if v62 then
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
local t10 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_safety_off.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_safety_off.png",
	onActivated = function() -- line: 331
		-- upvalues: VRHub (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		VRHub:ToggleSafetyBubble()

		if v62 then
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
local t11 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leave.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leave.png",
	onActivated = function() -- line: 349
		-- upvalues: VRHub (copy), InGameMenuInit (copy), InGameMenuConstants (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		VRHub:SetShowTopBar(true)
		VRHub:SetShowMoreMenu(false)

		if InGameMenuInit then
			if not InGameMenuInit.getOpen() then
				InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
			end

			InGameMenuInit.openGameLeavePage()
		end

		if v62 then
			local v95 = InGameMenuInit.getOpen()

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.Leave,
				isToggleOn = v95,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-LeaveGame")
	end
}
local t12 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_leave_highlighted.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_leave_highlighted.png",
	onActivated = t11.onActivated
}
local t13 = {
	iconOn = "rbxasset://textures/ui/MenuBar/icon_more.png",
	iconOff = "rbxasset://textures/ui/MenuBar/icon_more.png",
	onActivated = function() -- line: 381
		-- upvalues: VRHub (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
		VRHub:SetShowTopBar(true)
		VRHub:SetShowMoreMenu(not VRHub.ShowMoreMenu)

		if v62 then
			local ShowMoreMenu = VRHub.ShowMoreMenu

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.MoreSubMenu,
				isToggleOn = ShowMoreMenu,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-More")
	end
}
local t14 = {
	iconComponent = VRBarSeparator,
	itemSize = UDim2.new(0, 28, 0, 44)
}
local t15 = {
	icon = "rbxasset://textures/ui/MenuBar/icon_emote.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Emotes"),
	onActivated = function() -- line: 405
		-- upvalues: t7 (copy), RbxAnalyticsService (copy)
		t7.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-Emotes")
	end
}
local t16 = {
	icon = "rbxasset://textures/ui/MenuBar/icon_leaderboard.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Leaderboard"),
	onActivated = function() -- line: 414
		-- upvalues: t6 (copy), RbxAnalyticsService (copy)
		t6.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-PlayerList")
	end
}
local t17 = {
	icon = "rbxasset://textures/ui/MenuBar/icon__backpack.png",
	text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Inventory"),
	onActivated = function() -- line: 423
		-- upvalues: t5 (copy), RbxAnalyticsService (copy)
		t5.onActivated()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-MoreMenu-Backpack")
	end
}
local t18 = {
	text = "Join Voice",
	iconOn = Images["icons/controls/publicAudioJoin"],
	iconOff = Images["icons/controls/publicAudioJoin"],
	onActivated = function() -- line: 433
		-- upvalues: default (copy), Constants2 (copy), v33 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy)
		default.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		default:JoinVoice()

		if v33 then
			local v97 = default:ShouldShowJoinVoice()

			VRBottomBarAnalytics.sendEventToTelemetryV2({
				integrationId = VRBottomBarType.ButtomName.JoinVoice,
				isToggleOn = v97,
				source = VRBottomBarType.Source.VRBottomBar
			})
		end
	end
}

local function roundOffset(p2) -- line: 448
	return p2 >= 0 and math.floor(p2 * 10 + 0.5) / 10 or math.ceil(p2 * 10 - 0.5) / 10
end

function v44.init(p3) -- line: 453
	-- upvalues: t1 (copy), v61 (copy), VRService (copy), RobloxGui (copy), Roact (copy), SplashScreenManager (copy), React (copy), VRBarVoiceIcon (copy), Cryo (copy), Players (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy), t3 (copy), t14 (copy), t4 (copy), t11 (copy), IsSpatialRobloxGuiEnabled (copy), VRHub (copy), VRUtil (copy), Otter (copy), t2 (copy), FFlagVRBottomBarDebugPositionConfig (copy)
	local t19 = {
		moreMenuOpen = false,
		vrMenuOpen = true,
		lookAway = false,
		yOffset = t1.Y * v61,
		zOffset = t1.Z * v61
	}
	local g101 = nil
	local result = nil

	repeat
		if g101 or VRService.VREnabled then
			if not g101 then
				local UserGui = RobloxGui.Modules.VR.UserGui
				local ok

				ok, result = pcall(require, UserGui)

				if ok then
				else
					warn("Failure to Start CoreScript module " .. UserGui.Name .. ".\n" .. result)
					result = nil
				end
			end

			if g101 or result then
				g101 = false
				t19.userGui = result
				t19.hidden = not SplashScreenManager.isFPSAtTarget()
				p3:setState(t19)
				p3.backpackHasItems = false
				p3.emotesLoaded = false

				function p3.onTargetFPSSTateChange(p4) -- line: 467
					-- upvalues: p3 (copy)
					p3:setState({
						hidden = not p4
					})
				end

				SplashScreenManager.addStatusChangeListener(p3.onTargetFPSSTateChange)

				function p3.getVoiceIcon() -- line: 472
					-- upvalues: React (copy), VRBarVoiceIcon (copy), Cryo (copy), Players (copy), p3 (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
					return {
						iconImageComponent = function(p5) -- line: 474
							-- upvalues: React (copy), VRBarVoiceIcon (copy), Cryo (copy), Players (copy)
							return React.createElement(VRBarVoiceIcon, Cryo.Dictionary.join(p5, {
								iconStyle = "MicLight",
								userId = tostring(Players.LocalPlayer.UserId)
							}))
						end,
						onActivated = function() -- line: 483
							-- upvalues: p3 (copy), v62 (copy), VRBottomBarAnalytics (copy), VRBottomBarType (copy), RbxAnalyticsService (copy)
							if p3.props.voiceState == Enum.VoiceChatState.Failed then
								p3.props.voiceChatServiceManager:RejoinPreviousChannel()
							else
								p3.props.voiceChatServiceManager:ToggleMic("VRBottomBar")
							end

							if v62 then
								local v167 = p3.props.voiceState == Enum.VoiceChatState.Joined and true

								VRBottomBarAnalytics.sendEventToTelemetryV2({
									integrationId = VRBottomBarType.ButtomName.Voice,
									isToggleOn = v167,
									source = VRBottomBarType.Source.VRBottomBar
								})
							end

							RbxAnalyticsService:ReportCounter("VR-BottomBar-Voice")
						end
					}
				end
				function p3.getDebugYOffsetUp() -- line: 508
					-- upvalues: p3 (copy)
					return {
						iconOn = "rbxasset://textures/ui/MenuBar/arrow_up.png",
						iconOff = "rbxasset://textures/ui/MenuBar/arrow_up.png",
						onActivated = function() -- line: 512
							-- upvalues: p3 (copy)
							p3:setState({
								yOffset = p3.state.yOffset + 0.1
							})
						end
					}
				end
				function p3.getDebugYOffsetDown() -- line: 521
					-- upvalues: p3 (copy)
					return {
						iconOn = "rbxasset://textures/ui/MenuBar/arrow_down.png",
						iconOff = "rbxasset://textures/ui/MenuBar/arrow_down.png",
						onActivated = function() -- line: 525
							-- upvalues: p3 (copy)
							p3:setState({
								yOffset = p3.state.yOffset - 0.1
							})
						end
					}
				end
				function p3.getDebugZOffsetUp() -- line: 534
					-- upvalues: p3 (copy)
					return {
						iconOn = "rbxasset://textures/ui/MenuBar/arrow_left.png",
						iconOff = "rbxasset://textures/ui/MenuBar/arrow_left.png",
						onActivated = function() -- line: 538
							-- upvalues: p3 (copy)
							p3:setState({
								zOffset = p3.state.zOffset + 0.1
							})
						end
					}
				end
				function p3.getDebugZOffsetDown() -- line: 547
					-- upvalues: p3 (copy)
					return {
						iconOn = "rbxasset://textures/ui/MenuBar/arrow_right.png",
						iconOff = "rbxasset://textures/ui/MenuBar/arrow_right.png",
						onActivated = function() -- line: 551
							-- upvalues: p3 (copy)
							p3:setState({
								zOffset = p3.state.zOffset - 0.1
							})
						end
					}
				end
				function p3.getDebugTextLabel() -- line: 560
					-- upvalues: p3 (copy), Roact (copy)
					return {
						iconComponent = function(p6) -- line: 562
							-- upvalues: p3 (copy), Roact (copy)
							local yOffset = p3.state.yOffset
							local v170 = yOffset >= 0 and math.floor(yOffset * 10 + 0.5) / 10 or math.ceil(yOffset * 10 - 0.5) / 10
							local zOffset = p3.state.zOffset
							local v172 = "Y " .. v170 .. ", Z " .. (zOffset >= 0 and math.floor(zOffset * 10 + 0.5) / 10 or math.ceil(zOffset * 10 - 0.5) / 10)

							return Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Text = v172,
								TextColor3 = Color3.new(1, 1, 1),
								TextWrapped = true,
								TextScaled = true,
								Size = UDim2.fromScale(1, 1),
								[Roact.Children] = p6[Roact.Children]
							})
						end,
						itemSize = UDim2.new(0, 44, 0, 44)
					}
				end

				p3:setState({
					itemList = {
						t3,
						t14,
						t4,
						t14,
						t11
					},
					moreItemList = {}
				})

				function p3.onShowTopBarChanged() -- line: 585
					-- upvalues: IsSpatialRobloxGuiEnabled (copy), VRHub (copy), p3 (copy)
					if IsSpatialRobloxGuiEnabled then
						return
					end

					if not VRHub.ShowTopBar then
						VRHub:SetShowMoreMenu(false)
					end

					p3:setState({
						vrMenuOpen = VRHub.ShowTopBar
					})
				end
				function p3.onShowMoreMenuChanged() -- line: 597
					-- upvalues: p3 (copy), VRHub (copy)
					p3:setState({
						moreMenuOpen = VRHub.ShowMoreMenu
					})
				end
				function p3.updateItemListState() -- line: 603
					-- upvalues: p3 (copy)
					local v129, v130 = p3:updateItems()

					p3:setState({
						itemList = v129,
						moreItemList = v130
					})
				end
				function p3.onBackpackItemAdded() -- line: 611
					-- upvalues: p3 (copy)
					if not p3.backpackHasItems then
						p3.backpackHasItems = true
						p3.updateItemListState()
					end
				end
				function p3.onBackpackEmpty() -- line: 618
					-- upvalues: p3 (copy)
					if p3.backpackHasItems then
						p3.backpackHasItems = false
						p3.updateItemListState()
					end
				end
				function p3.onEmotesLoaded(p7) -- line: 625
					-- upvalues: p3 (copy)
					if p7 ~= p3.emotesLoaded then
						p3.emotesLoaded = p7
						p3.updateItemListState()
					end
				end
				function p3.onVREnabledChanged() -- line: 632
					-- upvalues: p3 (copy), VRService (copy), RobloxGui (copy), Roact (copy)
					local v132 = p3
					local t20 = {}
					local g134 = nil
					local result2 = nil

					repeat
						if g134 or VRService.VREnabled then
							if not g134 then
								local UserGui = RobloxGui.Modules.VR.UserGui
								local ok

								ok, result2 = pcall(require, UserGui)

								if ok then
								else
									warn("Failure to Start CoreScript module " .. UserGui.Name .. ".\n" .. result2)
									result2 = nil
								end
							end

							if g134 or result2 then
								g134 = false
								t20.userGui = result2
								v132:setState(t20)

								return
							end
						end

						result2 = Roact.None
						g134 = true
					until not g134
				end
				function p3.onRenderStepped() -- line: 638
					-- upvalues: VRUtil (copy), p3 (copy)
					local v138 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head).LookVector.Y > -0.2

					if v138 ~= p3.state.lookAway then
						p3:setState({
							lookAway = v138
						})
					end
				end

				local v105, v106 = Roact.createBinding(0)

				p3.fadeTransparency = v105
				p3.setFadeTransparency = v106
				p3.fadeTransparencyMotor = Otter.createSingleMotor(p3.fadeTransparency:getValue())
				p3.fadeTransparencyMotor:onStep(p3.setFadeTransparency)
				p3.fadeTransparencyMotor:setGoal(Otter.spring(0, t2.Default))

				function p3.getAlignedPanelPart() -- line: 653
					-- upvalues: p3 (copy)
					local v139 = if not p3.state.userGui then nil else p3.state.userGui:getPanel()
					local v140 = v139 and v139:GetPart()

					if v140 and ((v139:IsPositionLockedType() or v139:IsUIManagerManagedType()) and (v139:IsVisible() or v139.alwaysUpdatePosition)) then
						return v140
					end
				end
				function p3.bottomBarPanelOffsetCallback(p8) -- line: 664
					-- upvalues: p3 (copy), VRUtil (copy)
					local finalPosition = p8.finalPosition
					local cameraHeadScale = p8.cameraHeadScale
					local v144 = p3.getAlignedPanelPart()

					if v144 then
						local yOffset = p3.state.yOffset
						local zOffset = p3.state.zOffset
						local v147 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
						local cFrame = CFrame.new(0, 0, zOffset * cameraHeadScale - v144.Size.Z * 0.5)
						local v149 = v144.CFrame:ToWorldSpace(cFrame)

						finalPosition = Vector3.new(v149.Position.X, v147.Position.Y + yOffset * cameraHeadScale, v149.Position.Z)
					end

					return finalPosition
				end
				function p3.moreMenuPanelOffsetCallback(p9) -- line: 687
					-- upvalues: p3 (copy), VRUtil (copy), v61 (copy), FFlagVRBottomBarDebugPositionConfig (copy)
					local finalPosition = p9.finalPosition
					local cameraHeadScale = p9.cameraHeadScale
					local v153 = p3.getAlignedPanelPart()

					if v153 then
						local v154 = p3.bottomBarPanelOffsetCallback(p9)
						local v155 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
						local cFrame = CFrame.new(v154, v155.Position)
						local v157 = (0.2 + p3.state.zOffset / 10) * v61
						local v158 = FFlagVRBottomBarDebugPositionConfig and (#p3.state.itemList - 3) / 2 * v157 or (#p3.state.itemList - 2.5) / 2 * v157
						local v159 = cFrame:ToWorldSpace((CFrame.new(-v158 * cameraHeadScale, v157 / 2 * cameraHeadScale, -0.025)))

						finalPosition = (CFrame.new(v159.Position) * v153.CFrame.Rotation):ToWorldSpace((CFrame.new(0, #p3.state.moreItemList * v157 / 2 * cameraHeadScale, 0.025))).Position
					end

					return finalPosition
				end
				function p3.moreMenuPanelTiltCallback(p10) -- line: 716
					-- upvalues: p3 (copy)
					local panelCFrame = p10.panelCFrame
					local v162 = p3.getAlignedPanelPart()

					if v162 then
						panelCFrame = CFrame.new(panelCFrame.Position) * v162.CFrame.Rotation
					end

					return panelCFrame
				end

				return
			end
		end

		result = Roact.None
		g101 = true
	until not g101
end
function v44.didMount(p11) -- line: 727
	-- upvalues: EmotesMenuMaster (copy), v52 (copy)
	p11.emotesLoaded = EmotesMenuMaster:isEmotesLoaded()
	p11.backpackHasItems = v52.IsInventoryEmpty()
	p11.updateItemListState()
end
function v44.updateItems(p12) -- line: 734
	-- upvalues: StarterGui (copy), IsSpatialRobloxGuiEnabled (copy), t3 (copy), t14 (copy), FFlagVRBottomBarDebugPositionConfig (copy), t4 (copy), StarterPlayer (copy), t8 (copy), GetFFlagEnableVrVoiceConnectDisconnect (copy), default (copy), t18 (copy), GetFFlagEnableVrVoiceParity (copy), VRHub (copy), t9 (copy), t10 (copy), t12 (copy), t11 (copy), t15 (copy), t16 (copy), t17 (copy), t13 (copy)
	local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
	local CoreGuiEnabled2 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
	local CoreGuiEnabled3 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
	local CoreGuiEnabled4 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	local t21

	if IsSpatialRobloxGuiEnabled then
		t21 = {
			t3,
			t14
		}

		if FFlagVRBottomBarDebugPositionConfig then
			t21 = {
				p12.getDebugYOffsetUp(),
				p12.getDebugYOffsetDown(),
				p12.getDebugZOffsetUp(),
				p12.getDebugZOffsetDown(),
				p12.getDebugTextLabel(),
				t14,
				t3,
				t14
			}
		end
	else
		t21 = {
			t3,
			t14,
			t4
		}

		if FFlagVRBottomBarDebugPositionConfig then
			t21 = {
				p12.getDebugYOffsetUp(),
				p12.getDebugYOffsetDown(),
				p12.getDebugZOffsetUp(),
				p12.getDebugZOffsetDown(),
				p12.getDebugTextLabel(),
				t14,
				t3,
				t14,
				t4
			}
		end
	end

	local v114 = CoreGuiEnabled2 and not (StarterPlayer.UserEmotesEnabled and p12.emotesLoaded == false)
	local v115 = CoreGuiEnabled and p12.backpackHasItems

	if CoreGuiEnabled3 then
		table.insert(t21, t8)
	end

	if GetFFlagEnableVrVoiceConnectDisconnect() and default:ShouldShowJoinVoiceOnDisconnect() then
		table.insert(t21, t18)
	elseif GetFFlagEnableVrVoiceParity() and default:ShouldShowJoinVoice() then
		table.insert(t21, t18)
	end

	if p12.props.voiceEnabled then
		table.insert(t21, p12.getVoiceIcon())
	end

	table.insert(t21, t14)

	if VRHub.SafetyBubble and VRHub.SafetyBubble.enabled then
		table.insert(t21, t9)
	else
		table.insert(t21, t10)
	end

	if VRHub.ShowHighlightedLeaveGameIcon then
		table.insert(t21, t12)
	else
		table.insert(t21, t11)
	end

	local t22 = {}

	if v114 then
		table.insert(t22, t15)
	end

	if CoreGuiEnabled4 then
		table.insert(t22, t16)
	end

	if v115 then
		table.insert(t22, t17)
	end

	if #t22 > 0 then
		table.insert(t21, t13)
	end

	return t21, t22
end
function v44.renderWithStyle(p13, p14) -- line: 824
	-- upvalues: v61 (copy), FFlagVRBottomBarDebugPositionConfig (copy), Roact (copy), Panel3D (copy), IsSpatialRobloxGuiEnabled (copy), Constants3 (ref), Constants (copy), EngineFeature (copy), GuiService (copy), registerRoactPanel (ref), PanelType (ref), UIManager (ref), SystemBar (copy), Placement (copy), BaseMenu (copy), ImageSetLabel (copy), ExternalEventConnection (copy), VRHub (copy), StarterGui (copy), v52 (copy), EmotesMenuMaster (copy), RunService (copy), VRService (copy)
	local v119 = (0.2 + p13.state.zOffset / 10) * v61
	local itemList = p13.state.itemList
	local moreItemList = p13.state.moreItemList
	local v122 = not FFlagVRBottomBarDebugPositionConfig and 1 or 7

	if not p13.state.vrMenuOpen then
		v122 = not FFlagVRBottomBarDebugPositionConfig and 3 or 9
	elseif p13.state.moreMenuOpen and #moreItemList > 0 then
		v122 = #itemList
	end

	return Roact.createFragment({
		BottomBarPanel3D = Roact.createElement(Panel3D, {
			panelName = "BottomBar",
			lerp = true,
			tilt = 0,
			faceCamera = true,
			curvature = 0,
			zOffset = 1,
			partSize = if not IsSpatialRobloxGuiEnabled then Vector2.new((#itemList - 1) * v119, v119) else Vector2.new((#itemList - 1) * Constants3.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale, Constants3.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale),
			virtualScreenSize = Vector2.new((#itemList - 1) * 50, 50),
			offset = p13.state.vrMenuOpen and CFrame.new(0, 0, 0) or CFrame.new(0, -0.5, 0),
			offsetCallback = p13.bottomBarPanelOffsetCallback,
			anchoring = if not IsSpatialRobloxGuiEnabled then Constants.AnchoringTypes.Head else Constants.AnchoringTypes.PanelManaged,
			alwaysOnTop = not not EngineFeature or nil,
			parent = EngineFeature and GuiService.CoreGuiFolder or nil,
			connectPanelManagerFunction = if not IsSpatialRobloxGuiEnabled then nil else function(p15) -- line: 861
				-- upvalues: registerRoactPanel (ref), PanelType (ref), UIManager (ref)
				if p15 then
					registerRoactPanel(p15, PanelType.BottomBar)

					return
				end

				UIManager.getInstance():removeRoactPanel(PanelType.BottomBar)
			end
		}, {
			CanvasGroup = Roact.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				GroupTransparency = p13.fadeTransparency,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				SystemBar = Roact.createElement(SystemBar, {
					layoutOrder = 1,
					roundCorners = true,
					buttonStroke = true,
					bgTransparency = 0,
					itemList = itemList,
					selection = v122,
					placement = Placement.Bottom,
					hidden = p13.state.hidden,
					onSafeAreaChanged = function() -- line: 881
					end,
					size = UDim2.new(1, 0, 1, 0),
					position = UDim2.new(),
					sortOrder = Enum.SortOrder.LayoutOrder
				})
			})
		}),
		MoreMenuPanel3D = p13.state.moreMenuOpen and Roact.createElement(Panel3D, {
			panelName = "MoreMenu",
			lerp = true,
			tilt = 0,
			faceCamera = true,
			zOffset = 2,
			partSize = if not IsSpatialRobloxGuiEnabled then Vector2.new(5 * v119, #moreItemList * v119) else Vector2.new(5 * Constants3.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale, #moreItemList * Constants3.BOTTOM_BAR_BASE_PART_SIZE * workspace.CurrentCamera.HeadScale),
			virtualScreenSize = Vector2.new(250, #moreItemList * 56 + 8),
			offset = p13.state.vrMenuOpen and CFrame.new(0, 0, 0) or CFrame.new(0, -0.5, 0),
			offsetCallback = p13.moreMenuPanelOffsetCallback,
			tiltCallback = p13.moreMenuPanelTiltCallback,
			anchoring = if not IsSpatialRobloxGuiEnabled then Constants.AnchoringTypes.Head else Constants.AnchoringTypes.PanelManaged,
			alwaysOnTop = not not EngineFeature or nil,
			parent = EngineFeature and GuiService.CoreGuiFolder or nil,
			connectPanelManagerFunction = if not IsSpatialRobloxGuiEnabled then nil else function(p16) -- line: 913
				-- upvalues: registerRoactPanel (ref), PanelType (ref), UIManager (ref)
				if p16 then
					registerRoactPanel(p16, PanelType.MoreMenu)

					return
				end

				UIManager.getInstance():removeRoactPanel(PanelType.MoreMenu)
			end
		}, {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				MoreMenu = Roact.createElement(BaseMenu, {
					anchorPoint = Vector2.new(0.5, 1),
					buttonProps = moreItemList,
					position = UDim2.new(0.5, 0, 1, -8),
					background = p14.Theme.BackgroundContrast
				}),
				Caret = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/MenuBar/dropdown-arrow.png",
					AnchorPoint = Vector2.new(0.5, 1),
					ImageColor3 = Color3.fromRGB(25, 27, 29),
					Position = UDim2.new(0.5, 0, 1, 0),
					Size = UDim2.new(0, 24, 0, 10)
				})
			})
		}),
		ShowHighlightedLeaveGameIconToggled = Roact.createElement(ExternalEventConnection, {
			event = VRHub.ShowHighlightedLeaveGameIconToggled.Event,
			callback = p13.updateItemListState
		}),
		ShowTopBarChanged = Roact.createElement(ExternalEventConnection, {
			event = VRHub.ShowTopBarChanged.Event,
			callback = p13.onShowTopBarChanged
		}),
		ShowMoreMenuChanged = Roact.createElement(ExternalEventConnection, {
			event = VRHub.ShowMoreMenuChanged.Event,
			callback = p13.onShowMoreMenuChanged
		}),
		CoreGuiChanged = Roact.createElement(ExternalEventConnection, {
			event = StarterGui.CoreGuiChangedSignal,
			callback = p13.updateItemListState
		}),
		SafetyBubbleToggled = VRHub.SafetyBubble and Roact.createElement(ExternalEventConnection, {
			event = VRHub.SafetyBubble.Toggled.Event,
			callback = p13.updateItemListState
		}),
		BackpackItemAdded = Roact.createElement(ExternalEventConnection, {
			event = v52.BackpackItemAdded.Event,
			callback = p13.onBackpackItemAdded
		}),
		BackpackEmpty = Roact.createElement(ExternalEventConnection, {
			event = v52.BackpackEmpty.Event,
			callback = p13.onBackpackEmpty
		}),
		EmotesLoaded = Roact.createElement(ExternalEventConnection, {
			event = EmotesMenuMaster.EmotesLoaded.Event,
			callback = p13.onEmotesLoaded
		}),
		RenderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.RenderStepped,
			callback = p13.onRenderStepped
		}),
		VREnabled = Roact.createElement(ExternalEventConnection, {
			event = VRService:GetPropertyChangedSignal("VREnabled"),
			callback = p13.onVREnabledChanged
		})
	})
end
function v44.render(p17) -- line: 987
	-- upvalues: withStyle (copy)
	return withStyle(function(p18) -- line: 988
		-- upvalues: p17 (copy)
		return p17:renderWithStyle(p18)
	end)
end
function v44.didUpdate(p19, p20, p21) -- line: 993
	-- upvalues: Otter (copy), t2 (copy), VRHub (copy)
	if p21.lookAway ~= p19.state.lookAway or p21.vrMenuOpen ~= p19.state.vrMenuOpen then
		if not p19.state.vrMenuOpen and p19.state.lookAway then
			p19.fadeTransparencyMotor:setGoal(Otter.spring(1, t2.Slower))
		else
			p19.fadeTransparencyMotor:setGoal(Otter.spring(0, t2.Default))
		end
	end

	if p19.state.moreMenuOpen and #p19.state.moreItemList == 0 then
		VRHub:SetShowMoreMenu(false)
	end

	if p20.voiceEnabled ~= p19.props.voiceEnabled then
		p19.updateItemListState()

		return
	end

	if p21.yOffset ~= p19.state.yOffset or p21.zOffset ~= p19.state.zOffset then
		p19.updateItemListState()
	end
end
function v44.willUnmount(p22) -- line: 1015
	p22.fadeTransparencyMotor:stop()
end

return RoactRodux.UNSTABLE_connect2(nil, nil)(v44)
