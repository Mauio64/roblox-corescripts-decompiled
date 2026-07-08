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
local v46 = if not isInExperienceUIVREnabled then require(ParentParentParent.VR.VRBottomBar.VRBottomBar) else require(Components.VRBottomUnibar)
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local v49 = if not game:GetEngineFeature("InGameChromeSignalAPI") then nil else require(Chrome.ChromeShared.Analytics)
local v50 = if not game:GetEngineFeature("VoiceChatSupported") or not GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then nil else require(Chrome.Integrations.JoinVoiceBinder)
local PartyMicBinder = require(Chrome.Integrations.Party.PartyMicBinder)
local Unibar = require(Chrome.ChromeShared.Unibar)
local default = require(ParentParentParent.VoiceChat.VoiceChatServiceManager).default
local VoiceStateContext = require(ParentParentParent.VoiceChat.VoiceStateContext)
local v55 = if not v33 then nil else require(Chrome.Service)
local v56 = if not v33 then nil else require(Chrome.ChromeShared.Unibar.Constants)
local v57 = if not v33 then nil else require(Chrome.Integrations.CommonIcon)
local v58 = if not v33 then nil else require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local v59 = if not v33 or (not v55 or not v56) then nil else require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal.new(v55:onIntegrationStatusChanged(), function() -- line: 87
	-- upvalues: v55 (copy), v56 (copy)
	return v55:isWindowOpen(v56.IN_EXPERIENCE_SHOP_ID)
end)
local v60 = if not v33 then nil else require(Chrome.Integrations.InExperienceShop.ShopWindowLayout).toggleInExperienceShopWindow

local function getShopGlobalIconEnabled(p1) -- line: 98
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
local function getShopGlobalStatusIndicatorEnabled(p2) -- line: 106
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
local function handleShopGlobalIconActivated() -- line: 114
	-- upvalues: v33 (copy), FFlagCenterInExperienceShopWindow (copy), v60 (copy), v55 (copy), v56 (copy)
	if not v33 then
		return
	end

	if FFlagCenterInExperienceShopWindow then
		if v60 then
			v60()

			return
		end
	elseif v55 and v56 then
		v55:toggleWindow(v56.IN_EXPERIENCE_SHOP_ID)
	end
end
local function canShowAssistantBuild() -- line: 129
	-- upvalues: BuildExperience (copy), VRService (copy)
	return BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end
local function TopBarApp(_: {[any]: any}) -- line: 133
	-- upvalues: UniversalAppPolicy (copy), FFlagAddTopBarPoliciesToUniversalPolicies (copy), SignalsReact (copy), CoreGuiCommon (copy), Display (copy), v33 (copy), getShopGlobalIconEnabled (copy), getShopGlobalStatusIndicatorEnabled (copy), handleShopGlobalIconActivated (copy), React (copy), InExperienceShop (copy), v58 (copy), v59 (copy), GamepadConnector (copy), isSpatial (copy), VRService (copy), Constants (copy), View (copy), Constants2 (copy), Songbird (copy), FFlagAddMenuNavigationToggleDialog (copy), MenuNavigationToggleDialog (copy), FFlagGamepadNavigationDialogABTest (copy), GamepadNavigationDialog (copy), v50 (copy), GetFFlagEnableCrossExpVoice (copy), PartyMicBinder (copy), v49 (copy), FFlagEnableSideSheet (copy), SelectionCursorProvider (copy), MenuIcon (copy), FFlagAddTraversalBackButton (copy), TraversalBackButton (copy), MenuIconContext (copy), Unibar (copy), ShopGlobalIcon (copy), FFlagExperienceShopNewIconography (copy), v57 (copy), FFlagAppNavMyStatsTab (copy), BuildExperience (copy), BuildPillMenuPortalHost (copy), HealthBar (copy), VoiceStateContext (copy), v46 (copy), default (copy), isInExperienceUIVREnabled (copy)
	local v71 = UniversalAppPolicy.useAppPolicy(function(p3) -- line: 134
		-- upvalues: FFlagAddTopBarPoliciesToUniversalPolicies (copy)
		if FFlagAddTopBarPoliciesToUniversalPolicies then
			return p3.getShowBadgeOver12()
		end

		return p3.ShowBadgeOver12 or false
	end)
	local v72 = SignalsReact.useSignalState(function(p4) -- line: 142
		-- upvalues: CoreGuiCommon (copy)
		return CoreGuiCommon.Stores.GetKeepOutAreasStore(p4)
	end)
	local v73 = SignalsReact.useSignalState(function(p5) -- line: 145
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p5).getUIScale(p5)
	end)
	local v74 = nil
	local v75 = nil
	local v76 = nil
	local v77 = nil

	if v33 then
		v74 = SignalsReact.useSignalState(getShopGlobalIconEnabled)
		v75 = SignalsReact.useSignalState(getShopGlobalStatusIndicatorEnabled)
		v76 = handleShopGlobalIconActivated
		React.useEffect(function() -- line: 157
			-- upvalues: InExperienceShop (copy)
			return InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon() or function() -- line: 159
			end
		end, {})
		v77 = (v58 or function() -- line: 161
		end)(v59)
	end

	local v78 = React.useRef(nil)
	local v79 = React.useRef(nil)
	local v80 = GamepadConnector:getShowTopBar()
	local v81, v82 = React.useBinding(v80:get())

	React.useEffect(function() -- line: 171
		-- upvalues: isSpatial (copy), GamepadConnector (copy), VRService (copy), v80 (copy), v82 (copy), v72 (copy)
		if not isSpatial() then
			GamepadConnector:connectToTopbar()
		end

		local connection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 175
			-- upvalues: isSpatial (copy), GamepadConnector (copy)
			if isSpatial() then
				GamepadConnector:disconnectFromTopbar()

				return
			end

			GamepadConnector:connectToTopbar()
		end)
		local v92 = v80:connect(function() -- line: 183
			-- upvalues: v82 (copy), v80 (copy)
			v82(v80:get())
		end)

		return function() -- line: 186
			-- upvalues: connection (copy), GamepadConnector (copy), v72 (copy), v92 (copy)
			if connection then
				connection:Disconnect()
			end

			GamepadConnector:disconnectFromTopbar()

			if v72 then
				v72.cleanup()
			end

			v92:disconnect()
		end
	end, {})

	local v83 = React.useCallback(function(p6) -- line: 198
		-- upvalues: v72 (copy), Constants (copy)
		v72.setKeepOutArea(Constants.TopBarKeepOutAreaId, p6.AbsolutePosition, p6.AbsoluteSize)
	end, { v72 })
	local v84 = Constants.ScreenSideOffset * v73
	local v85 = Constants.TopBarHeight * v73
	local v86 = Constants.TopBarButtonHeight * v73
	local v87 = Constants.TopBarTopMargin * v73

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
			JoinVoiceBinder = if not v50 then nil else React.createElement(v50),
			PartyMicBinder = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(PartyMicBinder),
			ChromeAnalytics = if not v49 then nil else React.createElement(v49)
		}),
		TopBarFrame = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, v85)
		}, {
			TopLeftFrame = React.createElement(View, {
				tag = "anchor-top-left auto-x row gap-small",
				Size = UDim2.fromOffset(0, v86),
				onAbsoluteSizeChanged = v83,
				onAbsolutePositionChanged = v83,
				Position = UDim2.new(0, v84, 0, v87),
				Visible = v81
			}, {
				MenuIcon = if FFlagEnableSideSheet then nil else React.createElement(SelectionCursorProvider, {}, {
					Icon = React.createElement(MenuIcon, {
						showBadgeOver12 = v71,
						menuIconRef = v79,
						unibarMenuRef = v78
					})
				}),
				TraversalBackButton = if not FFlagAddTraversalBackButton then nil else React.createElement(TraversalBackButton),
				UnibarFrame = React.createElement(MenuIconContext.Provider, {
					value = {
						menuIconRef = v79
					}
				}, { React.createElement(Unibar, {
					layoutOrder = 2,
					onMinWidthChanged = function() -- line: 267
					end,
					onAreaChanged = function() -- line: 268
					end,
					menuRef = v78
				}) }),
				ShopGlobalIcon = if not v33 or (not v74 or ShopGlobalIcon == nil) then nil else React.createElement(ShopGlobalIcon, {
					layoutOrder = 3,
					buttonSize = v86,
					showStatusIndicator = v75,
					onActivated = v76,
					isActive = v77,
					icon = if FFlagExperienceShopNewIconography or (not v57 or not v59) then nil else v57("BuildingStore", nil, v59)
				})
			}),
			TopRightFrame = React.createElement(View, {
				tag = "anchor-top-right auto-x",
				Size = UDim2.fromOffset(0, v86),
				Position = UDim2.new(1, -v84, 0, v87)
			}, {
				BuildPillMenu = if not FFlagAppNavMyStatsTab or not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then nil else React.createElement(BuildPillMenuPortalHost),
				HealthBar = React.createElement(HealthBar)
			})
		}),
		VRBottomBar = if not VRService.VREnabled then nil else React.createElement(VoiceStateContext.Provider, {}, {
			VRBottomBar = VoiceStateContext.withVoiceState(function(p7) -- line: 302
				-- upvalues: React (copy), v46 (copy), default (copy), isInExperienceUIVREnabled (copy), v71 (copy)
				return React.createElement(v46, {
					voiceChatServiceManager = default,
					voiceEnabled = p7.voiceEnabled,
					voiceState = p7.voiceState,
					showBadgeOver12 = if not isInExperienceUIVREnabled then nil else v71
				})
			end)
		})
	})
end

return TopBarApp
