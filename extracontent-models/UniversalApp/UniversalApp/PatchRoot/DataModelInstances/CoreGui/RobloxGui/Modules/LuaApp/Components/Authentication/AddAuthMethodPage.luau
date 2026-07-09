local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppOmniRecommendationsRequest = require(CorePackages.Workspace.Packages.RoactServiceTags).AppOmniRecommendationsRequest
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local Promise = require(Modules.LuaApp.Promise)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local DarkTheme = UIBlox.App.Style.Themes.DarkTheme
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local CollapsingTextInputValidator = require(Modules.LuaApp.Components.Authentication.CollapsingTextInputValidator)
local PasswordValidator = require(Modules.LuaApp.Thunks.Authentication.PasswordValidator)
local InputValidity = require(Modules.LuaApp.Components.Authentication.Enum.InputValidity)
local Button = UIBlox.App.Button.Button
local LinkButton = UIBlox.App.Button.LinkButton
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local DividerWithText = AuthCommon.Components.DividerWithText
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local GetPasswordManagerUsageStore = AuthCommon.Stores.GetPasswordManagerUsageStore
local MultiPageSignupText = require(Modules.LuaApp.Components.Authentication.MultiPageSignupText)
local PageWithDisclaimerLinks = require(Modules.LuaApp.Components.Authentication.PageWithDisclaimerLinks)
local Foundation = require(CorePackages.Packages.Foundation)
local Button2 = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local IconButton = Foundation.IconButton
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local RegisterPasskey = require(Modules.LuaApp.Thunks.Authentication.RegisterPasskey)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local SetPassword = require(Modules.LuaApp.Thunks.Authentication.SetPassword)
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local UpdateUserEmail = require(Modules.LuaApp.Thunks.Authentication.EmailVerification.UpdateUserEmail)
local isStringEmail = require(Modules.LuaApp.Util.isStringEmail)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local CredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol)
local Constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default
local GetUserAppLaunchInfo = require(CorePackages.Workspace.Packages.AuthCommon).Http.Requests.GetUserAppLaunchInfo
local GetAccountCreationMetadata = require(CorePackages.Workspace.Packages.AuthSignup).Requests.GetAccountCreationMetadata
local LaunchContext = require(CorePackages.Workspace.Packages.AppStartup).Enums.LaunchContext
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local IosAuthServiceExperiment = require(Modules.LuaApp.Experiment.IosAuthServiceExperiment)
local ToastRodux = require(CorePackages.Workspace.Packages.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableSavePasswordAfterRecovery = SharedFlags.GetFFlagEnableSavePasswordAfterRecovery
local FFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
local FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment = SharedFlags.FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
local FFlagEnableSignupFoundationalizeBackgroundAndText = SharedFlags.FFlagEnableSignupFoundationalizeBackgroundAndText
local FFlagEnableAddAuthMethodPageEmailSignup = SharedFlags.FFlagEnableAddAuthMethodPageEmailSignup
local v82 = game:DefineFastFlag("EnableAuthlessSignup", false)
local v83 = game:DefineFastFlag("CheckAndEnforceALNetworkCheck", false)
local v84 = game:DefineFastFlag("UseMultiPageSignupTextOnAddAuthMethodPage", false)
local v85 = game:DefineFastFlag("ShouldSkipPasskeySignupAutoFocus", false)
local v86 = game:DefineFastInt("LuaAppCmPasswordRegistrationDelay", 2)
local v87 = game:DefineFastFlag("PasskeySignupAndroidIterationEnabled", false)
local v88 = game:DefineFastFlag("EnableAuthedUsernameCMFix", false)
local EngineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local v90 = game:DefineFastString("AddAuthMethodEmailPlaceholder", "example@email.com")
local v91 = game:DefineFastFlag("EnableAddAuthMethodPageEmailSignupSetIsUnder13", false)
local v92 = game:DefineFastFlag("EnableAddAuthMethodPagePasskeyOrOTPText", false)
local v93 = game:DefineFastFlag("EnableStandardPasskeyButton", false)
local FFlagEnableFaceIDTextOnAddAuthMethodPage = SharedFlags.FFlagEnableFaceIDTextOnAddAuthMethodPage
local v95 = not v84 and 60 or 24
local t1 = {
	passwordFirst = {
		password = 4,
		spacing = 5,
		continue = 6,
		divider = 7,
		passkeyV2 = 8,
		passkeyNonV2 = 7
	},
	passkeyFirst = {
		password = 6,
		spacing = 7,
		continue = 8,
		divider = 5,
		passkey = 4
	},
	showCreatePasswordButton = {
		passkey = 4,
		divider = 5,
		createPasswordButton = 6
	},
	showCreatePasswordButtonPasswordFirst = {
		createPasswordButton = 4,
		divider = 5,
		passkey = 6
	},
	showPasswordSectionOnly = {
		password = 4,
		spacing = 5,
		continue = 6
	}
}

if FFlagEnableAddAuthMethodPageEmailSignup then
	t1.passwordFirst = {
		password = 4,
		spacing = 5,
		continue = 6,
		divider = 8,
		passkeyV2 = 9,
		passkeyNonV2 = 8
	}
end

local GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local PasskeyUpsell = require(CorePackages.Workspace.Packages.PasskeyUpsell)
local PasskeyUpsellScreen = PasskeyUpsell.Components.PasskeyUpsellScreen
local PasskeyUpsellSource = PasskeyUpsell.Enums.PasskeyUpsellSource
local FFlagAddReasonToEveryLogout = SharedFlags.FFlagAddReasonToEveryLogout
local FFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local default2 = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local iosAuthServiceSignupPasswordSave = require(Modules.LuaApp.Analytics.Events.Auth.iosAuthServiceSignupPasswordSave)
local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

GetTextBoundsParams.Text = "_unused"
GetTextBoundsParams.Font = Font.fromEnum(AppFonts.default:getDefault())
GetTextBoundsParams.Size = 19
GetTextBoundsParams.Width = 0
TextService:GetTextBoundsAsync(GetTextBoundsParams)

return function(_: {[any]: any}) -- line: 166
	-- upvalues: useRoactService (copy), RoactNetworking (copy), AppGuiService (copy), RoactAnalyticsAuthEvents (copy), RoactAnalytics (copy), AppOmniRecommendationsRequest (copy), useAppPolicy (copy), FFlagEnablePWManagerSignupCheck (copy), GetPasswordManagerUsageStore (copy), React (copy), RoactAppExperiment (copy), AppBtidLayers (copy), FFlagEnableSignupFoundationalizeBackgroundAndText (copy), GetFFlagEnableMultiPageSignupExperiment (copy), v87 (copy), FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment (copy), FFlagEnableAddAuthMethodPageEmailSignup (copy), v92 (copy), v82 (copy), v83 (copy), v93 (copy), FFlagEnableFaceIDTextOnAddAuthMethodPage (copy), IosAuthServiceExperiment (copy), useStyle (copy), useTokens (copy), useDispatch (copy), ReactFocusNavigation (copy), usePreferredInput (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), InputValidity (copy), isStringEmail (copy), v88 (copy), Players (copy), EventStreamConstants (copy), UpdateUserEmail (copy), LaunchApp (copy), LaunchContext (copy), SetPassword (copy), FFlagDisableMemStorageServicePasswordEvent (copy), HttpService (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), Promise (copy), v86 (copy), SetCurrentToastMessage (copy), ToastType (copy), RegisterPasskey (copy), Logout (copy), luaLogoutReasonNames (copy), v85 (copy), Responsive (copy), default2 (copy), TelemetryConfigs (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), GetUserAppLaunchInfo (copy), v91 (copy), User (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), GetAccountCreationMetadata (copy), PasskeyUpsellScreen (copy), PasskeyUpsellSource (copy), withLocalization (copy), t1 (copy), Button2 (copy), ButtonVariant (copy), Foundation (copy), InputSize (copy), Button (copy), ButtonType (copy), LinkButton (copy), FullscreenPageWithSafeArea (copy), DarkTheme (copy), PageWithDisclaimerLinks (copy), ImageSetButton (copy), Images (copy), View (copy), IconButton (copy), IconName (copy), ButtonSize (copy), v95 (copy), v84 (copy), MultiPageSignupText (copy), CollapsingTextInputValidator (copy), EngineFeature (copy), PasswordValidator (copy), TextInputBoxWithBorder (copy), AuthStatefulRoundCornerBorder (copy), v90 (copy), DividerWithText (copy)
	local v109 = useRoactService(RoactNetworking)
	local v110 = useRoactService(AppGuiService)
	local v111 = useRoactService(RoactAnalyticsAuthEvents)
	local v112 = useRoactService(RoactAnalytics)
	local v113 = useRoactService(AppOmniRecommendationsRequest)
	local v114 = useAppPolicy(function(p1) -- line: 172
		return p1
	end)
	local v115 = if not FFlagEnablePWManagerSignupCheck then nil else GetPasswordManagerUsageStore(false)

	if FFlagEnablePWManagerSignupCheck then
		React.useEffect(function() -- line: 181
			-- upvalues: v115 (copy)
			if v115 then
				v115.resetAll()
			end
		end, { v115 })
	end

	local v116, v117 = React.useState(true)
	local v118 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AuthenticationStylingLayer }, function(p2) -- line: 192
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldUseFoundationBackgroundColor = (p2[AppBtidLayers.AuthenticationStylingLayer] or {}).shouldUseFoundationBackgroundColor
		}
	end)
	local v119 = FFlagEnableSignupFoundationalizeBackgroundAndText and v118.shouldUseFoundationBackgroundColor
	local v120 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.SignupLayer }, function(p3) -- line: 204
		-- upvalues: AppBtidLayers (copy)
		local v192 = p3[AppBtidLayers.SignupLayer] or {}

		return {
			shouldUseV2FallbackScreen = v192.shouldUseV2FallbackScreen,
			shouldSuppressPasskeyOnAddAuthMethodPage = v192.shouldSuppressPasskeyOnAddAuthMethodPage,
			shouldWaitForPasswordRegistration = v192.shouldWaitForPasswordRegistration,
			shouldDelayPasswordRegistration = v192.shouldDelayPasswordRegistration,
			showPasskeyNudgingHeader = v192.showPasskeyNudgingHeader,
			showPasskeyBeforePassword = v192.showPasskeyBeforePassword,
			showPasskeyNudgingParagraph = v192.showPasskeyNudgingParagraph,
			shouldRemoveOrDivider = v192.shouldRemoveOrDivider,
			shouldUsePrimaryPasskeyButton = v192.shouldUsePrimaryPasskeyButton,
			shouldUseSecondaryPasswordNextButton = v192.shouldUseSecondaryPasswordNextButton,
			showPasskeyIconOnAddAuthMethodPage = v192.showPasskeyIconOnAddAuthMethodPage,
			showPasswordLockIconOnAddAuthMethodPage = v192.showPasswordLockIconOnAddAuthMethodPage,
			showPasskeyEducationalPage = v192.showPasskeyEducationalPage,
			shouldShowCreateAPasswordButton = v192.shouldShowCreateAPasswordButton,
			shouldDisablePasswordFocus = v192.shouldDisablePasswordFocus,
			shouldShowEmailSignupO13 = v192.shouldShowEmailSignupO13,
			shouldShowEmailSignupU13 = v192.shouldShowEmailSignupU13,
			shouldShowPasskeyOrOTPText = v192.shouldShowPasskeyOrOTPText,
			shouldShowSetupLaterInCornerWhenEmailProvided = v192.shouldShowSetupLaterInCornerWhenEmailProvided,
			shouldShowSetupLaterInBottomRowWhenEmailProvided = v192.shouldShowSetupLaterInBottomRowWhenEmailProvided,
			shouldUseStandardPasskeyButton = v192.shouldUseStandardPasskeyButton,
			shouldShowFaceIDText = v192.shouldShowFaceIDText
		}
	end)
	local shouldUseV2FallbackScreen = v120.shouldUseV2FallbackScreen
	local v122 = GetFFlagEnableMultiPageSignupExperiment() and v120.shouldSuppressPasskeyOnAddAuthMethodPage
	local v123 = v87 and v120.shouldWaitForPasswordRegistration
	local v124 = v87 and v120.shouldDelayPasswordRegistration
	local v125 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasskeyNudgingHeader
	local v126 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasskeyBeforePassword
	local v127 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasskeyNudgingParagraph
	local v128 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.shouldRemoveOrDivider
	local v129 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.shouldUsePrimaryPasskeyButton
	local v130 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.shouldUseSecondaryPasswordNextButton
	local v131 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasskeyIconOnAddAuthMethodPage
	local v132 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasswordLockIconOnAddAuthMethodPage
	local v133 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.showPasskeyEducationalPage
	local v134 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.shouldShowCreateAPasswordButton
	local v135 = FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment and v120.shouldDisablePasswordFocus
	local v136 = FFlagEnableAddAuthMethodPageEmailSignup and if not v116 then v120.shouldShowEmailSignupO13 else v120.shouldShowEmailSignupU13
	local v137 = v92 and v120.shouldShowPasskeyOrOTPText
	local v138, v139 = React.useState(false)
	local v140 = v82 and v136

	if v83 then
		v140 = v140 and v138
	end

	local v141 = v140 and v120.shouldShowSetupLaterInCornerWhenEmailProvided
	local v142 = v140 and v120.shouldShowSetupLaterInBottomRowWhenEmailProvided
	local v143 = v93 and v120.shouldUseStandardPasskeyButton
	local v144 = FFlagEnableFaceIDTextOnAddAuthMethodPage and (v120.shouldShowFaceIDText and v114.getShouldShowFaceIDText())
	local v145 = v136 and v116
	local v146, v147 = React.useState(true)
	local v148, v149 = React.useState(false)
	local v150, v151 = React.useState(true)
	local v152, v153 = React.useState("")
	local v154, v155 = React.useState("")
	local v156, v157 = React.useState("")
	local v158, v159 = React.useState(false)
	local v160, v161 = React.useState("")
	local v162, v163 = React.useState(false)
	local v164, v165 = React.useState(true)
	local v166, v167 = React.useState(false)
	local v168, v169 = React.useState(false)
	local v170 = React.useRef(nil)
	local v171 = React.useRef(nil)
	local v172 = IosAuthServiceExperiment.useIsIosAuthServiceEnabled()
	local v173 = useStyle()
	local v174 = useTokens()
	local v175 = useDispatch()
	local v176 = ReactFocusNavigation.useFocusGuiObject()
	local v177 = usePreferredInput()

	local function v178() -- line: 338
		-- upvalues: v147 (copy), v146 (copy)
		v147(not v146)
	end
	local function v179(p4, p5) -- line: 342
		-- upvalues: v153 (copy), v163 (copy), InputValidity (copy)
		v153(p4)
		v163(p5 == InputValidity.Valid)
	end
	local function v180(p6) -- line: 347
		-- upvalues: v155 (copy), isStringEmail (copy), v157 (copy), v159 (copy), v163 (copy)
		local p6Text = p6.Text

		v155(p6Text)

		local v198 = isStringEmail((tostring(p6Text)))

		if v198 or p6Text == "" then
			v157("")
			v159(false)
		else
			v157("")
			v159(true)
		end

		v163(v198)
	end
	local function v181() -- line: 379
		-- upvalues: v163 (copy), v111 (copy), EventStreamConstants (copy), v136 (copy), v175 (copy), UpdateUserEmail (copy), v109 (copy), v154 (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), LaunchApp (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v157 (copy), v159 (copy), SetPassword (copy), v152 (copy), v88 (copy), v160 (copy), Players (copy), shouldUseV2FallbackScreen (copy), v166 (copy), v172 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), HttpService (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), v115 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v123 (copy), v124 (copy), Promise (copy), v86 (copy), SetCurrentToastMessage (copy), ToastType (copy), v173 (copy)
		v163(false)
		v111.reportAuthButtonClick(EventStreamConstants.Context.PasskeySignupPasswordFallback, EventStreamConstants.Button.Continue)

		if v136 then
			v111.reportAuthButtonClick(EventStreamConstants.Context.SignupEmailOnAddAuthMethod, EventStreamConstants.Button.SubmitEmail)
			v175(UpdateUserEmail(v109, v154, nil)):andThen(function() -- line: 393
				-- upvalues: v111 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy)
				v111.reportAuthModalShown(EventStreamConstants.Context.SignupEmailOnAddAuthMethod, EventStreamConstants.State.Success)
				AppStorageUtilities.setSignupActionRequired("")
				AppStorageUtilities.setPasskeySignupUsername("")
				AppStorageUtilities.flush()

				local v219 = AppStorageUtilities.getAuthenticatedTheme()

				if v219 ~= "" then
					v169(true)
					MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v219)
				end

				SystemThemeFeature.ClearThemeOverride()
				v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
				v163(true)
			end, function(p7) -- line: 405
				-- upvalues: v111 (copy), EventStreamConstants (copy), v157 (copy), v159 (copy), v163 (copy)
				local v221 = p7 and (not not p7.Message and (p7.Message ~= "" and p7.Message)) or ""

				v111.reportAuthClientError(EventStreamConstants.Context.SignupEmailOnAddAuthMethod, v221)
				v157(v221)
				v159(true)
				v163(true)
			end)

			return
		end

		SetPassword(v109, v152):andThen(function(_) -- line: 418
			-- upvalues: AppStorageUtilities (copy), v88 (copy), v160 (copy), Players (copy), shouldUseV2FallbackScreen (copy), v152 (copy), v166 (copy), v172 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), v111 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), v115 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v169 (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy), v123 (copy), v124 (copy), Promise (copy), v86 (copy)
			AppStorageUtilities.setSignupActionRequired("")
			AppStorageUtilities.setPasskeySignupUsername("")
			AppStorageUtilities.flush()

			local v223

			if v88 and (v160 and v160 ~= "") then
				v223 = v160
			else
				local v224 = AppStorageUtilities.getPasskeySignupUsername()

				v223 = if not v224 or v224 == "" then not Players.LocalPlayer and "" or (Players.LocalPlayer.Name or "") else v224
			end

			local v225 = v223

			if shouldUseV2FallbackScreen and v225 and v152 then
				local v226 = v166 and v172

				if not FFlagDisableMemStorageServicePasswordEvent and not v226 then
					MemStorageService:Fire(MemStorageKeys.AuthenticatedCredentials, HttpService:JSONEncode({
						authType = "signup",
						cvalue = v225,
						password = v152
					}))
				end

				if v166 then
					local t3 = {
						username = v225,
						password = v152
					}
					local json = HttpService:JSONEncode(t3)

					local function v229() -- line: 449
						-- upvalues: v111 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), v225 (copy), default (copy), json (copy), Constants (copy), HttpService (copy), Logger (copy), v115 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v172 (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy)
						v111.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServicePasswordFallback, EventStreamConstants.Button.IosAuthServiceSavePasswordAttempted)
						iosAuthServiceSignupPasswordSave.reportAttempted(v225)

						return default:registerCredentials(default.CredentialsTypes.password, json, Constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p9) -- line: 463
							-- upvalues: HttpService (copy), Logger (copy), v115 (copy), v111 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), v225 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v172 (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy)
							local v245 = if not p9 then {} else HttpService:JSONDecode(p9)

							if v245 and v245.errorCode == nil then
								Logger:info("Successfully registered password.")

								if v115 then
									v115.setPasswordManagerMediatedSignup(true)
								end

								v111.reportAuthButtonClick(EventStreamConstants.Context.CMPasswordPasskeyFallback, EventStreamConstants.Button.SavePassword)
								v111.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServicePasswordFallback, EventStreamConstants.Button.IosAuthServiceSavePasswordSuccess)
								iosAuthServiceSignupPasswordSave.reportSuccess(v225)
							else
								Logger:warning("Error registering password: " .. tostring(v245.errorMsg))
								v111.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServicePasswordFallback, EventStreamConstants.Button.IosAuthServiceSavePasswordFailure, v245.errorMsg or "unknown")
								iosAuthServiceSignupPasswordSave.reportFailure(v225, v245.errorMsg or "unknown")
							end

							if GetFFlagEnableSavePasswordAfterRecovery() and v172 then
								local v246 = AppStorageUtilities.getAuthenticatedTheme()

								if v246 ~= "" then
									v169(true)
									MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v246)
								end

								SystemThemeFeature.ClearThemeOverride()
								v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
								v163(true)
							end
						end, function(p10) -- line: 512
							-- upvalues: Logger (copy), v111 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), v225 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v172 (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy)
							Logger:warning("Error registering password: " .. tostring(p10))
							v111.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServicePasswordFallback, EventStreamConstants.Button.IosAuthServiceSavePasswordFailure, (tostring(p10)))
							iosAuthServiceSignupPasswordSave.reportFailure(v225, (tostring(p10)))

							if GetFFlagEnableSavePasswordAfterRecovery() and v172 then
								local v248 = AppStorageUtilities.getAuthenticatedTheme()

								if v248 ~= "" then
									v169(true)
									MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v248)
								end

								SystemThemeFeature.ClearThemeOverride()
								v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
								v163(true)
							end
						end)
					end

					if GetFFlagEnableSavePasswordAfterRecovery() and v172 then
						return v229()
					end

					local v230

					if v123 then
						v230 = v229()
						v230:await()
					else
						v230 = if not v124 then v229() else Promise.delay(v86):andThen(v229)
					end

					return v230:andThen(function() -- line: 559
						-- upvalues: AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), v163 (copy)
						local v243 = AppStorageUtilities.getAuthenticatedTheme()

						if v243 ~= "" then
							v169(true)
							MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v243)
						end

						SystemThemeFeature.ClearThemeOverride()
						v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
						v163(true)
					end)
				end

				v111.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServicePasswordFallback, EventStreamConstants.Button.IosAuthServiceSavePasswordSkipped, EventStreamConstants.State.IosAuthServiceProtocolNotAvailable)
				iosAuthServiceSignupPasswordSave.reportSkipped(EventStreamConstants.State.IosAuthServiceProtocolNotAvailable)
			end

			local v231 = AppStorageUtilities.getAuthenticatedTheme()

			if v231 ~= "" then
				v169(true)
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v231)
			end

			SystemThemeFeature.ClearThemeOverride()
			v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
			v163(true)

			return Promise.resolve()
		end, function(_) -- line: 592
			-- upvalues: v175 (copy), SetCurrentToastMessage (copy), ToastType (copy), v173 (copy), v163 (copy)
			v175(SetCurrentToastMessage({
				toastMessage = "Authentication.Login.Response.SomethingWentWrong",
				slideIn = true,
				toastType = ToastType.NetworkingError,
				toastIconColorStyle = {
					Transparency = 0,
					Color = v173.Theme.Alert.Color
				}
			}))
			v163(true)
		end)
	end
	local function v182() -- line: 607
		-- upvalues: v164 (copy), v165 (copy), v111 (copy), EventStreamConstants (copy), RegisterPasskey (copy), v109 (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), Promise (copy)
		if not v164 then
			return
		end

		v165(false)
		v111.reportAuthButtonClick(EventStreamConstants.Context.PasskeySignupPasswordFallback, EventStreamConstants.Button.SetupPasskey)

		return RegisterPasskey(v109):andThen(function(_) -- line: 619
			-- upvalues: v111 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy), Promise (copy)
			v111.reportAuthModalShown(EventStreamConstants.Context.SignupPasswordFallbackPasskeyCreated, "success")
			AppStorageUtilities.setSignupActionRequired("")
			AppStorageUtilities.setPasskeySignupUsername("")
			AppStorageUtilities.flush()

			local v234 = AppStorageUtilities.getAuthenticatedTheme()

			if v234 ~= "" then
				v169(true)
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v234)
			end

			SystemThemeFeature.ClearThemeOverride()
			v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))

			return Promise.resolve()
		end, function(p13) -- line: 631
			-- upvalues: v111 (copy), EventStreamConstants (copy), v165 (copy), Promise (copy)
			if p13.name then
				v111.reportAuthModalShown(EventStreamConstants.Context.SignupPasswordFallbackPasskeyCreated, p13.name)

				if type(p13.body) == "string" then
					v111.reportAuthClientError(EventStreamConstants.Context.SignupPasswordFallbackPasskeyCreated, p13.body, p13.source)
				end
			else
				v111.reportAuthModalShown(EventStreamConstants.Context.SignupPasswordFallbackPasskeyCreated, "unknown")
			end

			v165(true)

			return Promise.resolve()
		end)
	end
	local function v183() -- line: 658
		-- upvalues: v111 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), v175 (copy), Logout (copy), v109 (copy), v110 (copy), luaLogoutReasonNames (copy)
		v111.reportAuthButtonClick(EventStreamConstants.Context.PasskeySignupPasswordFallback, EventStreamConstants.Button.Close)
		AppStorageUtilities.setSignupActionRequired("")
		AppStorageUtilities.setPasskeySignupUsername("")
		AppStorageUtilities.flush()
		v175(Logout(v109, v110, luaLogoutReasonNames.MultiStepSignupCanceled))
	end

	React.useEffect(function() -- line: 670
		-- upvalues: v85 (copy), v170 (copy), v135 (copy), v171 (copy), v177 (copy), Responsive (copy), v176 (copy), v111 (copy), EventStreamConstants (copy), v136 (copy), default2 (copy), TelemetryConfigs (copy)
		if not v85 and v170.current then
			if v135 and v171.current then
				if v177 == Responsive.Input.Directional then
					v176(v171.current)
				end
			else
				v170.current:CaptureFocus()
			end
		end

		v111.reportAuthPageload(EventStreamConstants.Context.PasskeySignupPasswordFallback)

		if v136 then
			v111.reportAuthPageload(EventStreamConstants.Context.SignupEmailOnAddAuthMethod)
		end

		default2:logRobloxTelemetryCounter(TelemetryConfigs.AddAuthMethodPageMountTelemetryConfig, 1)
	end, {})
	React.useEffect(function() -- line: 696
		-- upvalues: v168 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy)
		if not v168 then
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, "dark")
			SystemThemeFeature.SetDarkThemeOverride()
		end
	end, { v173 })
	React.useEffect(function() -- line: 705
		-- upvalues: shouldUseV2FallbackScreen (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v111 (copy), EventStreamConstants (copy), v167 (copy), Logger (copy)
		if shouldUseV2FallbackScreen then
			default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p14) -- line: 712
				-- upvalues: v111 (copy), EventStreamConstants (copy), v167 (copy)
				local v237 = false

				if p14.password and p14.password.isAvailable then
					v237 = true
				end

				v111.reportAuthPageload(EventStreamConstants.Context.CMPasswordPasskeySignup, (tostring(v237)))
				v167(v237)
			end):catch(function(p15) -- line: 726
				-- upvalues: Logger (copy)
				Logger:warning("Error checking for available credential types. Error: ", p15)
			end)
		end
	end, { shouldUseV2FallbackScreen })
	React.useEffect(function() -- line: 732
		-- upvalues: GetUserAppLaunchInfo (copy), v109 (copy), v88 (copy), v161 (copy), v91 (copy), v117 (copy), User (copy), AppStorageUtilities (copy), FFlagAddReasonToEveryLogout (copy), v175 (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy)
		GetUserAppLaunchInfo(v109):andThen(function(p16) -- line: 733
			-- upvalues: v88 (copy), v161 (copy), v91 (copy), v117 (copy), User (copy), AppStorageUtilities (copy), FFlagAddReasonToEveryLogout (copy), v175 (copy), Logout (copy), v109 (copy), GuiService (copy), luaLogoutReasonNames (copy)
			local name = nil

			if p16 and p16.responseBody then
				name = p16.responseBody.name
			end

			if name and name ~= "" then
				if v88 then
					v161(name)
				end

				if v91 then
					v117(User.fromUserInfoRequest(p16).isUnder13)

					return
				end
			else
				AppStorageUtilities.setSignupActionRequired("")
				AppStorageUtilities.setPasskeySignupUsername("")
				AppStorageUtilities.flush()

				if FFlagAddReasonToEveryLogout then
					v175(Logout(v109, GuiService, luaLogoutReasonNames.MultiStepSignupResetIncompleteState))

					return
				end

				v175(Logout(v109, GuiService))
			end
		end):catch(function(_) -- line: 754
			-- upvalues: AppStorageUtilities (copy), FFlagAddReasonToEveryLogout (copy), v175 (copy), Logout (copy), v109 (copy), GuiService (copy), luaLogoutReasonNames (copy)
			AppStorageUtilities.setSignupActionRequired("")
			AppStorageUtilities.setPasskeySignupUsername("")
			AppStorageUtilities.flush()

			if FFlagAddReasonToEveryLogout then
				v175(Logout(v109, GuiService, luaLogoutReasonNames.MultiStepSignupResetIncompleteState))

				return
			end

			v175(Logout(v109, GuiService))
		end)
	end, {})
	React.useEffect(function() -- line: 764
		-- upvalues: v83 (copy), EventStreamConstants (copy), GetAccountCreationMetadata (copy), v109 (copy), v139 (copy), v111 (copy)
		if v83 then
			local ALError = EventStreamConstants.State.ALError

			GetAccountCreationMetadata(v109):andThen(function(p18) -- line: 768
				-- upvalues: ALError (ref), EventStreamConstants (copy), v139 (copy)
				if p18 and (p18.responseBody and p18.responseBody.isEligibleForALSignup == true) then
					ALError = EventStreamConstants.State.ALCheckSuccess
					v139(true)

					return
				end

				ALError = EventStreamConstants.State.ALCheckFail
			end):catch(function() -- line: 776
				-- upvalues: ALError (ref), EventStreamConstants (copy)
				ALError = EventStreamConstants.State.ALError
			end):finally(function() -- line: 779
				-- upvalues: v111 (copy), EventStreamConstants (copy), ALError (ref)
				v111.reportAuthPageload(EventStreamConstants.Context.AddAuthMethodPage, ALError)
			end)
		end
	end, {
		v109,
		v111.reportAuthPageload
	})

	local v184

	if v88 and v160 and v160 ~= "" then
		v184 = v160
	else
		local v185 = AppStorageUtilities.getPasskeySignupUsername()

		v184 = if not v185 or v185 == "" then not Players.LocalPlayer and "" or (Players.LocalPlayer.Name or "") else v185
	end

	local v186 = v184
	local v187 = React.useCallback(function(p19) -- line: 788
		-- upvalues: v111 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy)
		v111.reportAuthButtonClick(EventStreamConstants.Context.PasskeySignupPasswordFallback, p19)
		AppStorageUtilities.setSignupActionRequired("")
		AppStorageUtilities.setPasskeySignupUsername("")
		AppStorageUtilities.flush()

		local v202 = AppStorageUtilities.getAuthenticatedTheme()

		if v202 ~= "" then
			v169(true)
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v202)
		end

		SystemThemeFeature.ClearThemeOverride()
		v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
	end, {
		v114,
		v111.reportAuthButtonClick,
		v175,
		v109,
		v113,
		function() -- line: 319
			-- upvalues: AppStorageUtilities (copy)
			AppStorageUtilities.setSignupActionRequired("")
			AppStorageUtilities.setPasskeySignupUsername("")
			AppStorageUtilities.flush()
		end,
		function() -- line: 327
			-- upvalues: AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy)
			local v193 = AppStorageUtilities.getAuthenticatedTheme()

			if v193 ~= "" then
				v169(true)
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v193)
			end

			SystemThemeFeature.ClearThemeOverride()
		end,
		v112
	})

	if v133 and not v148 then
		return (React.createElement(PasskeyUpsellScreen, {
			resetNavigationHistory = function(_) -- line: 811
				-- upvalues: v111 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), v169 (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), v175 (copy), LaunchApp (copy), v109 (copy), v113 (copy), v112 (copy), v114 (copy), LaunchContext (copy)
				v111.reportAuthModalShown(EventStreamConstants.Context.SignupPasswordFallbackPasskeyCreatedFromEducation, "success")
				AppStorageUtilities.setSignupActionRequired("")
				AppStorageUtilities.setPasskeySignupUsername("")
				AppStorageUtilities.flush()

				local v204 = AppStorageUtilities.getAuthenticatedTheme()

				if v204 ~= "" then
					v169(true)
					MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v204)
				end

				SystemThemeFeature.ClearThemeOverride()
				v175(LaunchApp(v109, v113, v112, v114, LaunchContext.SignUp))
			end,
			onDismiss = function() -- line: 822
				-- upvalues: v149 (copy)
				v149(true)
			end,
			source = PasskeyUpsellSource.AddAuthMethodPage
		}))
	end

	local v188 = v173.Font.BaseSize * v173.Font.Header1.RelativeSize

	return withLocalization({
		continueText = "Authentication.SignUp.Label.Continue",
		doneText = "CommonUI.Controls.Action.Done",
		passwordHint = "Authentication.SignUp.Label.Use8CharPassword",
		signUpLabel = "Authentication.SignUp.Action.CreateAccount",
		oneMoreStepText = "Authentication.SignUp.Description.OneMoreStep",
		setUpPasskeyLabel = "Authentication.SignUp.Label.SetUpPasskey",
		createAPasskeyLabel = "Authentication.SignUp.Action.CreateAPasskey",
		createAPasswordButtonText = "Authentication.SignUp.Heading.PasswordPage",
		createAPasswordText = "Authentication.SignUp.Description.CreateAPassword",
		ensureNeverLoseAccountText = "Authentication.SignUp.Description.EnsureNeverLoseAccount",
		dividerText = "Authentication.SignUp.Description.Or",
		secureAccountWithPasskeyText = "Authentication.SignUp.Description.SecureAccountWithPasskeyText",
		createdAccountChooseSigninText = "Authentication.SignUp.Header.CreatedAccountChooseSignin",
		createAccountPasskeyEmphasisDescriptionText = "Authentication.SignUp.Description.CreateAccountPasskeyEmphasisDescription",
		emailLabelText = "Authentication.SignUp.Label.EnterYourEmail",
		parentEmailLabelText = "Authentication.SignUp.Label.EnterYourParentsEmail",
		invalidEmailText = "Feature.VerificationUpsell.Message.InvalidEmailAddress",
		parentEmailDisclaimerText = "Authentication.SignUp.Description.ParentEmailDisclaimer",
		createPasskeyOrOTPText = "Authentication.SignUp.Description.CreatePasskeyOrOTP",
		setupLaterText = "Authentication.SignUp.Action.SetupLater",
		faceIDHeadingText = "Authentication.SignUp.Heading.SecureWithFaceId",
		faceIDDescriptionText = "Authentication.SignUp.Description.FaceIdPromo",
		enableFaceIDText = "Authentication.SignUp.Action.EnableFaceId",
		userGreetingHeaderText = {
			"Authentication.SignUp.Heading.UserGreetingWithName",
			username = v186
		},
		userGreetingHeaderTextWithPasskeyPassword = {
			"Authentication.SignUp.Heading.UserGreetingWithNameAndPasskeyPassword",
			username = v186
		},
		userPasswordOnlyGreetingHeaderText = {
			"Authentication.SignUp.Title",
			username = v186
		}
	})(function(p21) -- line: 862
		-- upvalues: shouldUseV2FallbackScreen (copy), v186 (copy), v134 (copy), v150 (copy), v144 (copy), v125 (copy), v127 (copy), v137 (copy), GetFFlagEnableMultiPageSignupExperiment (copy), v122 (copy), v126 (copy), t1 (copy), v129 (copy), React (copy), Button2 (copy), ButtonVariant (copy), v131 (copy), Foundation (copy), v182 (copy), v164 (copy), InputSize (copy), v171 (copy), v143 (copy), Button (copy), ButtonType (copy), LinkButton (copy), v130 (copy), v132 (copy), v151 (copy), FullscreenPageWithSafeArea (copy), v119 (copy), v174 (copy), DarkTheme (copy), PageWithDisclaimerLinks (copy), v145 (copy), ImageSetButton (copy), Images (copy), v183 (copy), View (copy), IconButton (copy), IconName (copy), ButtonSize (copy), v173 (copy), v188 (copy), v82 (copy), v141 (copy), v187 (copy), EventStreamConstants (copy), v95 (copy), v84 (copy), MultiPageSignupText (copy), v136 (copy), CollapsingTextInputValidator (copy), EngineFeature (copy), v179 (copy), PasswordValidator (copy), v146 (copy), v178 (copy), v170 (copy), TextInputBoxWithBorder (copy), v158 (copy), AuthStatefulRoundCornerBorder (copy), v180 (copy), v116 (copy), v156 (copy), v90 (copy), FFlagEnableAddAuthMethodPageEmailSignup (copy), v181 (copy), v162 (copy), v128 (copy), DividerWithText (copy), v142 (copy)
		local v206 = if not shouldUseV2FallbackScreen or not v186 then p21.oneMoreStepText else if not v134 or v150 then if not v144 then if not v125 then p21.userGreetingHeaderText else p21.createdAccountChooseSigninText else p21.faceIDHeadingText else p21.userGreetingHeaderText
		local v207 = if not v134 or v150 then if not v144 then if not v127 or not v137 then if not v127 then p21.createAPasswordText else p21.createAccountPasskeyEmphasisDescriptionText else p21.createPasskeyOrOTPText else p21.faceIDDescriptionText else p21.createAPasswordText

		if GetFFlagEnableMultiPageSignupExperiment() and v122 then
			v206 = p21.userPasswordOnlyGreetingHeaderText
			v207 = p21.ensureNeverLoseAccountText
		end

		local v208 = if not v144 then p21.createAPasskeyLabel else p21.enableFaceIDText
		local v209 = not v126 and "passwordFirst" or "passkeyFirst"

		if v134 then
			v209 = if not v150 or not v126 then not v150 and "showPasswordSectionOnly" or "showCreatePasswordButtonPasswordFirst" else "showCreatePasswordButton"
		end

		local v210 = t1[v209]
		local password = v210.password
		local spacing = v210.spacing
		local continue = v210.continue
		local divider = v210.divider
		local v215 = v210.passkey or if not shouldUseV2FallbackScreen then v210.passkeyNonV2 else v210.passkeyV2
		local createPasswordButton = v210.createPasswordButton
		local v217 = if not shouldUseV2FallbackScreen or not v129 then if not shouldUseV2FallbackScreen or not v143 then if not shouldUseV2FallbackScreen then React.createElement(LinkButton, {
			layoutOrder = v215,
			text = p21.setUpPasskeyLabel,
			onActivated = v182,
			isDisabled = not v164,
			buttonRef = v171
		}) else React.createElement(Button, {
			layoutOrder = v215,
			buttonType = ButtonType.Secondary,
			text = v208,
			size = UDim2.new(1, 0, 0, 48),
			onActivated = v182,
			isDisabled = not v164,
			buttonRef = v171
		}) else React.createElement(Button2, {
			LayoutOrder = v215,
			variant = ButtonVariant.Standard,
			text = v208,
			icon = if not v131 then nil else Foundation.Enums.IconName.Key,
			onActivated = v182,
			isDisabled = not v164,
			size = InputSize.Large,
			width = UDim.new(1, 0),
			buttonRef = v171
		}) else React.createElement(Button2, {
			LayoutOrder = v215,
			variant = ButtonVariant.Emphasis,
			text = v208,
			icon = if not v131 then nil else Foundation.Enums.IconName.Key,
			onActivated = v182,
			isDisabled = not v164,
			size = InputSize.Large,
			width = UDim.new(1, 0),
			buttonRef = v171
		})
		local v218 = createPasswordButton and React.createElement(Button2, {
			LayoutOrder = createPasswordButton,
			variant = if not v130 then ButtonVariant.Emphasis else ButtonVariant.Standard,
			text = p21.createAPasswordButtonText,
			icon = if not v132 then nil else Foundation.Enums.IconName.LockClosed,
			onActivated = function() -- line: 971
				-- upvalues: v151 (copy)
				v151(false)
			end,
			size = InputSize.Large,
			width = UDim.new(1, 0)
		})

		return React.createElement(FullscreenPageWithSafeArea, {
			BackgroundTransparency = 0,
			includeStatusBar = true,
			BackgroundColor3 = if not v119 then DarkTheme.BackgroundUIDefault.Color else v174.Color.Surface.Surface_0.Color3
		}, {
			PageContent = React.createElement(PageWithDisclaimerLinks, {
				showFooter = v145
			}, {
				HeaderFrameListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				HeaderPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 25)
				}),
				HeaderFrame = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 48),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					LogoutButton = if shouldUseV2FallbackScreen then nil else React.createElement(ImageSetButton, {
						Size = UDim2.new(0, 36, 0, 36),
						AutoButtonColor = false,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						ScaleType = Enum.ScaleType.Fit,
						Image = Images["icons/navigation/close"],
						ImageColor3 = DarkTheme.UIEmphasis.Color,
						ImageTransparency = 0,
						[React.Event.Activated] = v183
					}),
					HeaderBackButton = if not v134 or v150 then nil else React.createElement(View, {
						tag = "col",
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 36, 0, 36),
						Position = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5)
					}, {
						Button = React.createElement(IconButton, {
							icon = IconName.ChevronLargeLeft,
							variant = ButtonVariant.Utility,
							size = ButtonSize.Medium,
							onActivated = function() -- line: 1033
								-- upvalues: v151 (copy)
								v151(true)
							end
						})
					}),
					Title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Text = p21.signUpLabel,
						Font = v173.Font.CaptionHeader.Font,
						TextSize = v188,
						TextColor3 = DarkTheme.TextEmphasis.Color,
						TextTransparency = DarkTheme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Center
					}),
					SetupLaterButton = if not v82 or not v141 then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -12, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						Button = React.createElement(LinkButton, {
							fontStyle = "CaptionHeader",
							colorStyleDefault = "TextDefault",
							colorStyleHover = "TextDefault",
							text = p21.setupLaterText,
							onActivated = function() -- line: 1064
								-- upvalues: v187 (copy), EventStreamConstants (copy)
								v187(EventStreamConstants.Button.SetupLaterCornerButton)
							end
						})
					})
				}),
				Divider = React.createElement("Frame", {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0.5, 0, 0, 48),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = not v119 and 0 or 1,
					BackgroundColor3 = DarkTheme.UIEmphasis.Color
				}),
				ContentFrame = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, -49),
					Position = UDim2.new(0.5, 0, 0, 49),
					AnchorPoint = Vector2.new(0.5, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ContainerListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 5)
					}),
					ContentPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24),
						PaddingTop = UDim.new(0, v95)
					}),
					MultiPageSignupText = if not v84 then nil else React.createElement(MultiPageSignupText, {
						layoutOrder = 1,
						titleText = v206,
						helpText = v207
					}),
					InstructionsHeadingText = if not v84 then React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextSize = 24,
						Text = v206,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = v173.Theme.TextEmphasis.Color,
						Font = v173.Font.Header1.Font
					}, {
						UIPadding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, 36)
						})
					}) else nil,
					InstructionsHeadingBody = if not v84 then React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextSize = 14,
						TextWrapped = true,
						Text = v207,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = v173.Theme.TextDefault.Color,
						Font = v173.Font.Header2.Font
					}, {}) else nil,
					Spacing = React.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 16)
					}),
					PasswordValidator = if v136 or not password then nil else React.createElement(CollapsingTextInputValidator, {
						titleTextKey = "CommonUI.Messages.Label.Password",
						summaryErrorTextKey = "Authentication.SignUp.Label.ErrorsWithPassword",
						prerequisiteMet = true,
						showDetailedError = true,
						layoutOrder = password,
						textInputType = EngineFeature and Enum.TextInputType.NewPassword or Enum.TextInputType.Password,
						onInputTextChanged = v179,
						onInputTextValidated = v179,
						validator = PasswordValidator,
						validatorAdditionalProps = {
							username = v186
						},
						returnKeyType = Enum.ReturnKeyType.Next,
						hidePassword = v146,
						onToggleCallback = v178,
						textBoxRef = v170
					}),
					EmailInput = if not v136 or not password then nil else React.createElement(TextInputBoxWithBorder, {
						textInputHeight = 36,
						textInputType = Enum.TextInputType.Email,
						layoutOrder = password,
						borderState = if not v158 then AuthStatefulRoundCornerBorder.BorderState.Default else AuthStatefulRoundCornerBorder.BorderState.Error,
						textBarColor = v173.Theme.BackgroundUIContrast.Color,
						onChangeTextCallback = v180,
						labelText = if not v116 then p21.emailLabelText else p21.parentEmailLabelText,
						labelTextColor = v173.Theme.TextDefault.Color,
						errorText = if v156 == "" then if not v158 then nil else p21.invalidEmailText else v156,
						Size = UDim2.new(1, 0, 0, 0),
						placeholderText = v90,
						placeholderTextColor = v173.Theme.TextDefault.Color
					}),
					ParentEmailDisclaimer = if not FFlagEnableAddAuthMethodPageEmailSignup or (not v136 or (not v116 or not continue)) then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = continue + 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 4)
						}),
						Label = React.createElement("TextLabel", {
							TextWrapped = true,
							BackgroundTransparency = 1,
							Text = p21.parentEmailDisclaimerText,
							TextColor3 = v173.Theme.TextDefault.Color,
							TextTransparency = v173.Theme.TextDefault.Transparency,
							Font = v173.Font.Footer.Font,
							TextSize = v173.Font.BaseSize * v173.Font.Footer.RelativeSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					}),
					Spacing2 = if not spacing then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = spacing,
						Size = UDim2.new(1, 0, 0, 8)
					}),
					ContinueButton = if not continue then nil else if not v130 then React.createElement(Button, {
						layoutOrder = continue,
						buttonType = ButtonType.PrimaryContextual,
						text = if not shouldUseV2FallbackScreen then p21.continueText else p21.doneText,
						size = UDim2.new(1, 0, 0, 48),
						onActivated = v181,
						isDisabled = not v162
					}) else React.createElement(Button2, {
						LayoutOrder = continue,
						variant = ButtonVariant.Standard,
						text = if not shouldUseV2FallbackScreen then p21.continueText else p21.doneText,
						icon = if not v132 then nil else Foundation.Enums.IconName.LockClosed,
						size = InputSize.Large,
						width = UDim.new(1, 0),
						onActivated = v181,
						isDisabled = not v162
					}),
					DividerWithText = if not shouldUseV2FallbackScreen or (v122 or (v128 or not divider)) then nil else React.createElement(DividerWithText, {
						width = 0,
						height = 0,
						padding = 8,
						layoutOrder = divider,
						size = UDim2.new(1, 0, 0, 32),
						font = v173.Font.BodySmall.Font,
						fontSize = v173.Font.BaseSize * v173.Font.BodySmall.RelativeSize,
						color3 = v173.Theme.TextMuted.Color,
						transparency = v173.Theme.TextMuted.Transparency,
						text = p21.dividerText
					}),
					CreatePasswordButton = v218,
					PasskeyButton = if not v122 and v215 then v217 else nil,
					SetupLaterBottomButton = if not v82 or not v142 then nil else React.createElement(Button2, {
						LayoutOrder = 11,
						variant = ButtonVariant.Utility,
						text = p21.setupLaterText,
						size = InputSize.Large,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 1274
							-- upvalues: v187 (copy), EventStreamConstants (copy)
							v187(EventStreamConstants.Button.SetupLaterRowButton)
						end
					})
				})
			})
		})
	end)
end
