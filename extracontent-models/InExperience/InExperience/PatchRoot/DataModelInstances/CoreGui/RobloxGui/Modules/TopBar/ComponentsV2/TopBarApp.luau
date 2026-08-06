game:GetService("CoreGui")

local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Components = ParentParent.Components
local Presentation = Components.Presentation
local Chrome = ParentParent.Parent.Chrome
local Constants = require(ParentParent.Constants)
local Constants2 = require(Chrome.Integrations.MusicUtility.Constants)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Foundation = require(CorePackages.Packages.Foundation)
local Display = require(CorePackages.Workspace.Packages.Display)
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Songbird = require(CorePackages.Workspace.Packages.Songbird)
local Traversal = CoreScriptsRoactCommon.Traversal
local UIBlox = require(CorePackages.Packages.UIBlox)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local FFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
local FFlagGamepadNavigationDialogABTest = require(ParentParent.Flags.FFlagGamepadNavigationDialogABTest)
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar
local FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local v33 = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop
local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local ShopGlobalIcon = InExperienceShop.ShopGlobalIcon
local View = Foundation.View
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local GamepadConnector = require(Components.GamepadConnector)
local GamepadNavigationDialog = require(Presentation.GamepadNavigationDialog)
local HealthBar = CoreGuiCommon.Components.HealthBar
local MenuIcon = require(ParentParent.ComponentsV2.MenuIcon)
local MenuIconContext = require(Components.MenuIconContext)
local MenuNavigationToggleDialog = require(Presentation.GamepadMenu.MenuNavigationToggleDialog)
local TraversalBackButton = require(Components.TraversalBackButton)
local PlaytestModeTooltip = require(Presentation.PlaytestModeTooltip)
local v47 = if not isInExperienceUIVREnabled then require(ParentParentParent.VR.VRBottomBar.VRBottomBar) else require(Components.VRBottomUnibar)
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local v50 = if not game:GetEngineFeature("InGameChromeSignalAPI") then nil else require(Chrome.ChromeShared.Analytics)
local v51 = if not game:GetEngineFeature("VoiceChatSupported") or not GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then nil else require(Chrome.Integrations.JoinVoiceBinder)
local PartyMicBinder = require(Chrome.Integrations.Party.PartyMicBinder)
local Unibar = require(Chrome.ChromeShared.Unibar)
local default = require(ParentParentParent.VoiceChat.VoiceChatServiceManager).default
local VoiceStateContext = require(ParentParentParent.VoiceChat.VoiceStateContext)
local v56 = if not v33 then nil else require(Chrome.Service)
local v57 = if not v33 then nil else require(Chrome.ChromeShared.Unibar.Constants)
local v58 = if not v33 then nil else require(Chrome.Integrations.CommonIcon)
local v59 = if not v33 then nil else require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local v60 = if not v33 or (not v56 or not v57) then nil else require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal.new(v56:onIntegrationStatusChanged(), function() -- line: 88
	-- upvalues: v56 (copy), v57 (copy)
	return v56:isWindowOpen(v57.IN_EXPERIENCE_SHOP_ID)
end)
local v61 = if not v33 then nil else require(Chrome.Integrations.InExperienceShop.ShopWindowLayout).toggleInExperienceShopWindow

local function getShopGlobalIconEnabled(p1) -- line: 99
	-- upvalues: v33 (copy), InExperienceShop (copy)
	if not v33 then
		return false
	end

	local GetShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if GetShopGlobalIconStore then
		return (GetShopGlobalIconStore(p1).getEnabled(p1))
	end

	return false
end
local function getShopGlobalStatusIndicatorEnabled(p2) -- line: 107
	-- upvalues: v33 (copy), InExperienceShop (copy)
	if not v33 then
		return false
	end

	local GetShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if GetShopGlobalIconStore then
		return (GetShopGlobalIconStore(p2).getStatusIndicatorEnabled(p2))
	end

	return false
end
local function handleShopGlobalIconActivated() -- line: 115
	-- upvalues: v33 (copy), FFlagCenterInExperienceShopWindow (copy), v61 (copy), v56 (copy), v57 (copy)
	if not v33 then
		return
	end

	if FFlagCenterInExperienceShopWindow then
		if v61 then
			v61()

			return
		end
	elseif v56 and v57 then
		v56:toggleWindow(v57.IN_EXPERIENCE_SHOP_ID)
	end
end
local function canShowAssistantBuild() -- line: 130
	-- upvalues: BuildExperience (copy), VRService (copy)
	return BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end
local function TopBarApp(_: {[any]: any}) -- line: 134
	-- upvalues: UniversalAppPolicy (copy), SignalsReact (copy), CoreGuiCommon (copy), Display (copy), v33 (copy), getShopGlobalIconEnabled (copy), getShopGlobalStatusIndicatorEnabled (copy), handleShopGlobalIconActivated (copy), React (copy), InExperienceShop (copy), v59 (copy), v60 (copy), GamepadConnector (copy), isSpatial (copy), VRService (copy), Constants (copy), View (copy), Constants2 (copy), Songbird (copy), FFlagAddMenuNavigationToggleDialog (copy), MenuNavigationToggleDialog (copy), FFlagGamepadNavigationDialogABTest (copy), GamepadNavigationDialog (copy), v51 (copy), GetFFlagEnableCrossExpVoice (copy), PartyMicBinder (copy), v50 (copy), FFlagEnablePlaytestModeUnibar (copy), PlaytestModeTooltip (copy), FFlagEnableSideSheet (copy), SelectionCursorProvider (copy), MenuIcon (copy), FFlagAddTraversalBackButton (copy), TraversalBackButton (copy), MenuIconContext (copy), Unibar (copy), ShopGlobalIcon (copy), FFlagExperienceShopNewIconography (copy), v58 (copy), FFlagAppNavMyStatsTab (copy), BuildExperience (copy), BuildPillMenuPortalHost (copy), HealthBar (copy), VoiceStateContext (copy), v47 (copy), default (copy), isInExperienceUIVREnabled (copy)
	local v72 = UniversalAppPolicy.useAppPolicy(function(p3) -- line: 135
		return p3.getShowBadgeOver12()
	end)
	local v73 = SignalsReact.useSignalState(function(p4) -- line: 139
		-- upvalues: CoreGuiCommon (copy)
		return CoreGuiCommon.Stores.GetKeepOutAreasStore(p4)
	end)
	local v74 = SignalsReact.useSignalState(function(p5) -- line: 142
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p5).getUIScale(p5)
	end)
	local v75 = nil
	local v76 = nil
	local v77 = nil
	local v78 = nil

	if v33 then
		v75 = SignalsReact.useSignalState(getShopGlobalIconEnabled)
		v76 = SignalsReact.useSignalState(getShopGlobalStatusIndicatorEnabled)
		v77 = handleShopGlobalIconActivated
		React.useEffect(function() -- line: 154
			-- upvalues: InExperienceShop (copy)
			return InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon() or function() -- line: 156
			end
		end, {})
		v78 = (v59 or function() -- line: 158
		end)(v60)
	end

	local v79 = React.useRef(nil)
	local v80 = React.useRef(nil)
	local v81 = GamepadConnector:getShowTopBar()
	local v82, v83 = React.useBinding(v81:get())

	React.useEffect(function() -- line: 168
		-- upvalues: isSpatial (copy), GamepadConnector (copy), VRService (copy), v81 (copy), v83 (copy), v73 (copy)
		if not isSpatial() then
			GamepadConnector:connectToTopbar()
		end

		local connection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 172
			-- upvalues: isSpatial (copy), GamepadConnector (copy)
			if isSpatial() then
				GamepadConnector:disconnectFromTopbar()

				return
			end

			GamepadConnector:connectToTopbar()
		end)
		local v93 = v81:connect(function() -- line: 180
			-- upvalues: v83 (copy), v81 (copy)
			v83(v81:get())
		end)

		return function() -- line: 183
			-- upvalues: connection (copy), GamepadConnector (copy), v73 (copy), v93 (copy)
			if connection then
				connection:Disconnect()
			end

			GamepadConnector:disconnectFromTopbar()

			if v73 then
				v73.cleanup()
			end

			v93:disconnect()
		end
	end, {})

	local v84 = React.useCallback(function(p6) -- line: 195
		-- upvalues: v73 (copy), Constants (copy)
		v73.setKeepOutArea(Constants.TopBarKeepOutAreaId, p6.AbsolutePosition, p6.AbsoluteSize)
	end, { v73 })
	local v85 = Constants.ScreenSideOffset * v74
	local v86 = Constants.TopBarHeight * v74
	local v87 = Constants.TopBarButtonHeight * v74
	local v88 = Constants.TopBarTopMargin * v74

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = 6,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Popups = React.createElement(View, {
			tag = "size-full"
		}, {
			SongbirdReportAudioFrame = React.createElement(View, {
				tag = "anchor-center-center position-center-center",
				Size = UDim2.new(1, 0, 0, Constants2.AUDIO_REPORTING_WINDOW_MIN_HEIGHT)
			}, {
				ReportAudioPopup = React.createElement(Songbird.ReportAudioPopup)
			}),
			MenuNavigationToggleDialog = if not FFlagAddMenuNavigationToggleDialog then nil else React.createElement(MenuNavigationToggleDialog, {
				Position = UDim2.fromScale(0.5, 0.1),
				GamepadConnector = GamepadConnector
			}),
			GamepadNavigationDialog = if not FFlagGamepadNavigationDialogABTest then nil else React.createElement(GamepadNavigationDialog)
		}),
		Binders = React.createElement(React.Fragment, {}, {
			JoinVoiceBinder = if not v51 then nil else React.createElement(v51),
			PartyMicBinder = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(PartyMicBinder),
			ChromeAnalytics = if not v50 then nil else React.createElement(v50)
		}),
		PlaytestTooltip = if not FFlagEnablePlaytestModeUnibar then nil else React.createElement(PlaytestModeTooltip, {
			anchorRef = v79
		}),
		TopBarFrame = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, v86)
		}, {
			TopLeftFrame = React.createElement(View, {
				tag = "anchor-top-left auto-x row gap-small",
				Size = UDim2.fromOffset(0, v87),
				onAbsoluteSizeChanged = v84,
				onAbsolutePositionChanged = v84,
				Position = UDim2.new(0, v85, 0, v88),
				Visible = v82
			}, {
				MenuIcon = if FFlagEnableSideSheet then nil else React.createElement(SelectionCursorProvider, {}, {
					Icon = React.createElement(MenuIcon, {
						showBadgeOver12 = v72,
						menuIconRef = v80,
						unibarMenuRef = v79
					})
				}),
				TraversalBackButton = if not FFlagAddTraversalBackButton then nil else React.createElement(TraversalBackButton),
				UnibarFrame = React.createElement(MenuIconContext.Provider, {
					value = {
						menuIconRef = v80
					}
				}, { React.createElement(Unibar, {
					layoutOrder = 2,
					onMinWidthChanged = function() -- line: 269
					end,
					onAreaChanged = function() -- line: 270
					end,
					menuRef = v79
				}) }),
				ShopGlobalIcon = if not v33 or (not v75 or ShopGlobalIcon == nil) then nil else React.createElement(ShopGlobalIcon, {
					layoutOrder = 3,
					buttonSize = v87,
					showStatusIndicator = v76,
					onActivated = v77,
					isActive = v78,
					icon = if FFlagExperienceShopNewIconography or (not v58 or not v60) then nil else v58("BuildingStore", nil, v60)
				})
			}),
			TopRightFrame = React.createElement(View, {
				tag = "anchor-top-right auto-x",
				Size = UDim2.fromOffset(0, v87),
				Position = UDim2.new(1, -v85, 0, v88)
			}, {
				BuildPillMenu = if not FFlagAppNavMyStatsTab or not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then nil else React.createElement(BuildPillMenuPortalHost),
				HealthBar = React.createElement(HealthBar)
			})
		}),
		VRBottomBar = if not VRService.VREnabled then nil else React.createElement(VoiceStateContext.Provider, {}, {
			VRBottomBar = VoiceStateContext.withVoiceState(function(p7) -- line: 304
				-- upvalues: React (copy), v47 (copy), default (copy), isInExperienceUIVREnabled (copy), v72 (copy)
				return React.createElement(v47, {
					voiceChatServiceManager = default,
					voiceEnabled = p7.voiceEnabled,
					voiceState = p7.voiceState,
					showBadgeOver12 = if not isInExperienceUIVREnabled then nil else v72
				})
			end)
		})
	})
end

return TopBarApp
