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
local Image = Foundation.Image
local View = Foundation.View

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local FFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local Images = UIBlox.App.ImageSet.Images

local image = FFlagCoreUiMigrateUIBloxToFoundation and "icons/controls/close-ingame"
	or Images["icons/controls/close-ingame"]
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildModeLaunch = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.BuildModeLaunch)
local Songbird = require(CorePackages.Workspace.Packages.Songbird)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Traversal = CoreScriptsRoactCommon.Traversal

local CoreGuiCommon2 = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon2.Stores
local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local Presentation = script.Parent.Presentation
local BuildPillMenuPortalHost = BuildExperience.BuildPillMenuPortalHost
local MenuIcon = require(Presentation.MenuIcon)
local ChatIcon = require(Presentation.ChatIcon)
local MoreMenu = require(Presentation.MoreMenu)
local HealthBar = require(Presentation.HealthBar)
local HurtOverlay = require(Presentation.HurtOverlay)
local GamepadNavigationDialog = require(Presentation.GamepadNavigationDialog)
local HeadsetMenu = require(Presentation.HeadsetMenu)
local HeadsetDisconnectDialog = CoreGuiCommon2.Components.HeadsetDisconnectDialog
local PlaytestModeTooltip = require(Presentation.PlaytestModeTooltip)
local UnpublishedPlaytestModeTooltip = BuildExperience.UnpublishedPlaytestModeTooltip

local TraversalBackButton = require(script.Parent.TraversalBackButton)

local Chrome = script.Parent.Parent.Parent.Chrome

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome2.Enabled
local PlaytestModeThemeProvider = require(Chrome.ChromeShared.Unibar.PlaytestModeThemeProvider)
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar

local FFlagEnableUISelector = CoreGuiCommon2.Flags.FFlagEnableUISelector

local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon2.Flags.FFlagTopBarSignalizeKeepOutAreas

local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant
local defineFastInt = game:DefineFastInt("UILessTooltipDuration", 10)

local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon2.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon2.Flags.FFlagTopBarSignalizeScreenSize

local FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton
local defineFastFlag = game:DefineFastFlag("UseNewHeadsetDisconnectDialog", false)
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local v = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop

local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local ShopGlobalIcon = InExperienceShop.ShopGlobalIcon
local FFlagTopBarShopIconV2 = require(script.Parent.Parent.Flags.FFlagTopBarShopIconV2)
local ShopIcon

if FFlagTopBarShopIconV2 then
	ShopIcon = require(Presentation.ShopIcon)
else
	ShopIcon = nil
end

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagExperienceAgeRatingBadge = InExperienceTopBar.Flags.FFlagExperienceAgeRatingBadge
local v2 = FFlagExperienceAgeRatingBadge and FFlagShowGameAgeRating
local ExperienceAgeRatingBadge = require(CorePackages.Workspace.Packages.InExperienceTopBar.ExperienceAgeRatingBadge)
local ExperienceAgeRatingPolicy = require(script.Parent.Parent.ExperienceAgeRatingPolicy)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local v3 = isSideSheetEnabled and (FFlagShowSwitchServerButton or isPioneerLaunch())
local SwitchServer = require(CorePackages.Workspace.Packages.SwitchServer)
local SwitchServerConfirmation = SwitchServer.SwitchServerConfirmation
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore

local KeepOutAreasHandler = nil
local Analytics = nil
local Unibar

if Enabled() then
	Unibar = require(Chrome.ChromeShared.Unibar)
else
	Unibar = nil
end

if game:GetEngineFeature("InGameChromeSignalAPI") then
	KeepOutAreasHandler = require(Chrome.ChromeShared.Service.KeepOutAreasHandler)

	if Enabled() then
		Analytics = require(Chrome.ChromeShared.Analytics)
	end
end

local CommonIcon = nil
local LocalStore, Constants2

if Enabled() then
	LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
	Constants2 = require(Chrome.ChromeShared.Unibar.Constants)

	if v then
		CommonIcon = require(Chrome.Integrations.CommonIcon)
	end
else
	LocalStore = nil
	Constants2 = nil
end

local v4 = FFlagTopBarShopIconV2 and FFlagAddTraversalBackButton and Enabled()

local Connection = require(script.Parent.Connection)

local parent = Presentation.Parent.Parent
local Constants3 = require(parent.Constants)
local SetScreenSize = require(parent.Actions.SetScreenSize)
local SetKeepOutArea = require(parent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(parent.Actions.RemoveKeepOutArea)
local MenuIconContext

if Enabled() and (FFlagEnableConsoleExpControls or FFlagExperienceAgeRatingBadge) then
	MenuIconContext = require(script.Parent.MenuIconContext)
else
	MenuIconContext = nil
end

local GamepadMenu = nil
local GamepadConnector = nil
local fFlagAddMenuNavigationToggleDialog = nil
local MenuNavigationToggleDialog = nil

if Enabled() and FFlagEnableConsoleExpControls then
	GamepadConnector = require(script.Parent.GamepadConnector)
	fFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
	MenuNavigationToggleDialog = require(Presentation.GamepadMenu.MenuNavigationToggleDialog)
else
	GamepadMenu = require(Presentation.GamepadMenu)
end

local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local isNewTiltIconEnabled = require(RobloxGui.Modules.isNewTiltIconEnabled)
local FFlagGamepadNavigationDialogABTest = require(parent.Flags.FFlagGamepadNavigationDialogABTest)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local PartyMicBinder = require(script.Parent.Parent.Parent.Chrome.Integrations.Party.PartyMicBinder)

local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local JoinVoiceBinder

if
	game:GetEngineFeature("VoiceChatSupported")
	and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice()
	and Enabled()
then
	JoinVoiceBinder = require(script.Parent.Parent.Parent.Chrome.Integrations.JoinVoiceBinder)
else
	JoinVoiceBinder = nil
end

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local TopBarAppPolicy = require(script.Parent.Parent.TopBarAppPolicy)

local enabled = Enabled()
local v5

if isInExperienceUIVREnabled and Enabled() then
	v5 = require(script.Parent.VRBottomUnibar)
else
	v5 = require(RobloxGui.Modules.VR.VRBottomBar.VRBottomBar)
end

local function selectMenuOpen(p)
	return p.displayOptions.menuOpen or p.displayOptions.inspectMenuOpen
end

local function canShowAssistantBuild() -- 2 equivalent calls inferred from this helper
	return BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end

local extended = Roact.PureComponent:extend("TopBarApp")

local strictInterface = t.strictInterface
local menuOpen2

if not FFlagTopBarSignalizeMenuOpen then
	menuOpen2 = t.optional(t.boolean)
end

local inspectMenuOpen2

if not FFlagTopBarSignalizeMenuOpen then
	inspectMenuOpen2 = t.optional(t.boolean)
end

local setScreenSize

if not FFlagTopBarSignalizeScreenSize then
	setScreenSize = t.callback
end

local setKeepOutArea2

if not FFlagTopBarSignalizeKeepOutAreas then
	setKeepOutArea2 = t.callback
end

local removeKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	removeKeepOutArea = t.callback
end

extended.validateProps = strictInterface({
	menuOpen = menuOpen2,
	inspectMenuOpen = inspectMenuOpen2,
	setScreenSize = setScreenSize,
	setKeepOutArea = setKeepOutArea2,
	removeKeepOutArea = removeKeepOutArea,
	showGameAgeRating = t.optional(t.boolean)
})

function extended:init()
	local binding, setUnibarRightSidePosition = Roact.createBinding(UDim2.new())
	self.unibarRightSidePosition = binding
	self.setUnibarRightSidePosition = setUnibarRightSidePosition
	local binding2, setCloseButtonState = Roact.createBinding(false)
	self.closeButtonState = binding2
	self.setCloseButtonState = setCloseButtonState
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)

	if FFlagAddUILessMode then
		self.uiLessStore = Stores.GetUILessStore(false)

		if FIntAddUILessModeVariant ~= 0 then
			local binding3, setUILessTooltipVisible = Roact.createBinding(false)
			self.uiLessTooltipVisible = binding3
			self.setUILessTooltipVisible = setUILessTooltipVisible
			local binding4, setUILessTooltipTransparency = Roact.createBinding(0)
			self.uiLessTooltipTransparency = binding4
			self.setUILessTooltipTransparency = setUILessTooltipTransparency

			function self.fadeOutUILessTooltip()
				local numberValue = Instance.new("NumberValue")
				numberValue.Value = 0
				numberValue:GetPropertyChangedSignal("Value"):Connect(function()
					self.setUILessTooltipTransparency(numberValue.Value)
				end)
				self.uiLessTooltipTween = TweenService:Create(numberValue, TweenInfo.new(0.5), {
					Value = 1
				})

				self.uiLessTooltipTween.Completed:Connect(function()
					self.setUILessTooltipVisible(false)
					self.uiLessTooltipTween = nil
				end)

				self.uiLessTooltipTween:Play()
			end

			function self.cleanupUILessTooltip()
				if self.uiLessTooltipTween then
					self.uiLessTooltipTween:Cancel()
					self.uiLessTooltipTween = nil
				end

				if self.uiLessTooltipTimer then
					task.cancel(self.uiLessTooltipTimer)
					self.uiLessTooltipTimer = nil
				end
			end

			if self.uiLessStore.getUILessModeEnabled(false) then
				local v6

				if LocalStore then
					local v7 = LocalStore.loadForLocalPlayer("NumExperiencesUserSeenUILessTooltipKey2") or 0

					v6 = v7 < Constants2.MAX_NUM_UNIVERSES_SHOWN

					if v6 then
						LocalStore.storeForLocalPlayer("NumExperiencesUserSeenUILessTooltipKey2", v7 + 1)
					end
				else
					v6 = true
				end

				if v6 then
					self.setUILessTooltipVisible(true)
					self.uiLessTooltipTimer = task.delay(defineFastInt, function()
						self.fadeOutUILessTooltip()
						self.uiLessTooltipTimer = nil
					end)
				end
			end

			ContextActionService:BindCoreAction("ToggleUILess", function(_, p)
				if p ~= Enum.UserInputState.Begin then
					return
				end

				if self.uiLessStore.getUILessModeEnabled(false) then
					if FIntAddUILessModeVariant == 1 then
						self.uiLessStore.setUIVisible(function(p2): boolean
							if p2 == SettingsHub:GetVisibility() then
								SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
							end

							return not p2
						end)

						self.cleanupUILessTooltip()
						self.setUILessTooltipVisible(false)
					elseif FIntAddUILessModeVariant == 2 then
						self.uiLessStore.setUIVisible(function(p2): boolean
							return not p2
						end)

						if SettingsHub:GetVisibility() then
							SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
						end

						self.cleanupUILessTooltip()
						self.setUILessTooltipVisible(false)
					end
				else
					SettingsHub:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
				end
			end, false, Enum.KeyCode.Escape)
		end
	end

	if FFlagTopBarSignalizeMenuOpen then
		local binding3, setTiltMenuOpen = Roact.createBinding(false)
		self.tiltMenuOpen = binding3
		self.setTiltMenuOpen = setTiltMenuOpen
		local binding4, setInspectMenuOpen = Roact.createBinding(false)
		self.inspectMenuOpen = binding4
		self.setInspectMenuOpen = setInspectMenuOpen

		self.inspectMenuDisposeEffect = Signals.createEffect(function(p)
			local inspectAndBuyOpen = Stores.GetInspectAndBuyStore(p).getInspectAndBuyOpen(p)
			self.setInspectMenuOpen(inspectAndBuyOpen)
		end)

		SettingsShowSignal:connect(function(p)
			self.setTiltMenuOpen(p)
		end)
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		self.keepOutAreasStore = CoreGuiCommon2.Stores.GetKeepOutAreasStore(false)
	end

	if FFlagExperienceAgeRatingBadge then
		self:setState({ ageRatingSpatial = isSpatial() })
		local binding3, setAgeRatingControlsVisible = React.createBinding(true)
		self.ageRatingControlsVisible = binding3
		self.setAgeRatingControlsVisible = setAgeRatingControlsVisible
		local binding4, setAgeRatingControlsWidth = React.createBinding(0)
		self.ageRatingControlsWidth = binding4
		self.setAgeRatingControlsWidth = setAgeRatingControlsWidth
		function self.onAgeRatingControlsSizeChanged(p)
			self.setAgeRatingControlsWidth(p.AbsoluteSize.X)
		end
		function self.onAgeRatingUnibarAreaChanged(p: string, vector2: Vector2, vector2_2: Vector2)
			self.setAgeRatingControlsWidth(vector2_2.X)
			local v6

			if FFlagTopBarSignalizeKeepOutAreas then
				v6 = self.keepOutAreasStore.setKeepOutArea
			else
				v6 = self.props.setKeepOutArea
			end

			v6(p, vector2, vector2_2)
		end
		function self.onAgeRatingAreaChanged(p)
			local setKeepOutArea

			if FFlagTopBarSignalizeKeepOutAreas then
				setKeepOutArea = self.keepOutAreasStore.setKeepOutArea
			else
				setKeepOutArea = self.props.setKeepOutArea
			end

			local keepOutAreaId = ExperienceAgeRatingPolicy.keepOutAreaId
			local v6 = if p then p.AbsolutePosition else Vector2.zero
			local v7 = if p then p.AbsoluteSize else Vector2.zero
			setKeepOutArea(keepOutAreaId, v6, v7)
		end
	end

	function self.onCloseBtnStateChange(_, p)
		self.setCloseButtonState(p)
	end

	if Enabled() then
		local Service = require(Chrome.Service)
		self:setState({ unibarAlignment = Service:orderAlignment():get() })

		if FFlagEnableConsoleExpControls then
			self.GamepadConnector = GamepadConnector
		end

		if FFlagEnableConsoleExpControls then
			self.unibarMenuRef = React.createRef()
			self.menuIconRef = Roact.createRef()
		end

		if v and not v4 then
			self.shopGlobalIconDisposeEffect = Signals.createEffect(function(p)
				local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

				if not getShopGlobalIconStore then
					return
				end

				local shopGlobalIconStore = getShopGlobalIconStore(p)
				self:setState({
					shopGlobalIconEnabled = shopGlobalIconStore.getEnabled(p),
					shopGlobalStatusIndicatorEnabled = shopGlobalIconStore.getStatusIndicatorEnabled(p)
				})
			end)
			function self.onShopGlobalIconActivated()
				if not FFlagCenterInExperienceShopWindow then
					Service:toggleWindow(Constants2.IN_EXPERIENCE_SHOP_ID)

					return
				end

				local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
				ShopWindowLayout.toggleInExperienceShopWindow()
			end
			self.shopGlobalIconCleanup = InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon()
			local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
			self.shopIsActiveMappedSignal = ChromeUtils.MappedSignal.new(
				Service:onIntegrationStatusChanged(),
				function()
					return Service:isWindowOpen(Constants2.IN_EXPERIENCE_SHOP_ID)
				end
			)
		end
	end

	self:setState({ chatVersion = TextChatService.ChatVersion })

	if not game:IsLoaded() then
		game.Loaded:Connect(function()
			self:setState({ chatVersion = TextChatService.ChatVersion })
		end)
	end

	if v3 then
		self.disposeSwitchServerEffect = Signals.createEffect(function(p)
			local switchServerStore = GetSwitchServerStore(false)
			self:setState({
				shouldEnableSwitchServer = switchServerStore.shouldEnableSwitchServer(p),
				isConfirmationOpen = switchServerStore.isConfirmationOpen(p)
			})
		end)
		self.setConfirmationOpen = GetSwitchServerStore(false).setConfirmationOpen
	end
end

function extended:didMount()
	if FFlagExperienceAgeRatingBadge then
		if GamepadConnector then
			local showTopBar = GamepadConnector:getShowTopBar()
			self.ageRatingVisibilityConnection = showTopBar:connect(function()
				self.setAgeRatingControlsVisible(showTopBar:get())
			end, true)
		end

		if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and self.uiLessStore then
			self.ageRatingVisibilityEffect = Signals.createEffect(function(p)
				if self.uiLessStore.getUILessModeEnabled(p) then
					self.setAgeRatingControlsVisible(self.uiLessStore.getUIVisible(p))
				end
			end)
		end

		self.ageRatingSpatialConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
			self:setState({ ageRatingSpatial = isSpatial() })
		end)
	end

	if Enabled() then
		local Service = require(Chrome.Service)
		self.orderAlignmentConnection = Service:orderAlignment():connect(function()
			self:setState({ unibarAlignment = Service:orderAlignment():get() })
		end)

		if v and not v4 then
			self.shopIsActiveConnection = Service:onIntegrationStatusChanged():connect(function()
				self:setState({
					shopGlobalIconIsActive = Service:isWindowOpen(Constants2.IN_EXPERIENCE_SHOP_ID)
				})
			end)
		end

		if FFlagEnableConsoleExpControls then
			if not isSpatial() then
				self.GamepadConnector:connectToTopbar()
			end

			self.vrEnabledConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
				if isSpatial() then
					self.GamepadConnector:disconnectFromTopbar()
				else
					self.GamepadConnector:connectToTopbar()
				end
			end)
		end
	end
end

function extended:willUnmount()
	if self.ageRatingVisibilityConnection then
		self.ageRatingVisibilityConnection:disconnect()
	end

	if self.ageRatingVisibilityEffect then
		self.ageRatingVisibilityEffect()
	end

	if self.ageRatingSpatialConnection then
		self.ageRatingSpatialConnection:Disconnect()
	end

	if Enabled() then
		if self.orderAlignmentConnection then
			self.orderAlignmentConnection:disconnect()
			self.orderAlignmentConnection = nil
		end

		if FFlagEnableConsoleExpControls then
			if self.vrEnabledConnection then
				self.vrEnabledConnection:Disconnect()
				self.vrEnabledConnection = nil
			end

			self.GamepadConnector:disconnectFromTopbar()
		end
	end

	if self.disposeUiScaleEffect then
		self.disposeUiScaleEffect()
	end

	if v and not v4 then
		if Enabled() and self.shopGlobalIconDisposeEffect then
			self.shopGlobalIconDisposeEffect()
		end

		if self.shopIsActiveConnection then
			self.shopIsActiveConnection:disconnect()
			self.shopIsActiveConnection = nil
		end

		if self.shopGlobalIconCleanup then
			self.shopGlobalIconCleanup()
			self.shopGlobalIconCleanup = nil
		end
	end

	if FFlagAddUILessMode then
		if self.uiLessStore then
			self.uiLessStore.cleanup()
		end

		if FIntAddUILessModeVariant ~= 0 then
			self.cleanupUILessTooltip()
			ContextActionService:UnbindCoreAction("ToggleUILess")
		end
	end

	if FFlagTopBarSignalizeMenuOpen then
		if self.tiltMenuDisposeEffect then
			self.tiltMenuDisposeEffect()
		end

		if self.inspectMenuDisposeEffect then
			self.inspectMenuDisposeEffect()
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas and self.keepOutAreasStore then
		self.keepOutAreasStore.cleanup()
	end

	if v3 and self.disposeSwitchServerEffect then
		self.disposeSwitchServerEffect()
	end
end

function extended:render()
	return withFoundationOrUIBloxStyle(function(data)
		return {
			Theme = {
				Overlay = {
					Color = data.Color.Common.Scrim.Color3,
					Transparency = data.Color.Common.Scrim.Transparency
				},
				BackgroundOnHover = {
					Color = data.Color.State.Hover.Color3,
					Transparency = data.Color.State.Hover.Transparency
				},
				BackgroundOnPress = {
					Color = data.Color.State.Press.Color3,
					Transparency = data.Color.State.Press.Transparency
				}
			},
			Tokens = {
				Color = {
					Extended = {
						White = { White_100 = data.Color.Extended.White.White_100 }
					}
				},
				Size = {
					Size_100 = data.Size.Size_100,
					Size_200 = data.Size.Size_200,
					Size_300 = data.Size.Size_300
				},
				Radius = { Small = data.Radius.Small },
				FontSize = { FontSize_300 = data.FontSize.FontSize_300 },
				Global = {
					Color = { White = data.Color.Extended.White.White_100 },
					Space_50 = data.Size.Size_100,
					Space_100 = data.Size.Size_200,
					Space_150 = data.Size.Size_300,
					FontSize_50 = data.FontSize.FontSize_300
				},
				Semantic = {
					Radius = { Small = data.Radius.Small }
				}
			}
		}
	end, function(p)
		return self:renderWithStyle(p)
	end)
end

function extended:renderUnibarFrame(flag: boolean, replacesAgeRating: boolean)
	if isInExperienceUIVREnabled and isSpatial() then
		return nil
	end

	if FFlagEnableConsoleExpControls or v2 then
		local createElement = React.createElement
		local provider = MenuIconContext.Provider
		local v6 = {
			value = { menuIconRef = self.menuIconRef, replacesAgeRating = replacesAgeRating }
		}

		local createElement2 = React.createElement
		local onAreaChanged

		if v2 and not FFlagAddTraversalBackButton then
			onAreaChanged = self.onAgeRatingUnibarAreaChanged
		elseif FFlagTopBarSignalizeKeepOutAreas then
			onAreaChanged = self.keepOutAreasStore.setKeepOutArea
		else
			onAreaChanged = self.props.setKeepOutArea
		end

		local v7 = {
			layoutOrder = 1,
			onAreaChanged = onAreaChanged,
			onMinWidthChanged = not v4 and function(p: number)
				self.setUnibarRightSidePosition(UDim2.new(0, p, 0, 0))
			end or nil,
			menuRef = 0
		}
		local menuRef

		if flag then
			menuRef = self.unibarMenuRef
		end

		v7.menuRef = menuRef
		return createElement(provider, v6, { createElement2(Unibar, v7) })
	else
		local createElement = Roact.createElement
		local onAreaChanged

		if FFlagTopBarSignalizeKeepOutAreas then
			onAreaChanged = self.keepOutAreasStore.setKeepOutArea
		else
			onAreaChanged = self.props.setKeepOutArea
		end

		return createElement(Unibar, {
			layoutOrder = 1,
			onAreaChanged = onAreaChanged,
			onMinWidthChanged = not v4 and function(p: number)
				self.setUnibarRightSidePosition(UDim2.new(0, p, 0, 0))
			end or nil
		})
	end
end

function extended:renderWithStyle(p)
	local enabled2 = Enabled()

	local v6 = Enum.HorizontalAlignment.Right

	if self.state.unibarAlignment ~= nil then
		v6 = self.state.unibarAlignment
	end

	local isEligible = ExperienceAgeRatingPolicy.isEligible
	local showGameAgeRating = self.props.showGameAgeRating

	local v7 = v6 == Enum.HorizontalAlignment.Left
	local v8

	if FFlagExperienceAgeRatingBadge then
		v8 = self.state.ageRatingSpatial
	else
		v8 = isSpatial()
	end

	local eligible = isEligible(showGameAgeRating, enabled2, v7, v8)

	local v9 = Constants3.ScreenSideOffset * self.state.UiScale
	local v10 = Constants3.TopBarHeight * self.state.UiScale
	local v11 = Constants3.TopBarTopMargin * self.state.UiScale
	local leftGap = Constants3.TopBarPadding * self.state.UiScale
	local v12

	if eligible and not v4 then
		v12 = v and self.state.shopGlobalIconEnabled and 0 or leftGap
	elseif FFlagAppNavMyStatsTab and canShowAssistantBuild() then -- inferred equivalent call
		v12 = v9
	elseif v4 or not (v and self.state.shopGlobalIconEnabled) then
		v12 = leftGap
	else
		v12 = 2 * Constants2.UNIBAR_END_PADDING * self.state.UiScale
	end

	local v13 = Constants3.LegacyCloseMenuIconSize * self.state.UiScale
	local v14 = Constants3.UnibarFrame.PaddingTop * self.state.UiScale
	local v15 = Constants3.UnibarFrame.PaddingBottom * self.state.UiScale
	local v16 = Constants3.UnibarFrame.PaddingLeft * self.state.UiScale
	local v17 = Constants3.UnibarFrame.ExtendedSize * self.state.UiScale
	local visible2

	if FFlagTopBarSignalizeMenuOpen then
		visible2 = self.tiltMenuOpen
	else
		visible2 = self.props.menuOpen
	end

	if TenFootInterface:IsEnabled() and not Enabled() then
		v9 = Constants3.ScreenSideOffsetTenFoot
		v10 = Constants3.TopBarHeightTenFoot
	end

	local v18

	if FFlagTopBarSignalizeMenuOpen then
		v18 = Roact.joinBindings({ self.tiltMenuOpen, self.inspectMenuOpen }):map(function(list): boolean
			return not (list[0] or list[1])
		end)
	else
		local menuOpen = self.props.menuOpen or self.props.inspectMenuOpen
		v18 = not menuOpen
	end

	local udim = UDim2.new(0, 0, 0, v11)
	local v19 = v10 - v11
	local udim2 = UDim2.new(0, v9, 0, 0)
	local udim3 = UDim2.new(1, -v9, 0, 0)
	local udim4 = UDim2.new(1, -v9, 0, v11)
	local udim5 = UDim2.new(0, 0, 0.5, 0)

	local element = Roact.createElement(VoiceStateContext.Provider, {}, {
		VRBottomBar = VoiceStateContext.withVoiceState(function(p2)
			local createElement = Roact.createElement
			local v20 = {
				voiceChatServiceManager = default,
				voiceEnabled = p2.voiceEnabled,
				voiceState = p2.voiceState,
				showBadgeOver12 = 0
			}
			local showBadgeOver

			if isInExperienceUIVREnabled then
				showBadgeOver = self.props.showGameAgeRating
			end

			v20.showBadgeOver12 = showBadgeOver
			return createElement(v5, v20)
		end)
	})

	local createElement = Roact.createElement
	local iconScale

	if not FFlagTopBarSignalizeMenuOpen then
		iconScale = not self.props.menuOpen and 1 or Constants3.MenuIconOpenScale
	end

	local v20 = {
		iconScale = iconScale,
		layoutOrder = 1,
		showBadgeOver12 = self.props.showGameAgeRating and not eligible,
		menuIconRef = 0,
		unibarMenuRef = 0,
		onAreaChanged = 0
	}
	local menuIconRef

	if enabled2 and FFlagEnableConsoleExpControls then
		menuIconRef = self.menuIconRef
	end

	v20.menuIconRef = menuIconRef
	local unibarMenuRef

	if enabled2 and FFlagEnableConsoleExpControls then
		unibarMenuRef = self.unibarMenuRef
	end

	v20.unibarMenuRef = unibarMenuRef
	local onAreaChanged

	if FFlagTopBarSignalizeKeepOutAreas then
		onAreaChanged = self.keepOutAreasStore.setKeepOutArea
	end

	v20.onAreaChanged = onAreaChanged
	local element2 = createElement(MenuIcon, v20)

	local menuIcon = Roact.createElement(SelectionCursorProvider, {}, { Icon = element2 })

	if FFlagEnablePlaytestModeUnibar then
		menuIcon = Roact.createElement(PlaytestModeThemeProvider, nil, { MenuIcon = menuIcon })
	end

	local v21 = not isInExperienceUIVREnabled or not isSpatial()
	local ageRating

	if eligible then
		ageRating = React.createElement(View, {
			tag = "row align-y-center auto-x",
			Size = UDim2.fromOffset(0, Constants3.TopBarButtonHeight * self.state.UiScale),
			LayoutOrder = 3,
			padding = v4 and {
				left = self.ageRatingControlsVisible:map(function(p2)
					return UDim.new(0, not p2 and 0 or leftGap)
				end)
			} or nil,
			ref = self.onAgeRatingAreaChanged,
			onAbsoluteSizeChanged = self.onAgeRatingAreaChanged,
			onAbsolutePositionChanged = self.onAgeRatingAreaChanged
		}, {
			Badge = React.createElement(ExperienceAgeRatingBadge, {
				universeId = tostring(game.GameId)
			})
		})
	end

	local createElement2 = Roact.createElement
	local v22 = {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = 6,
		[Roact.Change.AbsoluteSize] = not FFlagTopBarSignalizeScreenSize and function(p2)
			self.props.setScreenSize(p2.AbsoluteSize)
		end or nil
	}
	local children = {
		Connection = Roact.createElement(Connection),
		PlaytestTooltip = 0,
		UnpublishedPlaytestTooltip = 0,
		InExperienceUiSelector = 0,
		GamepadMenu = 0,
		MenuNavigationToggleDialog = 0,
		GamepadNavigationDialog = 0,
		SwitchServerConfirmation = 0,
		HeadsetMenu = 0,
		VRBottomBar = 0,
		KeepOutAreasHandler = 0,
		FullScreenFrame = 0,
		MenuIconHolder = 0,
		UILessTooltip = 0,
		LegacyCloseMenu = 0,
		SongbirdDebugAudio = 0,
		UnibarLeftFrame = 0,
		UnibarRightFrame = 0,
		TopBarFrame = 0
	}
	local playtestTooltip

	if FFlagEnablePlaytestModeUnibar then
		playtestTooltip = Roact.createElement(PlaytestModeTooltip, {
			anchorRef = self.unibarMenuRef
		})
	end

	children.PlaytestTooltip = playtestTooltip
	local unpublishedPlaytestTooltip

	if FFlagEnableTeamTestLua then
		unpublishedPlaytestTooltip = Roact.createElement(UnpublishedPlaytestModeTooltip, {
			anchorRef = self.unibarMenuRef,
			isVisible = v18
		})
	end

	children.UnpublishedPlaytestTooltip = unpublishedPlaytestTooltip
	local inExperienceUiSelector

	if FFlagEnableUISelector then
		inExperienceUiSelector = React.createElement(CoreGuiCommon2.Components.InExperienceUiSelector)
	end

	children.InExperienceUiSelector = inExperienceUiSelector
	local gamepadMenu

	if not FFlagEnableConsoleExpControls then
		gamepadMenu = Roact.createElement(GamepadMenu, { chatVersion = self.state.chatVersion })
	end

	children.GamepadMenu = gamepadMenu
	local menuNavigationToggleDialog

	if enabled2 and fFlagAddMenuNavigationToggleDialog and FFlagEnableConsoleExpControls then
		local createElement3 = Roact.createElement
		local v23 = { Position = UDim2.fromScale(0.5, 0.1), GamepadConnector = 0 }
		local gamepadConnector

		if FFlagEnableConsoleExpControls then
			gamepadConnector = self.GamepadConnector
		end

		v23.GamepadConnector = gamepadConnector
		menuNavigationToggleDialog = createElement3(MenuNavigationToggleDialog, v23)
	end

	children.MenuNavigationToggleDialog = menuNavigationToggleDialog
	local gamepadNavigationDialog

	if FFlagGamepadNavigationDialogABTest then
		gamepadNavigationDialog = Roact.createElement(GamepadNavigationDialog)
	end

	children.GamepadNavigationDialog = gamepadNavigationDialog
	local switchServerConfirmation

	if v3 and self.state.shouldEnableSwitchServer and self.state.isConfirmationOpen then
		switchServerConfirmation = React.createElement(SwitchServerConfirmation, {
			setSwitchServerConfirmationOpen = self.setConfirmationOpen
		})
	end

	children.SwitchServerConfirmation = switchServerConfirmation
	local headsetMenu

	if defineFastFlag then
		headsetMenu = Roact.createElement(HeadsetDisconnectDialog)
	else
		headsetMenu = Roact.createElement(HeadsetMenu)
	end

	children.HeadsetMenu = headsetMenu

	children.VRBottomBar = VRService.VREnabled and element or nil
	local keepOutAreasHandler

	if not (FFlagTopBarSignalizeKeepOutAreas or not KeepOutAreasHandler) then
		keepOutAreasHandler = Roact.createElement(KeepOutAreasHandler)
	end

	children.KeepOutAreasHandler = keepOutAreasHandler

	children.FullScreenFrame = Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = v18 },
		{
			HurtOverlay = Roact.createElement(HurtOverlay)
		}
	)
	local menuIconHolder

	if not (isSideSheetEnabled or not (v21 and isNewTiltIconEnabled())) then
		menuIconHolder = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.new(0, v9, 0, v11),
				Size = UDim2.new(1, 0, 0, v19)
			},
			{ MenuIcon = menuIcon }
		)
	end

	children.MenuIconHolder = menuIconHolder
	local uiLessTooltip

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 then
		uiLessTooltip = withLocalization({
			uiLessTooltipTitle = Constants3.LocalizedKeys.UILessTooltipTitle,
			uiLessTooltipDescription = Constants3.LocalizedKeys.UILessTooltipDescription
		})(function(p2)
			return Roact.createElement("Frame", {
				BackgroundColor3 = p.Tokens.Color.Extended.White.White_100.Color3,
				BorderSizePixel = 0,
				Position = UDim2.new(0, v9, 0, v11),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = self.uiLessTooltipTransparency,
				Visible = self.uiLessTooltipVisible,
				ZIndex = 10000,
				[Roact.Ref] = self.uiLessTooltip
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, p.Tokens.Size.Size_200),
					PaddingBottom = UDim.new(0, p.Tokens.Size.Size_200),
					PaddingLeft = UDim.new(0, p.Tokens.Size.Size_300),
					PaddingRight = UDim.new(0, p.Tokens.Size.Size_300)
				}),
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, p.Tokens.Radius.Small)
				}),
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, p.Tokens.Size.Size_100)
				}),
				Title = Roact.createElement("TextLabel", {
					Text = p2.uiLessTooltipTitle,
					TextSize = p.Tokens.FontSize.FontSize_300,
					TextTransparency = self.uiLessTooltipTransparency,
					Font = Enum.Font.BuilderSansBold,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1
				}),
				Description = Roact.createElement("TextLabel", {
					Text = p2.uiLessTooltipDescription,
					TextSize = p.Tokens.FontSize.FontSize_300,
					TextTransparency = self.uiLessTooltipTransparency,
					Font = Enum.Font.BuilderSans,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2
				})
			})
		end)
	end

	children.UILessTooltip = uiLessTooltip

	local legacyCloseMenu = not (Unibar or isNewInGameMenuEnabled())

	if legacyCloseMenu then
		local createElement3 = Roact.createElement
		local v23 = {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, v9, 0, 0),
			Size = UDim2.new(1, 0, 0, v10),
			Visible = visible2
		}
		local closeMenuButtonRound

		if Unibar then
			local createElement4 = Roact.createElement
			local v24 = {
				onStateChanged = self.onCloseBtnStateChange,
				Visible = not TenFootInterface:IsEnabled(),
				BackgroundTransparency = p.Theme.Overlay.Transparency,
				Position = udim5,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, v13, 0, v13),
				BackgroundColor3 = p.Theme.Overlay.Color,
				[Roact.Event.Activated] = function()
					local SettingsHub2 = require(RobloxGui.Modules.Settings.SettingsHub)
					SettingsHub2:ToggleVisibility()
				end
			}
			local v25 = {
				UICorner = enabled2 and Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}) or nil,
				Line1 = Roact.createElement("Frame", {
					Name = "TopLine",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0, 16, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(1, 1, 1),
					Rotation = 45
				}),
				Line2 = Roact.createElement("Frame", {
					Name = "BottomLine",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0, 16, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(1, 1, 1),
					Rotation = -45
				}),
				StateOverlayRound = 0
			}
			local stateOverlayRound

			if not enabled2 then
				stateOverlayRound = Roact.createElement("Frame", {
					BackgroundTransparency = self.closeButtonState:map(function(p2)
						if p2 == ControlState.Pressed then
							return p.Theme.BackgroundOnPress.Transparency
						end

						if p2 == ControlState.Hover then
							return p.Theme.BackgroundOnHover.Transparency
						end

						return 1
					end),
					BackgroundColor3 = self.closeButtonState:map(function(p2)
						if p2 == ControlState.Pressed then
							return p.Theme.BackgroundOnPress.Color
						end

						if p2 == ControlState.Hover then
							return p.Theme.BackgroundOnHover.Color
						end

						return Color3.new(1, 1, 1)
					end),
					Size = UDim2.fromScale(1, 1),
					ZIndex = 2
				}, {
					UICorner = enabled2 and Roact.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					}) or nil
				}) or nil
			end

			v25.StateOverlayRound = stateOverlayRound
			closeMenuButtonRound = createElement4(Interactable, v24, v25) or nil
		end

		local closeMenuButton

		if not Unibar then
			local v24

			if FFlagCoreUiMigrateUIBloxToFoundation then
				v24 = Roact.createElement(Image, {
					Visible = not TenFootInterface:IsEnabled(),
					Position = udim5,
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, v13, 0, v13),
					Image = image,
					onActivated = function()
						local SettingsHub2 = require(RobloxGui.Modules.Settings.SettingsHub)
						SettingsHub2:ToggleVisibility()
					end
				})
			else
				v24 = Roact.createElement(ImageSetButton, {
					Visible = not TenFootInterface:IsEnabled(),
					BackgroundTransparency = 1,
					Position = udim5,
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, v13, 0, v13),
					Image = image,
					[Roact.Event.Activated] = function()
						local SettingsHub2 = require(RobloxGui.Modules.Settings.SettingsHub)
						SettingsHub2:ToggleVisibility()
					end
				})
			end

			closeMenuButton = v24 or nil
		end

		legacyCloseMenu = createElement3("Frame", v23, {
			CloseMenuButtonRound = closeMenuButtonRound,
			CloseMenuButton = closeMenuButton
		})
	end

	children.LegacyCloseMenu = legacyCloseMenu

	children.SongbirdDebugAudio = Roact.createElement(Songbird.DebugAudioEmitters)
	local unibarLeftFrame

	if Unibar and v6 == Enum.HorizontalAlignment.Left then
		local createElement3 = Roact.createElement

		local v23 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v19),
			Position = udim4,
			AnchorPoint = Vector2.new(1, 0)
		}
		local joinVoiceBinder

		if enabled2 and JoinVoiceBinder then
			joinVoiceBinder = Roact.createElement(JoinVoiceBinder)
		end

		local partyMicBinder

		if enabled2 and GetFFlagEnableCrossExpVoice() then
			partyMicBinder = Roact.createElement(PartyMicBinder)
		end

		local chromeAnalytics

		if Analytics then
			chromeAnalytics = Roact.createElement(Analytics)
		end

		local createElement4 = Roact.createElement
		local v24 = {
			PaddingTop = UDim.new(0, v14),
			PaddingBottom = UDim.new(0, v15),
			PaddingLeft = 0
		}
		local paddingLeft

		if eligible then
			paddingLeft = self.ageRatingControlsVisible:map(function(p2)
				local v25

				if p2 then
					v25 = v16
				else
					v25 = 2 * v9
				end

				return UDim.new(0, v25)
			end)
		else
			paddingLeft = UDim.new(0, v16)
		end

		v24.PaddingLeft = paddingLeft
		local children2 = {
			JoinVoiceBinder = joinVoiceBinder,
			PartyMicBinder = partyMicBinder,
			ChromeAnalytics = chromeAnalytics,
			Padding = createElement4("UIPadding", v24),
			TopBarLeftContainer = 0,
			Unibar = 0,
			HealthBar = 0,
			AssistantBuildPillMenu = 0,
			StackedElements = 0
		}

		local topBarLeftContainer = FFlagAddTraversalBackButton

		if topBarLeftContainer then
			if v4 then
				local createElement5 = React.createElement

				local createElement6 = React.createElement
				local traversalBackButton

				if FFlagAddTraversalBackButton and not (isInExperienceUIVREnabled and isSpatial()) then
					traversalBackButton = React.createElement(TraversalBackButton)
				end

				local children3 = {
					PaddedControlRow = createElement6(View, {
						tag = "row gap-xsmall auto-xy",
						LayoutOrder = 1
					}, {
						TraversalBackButton = traversalBackButton,
						UnibarFrame = self:renderUnibarFrame(enabled2, eligible)
					}),
					ShopIcon = 0,
					AgeRating = 0
				}

				local createElement7 = React.createElement
				local v25 = {
					layoutOrder = 2,
					buttonSize = Constants3.TopBarButtonHeight * self.state.UiScale,
					leftGap = leftGap,
					onAreaChanged = 0
				}
				local onAreaChanged2

				if FFlagTopBarSignalizeKeepOutAreas then
					onAreaChanged2 = self.keepOutAreasStore.setKeepOutArea
				else
					onAreaChanged2 = self.props.setKeepOutArea
				end

				v25.onAreaChanged = onAreaChanged2
				children3.ShopIcon = createElement7(ShopIcon, v25)

				children3.AgeRating = ageRating
				topBarLeftContainer = createElement5(View, { tag = "row auto-xy" }, children3)
			else
				local createElement5 = React.createElement
				local onAbsoluteSizeChanged

				if v2 then
					onAbsoluteSizeChanged = self.onAgeRatingControlsSizeChanged
				end

				local traversalBackButton

				if FFlagAddTraversalBackButton and not (isInExperienceUIVREnabled and isSpatial()) then
					traversalBackButton = React.createElement(TraversalBackButton)
				end

				topBarLeftContainer = createElement5(
					View,
					{
						tag = "row gap-xsmall auto-xy",
						onAbsoluteSizeChanged = onAbsoluteSizeChanged
					},
					{
						TraversalBackButton = traversalBackButton,
						UnibarFrame = self:renderUnibarFrame(enabled2, eligible)
					}
				)
			end
		end

		children2.TopBarLeftContainer = topBarLeftContainer
		local unibar

		if not FFlagAddTraversalBackButton then
			unibar = self:renderUnibarFrame(enabled2, eligible)
		end

		children2.Unibar = unibar
		local healthBar

		if enabled then
			healthBar = Roact.createElement(HealthBar, {})
		end

		children2.HealthBar = healthBar
		local assistantBuildPillMenu

		if FFlagAppNavMyStatsTab and canShowAssistantBuild() then -- inferred equivalent call
			assistantBuildPillMenu = React.createElement(BuildPillMenuPortalHost, {
				position = UDim2.new(1, 0, 0, 0),
				anchorPoint = Vector2.new(1, 0)
			})
		end

		children2.AssistantBuildPillMenu = assistantBuildPillMenu

		local createElement5 = Roact.createElement
		local position

		if eligible and not v4 then
			position = Roact.joinBindings({
				width = self.ageRatingControlsWidth,
				visible = self.ageRatingControlsVisible
			}):map(function(p2)
				return UDim2.fromOffset(not (FFlagAddTraversalBackButton or p2.visible) and 0 or p2.width, 0)
			end)
		else
			position = self.unibarRightSidePosition
		end

		local v25 = {
			BackgroundTransparency = 1,
			Position = position,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local createElement6 = Roact.createElement
		local paddingLeft2

		if eligible and not v4 then
			paddingLeft2 = Roact.joinBindings({
				visible = self.ageRatingControlsVisible,
				width = self.ageRatingControlsWidth
			}):map(function(p2)
				local visible = p2.visible or FFlagAddTraversalBackButton and p2.width > 0
				return UDim.new(0, not visible and 0 or v12)
			end)
		else
			paddingLeft2 = UDim.new(0, v12)
		end

		local children3 = {
			Padding = createElement6("UIPadding", { PaddingLeft = paddingLeft2 }),
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, leftGap),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ShopGlobalIcon = 0,
			AgeRating = 0,
			HealthBar = 0
		}
		local shopGlobalIcon

		if not (v4 or not (v and self.state.shopGlobalIconEnabled)) then
			local createElement7 = Roact.createElement
			local v26 = {
				buttonSize = Constants3.TopBarButtonHeight * self.state.UiScale,
				layoutOrder = 1,
				leftGap = leftGap,
				showStatusIndicator = self.state.shopGlobalStatusIndicatorEnabled,
				onActivated = self.onShopGlobalIconActivated,
				onAreaChanged = 0,
				isActive = 0,
				icon = 0
			}
			local onAreaChanged2

			if FFlagTopBarSignalizeKeepOutAreas then
				onAreaChanged2 = self.keepOutAreasStore.setKeepOutArea
			else
				onAreaChanged2 = self.props.setKeepOutArea
			end

			v26.onAreaChanged = onAreaChanged2

			v26.isActive = self.state.shopGlobalIconIsActive
			local icon

			if not (FFlagExperienceShopNewIconography or not (CommonIcon and self.shopIsActiveMappedSignal)) then
				icon = CommonIcon("BuildingStore", nil, self.shopIsActiveMappedSignal)
			end

			v26.icon = icon
			shopGlobalIcon = createElement7(ShopGlobalIcon, v26)
		end

		children3.ShopGlobalIcon = shopGlobalIcon

		if v4 then
			ageRating = nil
		end

		children3.AgeRating = ageRating
		local healthBar2

		if not enabled then
			healthBar2 = Roact.createElement(HealthBar, { layoutOrder = 10 })
		end

		children3.HealthBar = healthBar2
		children2.StackedElements = createElement5("Frame", v25, children3)
		unibarLeftFrame = createElement3("Frame", v23, children2) or nil
	end

	children.UnibarLeftFrame = unibarLeftFrame
	local unibarRightFrame

	if Unibar and v6 == Enum.HorizontalAlignment.Right then
		local createElement3 = Roact.createElement
		local v23 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v19),
			Position = udim4,
			AnchorPoint = Vector2.new(1, 0)
		}
		local chromeAnalytics

		if Analytics then
			chromeAnalytics = Roact.createElement(Analytics)
		end

		local children2 = {
			ChromeAnalytics = chromeAnalytics,
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v14),
				PaddingBottom = UDim.new(0, v15)
			}),
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, leftGap),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			HealthBar = Roact.createElement(HealthBar, { layoutOrder = 1 }),
			Unibar = 0
		}

		local createElement4 = Roact.createElement
		local onAreaChanged2

		if FFlagTopBarSignalizeKeepOutAreas then
			onAreaChanged2 = self.keepOutAreasStore.setKeepOutArea
		else
			onAreaChanged2 = self.props.setKeepOutArea
		end

		children2.Unibar = createElement4(Unibar, {
			onAreaChanged = onAreaChanged2,
			layoutOrder = 2
		})
		unibarRightFrame = createElement3("Frame", v23, children2) or nil
	end

	children.UnibarRightFrame = unibarRightFrame

	local createElement3 = Roact.createElement
	local v23 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v19),
		Visible = v18,
		Position = udim
	}

	local leftFrame = enabled2 or not TenFootInterface:IsEnabled() or FFlagResponsiveUnitsDeprecateTenFoot

	if leftFrame then
		local createElement4 = Roact.createElement
		local v24 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -v9, 1, 0),
			Position = udim2
		}

		local v25 = {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, leftGap),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Blank = enabled2 and Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(0, v17, 0, 1),
				BackgroundTransparency = 1
			}),
			MenuIcon = 0,
			ChatIcon = 0
		}

		local menuIcon2 = not isNewTiltIconEnabled()

		if menuIcon2 then
			local createElement5 = Roact.createElement
			local v26 = {
				layoutOrder = 1,
				showBadgeOver12 = self.props.showGameAgeRating and not eligible,
				onAreaChanged = 0
			}
			local onAreaChanged2

			if FFlagTopBarSignalizeKeepOutAreas then
				onAreaChanged2 = self.keepOutAreasStore.setKeepOutArea
			end

			v26.onAreaChanged = onAreaChanged2
			menuIcon2 = createElement5(MenuIcon, v26)
		end

		v25.MenuIcon = menuIcon2
		local chatIcon

		if not enabled2 then
			chatIcon = Roact.createElement(ChatIcon, { layoutOrder = 3 }) or nil
		end

		v25.ChatIcon = chatIcon
		leftFrame = createElement4("Frame", v24, v25)
	end

	local rightFrame

	if not Unibar then
		rightFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -v9, 1, 0),
			Position = udim3,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, leftGap),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			HealthBar = Roact.createElement(HealthBar, { layoutOrder = 1 }),
			MoreMenu = not TenFootInterface:IsEnabled() and Roact.createElement(MoreMenu, {
				layoutOrder = 2
			})
		}) or nil
	end

	children.TopBarFrame = createElement3("Frame", v23, {
		LeftFrame = leftFrame,
		RightFrame = rightFrame
	})
	return createElement2("ScreenGui", v22, children)
end

local function mapStateToProps(p)
	if FFlagTopBarSignalizeMenuOpen then
		return nil
	end

	local inspectMenuOpen = p.displayOptions.inspectMenuOpen

	return { menuOpen = p.displayOptions.menuOpen, inspectMenuOpen = inspectMenuOpen }
end

local v6

if FFlagShowGameAgeRating then
	v6 = UniversalAppPolicy.UniversalAppPolicy.connect(function(p, _)
		return { showGameAgeRating = p.getShowGameAgeRating() }
	end)(extended)
else
	v6 = TopBarAppPolicy.connect(function(p, _)
		return { showGameAgeRating = p.showBadgeOver12() }
	end)(extended)
end

local function mapDispatchToProps(callback)
	return {
		setScreenSize = not FFlagTopBarSignalizeScreenSize and function(p)
			return callback(SetScreenSize(p))
		end or nil,
		setKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p, p2, p3)
			return callback(SetKeepOutArea(p, p2, p3))
		end or nil,
		removeKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p)
			return callback(RemoveKeepOutArea(p))
		end or nil
	}
end

local UNSTABLE_connect2 = RoactRodux.UNSTABLE_connect2

if FFlagTopBarSignalizeMenuOpen then
	mapStateToProps = nil
end

return UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v6)
