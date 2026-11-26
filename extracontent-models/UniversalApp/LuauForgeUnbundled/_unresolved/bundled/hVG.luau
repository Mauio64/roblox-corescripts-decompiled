local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dzz")
local module2 = require("@luauforge/bundled/ehl")
local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local module4 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceRegistry = module4.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module5 = require("@luauforge/bundled/gIF")
local module6 = require("@luauforge/bundled/fCM")
local module7 = require("@luauforge/bundled/hVH")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local getVirtualResolutionScale = Responsive.getVirtualResolutionScale
local useIsSpatial = Responsive.useIsSpatial

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled
local module9 = require("@luauforge/bundled/hOT")
local module10 = require("@luauforge/bundled/hOV")
local module11 = require("@luauforge/bundled/hOZ")
local module12 = require("@luauforge/bundled/ghR")
local module13 = require("@luauforge/bundled/guB")

local fFlagEnableKISAConsentModalization = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableKISAConsentModalization
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local getFFlagUseUpdatedVNGAgreementsWorkflow = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseUpdatedVNGAgreementsWorkflow
local fFlagLuaAppHomeVngAppUpsell = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHomeVngAppUpsell
local getFFlagApplyResolutionScale = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagApplyResolutionScale

local getFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableInAppBugReporting

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAbuseReportRevampFlow
local fFlagEnableMagicLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMagicLogin
local fFlagEnableSystemTrayModals = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSystemTrayModals

local fFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal

local fFlagDeprecatePeopleListContextualMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeprecatePeopleListContextualMenu

local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets
local defineFastFlag = game:DefineFastFlag("RemoveCentralOverlayBackgroundSafeArea", false)

local fFlagCentralOverlayExcludeDeviceSafePadding = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCentralOverlayExcludeDeviceSafePadding

local v5 = {
	[module2.PlacesList] = true,
	[module2.PeopleList] = not fFlagDeprecatePeopleListContextualMenu or nil,
	[module2.ExperienceGuidelinesExplained] = true,
	[module2.PurchaseGame] = true,
	[module2.PurchaseGameRobuxShortfall] = true,
	[module2.LeaveRobloxAlert] = true,
	[module2.ReportLogsOverlay] = true,
	[module2.ConfirmSignOut] = true,
	[module2.UpdateRequiredPrompt] = true,
	[module2.AgreeToPhoneNumberVerification] = true,
	[module2.DevSubMore] = true,
	[module2.DevSubConfirmCancel] = true,
	[module2.TencentNoticePopup] = true,
	[module2.SignUpBirthdayPickerOverlay] = true,
	[module2.LoginPasswordResetPrompt] = true,
	[module2.LoginEmailVerificationPrompt] = true,
	[module2.EmailVerificationUpsellOverlay] = true,
	[module2.PhoneVerificationUpsellOverlay] = true,
	[module2.PhoneVerificationUpsellOverlayWrapper] = true,
	[module2.VoicePhoneVerificationUpsellOverlayWrapper] = true,
	[module2.CrossDeviceCodePrompt] = true,
	[module2.CrossDeviceLoginConfirmation] = true,
	[module2.VerifiedEnableVoice] = true,
	[module2.UserAgreementsUpdatedPopup] = true,
	[module2.VNGUserAgreementsPopup] = true,
	[module2.VerifyPhoneNumber] = true,
	[module2.AccountSecurityPromptOverlay] = true,
	[module2.CameraPermissionPrompt] = true,
	[module2.AccountAuthenticationFailureOverlay] = true,
	[module2.UserAgreementsPrompt] = true,
	[module2.UserAgreementsSecondPrompt] = true,
	[module2.SimpleTextAlertPrompt] = true,
	[module2.FindFriendsModal] = true,
	[module2.ContactsList] = true,
	[module2.IapExperienceAnimator] = true,
	[module2.DiscoverabilityUpsell] = true,
	[module2.SurveyPrompt] = true,
	[module2.GamepadDisconnected] = true,
	[module2.AccountSelector] = module9() and true or nil,
	[module2.AccountSwitcher] = true,
	[module2.EmailOtp] = module10() and true or nil,
	[module2.NewAppAvailableModal] = module11() and true or nil,
	[module2.AccountSwitchingErrorOverlay] = module12 and true or nil,
	[module2.CloseOnlyInteractiveAlert] = true,
	[module2.ConfirmationDialog] = true,
	[module2.PlayButtonUpsellDialog] = true,
	[module2.SduiOverlay] = false,
	[module2.SquadPrompt] = getFFlagIsSquadEnabled() and true or nil,
	[module2.VngContactInfoFormWebviewPopup] = true,
	[module2.VngComplianceLoadingPopup] = getFFlagUseUpdatedVNGAgreementsWorkflow() and true or nil,
	[module2.KISAPopUpAgreements] = module13 and true or nil,
	[module2.ItemsReceivedAlert] = true,
	[module2.VngAppUpsell] = fFlagLuaAppHomeVngAppUpsell and true or nil,
	[module2.GamePlayerFeedbackForm] = getFFlagEdpPlayerFeedbackEnabled() and true or nil,
	[module2.BugReporter] = getFFlagEnableInAppBugReporting() and true or nil,
	[module2.SettingsPermissionInteractiveAlert] = true,
	[module2.DynamicAbuseReport] = fFlagEnableAbuseReportRevampFlow and true or nil,
	[module2.AccountReactivationPrompt] = true,
	[module2.MagicLoginApprovePopup] = fFlagEnableMagicLogin and true or nil,
	[module2.MagicLoginRequestPopup] = fFlagEnableMagicLogin and true or nil,
	[module2.DeviceSelectorPeekView] = fFlagEnableMagicLogin and true or nil,
	[module2.AccountLinkingAlert] = true,
	[module2.EconomicRestrictionPrompt] = true,
	[module2.AccountLockModal] = true,
	[module2.UnifiedProductPurchaseModal] = true,
	[module2.NotificationsModal] = fFlagEnableSystemTrayModals and true or nil,
	[module2.SystemTrayModal] = fFlagEnableSystemTrayModals and true or nil,
	[module2.UnifiedProductPurchaseModal] = not fFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal
}

local overlayComponent = require("@luauforge/bundled/hVI").OverlayComponent

local extended = Roact.PureComponent:extend("CentralOverlay")

extended.defaultProps = { hideCentralOverlay = false }

function extended:init()
	self.defaultChildRef = Roact.createRef()
end

function extended.render(p2)
	local v6 = not getFFlagApplyResolutionScale() and 1 or getVirtualResolutionScale()
	local displayOrder = p2.props.displayOrder
	local overlayComponent2 = p2.props.overlayComponent
	local arguments = p2.props.arguments
	local v7

	if getFFlagApplyResolutionScale() then
		v7 = Vector2.new(p2.props.screenSize.X * v6, p2.props.screenSize.Y * v6)
	else
		v7 = p2.props.screenSize
	end

	local globalGuiInset = p2.props.globalGuiInset
	local shouldCreateBackgroundWrapper = p2.props.shouldCreateBackgroundWrapper

	if v7.X <= 0 or v7.Y <= 0 then
		return nil
	end

	return withStyle(function(p3)
		local v8

		if fFlagCentralOverlayExcludeDeviceSafePadding then
			v8 = getSafeAreaSize(v7, globalGuiInset, true)
		else
			v8 = getSafeAreaSize(v7, globalGuiInset)
		end

		local v9 = Colors.Black
		local v10

		if p3 then
			if p2.props.includeStatusBar then
				v8 = UDim2.new(0, v8.X.Offset, 0, v8.Y.Offset)
			end

			v9 = p3.Theme.Overlay.Color
			v10 = p3.Theme.Overlay.Transparency
		else
			v10 = 0.3
		end

		arguments = Cryo.Dictionary.join(arguments, {
			defaultChildRef = p2.defaultChildRef,
			closeCentralOverlayThunk = module6
		})
		local v11

		if shouldCreateBackgroundWrapper then
			local createElement = React.createElement

			local v14 = if not defineFastFlag then UDim2.fromOffset(0, -globalGuiInset.top) else nil
			local v13 = {
				Position = v14,
				Size = UDim2.fromOffset(v7.X, v7.Y),
				BackgroundColor3 = v9,
				BackgroundTransparency = v10,
				BorderSizePixel = 0,
				Selectable = false,
				Active = true
			}
			local v16

			if not defineFastFlag then
				local createElement2 = React.createElement
				local v18 = {
					Position = UDim2.fromOffset(0, globalGuiInset.top),
					Size = v8,
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Selectable = false
				}

				local v20 = if overlayComponent2 then React.createElement(
					overlayComponent2,
					module.JoinDictionaries(arguments, { containerWidth = v8.X.Offset })
				) else nil
				v16 = createElement2("Frame", v18, { Prompt = v20 })
			end

			local v17 = if defineFastFlag and overlayComponent2 then React.createElement(
				overlayComponent2,
				module.JoinDictionaries(arguments, { containerWidth = v8.X.Offset })
			) else nil
			v11 = createElement("Frame", v13, { SafeAreaFrame = v16, Prompt = v17 })

			if not v11 then
				v11 = if overlayComponent2 then React.createElement(overlayComponent2, arguments) else nil
			end
		elseif overlayComponent2 then
			v11 = React.createElement(overlayComponent2, arguments)
		end

		local createElement = React.createElement
		local portal = Roact.Portal

		local v14 = overlayComponent2

		if v14 then
			local createElement2 = React.createElement
			local v16 = {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ScreenInsets = 0,
				DisplayOrder = 0
			}
			local v17 = if fFlagLuaAppSupportDeviceSafeInsets then Enum.ScreenInsets.None else nil
			v16.ScreenInsets = v17
			v16.DisplayOrder = displayOrder
			v14 = createElement2(module5, v16, {
				WrappingFrame = React.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ref = p2.props.forwardRef,
					Selectable = false,
					SelectionGroup = true,
					SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
					SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
					SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				}, { OverlayComponent = v11 })
			})
		end

		return createElement(portal, { target = CoreGui }, { PortalUIForOverlay = v14 })
	end)
end

local v6 = RoactRodux.connect(function(data, p2)
	local overlayType = data.CentralOverlay.OverlayType
	local arguments = data.CentralOverlay.Arguments

	local v7 = v5[overlayType]

	if overlayType == module2.CrossDeviceCodePrompt and arguments and arguments.useFoundationSheet then
		v7 = nil
	end

	if
		fFlagEnableKISAConsentModalization
		and overlayType == module2.KISAPopUpAgreements
		and arguments
		and arguments.useFoundationSheet
	then
		v7 = nil
	end

	return {
		overlayComponent = overlayComponent[overlayType],
		shouldCreateBackgroundWrapper = v7,
		arguments = arguments,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset
	}
end, function(callback)
	return {
		closePrompt = function()
			callback(module6())
		end
	}
end)(extended)

local function fn(p2)
	if useIsSpatial() then
		return React.createElement(module7, p2)
	end

	return React.createElement(v6, p2)
end

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

return function(p2)
	local v7 = useSelector(function(p3): boolean
		return overlayComponent[p3.CentralOverlay.OverlayType] ~= nil
	end)

	local state, setState = React.useState(nil)

	local v8 = useRegisterFocusNavigableSurface()
	local v9 = useDeRegisterFocusNavigableSurface()
	React.useEffect(function()
		if state and v7 then
			v8(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
		else
			v9(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
		end
	end, { state, v7, v8, v9 })

	local v10 = useDispatch()

	local v11 = useSelector(function(p3)
		return p3.CentralOverlay.OverlayType
	end)

	local set = {
		[module2.AccountReactivationPrompt] = true,
		[module2.AccountLockModal] = true,
		[module2.AccountIneligibleLoginModal] = true
	}

	local v12 = React.useMemo(function()
		if set[v11] then
			return nil
		end

		return InputHandlers.onRelease(function(object)
			v10(module6())
			object:cancel()
		end)
	end, { v10, v11 })

	local v13 = ReactFocusNavigation.useEventMap(navigateBacks, setState)
	local v14 = ReactFocusNavigation.useEventHandler(
		focusNavigationEventNameEnum.NavigateBack,
		v12,
		nil,
		v13
	)

	return React.createElement(fn, Cryo.Dictionary.join(p2, { forwardRef = v14 }))
end
