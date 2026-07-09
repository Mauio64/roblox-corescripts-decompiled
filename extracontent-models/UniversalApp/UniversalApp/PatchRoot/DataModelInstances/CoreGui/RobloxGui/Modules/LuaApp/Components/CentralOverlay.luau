local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local Immutable = require(Modules.Common.Immutable)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local Colors = require(Modules.LuaApp.Themes.Colors)
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local VRCentralOverlay = require(Modules.LuaApp.Components.CrossPlatformCompatibility.VRCentralOverlay)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local getVirtualResolutionScale = Responsive.getVirtualResolutionScale
local useIsSpatial = Responsive.useIsSpatial
local GetFFlagEdpPlayerFeedbackEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled
local GetFFlagEnableLoginAccountSelector = require(Modules.LuaApp.Flags.GetFFlagEnableLoginAccountSelector)
local GetFFlagEnableOtpEmailLogin = require(Modules.LuaApp.Flags.GetFFlagEnableOtpEmailLogin)
local GetFFlagEnableVNGNewAppAvailableModal = require(Modules.LuaApp.Flags.GetFFlagEnableVNGNewAppAvailableModal)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local GetFFlagEnableAccountSwitcherFoundationDesign = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign
local FFlagEnableKoreaKISACompliance = require(Modules.LuaApp.Flags.FFlagEnableKoreaKISACompliance)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagUseUpdatedVNGAgreementsWorkflow = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseUpdatedVNGAgreementsWorkflow
local FFlagLuaAppHomeVngAppUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHomeVngAppUpsell
local GetFFlagEnableReminderOfNormsABTest = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReminderOfNormsABTest
local GetFFlagApplyResolutionScale = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagApplyResolutionScale
local GetFFlagEnableInAppBugReporting = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInAppBugReporting
local FFlagEnableAbuseReportRevampFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAbuseReportRevampFlow
local FFlagEnableMagicLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMagicLogin
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXWearTimeSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXWearTimeSupport
local FFlagEnableUnifiedProductPurchaseFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableSystemTrayModals = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSystemTrayModals
local FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal
local FFlagLuaAppPlayButtonUpsellLinking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonUpsellLinking
local FFlagSduiExperienceDetailsSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiEventDetailsSupport
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local v54 = game:DefineFastFlag("LuaAppFixCentralOverlayDeviceSafe", false)
local v55 = game:DefineFastFlag("RemoveCentralOverlayBackgroundSafeArea", false)
local t1 = {
	[OverlayType.PlacesList] = true,
	[OverlayType.PeopleList] = true,
	[OverlayType.ExperienceGuidelinesExplained] = true,
	[OverlayType.PurchaseGame] = true,
	[OverlayType.PurchaseGameRobuxShortfall] = true,
	[OverlayType.LeaveRobloxAlert] = true,
	[OverlayType.ReportLogsOverlay] = true,
	[OverlayType.ConfirmSignOut] = true,
	[OverlayType.UpdateRequiredPrompt] = true,
	[OverlayType.AgreeToPhoneNumberVerification] = true,
	[OverlayType.DevSubMore] = true,
	[OverlayType.DevSubConfirmCancel] = true,
	[OverlayType.TencentNoticePopup] = true,
	[OverlayType.SignUpBirthdayPickerOverlay] = true,
	[OverlayType.LoginPasswordResetPrompt] = true,
	[OverlayType.LoginEmailVerificationPrompt] = true,
	[OverlayType.EmailVerificationUpsellOverlay] = true,
	[OverlayType.PhoneVerificationUpsellOverlay] = true,
	[OverlayType.PhoneVerificationUpsellOverlayWrapper] = true,
	[OverlayType.VoicePhoneVerificationUpsellOverlayWrapper] = true,
	[OverlayType.CrossDeviceCodePrompt] = true,
	[OverlayType.CrossDeviceLoginConfirmation] = true,
	[OverlayType.VerifiedEnableVoice] = true,
	[OverlayType.UserAgreementsUpdatedPopup] = true,
	[OverlayType.VNGUserAgreementsPopup] = true,
	[OverlayType.VerifyPhoneNumber] = true,
	[OverlayType.AccountSecurityPromptOverlay] = true,
	[OverlayType.CameraPermissionPrompt] = true,
	[OverlayType.AccountAuthenticationFailureOverlay] = true,
	[OverlayType.UserAgreementsPrompt] = true,
	[OverlayType.UserAgreementsSecondPrompt] = true,
	[OverlayType.SimpleTextAlertPrompt] = true,
	[OverlayType.FindFriendsModal] = true,
	[OverlayType.ContactsList] = true,
	[OverlayType.PurchasePass] = true,
	[OverlayType.PurchasePassInsufficientRobux] = true,
	[OverlayType.PurchaseDeveloperProduct] = true,
	[OverlayType.PurchaseDeveloperProductInsufficientRobux] = true,
	[OverlayType.PurchaseDeveloperProductPendingProductsLimitExceeded] = true,
	[OverlayType.PurchaseDeveloperProductSuccess] = true,
	[OverlayType.IapExperienceAnimator] = true,
	[OverlayType.DiscoverabilityUpsell] = true,
	[OverlayType.SurveyPrompt] = true,
	[OverlayType.GamepadDisconnected] = true,
	[OverlayType.AccountSelector] = not not GetFFlagEnableLoginAccountSelector() or nil,
	[OverlayType.AccountSwitcher] = not not GetFFlagEnableAccountSwitcherFoundationDesign() or nil,
	[OverlayType.EmailOtp] = not not GetFFlagEnableOtpEmailLogin() or nil,
	[OverlayType.NewAppAvailableModal] = not not GetFFlagEnableVNGNewAppAvailableModal() or nil,
	[OverlayType.AccountSwitchingErrorOverlay] = not not FFlagEnableLuaAccountSwitch or nil,
	[OverlayType.CloseOnlyInteractiveAlert] = true,
	[OverlayType.ConfirmationDialog] = true,
	[OverlayType.UpsellModal] = not FFlagLuaAppPlayButtonUpsellLinking or nil,
	[OverlayType.PlayButtonUpsellDialog] = not not FFlagLuaAppPlayButtonUpsellLinking or nil,
	[OverlayType.SduiOverlay] = not FFlagSduiExperienceDetailsSupport and (not FFlagSduiEventDetailsSupport and nil),
	[OverlayType.SquadPrompt] = not not GetFFlagIsSquadEnabled() or nil,
	[OverlayType.VngContactInfoFormWebviewPopup] = true,
	[OverlayType.VngComplianceLoadingPopup] = not not GetFFlagUseUpdatedVNGAgreementsWorkflow() or nil,
	[OverlayType.KISAPopUpAgreements] = not not FFlagEnableKoreaKISACompliance or nil,
	[OverlayType.ItemsReceivedAlert] = true,
	[OverlayType.VngAppUpsell] = not not FFlagLuaAppHomeVngAppUpsell or nil,
	[OverlayType.GamePlayerFeedbackForm] = not not GetFFlagEdpPlayerFeedbackEnabled() or nil,
	[OverlayType.ReminderOfNormsPopup] = not not GetFFlagEnableReminderOfNormsABTest() or nil,
	[OverlayType.BugReporter] = not not GetFFlagEnableInAppBugReporting() or nil,
	[OverlayType.SettingsPermissionInteractiveAlert] = true,
	[OverlayType.DynamicAbuseReport] = not not FFlagEnableAbuseReportRevampFlow or nil,
	[OverlayType.AccountReactivationPrompt] = true,
	[OverlayType.MagicLoginApprovePopup] = not not FFlagEnableMagicLogin or nil,
	[OverlayType.MagicLoginRequestPopup] = not not FFlagEnableMagicLogin or nil,
	[OverlayType.DeviceSelectorPeekView] = not not FFlagEnableMagicLogin or nil,
	[OverlayType.AccountLinkingAlert] = true,
	[OverlayType.WearTimeInfoModal] = not not FFlagAXWearTimeSupport or nil,
	[OverlayType.EconomicRestrictionPrompt] = true,
	[OverlayType.AccountLockModal] = true,
	[OverlayType.UnifiedProductPurchaseModal] = not not FFlagEnableUnifiedProductPurchaseFlow or nil,
	[OverlayType.NotificationsModal] = not not FFlagEnableSystemTrayModals or nil,
	[OverlayType.SystemTrayModal] = not not FFlagEnableSystemTrayModals or nil,
	[OverlayType.UnifiedProductPurchaseModal] = if not FFlagEnableUnifiedProductPurchaseFlow then nil else not FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal
}
local OverlayComponent = require(Modules.LuaApp.Components.CentralOverlayUtils).OverlayComponent
local v58 = Roact.PureComponent:extend("CentralOverlay")

v58.defaultProps = {
	hideCentralOverlay = false
}

function v58.init(p1) -- line: 165
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Roact (copy)
	p1.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil
	p1.defaultChildRef = Roact.createRef()
end
function v58.render(p2) -- line: 170
	-- upvalues: GetFFlagApplyResolutionScale (copy), getVirtualResolutionScale (copy), withStyle (copy), getSafeAreaSize (copy), Colors (copy), Cryo (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), CloseCentralOverlay (copy), React (copy), v55 (copy), v54 (copy), Immutable (copy), Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), GetFFlagLuaAppFixStudioNotchSupport (copy)
	local v64 = not GetFFlagApplyResolutionScale() and 1 or getVirtualResolutionScale()
	local displayOrder = p2.props.displayOrder
	local overlayComponent = p2.props.overlayComponent
	local arguments = p2.props.arguments
	local v68 = if not GetFFlagApplyResolutionScale() then p2.props.screenSize else Vector2.new(p2.props.screenSize.X * v64, p2.props.screenSize.Y * v64)
	local globalGuiInset = p2.props.globalGuiInset
	local shouldCreateBackgroundWrapper = p2.props.shouldCreateBackgroundWrapper

	if v68.X <= 0 or v68.Y <= 0 then
		return nil
	end

	return withStyle(function(p3) -- line: 185
		-- upvalues: getSafeAreaSize (copy), v68 (copy), globalGuiInset (copy), Colors (copy), p2 (copy), arguments (ref), Cryo (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), CloseCentralOverlay (copy), shouldCreateBackgroundWrapper (copy), React (copy), v55 (copy), v54 (copy), overlayComponent (copy), Immutable (copy), Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), displayOrder (copy)
		local v89 = getSafeAreaSize(v68, globalGuiInset)
		local Black = Colors.Black
		local n1 = 0.3

		if p3 then
			if p2.props.includeStatusBar then
				v89 = UDim2.new(0, v89.X.Offset, 0, v89.Y.Offset)
			end

			Black = p3.Theme.Overlay.Color
			n1 = p3.Theme.Overlay.Transparency
		end

		arguments = Cryo.Dictionary.join(arguments, {
			defaultChildRef = p2.defaultChildRef,
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p2.focusController else nil,
			closeCentralOverlayThunk = CloseCentralOverlay
		})

		local v92 = shouldCreateBackgroundWrapper and React.createElement("Frame", {
			BorderSizePixel = 0,
			Selectable = false,
			Active = true,
			Position = if not v55 then UDim2.fromOffset(if not v54 then -globalGuiInset.left else 0, -globalGuiInset.top) else nil,
			Size = UDim2.fromOffset(v68.X, v68.Y),
			BackgroundColor3 = Black,
			BackgroundTransparency = n1
		}, {
			SafeAreaFrame = if not v55 then React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Selectable = false,
				Position = UDim2.fromOffset(if not v54 then globalGuiInset.left else 0, globalGuiInset.top),
				Size = v89
			}, {
				Prompt = if not overlayComponent then nil else React.createElement(overlayComponent, Immutable.JoinDictionaries(arguments, {
					containerWidth = v89.X.Offset
				}))
			}) else nil,
			Prompt = if not v55 or not overlayComponent then nil else React.createElement(overlayComponent, Immutable.JoinDictionaries(arguments, {
				containerWidth = v89.X.Offset
			}))
		}) or if not overlayComponent then nil else React.createElement(overlayComponent, arguments)

		return React.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			PortalUIForOverlay = overlayComponent and React.createElement(ScreenGuiWithBlurControl, {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ScreenInsets = if not GetFFlagLuaAppFixStudioNotchSupport() then nil else Enum.ScreenInsets.None,
				DisplayOrder = displayOrder
			}, {
				WrappingFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Selectable = false,
					SelectionGroup = true,
					Size = UDim2.fromScale(1, 1),
					ref = p2.props.forwardRef,
					SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
					SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
					SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				}, {
					OverlayComponent = v92
				})
			})
		})
	end)
end

local u59 = RoactRodux.connect(function(p4, _) -- line: 278
	-- upvalues: OverlayComponent (copy), t1 (copy)
	local OverlayType2 = p4.CentralOverlay.OverlayType

	return {
		overlayComponent = OverlayComponent[OverlayType2],
		shouldCreateBackgroundWrapper = t1[OverlayType2],
		arguments = p4.CentralOverlay.Arguments,
		screenSize = p4.ScreenSize,
		globalGuiInset = p4.GlobalGuiInset
	}
end, function(p6) -- line: 288
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closePrompt = function() -- line: 290
			-- upvalues: p6 (copy), CloseCentralOverlay (copy)
			p6(CloseCentralOverlay())
		end
	}
end)(v58)

local function v60(p7) -- line: 296
	-- upvalues: useIsSpatial (copy), React (copy), VRCentralOverlay (copy), u59 (ref)
	if useIsSpatial() then
		return React.createElement(VRCentralOverlay, p7)
	end

	return React.createElement(u59, p7)
end

local t2 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

return function(p8) -- line: 310
	-- upvalues: useSelector (copy), OverlayComponent (copy), React (copy), useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), FocusNavigableSurfaceIdentifierEnum (copy), useDispatch (copy), OverlayType (copy), InputHandlers (copy), CloseCentralOverlay (copy), ReactFocusNavigation (copy), t2 (copy), FocusNavigationEventNameEnum (copy), v60 (copy), Cryo (copy)
	local v77 = useSelector(function(p9) -- line: 313
		-- upvalues: OverlayComponent (copy)
		return OverlayComponent[p9.CentralOverlay.OverlayType] ~= nil
	end)
	local v78, v79 = React.useState(nil)
	local v80 = useRegisterFocusNavigableSurface()
	local v81 = useDeRegisterFocusNavigableSurface()

	React.useEffect(function() -- line: 322
		-- upvalues: v78 (copy), v77 (copy), v80 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v81 (copy)
		if v78 and v77 then
			v80(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v78)

			return
		end

		v81(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v78)
	end, {
		v78,
		v77,
		v80,
		v81
	})

	local v82 = useDispatch()
	local v83 = useSelector(function(p10) -- line: 332
		return p10.CentralOverlay.OverlayType
	end)
	local t3 = {
		[OverlayType.AccountReactivationPrompt] = true,
		[OverlayType.AccountLockModal] = true
	}
	local v85 = React.useMemo(function() -- line: 342
		-- upvalues: t3 (copy), v83 (copy), InputHandlers (copy), v82 (copy), CloseCentralOverlay (copy)
		if t3[v83] then
			return nil
		end

		return InputHandlers.onRelease(function(p11) -- line: 347
			-- upvalues: v82 (copy), CloseCentralOverlay (copy)
			v82(CloseCentralOverlay())
			p11:cancel()
		end)
	end, {
		v82,
		v83
	})
	local v86 = ReactFocusNavigation.useEventMap(t2, v79)
	local v87 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v85, nil, v86)

	return React.createElement(v60, Cryo.Dictionary.join(p8, {
		forwardRef = v87
	}))
end
