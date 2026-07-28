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
local FFlagAddTopBarPoliciesToUniversalPolicies = SharedFlags.FFlagAddTopBarPoliciesToUniversalPolicies
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local v34 = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop
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
local v48 = if not isInExperienceUIVREnabled then require(ParentParentParent.VR.VRBottomBar.VRBottomBar) else require(Components.VRBottomUnibar)
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local v51 = if not game:GetEngineFeature("InGameChromeSignalAPI") then nil else require(Chrome.ChromeShared.Analytics)
local v52 = if not game:GetEngineFeature("VoiceChatSupported") or not GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then nil else require(Chrome.Integrations.JoinVoiceBinder)
local PartyMicBinder = require(Chrome.Integrations.Party.PartyMicBinder)
local Unibar = require(Chrome.ChromeShared.Unibar)
local default = require(ParentParentParent.VoiceChat.VoiceChatServiceManager).default
local VoiceStateContext = require(ParentParentParent.VoiceChat.VoiceStateContext)
local v57 = if not v34 then nil else require(Chrome.Service)
local v58 = if not v34 then nil else require(Chrome.ChromeShared.Unibar.Constants)
local v59 = if not v34 then nil else require(Chrome.Integrations.CommonIcon)
local v60 = if not v34 then nil else require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local v61 = if not v34 or (not v57 or not v58) then nil else require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal.new(v57:onIntegrationStatusChanged(), function() -- line: 89
	-- upvalues: v57 (copy), v58 (copy)
	return v57:isWindowOpen(v58.IN_EXPERIENCE_SHOP_ID)
end)
local v62 = if not v34 then nil else require(Chrome.Integrations.InExperienceShop.ShopWindowLayout).toggleInExperienceShopWindow

local function getShopGlobalIconEnabled(p1) -- line: 100
	-- upvalues: v34 (copy), InExperienceShop (copy)
	if not v34 then
		return false
	end

	local GetShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if GetShopGlobalIconStore then
		return (GetShopGlobalIconStore(p1).getEnabled(p1))
	end

	return false
end
local function getShopGlobalStatusIndicatorEnabled(p2) -- line: 108
	-- upvalues: v34 (copy), InExperienceShop (copy)
	if not v34 then
		return false
	end

	local GetShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if GetShopGlobalIconStore then
		return (GetShopGlobalIconStore(p2).getStatusIndicatorEnabled(p2))
	end

	return false
end
local function handleShopGlobalIconActivated() -- line: 116
	-- upvalues: v34 (copy), FFlagCenterInExperienceShopWindow (copy), v62 (copy), v57 (copy), v58 (copy)
	if not v34 then
		return
	end

	if FFlagCenterInExperienceShopWindow then
		if v62 then
			v62()

			return
		end
	elseif v57 and v58 then
		v57:toggleWindow(v58.IN_EXPERIENCE_SHOP_ID)
	end
end
local function canShowAssistantBuild() -- line: 131
	-- upvalues: BuildExperience (copy), VRService (copy)
	return BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end
local function TopBarApp(_: {[any]: any}) -- line: 135
	-- upvalues: UniversalAppPolicy (copy), FFlagAddTopBarPoliciesToUniversalPolicies (copy), SignalsReact (copy), CoreGuiCommon (copy), Display (copy), v34 (copy), getShopGlobalIconEnabled (copy), getShopGlobalStatusIndicatorEnabled (copy), handleShopGlobalIconActivated (copy), React (copy), InExperienceShop (copy), v60 (copy), v61 (copy), GamepadConnector (copy), isSpatial (copy), VRService (copy), Constants (copy), View (copy), Constants2 (copy), Songbird (copy), FFlagAddMenuNavigationToggleDialog (copy), MenuNavigationToggleDialog (copy), FFlagGamepadNavigationDialogABTest (copy), GamepadNavigationDialog (copy), v52 (copy), GetFFlagEnableCrossExpVoice (copy), PartyMicBinder (copy), v51 (copy), FFlagEnablePlaytestModeUnibar (copy), PlaytestModeTooltip (copy), FFlagEnableSideSheet (copy), SelectionCursorProvider (copy), MenuIcon (copy), FFlagAddTraversalBackButton (copy), TraversalBackButton (copy), MenuIconContext (copy), Unibar (copy), ShopGlobalIcon (copy), FFlagExperienceShopNewIconography (copy), v59 (copy), FFlagAppNavMyStatsTab (copy), BuildExperience (copy), BuildPillMenuPortalHost (copy), HealthBar (copy), VoiceStateContext (copy), v48 (copy), default (copy), isInExperienceUIVREnabled (copy)
	local v73 = UniversalAppPolicy.useAppPolicy(function(p3) -- line: 136
		-- upvalues: FFlagAddTopBarPoliciesToUniversalPolicies (copy)
		if FFlagAddTopBarPoliciesToUniversalPolicies then
			return p3.getShowBadgeOver12()
		end

		return p3.ShowBadgeOver12 or false
	end)
	local v74 = SignalsReact.useSignalState(function(p4) -- line: 144
		-- upvalues: CoreGuiCommon (copy)
		return CoreGuiCommon.Stores.GetKeepOutAreasStore(p4)
	end)
	local v75 = SignalsReact.useSignalState(function(p5) -- line: 147
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p5).getUIScale(p5)
	end)
	local v76 = nil
	local v77 = nil
	local v78 = nil
	local v79 = nil

	if v34 then
		v76 = SignalsReact.useSignalState(getShopGlobalIconEnabled)
		v77 = SignalsReact.useSignalState(getShopGlobalStatusIndicatorEnabled)
		v78 = handleShopGlobalIconActivated
		React.useEffect(function() -- line: 159
			-- upvalues: InExperienceShop (copy)
			return InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon() or function() -- line: 161
			end
		end, {})
		v79 = (v60 or function() -- line: 163
		end)(v61)
	end

	local v80 = React.useRef(nil)
	local v81 = React.useRef(nil)
	local v82 = GamepadConnector:getShowTopBar()
	local v83, v84 = React.useBinding(v82:get())

	React.useEffect(function() -- line: 173
		-- upvalues: isSpatial (copy), GamepadConnector (copy), VRService (copy), v82 (copy), v84 (copy), v74 (copy)
		if not isSpatial() then
			GamepadConnector:connectToTopbar()
		end

		local connection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 177
			-- upvalues: isSpatial (copy), GamepadConnector (copy)
			if isSpatial() then
				GamepadConnector:disconnectFromTopbar()

				return
			end

			GamepadConnector:connectToTopbar()
		end)
		local v94 = v82:connect(function() -- line: 185
			-- upvalues: v84 (copy), v82 (copy)
			v84(v82:get())
		end)

		return function() -- line: 188
			-- upvalues: connection (copy), GamepadConnector (copy), v74 (copy), v94 (copy)
			if connection then
				connection:Disconnect()
			end

			GamepadConnector:disconnectFromTopbar()

			if v74 then
				v74.cleanup()
			end

			v94:disconnect()
		end
	end, {})

	local v85 = React.useCallback(function(p6) -- line: 200
		-- upvalues: v74 (copy), Constants (copy)
		v74.setKeepOutArea(Constants.TopBarKeepOutAreaId, p6.AbsolutePosition, p6.AbsoluteSize)
	end, { v74 })
	local v86 = Constants.ScreenSideOffset * v75
	local v87 = Constants.TopBarHeight * v75
	local v88 = Constants.TopBarButtonHeight * v75
	local v89 = Constants.TopBarTopMargin * v75

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
			JoinVoiceBinder = if not v52 then nil else React.createElement(v52),
			PartyMicBinder = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(PartyMicBinder),
			ChromeAnalytics = if not v51 then nil else React.createElement(v51)
		}),
		PlaytestTooltip = if not FFlagEnablePlaytestModeUnibar then nil else React.createElement(PlaytestModeTooltip, {
			anchorRef = v80
		}),
		TopBarFrame = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, v87)
		}, {
			TopLeftFrame = React.createElement(View, {
				tag = "anchor-top-left auto-x row gap-small",
				Size = UDim2.fromOffset(0, v88),
				onAbsoluteSizeChanged = v85,
				onAbsolutePositionChanged = v85,
				Position = UDim2.new(0, v86, 0, v89),
				Visible = v83
			}, {
				MenuIcon = if FFlagEnableSideSheet then nil else React.createElement(SelectionCursorProvider, {}, {
					Icon = React.createElement(MenuIcon, {
						showBadgeOver12 = v73,
						menuIconRef = v81,
						unibarMenuRef = v80
					})
				}),
				TraversalBackButton = if not FFlagAddTraversalBackButton then nil else React.createElement(TraversalBackButton),
				UnibarFrame = React.createElement(MenuIconContext.Provider, {
					value = {
						menuIconRef = v81
					}
				}, { React.createElement(Unibar, {
					layoutOrder = 2,
					onMinWidthChanged = function() -- line: 274
					end,
					onAreaChanged = function() -- line: 275
					end,
					menuRef = v80
				}) }),
				ShopGlobalIcon = if not v34 or (not v76 or ShopGlobalIcon == nil) then nil else React.createElement(ShopGlobalIcon, {
					layoutOrder = 3,
					buttonSize = v88,
					showStatusIndicator = v77,
					onActivated = v78,
					isActive = v79,
					icon = if FFlagExperienceShopNewIconography or (not v59 or not v61) then nil else v59("BuildingStore", nil, v61)
				})
			}),
			TopRightFrame = React.createElement(View, {
				tag = "anchor-top-right auto-x",
				Size = UDim2.fromOffset(0, v88),
				Position = UDim2.new(1, -v86, 0, v89)
			}, {
				BuildPillMenu = if not FFlagAppNavMyStatsTab or not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then nil else React.createElement(BuildPillMenuPortalHost),
				HealthBar = React.createElement(HealthBar)
			})
		}),
		VRBottomBar = if not VRService.VREnabled then nil else React.createElement(VoiceStateContext.Provider, {}, {
			VRBottomBar = VoiceStateContext.withVoiceState(function(p7) -- line: 309
				-- upvalues: React (copy), v48 (copy), default (copy), isInExperienceUIVREnabled (copy), v73 (copy)
				return React.createElement(v48, {
					voiceChatServiceManager = default,
					voiceEnabled = p7.voiceEnabled,
					voiceState = p7.voiceState,
					showBadgeOver12 = if not isInExperienceUIVREnabled then nil else v73
				})
			end)
		})
	})
end

return TopBarApp
