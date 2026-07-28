local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

game:GetService("Players")

local VRService = game:GetService("VRService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local View = Foundation.View
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local Analytics = require(CorePackages.Workspace.Packages.Analytics).Analytics
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local Images = UIBlox.App.ImageSet.Images
local v26 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/controls/close-ingame"] else "icons/controls/close-ingame"
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local Songbird = require(CorePackages.Workspace.Packages.Songbird)
local Traversal = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).Traversal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon.Stores
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local Presentation = script.Parent.Presentation
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local MenuIcon = require(Presentation.MenuIcon)
local ChatIcon = require(Presentation.ChatIcon)
local MoreMenu = require(Presentation.MoreMenu)
local HealthBar = require(Presentation.HealthBar)
local HurtOverlay = require(Presentation.HurtOverlay)
local GamepadNavigationDialog = require(Presentation.GamepadNavigationDialog)
local HeadsetMenu = require(Presentation.HeadsetMenu)
local HeadsetDisconnectDialog = CoreGuiCommon.Components.HeadsetDisconnectDialog
local VoiceBetaBadge = require(Presentation.VoiceBetaBadge)
local PlaytestModeTooltip = require(Presentation.PlaytestModeTooltip)
local TraversalBackButton = require(script.Parent.TraversalBackButton)
local Chrome = script.Parent.Parent.Parent.Chrome
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local Constants2 = require(Chrome.Integrations.MusicUtility.Constants)
local PlaytestModeThemeProvider = require(Chrome.ChromeShared.Unibar.PlaytestModeThemeProvider)
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar
local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant
local v61 = game:DefineFastInt("UILessTooltipDuration", 10)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton
local v65 = game:DefineFastFlag("UseNewHeadsetDisconnectDialog", false)
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local v68 = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop
local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local ShopGlobalIcon = InExperienceShop.ShopGlobalIcon
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local Unibar = nil
local KeepOutAreasHandler = nil
local Analytics2 = nil

if Enabled() then
	Unibar = require(Chrome.ChromeShared.Unibar)
end

if game:GetEngineFeature("InGameChromeSignalAPI") then
	KeepOutAreasHandler = require(Chrome.ChromeShared.Service.KeepOutAreasHandler)

	if Enabled() then
		Analytics2 = require(Chrome.ChromeShared.Analytics)
	end
end

local LocalStore = nil
local Constants3 = nil
local CommonIcon = nil

if Enabled() then
	LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
	Constants3 = require(Chrome.ChromeShared.Unibar.Constants)

	if v68 then
		CommonIcon = require(Chrome.Integrations.CommonIcon)
	end
end

local Connection = require(script.Parent.Connection)
local ParentParent = Presentation.Parent.Parent
local Constants4 = require(ParentParent.Constants)
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)
local SetKeepOutArea = require(ParentParent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(ParentParent.Actions.RemoveKeepOutArea)
local v87 = if not Enabled() or not FFlagEnableConsoleExpControls then nil else require(script.Parent.MenuIconContext)
local GamepadMenu = nil
local GamepadConnector = nil
local FFlagAddMenuNavigationToggleDialog = nil
local MenuNavigationToggleDialog = nil

if Enabled() and FFlagEnableConsoleExpControls then
	GamepadConnector = require(script.Parent.GamepadConnector)
	FFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
	MenuNavigationToggleDialog = require(Presentation.GamepadMenu.MenuNavigationToggleDialog)
else
	GamepadMenu = require(Presentation.GamepadMenu)
end

local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local isNewTiltIconEnabled = require(RobloxGui.Modules.isNewTiltIconEnabled)
local GetFFlagBetaBadge = require(RobloxGui.Modules.Flags.GetFFlagBetaBadge)
local FFlagGamepadNavigationDialogABTest = require(ParentParent.Flags.FFlagGamepadNavigationDialogABTest)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local PartyMicBinder = require(script.Parent.Parent.Parent.Chrome.Integrations.Party.PartyMicBinder)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local JoinVoiceBinder = nil

if game:GetEngineFeature("VoiceChatSupported") and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and Enabled() then
	JoinVoiceBinder = require(script.Parent.Parent.Parent.Chrome.Integrations.JoinVoiceBinder)
end

local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local TopBarAppPolicy = require(script.Parent.Parent.TopBarAppPolicy)
local v104 = Enabled()
local v105 = if not isInExperienceUIVREnabled or not Enabled() then require(RobloxGui.Modules.VR.VRBottomBar.VRBottomBar) else require(script.Parent.VRBottomUnibar)

local function selectMenuOpen(p1) -- line: 182
	return p1.displayOptions.menuOpen or p1.displayOptions.inspectMenuOpen
end
local function canShowAssistantBuild() -- line: 186
	-- upvalues: BuildExperience (copy), VRService (copy)
	return BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end

local v108 = Roact.PureComponent:extend("TopBarApp")

v108.validateProps = t.strictInterface({
	menuOpen = if not FFlagTopBarSignalizeMenuOpen then t.optional(t.boolean) else nil,
	inspectMenuOpen = if not FFlagTopBarSignalizeMenuOpen then t.optional(t.boolean) else nil,
	displayBetaBadge = t.boolean,
	setScreenSize = if not FFlagTopBarSignalizeScreenSize then t.callback else nil,
	setKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil,
	removeKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil,
	showBadgeOver12 = t.optional(t.boolean)
})

function v108.init(p2) -- line: 205
	-- upvalues: Roact (copy), Signals (copy), Display (copy), FFlagAddUILessMode (copy), Stores (copy), FIntAddUILessModeVariant (copy), TweenService (copy), LocalStore (ref), Constants3 (ref), v61 (copy), SettingsHub (copy), Constants (copy), ContextActionService (copy), FFlagTopBarSignalizeMenuOpen (copy), SettingsShowSignal (copy), FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy), Enabled (copy), Chrome (copy), FFlagEnableConsoleExpControls (copy), GamepadConnector (ref), React (copy), v68 (copy), InExperienceShop (copy), FFlagCenterInExperienceShopWindow (copy), TextChatService (copy)
	local v114, v115 = Roact.createBinding(UDim2.new())

	p2.unibarRightSidePosition = v114
	p2.setUnibarRightSidePosition = v115

	local v116, v117 = Roact.createBinding(false)

	p2.closeButtonState = v116
	p2.setCloseButtonState = v117
	p2.disposeUiScaleEffect = Signals.createEffect(function(p3) -- line: 208
		-- upvalues: Display (copy), p2 (copy)
		local v169 = Display.GetDisplayStore(p3)

		p2:setState({
			UiScale = v169.getUIScale(p3)
		})
	end)

	if FFlagAddUILessMode then
		p2.uiLessStore = Stores.GetUILessStore(false)

		if FIntAddUILessModeVariant ~= 0 then
			local v118, v119 = Roact.createBinding(false)

			p2.uiLessTooltipVisible = v118
			p2.setUILessTooltipVisible = v119

			local v120, v121 = Roact.createBinding(0)

			p2.uiLessTooltipTransparency = v120
			p2.setUILessTooltipTransparency = v121

			function p2.fadeOutUILessTooltip() -- line: 222
				-- upvalues: p2 (copy), TweenService (copy)
				local NumberValue = Instance.new("NumberValue")

				NumberValue.Value = 0
				NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 225
					-- upvalues: p2 (copy), NumberValue (copy)
					p2.setUILessTooltipTransparency(NumberValue.Value)
				end)

				local t1 = {
					Value = 1
				}
				local tweenInfo = TweenInfo.new(0.5)

				p2.uiLessTooltipTween = TweenService:Create(NumberValue, tweenInfo, t1)
				p2.uiLessTooltipTween.Completed:Connect(function() -- line: 232
					-- upvalues: p2 (copy)
					p2.setUILessTooltipVisible(false)
					p2.uiLessTooltipTween = nil
				end)
				p2.uiLessTooltipTween:Play()
			end
			function p2.cleanupUILessTooltip() -- line: 240
				-- upvalues: p2 (copy)
				if p2.uiLessTooltipTween then
					p2.uiLessTooltipTween:Cancel()
					p2.uiLessTooltipTween = nil
				end

				if p2.uiLessTooltipTimer then
					task.cancel(p2.uiLessTooltipTimer)
					p2.uiLessTooltipTimer = nil
				end
			end

			if p2.uiLessStore.getUILessModeEnabled(false) then
				local v122 = true

				if LocalStore then
					local v123 = LocalStore.loadForLocalPlayer("NumExperiencesUserSeenUILessTooltipKey2") or 0

					v122 = v123 < Constants3.MAX_NUM_UNIVERSES_SHOWN

					if v122 then
						LocalStore.storeForLocalPlayer("NumExperiencesUserSeenUILessTooltipKey2", v123 + 1)
					end
				end

				if v122 then
					p2.setUILessTooltipVisible(true)
					p2.uiLessTooltipTimer = task.delay(v61, function() -- line: 269
						-- upvalues: p2 (copy)
						p2.fadeOutUILessTooltip()
						p2.uiLessTooltipTimer = nil
					end)
				end
			end

			ContextActionService:BindCoreAction("ToggleUILess", function(_, p5) -- line: 276
				-- upvalues: p2 (copy), FIntAddUILessModeVariant (copy), SettingsHub (copy), Constants (copy)
				if p5 ~= Enum.UserInputState.Begin then
					return
				end

				if p2.uiLessStore.getUILessModeEnabled(false) then
					if FIntAddUILessModeVariant == 1 then
						p2.uiLessStore.setUIVisible(function(p6) -- line: 283
							-- upvalues: SettingsHub (copy), Constants (copy)
							if p6 == SettingsHub:GetVisibility() then
								SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
							end

							return not p6
						end)
						p2.cleanupUILessTooltip()
						p2.setUILessTooltipVisible(false)

						return
					end

					if FIntAddUILessModeVariant == 2 then
						p2.uiLessStore.setUIVisible(function(p7) -- line: 294
							return not p7
						end)

						if SettingsHub:GetVisibility() then
							SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
						end

						p2.cleanupUILessTooltip()
						p2.setUILessTooltipVisible(false)

						return
					end
				else
					SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
				end
			end, false, Enum.KeyCode.Escape)
		end
	end

	if FFlagTopBarSignalizeMenuOpen then
		local v124, v125 = Roact.createBinding(false)

		p2.tiltMenuOpen = v124
		p2.setTiltMenuOpen = v125

		local v126, v127 = Roact.createBinding(false)

		p2.inspectMenuOpen = v126
		p2.setInspectMenuOpen = v127
		p2.inspectMenuDisposeEffect = Signals.createEffect(function(p8) -- line: 316
			-- upvalues: Stores (copy), p2 (copy)
			local v176 = Stores.GetInspectAndBuyStore(p8).getInspectAndBuyOpen(p8)

			p2.setInspectMenuOpen(v176)
		end)
		SettingsShowSignal:connect(function(p9) -- line: 321
			-- upvalues: p2 (copy)
			p2.setTiltMenuOpen(p9)
		end)
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		p2.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	function p2.onCloseBtnStateChange(_, p11) -- line: 330
		-- upvalues: p2 (copy)
		p2.setCloseButtonState(p11)
	end

	if Enabled() then
		local Service = require(Chrome.Service)

		p2:setState({
			unibarAlignment = Service:orderAlignment():get()
		})

		if FFlagEnableConsoleExpControls then
			p2.GamepadConnector = GamepadConnector
		end

		if FFlagEnableConsoleExpControls then
			p2.unibarMenuRef = React.createRef()
			p2.menuIconRef = Roact.createRef()
		end

		if v68 then
			p2.shopGlobalIconDisposeEffect = Signals.createEffect(function(p12) -- line: 349
				-- upvalues: InExperienceShop (copy), p2 (copy)
				local GetShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

				if not GetShopGlobalIconStore then
					return
				end

				local v182 = GetShopGlobalIconStore(p12)

				p2:setState({
					shopGlobalIconEnabled = v182.getEnabled(p12),
					shopGlobalStatusIndicatorEnabled = v182.getStatusIndicatorEnabled(p12)
				})
			end)

			function p2.onShopGlobalIconActivated() -- line: 360
				-- upvalues: FFlagCenterInExperienceShopWindow (copy), Chrome (copy), Service (copy), Constants3 (ref)
				if FFlagCenterInExperienceShopWindow then
					require(Chrome.Integrations.InExperienceShop.ShopWindowLayout).toggleInExperienceShopWindow()

					return
				end

				Service:toggleWindow(Constants3.IN_EXPERIENCE_SHOP_ID)
			end

			p2.shopGlobalIconCleanup = InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon()
			p2.shopIsActiveMappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 371
				-- upvalues: Service (copy), Constants3 (ref)
				return Service:isWindowOpen(Constants3.IN_EXPERIENCE_SHOP_ID)
			end)
		end
	end

	p2:setState({
		chatVersion = TextChatService.ChatVersion
	})

	if not game:IsLoaded() then
		game.Loaded:Connect(function() -- line: 385
			-- upvalues: p2 (copy), TextChatService (copy)
			p2:setState({
				chatVersion = TextChatService.ChatVersion
			})
		end)
	end
end
function v108.didMount(p13) -- line: 393
	-- upvalues: Enabled (copy), Chrome (copy), v68 (copy), Constants3 (ref), FFlagEnableConsoleExpControls (copy), isSpatial (copy), VRService (copy)
	if Enabled() then
		local Service = require(Chrome.Service)

		p13.orderAlignmentConnection = Service:orderAlignment():connect(function() -- line: 396
			-- upvalues: p13 (copy), Service (copy)
			p13:setState({
				unibarAlignment = Service:orderAlignment():get()
			})
		end)

		if v68 then
			p13.shopIsActiveConnection = Service:onIntegrationStatusChanged():connect(function() -- line: 403
				-- upvalues: p13 (copy), Service (copy), Constants3 (ref)
				p13:setState({
					shopGlobalIconIsActive = Service:isWindowOpen(Constants3.IN_EXPERIENCE_SHOP_ID)
				})
			end)
		end

		if FFlagEnableConsoleExpControls then
			if not isSpatial() then
				p13.GamepadConnector:connectToTopbar()
			end

			p13.vrEnabledConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 414
				-- upvalues: isSpatial (copy), p13 (copy)
				if isSpatial() then
					p13.GamepadConnector:disconnectFromTopbar()

					return
				end

				p13.GamepadConnector:connectToTopbar()
			end)
		end
	end
end
function v108.willUnmount(p14) -- line: 425
	-- upvalues: Enabled (copy), FFlagEnableConsoleExpControls (copy), v68 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), ContextActionService (copy), FFlagTopBarSignalizeMenuOpen (copy), FFlagTopBarSignalizeKeepOutAreas (copy)
	if Enabled() then
		if p14.orderAlignmentConnection then
			p14.orderAlignmentConnection:disconnect()
			p14.orderAlignmentConnection = nil
		end

		if FFlagEnableConsoleExpControls then
			if p14.vrEnabledConnection then
				p14.vrEnabledConnection:Disconnect()
				p14.vrEnabledConnection = nil
			end

			p14.GamepadConnector:disconnectFromTopbar()
		end
	end

	if p14.disposeUiScaleEffect then
		p14.disposeUiScaleEffect()
	end

	if v68 then
		if Enabled() and p14.shopGlobalIconDisposeEffect then
			p14.shopGlobalIconDisposeEffect()
		end

		if p14.shopIsActiveConnection then
			p14.shopIsActiveConnection:disconnect()
			p14.shopIsActiveConnection = nil
		end

		if p14.shopGlobalIconCleanup then
			p14.shopGlobalIconCleanup()
			p14.shopGlobalIconCleanup = nil
		end
	end

	if FFlagAddUILessMode then
		if p14.uiLessStore then
			p14.uiLessStore.cleanup()
		end

		if FIntAddUILessModeVariant ~= 0 then
			p14.cleanupUILessTooltip()
			ContextActionService:UnbindCoreAction("ToggleUILess")
		end
	end

	if FFlagTopBarSignalizeMenuOpen then
		if p14.tiltMenuDisposeEffect then
			p14.tiltMenuDisposeEffect()
		end

		if p14.inspectMenuDisposeEffect then
			p14.inspectMenuDisposeEffect()
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas and p14.keepOutAreasStore then
		p14.keepOutAreasStore.cleanup()
	end
end
function v108.render(p15) -- line: 487
	-- upvalues: withFoundationOrUIBloxStyle (copy)
	return withFoundationOrUIBloxStyle(function(p16) -- line: 488
		return {
			Theme = {
				Overlay = {
					Color = p16.Color.Common.Scrim.Color3,
					Transparency = p16.Color.Common.Scrim.Transparency
				},
				BackgroundOnHover = {
					Color = p16.Color.State.Hover.Color3,
					Transparency = p16.Color.State.Hover.Transparency
				},
				BackgroundOnPress = {
					Color = p16.Color.State.Press.Color3,
					Transparency = p16.Color.State.Press.Transparency
				}
			},
			Tokens = {
				Color = {
					Extended = {
						White = {
							White_100 = p16.Color.Extended.White.White_100
						}
					}
				},
				Size = {
					Size_100 = p16.Size.Size_100,
					Size_200 = p16.Size.Size_200,
					Size_300 = p16.Size.Size_300
				},
				Radius = {
					Small = p16.Radius.Small
				},
				FontSize = {
					FontSize_300 = p16.FontSize.FontSize_300
				},
				Global = {
					Color = {
						White = p16.Color.Extended.White.White_100
					},
					Space_50 = p16.Size.Size_100,
					Space_100 = p16.Size.Size_200,
					Space_150 = p16.Size.Size_300,
					FontSize_50 = p16.FontSize.FontSize_300
				},
				Semantic = {
					Radius = {
						Small = p16.Radius.Small
					}
				}
			}
		}
	end, function(p17) -- line: 539
		-- upvalues: p15 (copy)
		return p15:renderWithStyle(p17)
	end)
end
function v108.renderUnibarFrame(t2: {[any]: any}, b1: boolean) -- line: 544
	-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), FFlagEnableConsoleExpControls (copy), React (copy), v87 (copy), Unibar (ref), FFlagTopBarSignalizeKeepOutAreas (copy), Roact (copy)
	if isInExperienceUIVREnabled and isSpatial() then
		return nil
	end

	if FFlagEnableConsoleExpControls then
		return React.createElement(v87.Provider, {
			value = {
				menuIconRef = t2.menuIconRef
			}
		}, { React.createElement(Unibar, {
			layoutOrder = 1,
			onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then t2.props.setKeepOutArea else t2.keepOutAreasStore.setKeepOutArea,
			onMinWidthChanged = function(n1: number) -- line: 558
				-- upvalues: t2 (copy)
				t2.setUnibarRightSidePosition(UDim2.new(0, n1, 0, 0))
			end,
			menuRef = if not b1 then nil else t2.unibarMenuRef
		}) })
	end

	return Roact.createElement(Unibar, {
		layoutOrder = 1,
		onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then t2.props.setKeepOutArea else t2.keepOutAreasStore.setKeepOutArea,
		onMinWidthChanged = function(n2: number) -- line: 570
			-- upvalues: t2 (copy)
			t2.setUnibarRightSidePosition(UDim2.new(0, n2, 0, 0))
		end
	})
end
function v108.renderWithStyle(p18, p19) -- line: 577
	-- upvalues: Enabled (copy), GetFFlagBetaBadge (copy), Constants4 (copy), FFlagAppNavMyStatsTab (copy), BuildExperience (copy), VRService (copy), v68 (copy), Constants3 (ref), FFlagTopBarSignalizeMenuOpen (copy), TenFootInterface (copy), Roact (copy), VoiceStateContext (copy), v105 (copy), default (copy), isInExperienceUIVREnabled (copy), MenuIcon (copy), FFlagEnableConsoleExpControls (copy), FFlagTopBarSignalizeKeepOutAreas (copy), SelectionCursorProvider (copy), FFlagEnablePlaytestModeUnibar (copy), PlaytestModeThemeProvider (copy), isSpatial (copy), FFlagTopBarSignalizeScreenSize (copy), Connection (copy), PlaytestModeTooltip (copy), FFlagEnableUISelector (copy), React (copy), CoreGuiCommon (copy), GamepadMenu (ref), FFlagAddMenuNavigationToggleDialog (ref), MenuNavigationToggleDialog (ref), FFlagGamepadNavigationDialogABTest (copy), GamepadNavigationDialog (copy), v65 (copy), HeadsetDisconnectDialog (copy), HeadsetMenu (copy), KeepOutAreasHandler (ref), HurtOverlay (copy), FFlagEnableSideSheet (copy), isNewTiltIconEnabled (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), withLocalization (copy), Unibar (ref), isNewInGameMenuEnabled (copy), Interactable (copy), RobloxGui (copy), ControlState (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), v26 (copy), ImageSetButton (copy), Songbird (copy), Constants2 (copy), JoinVoiceBinder (ref), GetFFlagEnableCrossExpVoice (copy), PartyMicBinder (copy), Analytics2 (ref), FFlagAddTraversalBackButton (copy), View (copy), TraversalBackButton (copy), v104 (copy), HealthBar (copy), BuildPillMenuPortalHost (copy), ShopGlobalIcon (copy), FFlagExperienceShopNewIconography (copy), CommonIcon (ref), VoiceBetaBadge (copy), Analytics (copy), ChatIcon (copy), MoreMenu (copy)
	local v137 = Enabled()
	local v138 = GetFFlagBetaBadge() and not v137
	local displayBetaBadge = p18.props.displayBetaBadge
	local Right = Enum.HorizontalAlignment.Right

	if p18.state.unibarAlignment ~= nil then
		Right = p18.state.unibarAlignment
	end

	local u141 = Constants4.ScreenSideOffset * p18.state.UiScale
	local v142 = Constants4.TopBarHeight * p18.state.UiScale
	local v143 = Constants4.TopBarTopMargin * p18.state.UiScale
	local v144 = Constants4.TopBarPadding * p18.state.UiScale
	local v145 = if not FFlagAppNavMyStatsTab or not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then if not v68 or not p18.state.shopGlobalIconEnabled then v144 else 2 * Constants3.UNIBAR_END_PADDING * p18.state.UiScale else u141
	local v146 = Constants4.LegacyCloseMenuIconSize * p18.state.UiScale
	local v147 = Constants4.UnibarFrame.PaddingTop * p18.state.UiScale
	local v148 = Constants4.UnibarFrame.PaddingBottom * p18.state.UiScale
	local v149 = Constants4.UnibarFrame.PaddingLeft * p18.state.UiScale
	local v150 = Constants4.UnibarFrame.ExtendedSize * p18.state.UiScale
	local v151 = if not FFlagTopBarSignalizeMenuOpen then p18.props.menuOpen else p18.tiltMenuOpen

	if TenFootInterface:IsEnabled() and not Enabled() then
		u141 = Constants4.ScreenSideOffsetTenFoot
		v142 = Constants4.TopBarHeightTenFoot
	end

	local v152 = if not FFlagTopBarSignalizeMenuOpen then not (p18.props.menuOpen or p18.props.inspectMenuOpen) else Roact.joinBindings({
		p18.tiltMenuOpen,
		p18.inspectMenuOpen
	}):map(function(p20) -- line: 611
		return not (p20[0] or p20[1])
	end)
	local uDim2 = UDim2.new(0, 0, 0, v143)
	local v154 = v142 - v143
	local uDim2_2 = UDim2.new(0, u141, 0, 0)
	local uDim2_3 = UDim2.new(1, -u141, 0, 0)
	local uDim2_4 = UDim2.new(1, -u141, 0, v143)
	local uDim2_5 = UDim2.new(0, 0, 0.5, 0)
	local v159 = Roact.createElement(VoiceStateContext.Provider, {}, {
		VRBottomBar = VoiceStateContext.withVoiceState(function(p21) -- line: 625
			-- upvalues: Roact (copy), v105 (copy), default (copy), isInExperienceUIVREnabled (copy), p18 (copy)
			return Roact.createElement(v105, {
				voiceChatServiceManager = default,
				voiceEnabled = p21.voiceEnabled,
				voiceState = p21.voiceState,
				showBadgeOver12 = if not isInExperienceUIVREnabled then nil else p18.props.showBadgeOver12
			})
		end)
	})
	local v160 = Roact.createElement(MenuIcon, {
		layoutOrder = 1,
		iconScale = if not FFlagTopBarSignalizeMenuOpen then not p18.props.menuOpen and 1 or Constants4.MenuIconOpenScale else nil,
		showBadgeOver12 = p18.props.showBadgeOver12,
		menuIconRef = if not v137 or not FFlagEnableConsoleExpControls then nil else p18.menuIconRef,
		unibarMenuRef = if not v137 or not FFlagEnableConsoleExpControls then nil else p18.unibarMenuRef,
		onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then nil else p18.keepOutAreasStore.setKeepOutArea
	})
	local v161 = Roact.createElement(SelectionCursorProvider, {}, {
		Icon = v160
	})

	if FFlagEnablePlaytestModeUnibar then
		v161 = Roact.createElement(PlaytestModeThemeProvider, nil, {
			MenuIcon = v161
		})
	end

	local v162 = true

	if isInExperienceUIVREnabled then
		v162 = not isSpatial()
	end

	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = 6,
		[Roact.Change.AbsoluteSize] = not FFlagTopBarSignalizeScreenSize and function(p22) -- line: 669
			-- upvalues: p18 (copy)
			p18.props.setScreenSize(p22.AbsoluteSize)
		end or nil
	}, {
		Connection = Roact.createElement(Connection),
		PlaytestTooltip = if not FFlagEnablePlaytestModeUnibar then nil else Roact.createElement(PlaytestModeTooltip, {
			anchorRef = p18.unibarMenuRef
		}),
		InExperienceUiSelector = if not FFlagEnableUISelector then nil else React.createElement(CoreGuiCommon.Components.InExperienceUiSelector),
		GamepadMenu = if FFlagEnableConsoleExpControls then nil else Roact.createElement(GamepadMenu, {
			chatVersion = p18.state.chatVersion
		}),
		MenuNavigationToggleDialog = if not v137 or (not FFlagAddMenuNavigationToggleDialog or not FFlagEnableConsoleExpControls) then nil else Roact.createElement(MenuNavigationToggleDialog, {
			Position = UDim2.fromScale(0.5, 0.1),
			GamepadConnector = if not FFlagEnableConsoleExpControls then nil else p18.GamepadConnector
		}),
		GamepadNavigationDialog = if not FFlagGamepadNavigationDialogABTest then nil else Roact.createElement(GamepadNavigationDialog),
		HeadsetMenu = if not v65 then Roact.createElement(HeadsetMenu) else Roact.createElement(HeadsetDisconnectDialog),
		VRBottomBar = VRService.VREnabled and v159 or nil,
		KeepOutAreasHandler = if FFlagTopBarSignalizeKeepOutAreas or not KeepOutAreasHandler then nil else Roact.createElement(KeepOutAreasHandler),
		FullScreenFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = v152
		}, {
			HurtOverlay = Roact.createElement(HurtOverlay)
		}),
		MenuIconHolder = if FFlagEnableSideSheet or (not v162 or not isNewTiltIconEnabled()) then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, u141, 0, v143),
			Size = UDim2.new(1, 0, 0, v154)
		}, {
			MenuIcon = v161
		}),
		UILessTooltip = if not FFlagAddUILessMode or FIntAddUILessModeVariant == 0 then nil else withLocalization({
			uiLessTooltipTitle = Constants4.LocalizedKeys.UILessTooltipTitle,
			uiLessTooltipDescription = Constants4.LocalizedKeys.UILessTooltipDescription
		})(function(p23) -- line: 728
			-- upvalues: Roact (copy), p19 (copy), u141 (ref), v143 (copy), p18 (copy)
			return Roact.createElement("Frame", {
				BackgroundColor3 = p19.Tokens.Color.Extended.White.White_100.Color3,
				BorderSizePixel = 0,
				Position = UDim2.new(0, u141, 0, v143),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = p18.uiLessTooltipTransparency,
				Visible = p18.uiLessTooltipVisible,
				ZIndex = 10000,
				[Roact.Ref] = p18.uiLessTooltip
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, p19.Tokens.Size.Size_200),
					PaddingBottom = UDim.new(0, p19.Tokens.Size.Size_200),
					PaddingLeft = UDim.new(0, p19.Tokens.Size.Size_300),
					PaddingRight = UDim.new(0, p19.Tokens.Size.Size_300)
				}),
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, p19.Tokens.Radius.Small)
				}),
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, p19.Tokens.Size.Size_100)
				}),
				Title = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Text = p23.uiLessTooltipTitle,
					TextSize = p19.Tokens.FontSize.FontSize_300,
					TextTransparency = p18.uiLessTooltipTransparency,
					Font = Enum.Font.BuilderSansBold,
					AutomaticSize = Enum.AutomaticSize.XY
				}),
				Description = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Text = p23.uiLessTooltipDescription,
					TextSize = p19.Tokens.FontSize.FontSize_300,
					TextTransparency = p18.uiLessTooltipTransparency,
					Font = Enum.Font.BuilderSans,
					AutomaticSize = Enum.AutomaticSize.XY
				})
			})
		end),
		LegacyCloseMenu = not Unibar and (not isNewInGameMenuEnabled() and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, u141, 0, 0),
			Size = UDim2.new(1, 0, 0, v142),
			Visible = v151
		}, {
			CloseMenuButtonRound = Unibar and Roact.createElement(Interactable, {
				onStateChanged = p18.onCloseBtnStateChange,
				Visible = not TenFootInterface:IsEnabled(),
				BackgroundTransparency = p19.Theme.Overlay.Transparency,
				Position = uDim2_5,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, v146, 0, v146),
				BackgroundColor3 = p19.Theme.Overlay.Color,
				[Roact.Event.Activated] = function() -- line: 792
					-- upvalues: RobloxGui (copy)
					require(RobloxGui.Modules.Settings.SettingsHub):ToggleVisibility()
				end
			}, {
				UICorner = v137 and Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}) or nil,
				Line1 = Roact.createElement("Frame", {
					Name = "TopLine",
					BorderSizePixel = 0,
					Rotation = 45,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0, 16, 0, 2),
					BackgroundColor3 = Color3.new(1, 1, 1)
				}),
				Line2 = Roact.createElement("Frame", {
					Name = "BottomLine",
					BorderSizePixel = 0,
					Rotation = -45,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0, 16, 0, 2),
					BackgroundColor3 = Color3.new(1, 1, 1)
				}),
				StateOverlayRound = not v137 and Roact.createElement("Frame", {
					ZIndex = 2,
					BackgroundTransparency = p18.closeButtonState:map(function(p24) -- line: 822
						-- upvalues: ControlState (copy), p19 (copy)
						if p24 == ControlState.Pressed then
							return p19.Theme.BackgroundOnPress.Transparency
						end

						if p24 == ControlState.Hover then
							return p19.Theme.BackgroundOnHover.Transparency
						end

						return 1
					end),
					BackgroundColor3 = p18.closeButtonState:map(function(p25) -- line: 831
						-- upvalues: ControlState (copy), p19 (copy)
						if p25 == ControlState.Pressed then
							return p19.Theme.BackgroundOnPress.Color
						end

						if p25 == ControlState.Hover then
							return p19.Theme.BackgroundOnHover.Color
						end

						return Color3.new(1, 1, 1)
					end),
					Size = UDim2.fromScale(1, 1)
				}, {
					UICorner = v137 and Roact.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					}) or nil
				}) or nil
			}) or nil,
			CloseMenuButton = not Unibar and (if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetButton, {
				Visible = not TenFootInterface:IsEnabled(),
				BackgroundTransparency = 1,
				Position = uDim2_5,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, v146, 0, v146),
				Image = v26,
				[Roact.Event.Activated] = function() -- line: 868
					-- upvalues: RobloxGui (copy)
					require(RobloxGui.Modules.Settings.SettingsHub):ToggleVisibility()
				end
			}) else Roact.createElement(FoundationImage, {
				Visible = not TenFootInterface:IsEnabled(),
				Position = uDim2_5,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, v146, 0, v146),
				Image = v26,
				onActivated = function() -- line: 856
					-- upvalues: RobloxGui (copy)
					require(RobloxGui.Modules.Settings.SettingsHub):ToggleVisibility()
				end
			})) or nil
		})),
		SongbirdDebugAudio = Roact.createElement(Songbird.DebugAudioEmitters),
		SongbirdReportAudioFrame = Enabled() and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, Constants2.AUDIO_REPORTING_WINDOW_MIN_HEIGHT)
		}, {
			ReportAudioPopup = Roact.createElement(Songbird.ReportAudioPopup)
		}),
		UnibarLeftFrame = Unibar and (Right == Enum.HorizontalAlignment.Left and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v154),
			Position = uDim2_4,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			JoinVoiceBinder = if not v137 or not JoinVoiceBinder then nil else Roact.createElement(JoinVoiceBinder),
			PartyMicBinder = if not v137 or not GetFFlagEnableCrossExpVoice() then nil else Roact.createElement(PartyMicBinder),
			ChromeAnalytics = if not Analytics2 then nil else Roact.createElement(Analytics2),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v147),
				PaddingBottom = UDim.new(0, v148),
				PaddingLeft = UDim.new(0, v149)
			}),
			TopBarLeftContainer = FFlagAddTraversalBackButton and React.createElement(View, {
				tag = "row gap-xsmall auto-xy"
			}, {
				TraversalBackButton = if not not isInExperienceUIVREnabled and isSpatial() then nil else React.createElement(TraversalBackButton),
				UnibarFrame = p18:renderUnibarFrame(v137)
			}),
			Unibar = if FFlagAddTraversalBackButton then nil else p18:renderUnibarFrame(v137),
			HealthBar = if not v104 then nil else Roact.createElement(HealthBar, {}),
			AssistantBuildPillMenu = if not FFlagAppNavMyStatsTab or not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then nil else React.createElement(BuildPillMenuPortalHost, {
				position = UDim2.new(1, 0, 0, 0),
				anchorPoint = Vector2.new(1, 0)
			}),
			StackedElements = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = p18.unibarRightSidePosition,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v145)
				}),
				Layout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, v144),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ShopGlobalIcon = if not v68 or not p18.state.shopGlobalIconEnabled then nil else Roact.createElement(ShopGlobalIcon, {
					layoutOrder = 1,
					buttonSize = Constants4.TopBarButtonHeight * p18.state.UiScale,
					leftGap = v144,
					showStatusIndicator = p18.state.shopGlobalStatusIndicatorEnabled,
					onActivated = p18.onShopGlobalIconActivated,
					onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then p18.props.setKeepOutArea else p18.keepOutAreasStore.setKeepOutArea,
					isActive = p18.state.shopGlobalIconIsActive,
					icon = if FFlagExperienceShopNewIconography or (not CommonIcon or not p18.shopIsActiveMappedSignal) then nil else CommonIcon("BuildingStore", nil, p18.shopIsActiveMappedSignal)
				}),
				HealthBar = if not v104 then Roact.createElement(HealthBar, {
					layoutOrder = 10
				}) else nil,
				VoiceBetaBadge = if not GetFFlagBetaBadge() or not displayBetaBadge then nil else Roact.createElement(VoiceBetaBadge, {
					layoutOrder = 6,
					Analytics = Analytics.new()
				})
			})
		})) or nil,
		UnibarRightFrame = Unibar and (Right == Enum.HorizontalAlignment.Right and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v154),
			Position = uDim2_4,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			ChromeAnalytics = if not Analytics2 then nil else Roact.createElement(Analytics2),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v147),
				PaddingBottom = UDim.new(0, v148)
			}),
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, v144),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			HealthBar = Roact.createElement(HealthBar, {
				layoutOrder = 1
			}),
			Unibar = Roact.createElement(Unibar, {
				layoutOrder = 2,
				onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then p18.props.setKeepOutArea else p18.keepOutAreasStore.setKeepOutArea
			})
		})) or nil,
		TopBarFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v154),
			Visible = v152,
			Position = uDim2
		}, {
			LeftFrame = (v137 or not TenFootInterface:IsEnabled()) and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, -u141, 1, 0),
				Position = uDim2_2
			}, {
				Layout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, v144),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Blank = v137 and Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v150, 0, 1)
				}),
				MenuIcon = not isNewTiltIconEnabled() and Roact.createElement(MenuIcon, {
					layoutOrder = 1,
					showBadgeOver12 = p18.props.showBadgeOver12,
					onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then nil else p18.keepOutAreasStore.setKeepOutArea
				}),
				ChatIcon = not v137 and Roact.createElement(ChatIcon, {
					layoutOrder = 3
				}) or nil,
				VoiceBetaBadge = if not v138 or not displayBetaBadge then nil else Roact.createElement(VoiceBetaBadge, {
					layoutOrder = 4,
					Analytics = Analytics.new()
				})
			}),
			RightFrame = not Unibar and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, -u141, 1, 0),
				Position = uDim2_3,
				AnchorPoint = Vector2.new(1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, v144),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				HealthBar = Roact.createElement(HealthBar, {
					layoutOrder = 1
				}),
				MoreMenu = not TenFootInterface:IsEnabled() and Roact.createElement(MoreMenu, {
					layoutOrder = 2
				})
			}) or nil
		})
	})
end

local function mapStateToProps(p26) -- line: 1082
	-- upvalues: FFlagTopBarSignalizeMenuOpen (copy)
	if FFlagTopBarSignalizeMenuOpen then
		return nil
	end

	local inspectMenuOpen = p26.displayOptions.inspectMenuOpen

	return {
		menuOpen = p26.displayOptions.menuOpen,
		inspectMenuOpen = inspectMenuOpen
	}
end

local v110 = TopBarAppPolicy.connect(function(p27, _) -- line: 1095
	return {
		displayBetaBadge = p27.getDisplayVoiceBetaBadge(),
		showBadgeOver12 = p27.showBadgeOver12()
	}
end)(v108)

local function mapDispatchToProps(p29) -- line: 1102
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy), SetScreenSize (copy), FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy), RemoveKeepOutArea (copy)
	return {
		setScreenSize = not FFlagTopBarSignalizeScreenSize and function(p30) -- line: 1106
			-- upvalues: p29 (copy), SetScreenSize (copy)
			return p29(SetScreenSize(p30))
		end or nil,
		setKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p31, p32, p33) -- line: 1111
			-- upvalues: p29 (copy), SetKeepOutArea (copy)
			return p29(SetKeepOutArea(p31, p32, p33))
		end or nil,
		removeKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p34) -- line: 1116
			-- upvalues: p29 (copy), RemoveKeepOutArea (copy)
			return p29(RemoveKeepOutArea(p34))
		end or nil
	}
end

return RoactRodux.UNSTABLE_connect2((if not FFlagTopBarSignalizeMenuOpen then mapStateToProps else nil), mapDispatchToProps)(v110)
