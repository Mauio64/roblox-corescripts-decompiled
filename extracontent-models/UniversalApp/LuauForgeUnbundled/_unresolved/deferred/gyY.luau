local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/bundled/egx")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService

local appOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppOmniRecommendationsRequest
local module4 = require("@luauforge/bundled/grb")
local module5 = require("@luauforge/bundled/ecq")
local module6 = require("@luauforge/bundled/fzS")
local module7 = require("@luauforge/bundled/egs")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local darkTheme = UIBlox.App.Style.Themes.DarkTheme
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local module9 = require("@luauforge/bundled/ect")
local module10 = require("@luauforge/bundled/gyP")
local module11 = require("@luauforge/bundled/gyZ")
local LinkStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")
local button = UIBlox.App.Button.Button
local linkButton = UIBlox.App.Button.LinkButton
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local dividerWithText = AuthCommon.Components.DividerWithText
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local getPasswordManagerUsageStore = AuthCommon.Stores.GetPasswordManagerUsageStore
local passkeyRegistrationSource = AuthCommon.Enums.PasskeyRegistrationSource
local uiConstants = AuthCommon.Common.UIConstants
local module14 = require("@luauforge/deferred/gyK")
local module15 = require("@luauforge/deferred/gzb")
local loginV2OrDivider = require("@luauforge/bundled/gjC").LoginV2OrDivider

local Foundation = require(CorePackages.Packages.Foundation)
local button2 = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local inputSize = Foundation.Enums.InputSize
local iconName = Foundation.Enums.IconName
local iconButton = Foundation.IconButton
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module16 = require("@luauforge/bundled/ggi")
local module17 = require("@luauforge/bundled/geZ")
local module18 = require("@luauforge/bundled/grT")
local module19 = require("@luauforge/bundled/gfG")
local module20 = require("@luauforge/bundled/ggp")
local module21 = require("@luauforge/deferred/gzc")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module23 = require("@luauforge/deferred/gzd")
local module24 = require("@luauforge/bundled/gzf")
local module25 = require("@luauforge/bundled/gfK")
local module26 = require("@luauforge/bundled/ggu")
local constants = module26.Constants
local default = module26.CredentialsProtocol.default
local getUserAppLaunchInfo = require("@game/CorePackages/Workspace/Packages/AuthCommon").Http.Requests.GetUserAppLaunchInfo

local getAccountCreationMetadata = require("@luauforge/bundled/grL").Requests.GetAccountCreationMetadata
local launchContext = require("@luauforge/bundled/cBa").Enums.LaunchContext
local module27 = require("@luauforge/bundled/fGL")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local module28 = require("@luauforge/deferred/gzg")

local module29 = require("@luauforge/bundled/dzF")
local setCurrentToastMessage = module29.Actions.SetCurrentToastMessage
local toastType = module29.Enums.ToastType

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagEnableSavePasswordAfterRecovery = SharedFlags.GetFFlagEnableSavePasswordAfterRecovery
local fFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
local fFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish

local fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment = SharedFlags.FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
local fFlagEnableAddAuthMethodPageEmailSignup = SharedFlags.FFlagEnableAddAuthMethodPageEmailSignup
local defineFastFlag = game:DefineFastFlag("EnableAuthlessSignup", false)
local defineFastFlag2 = game:DefineFastFlag("CheckAndEnforceALNetworkCheck", false)

local defineFastFlag3 = game:DefineFastFlag("UseMultiPageSignupTextOnAddAuthMethodPage", false)
local defineFastFlag4 = game:DefineFastFlag("ShouldSkipPasskeySignupAutoFocus", false)
local defineFastInt = game:DefineFastInt("LuaAppCmPasswordRegistrationDelay", 2)
local defineFastFlag5 = game:DefineFastFlag("PasskeySignupAndroidIterationEnabled", false)
local defineFastFlag6 = game:DefineFastFlag("EnableAuthedUsernameCMFix", false)
local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local defineFastString = game:DefineFastString("AddAuthMethodEmailPlaceholder", "example@email.com")

local defineFastFlag7 = game:DefineFastFlag("EnableAddAuthMethodPageEmailSignupSetIsUnder13", false)

local defineFastFlag8 = game:DefineFastFlag("EnableAddAuthMethodPagePasskeyOrOTPText", false)
local defineFastFlag9 = game:DefineFastFlag("EnableStandardPasskeyButton", false)
local fFlagEnableFaceIDTextOnAddAuthMethodPage = SharedFlags.FFlagEnableFaceIDTextOnAddAuthMethodPage
local module31 = require("@luauforge/bundled/gzh")

local module32 = require("@luauforge/deferred/gzi")

local module33 = require("@luauforge/deferred/gzj")
local v5 = defineFastFlag3 and 24 or 60
local v6 = {
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
	showCreatePasswordButton = { passkey = 4, divider = 5, createPasswordButton = 6 },
	showCreatePasswordButtonPasswordFirst = {
		createPasswordButton = 4,
		divider = 5,
		passkey = 6
	},
	showPasswordSectionOnly = { password = 4, spacing = 5, continue = 6 }
}

if fFlagEnableAddAuthMethodPageEmailSignup then
	v6.passwordFirst = {
		password = 4,
		spacing = 5,
		continue = 6,
		divider = 8,
		passkeyV2 = 9,
		passkeyNonV2 = 8
	}
end

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/ggu").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local module34 = require("@luauforge/bundled/ghT")

local module35 = require("@luauforge/deferred/gzk")
local passkeyUpsellScreen = module35.Components.PasskeyUpsellScreen
local passkeyUpsellSource = module35.Enums.PasskeyUpsellSource

local fFlagAddReasonToEveryLogout = SharedFlags.FFlagAddReasonToEveryLogout
local fFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent

local telemetryConfigs = require("@luauforge/bundled/fzT").TelemetryConfigs

local iosAuthServiceHealthCounters = require("@luauforge/bundled/fzT").RobloxTelemetry.IosAuthServiceHealthCounters
local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local module36 = require("@luauforge/bundled/grU")

local getTextBoundsParams = Instance.new("GetTextBoundsParams")
getTextBoundsParams.Text = "_unused"
getTextBoundsParams.Font = Font.fromEnum(appFonts.default:getDefault())
getTextBoundsParams.Size = 19
getTextBoundsParams.Width = 0
TextService:GetTextBoundsAsync(getTextBoundsParams)

return function(p2)
	local v7 = module2(module3)
	local v8 = module2(appGuiService)
	local v9 = module2(module4)
	local v10 = module2(module5)
	local v11 = module2(appOmniRecommendationsRequest)
	local v12 = useAppPolicy(function(p3)
		return p3
	end)

	local v13 = if fFlagEnablePWManagerSignupCheck then getPasswordManagerUsageStore(false) else nil

	if fFlagEnablePWManagerSignupCheck then
		React.useEffect(function()
			if v13 then
				v13.resetAll()
			end
		end, { v13 })
	end

	local state, setState = React.useState(true)

	local shouldUseFoundationBackgroundColor = RoactAppExperiment.useBrowserTrackerExperiment(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p3)
			return {
				shouldUseFoundationBackgroundColor = (p3[appBtidLayers.AuthenticationStylingLayer] or {}).shouldUseFoundationBackgroundColor
			}
		end
	).shouldUseFoundationBackgroundColor

	local v14 = RoactAppExperiment.useBrowserTrackerExperiment({ appBtidLayers.SignupLayer }, function(p3)
		local v15 = p3[appBtidLayers.SignupLayer] or {}

		return {
			shouldUseV2FallbackScreen = v15.shouldUseV2FallbackScreen,
			shouldSuppressPasskeyOnAddAuthMethodPage = v15.shouldSuppressPasskeyOnAddAuthMethodPage,
			shouldWaitForPasswordRegistration = v15.shouldWaitForPasswordRegistration,
			shouldDelayPasswordRegistration = v15.shouldDelayPasswordRegistration,
			showPasskeyNudgingHeader = v15.showPasskeyNudgingHeader,
			showPasskeyBeforePassword = v15.showPasskeyBeforePassword,
			showPasskeyNudgingParagraph = v15.showPasskeyNudgingParagraph,
			shouldRemoveOrDivider = v15.shouldRemoveOrDivider,
			shouldUsePrimaryPasskeyButton = v15.shouldUsePrimaryPasskeyButton,
			shouldUseSecondaryPasswordNextButton = v15.shouldUseSecondaryPasswordNextButton,
			showPasskeyIconOnAddAuthMethodPage = v15.showPasskeyIconOnAddAuthMethodPage,
			showPasswordLockIconOnAddAuthMethodPage = v15.showPasswordLockIconOnAddAuthMethodPage,
			showPasskeyEducationalPage = v15.showPasskeyEducationalPage,
			shouldShowCreateAPasswordButton = v15.shouldShowCreateAPasswordButton,
			shouldDisablePasswordFocus = v15.shouldDisablePasswordFocus,
			shouldShowEmailSignupO13 = v15.shouldShowEmailSignupO13,
			shouldShowEmailSignupU13 = v15.shouldShowEmailSignupU13,
			shouldShowPasskeyOrOTPText = v15.shouldShowPasskeyOrOTPText,
			shouldShowSetupLaterInCornerWhenEmailProvided = v15.shouldShowSetupLaterInCornerWhenEmailProvided,
			shouldShowSetupLaterInBottomRowWhenEmailProvided = v15.shouldShowSetupLaterInBottomRowWhenEmailProvided,
			shouldUseStandardPasskeyButton = v15.shouldUseStandardPasskeyButton,
			shouldShowFaceIDText = v15.shouldShowFaceIDText
		}
	end)

	local shouldUseV2FallbackScreen = v14.shouldUseV2FallbackScreen
	local shouldSuppressPasskeyOnAddAuthMethodPage = module34()
		and v14.shouldSuppressPasskeyOnAddAuthMethodPage

	local shouldWaitForPasswordRegistration = defineFastFlag5 and v14.shouldWaitForPasswordRegistration

	local shouldDelayPasswordRegistration = defineFastFlag5 and v14.shouldDelayPasswordRegistration

	local showPasskeyNudgingHeader = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasskeyNudgingHeader

	local showPasskeyBeforePassword = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasskeyBeforePassword

	local showPasskeyNudgingParagraph = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasskeyNudgingParagraph

	local shouldRemoveOrDivider = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.shouldRemoveOrDivider

	local shouldUsePrimaryPasskeyButton = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.shouldUsePrimaryPasskeyButton

	local shouldUseSecondaryPasswordNextButton = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.shouldUseSecondaryPasswordNextButton

	local showPasskeyIconOnAddAuthMethodPage = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasskeyIconOnAddAuthMethodPage

	local showPasswordLockIconOnAddAuthMethodPage = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasswordLockIconOnAddAuthMethodPage

	local showPasskeyEducationalPage = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.showPasskeyEducationalPage

	local shouldShowCreateAPasswordButton = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.shouldShowCreateAPasswordButton

	local shouldDisablePasswordFocus = fFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment
		and v14.shouldDisablePasswordFocus
	local v15 = fFlagEnableAddAuthMethodPageEmailSignup

	if v15 then
		v15 = if state then v14.shouldShowEmailSignupU13 else v14.shouldShowEmailSignupO13
	end

	local shouldShowPasskeyOrOTPText = defineFastFlag8 and v14.shouldShowPasskeyOrOTPText

	local state2, setState2 = React.useState(false)

	local v16 = defineFastFlag and v15

	if defineFastFlag2 then
		v16 = v16 and state2
	end

	local shouldShowSetupLaterInCornerWhenEmailProvided = v16
		and v14.shouldShowSetupLaterInCornerWhenEmailProvided

	local shouldShowSetupLaterInBottomRowWhenEmailProvided = v16
		and v14.shouldShowSetupLaterInBottomRowWhenEmailProvided

	local shouldUseStandardPasskeyButton = defineFastFlag9 and v14.shouldUseStandardPasskeyButton

	local v17 = fFlagEnableFaceIDTextOnAddAuthMethodPage
		and v14.shouldShowFaceIDText
		and v12.getShouldShowFaceIDText()
	local v18

	if module31 then
		v18 = useSelector(function(p3): boolean
			return p3.FormFactor == formFactor.WIDE
		end)
	else
		v18 = false
	end

	local v19 = module31 and shouldUseV2FallbackScreen and not v15
	local v20 = module32 and v19
	local v21 = module33 and (v19 and "foundationAddAuthMethod" or "legacyAddAuthMethod") or nil
	local passkeySignupPasswordFallback = if module33 then module6.Context.PasskeySignupPasswordFallback else nil

	local v22 = shouldUseFoundationBackgroundColor or v19

	local v23 = v15 and state

	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(true)
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState("")
	local state9, setState9 = React.useState(false)

	local state10, setState10 = React.useState("")

	local state11, setState11 = React.useState(false)
	local state12, setState12 = React.useState(true)

	local state13, setState13 = React.useState(false)

	local state14, setState14 = React.useState(false)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = if module33 then React.useRef(false) else nil

	local v24 = module28.useIsIosAuthServiceEnabled()

	local v25 = useStyle()
	local v26 = useTokens()
	local v27 = useDispatch()

	local v28 = ReactFocusNavigation.useFocusGuiObject()
	local v29 = usePreferredInput()

	local function fn()
		module19.setSignupActionRequired("")

		module19.setPasskeySignupUsername("")

		module19.flush()
	end

	local function fn2()
		local authenticatedTheme = module19.getAuthenticatedTheme()

		if authenticatedTheme ~= "" then
			setState14(true)
			MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
		end

		module27.ClearThemeOverride()
	end

	local function fn3()
		if module33 then
			local reportAuthButtonClick = v9.reportAuthButtonClick
			local passkeySignupPasswordFallback2 = module6.Context.PasskeySignupPasswordFallback

			local v30 = if state3 then module6.Button.ShowPassword else module6.Button.HidePassword
			reportAuthButtonClick(
				passkeySignupPasswordFallback2,
				v30,
				state3 and "show" or "hide",
				nil,
				nil,
				passkeySignupPasswordFallback
			)
		end

		setState3(not state3)
	end

	local fn4 = module33 and function()
		if ref3 and ref3.current then
			ref3.current = false
		else
			v9.reportAuthFormInteraction(
				module6.Context.PasskeySignupPasswordFallback,
				module6.Field.Password,
				module6.ActionType.Focus,
				passkeySignupPasswordFallback
			)
		end
	end or nil

	local function fn5(p3, p4)
		setState6(p3)
		setState11(p4 == LinkStatus.Valid)
	end

	local function fn6(p3)
		local text2 = p3.Text
		setState7(text2)
		local v30 = module24((tostring(text2)))

		if v30 or text2 == "" then
			setState8("")
			setState9(false)
		else
			setState8("")
			setState9(true)
		end

		setState11(v30)
	end

	local function fn7()
		setState11(false)

		v9.reportAuthButtonClick(
			module6.Context.PasskeySignupPasswordFallback,
			module6.Button.Continue,
			v21,
			nil,
			nil,
			passkeySignupPasswordFallback
		)

		if not v15 then
			module21(v7, state6):andThen(function(p3)
				module19.setSignupActionRequired("")

				module19.setPasskeySignupUsername("")

				module19.flush()
				local v30

				if defineFastFlag6 and state10 and state10 ~= "" then
					v30 = state10
				else
					local passkeySignupUsername = module19.getPasskeySignupUsername()

					v30 = (not passkeySignupUsername or passkeySignupUsername == "")
						and (Players.LocalPlayer and Players.LocalPlayer.Name or "")
						or passkeySignupUsername
				end

				if shouldUseV2FallbackScreen and v30 and state6 then
					if not (fFlagDisableMemStorageServicePasswordEvent or state13 and v24) then
						MemStorageService:Fire(
							module25.AuthenticatedCredentials,
							HttpService:JSONEncode({
								cvalue = v30,
								password = state6,
								authType = "signup"
							})
						)
					end

					if state13 then
						local jsonEncode = HttpService:JSONEncode({
							username = v30,
							password = state6
						})

						local function fn8()
							if v24 then
								v9.reportAuthButtonClick(
									module6.Context.IosAuthServicePasswordFallback,
									module6.Button.IosAuthServiceSavePasswordAttempted
								)

								module36.reportAttempted(v30)
							end

							return default:registerCredentials(
								default.CredentialsTypes.password,
								jsonEncode,
								constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
							):andThen(
								function(json)
									local v32 = not json and {} or HttpService:JSONDecode(json)

									if v32 and v32.errorCode == nil then
										logger:info("Successfully registered password.")

										if v13 then
											v13.setPasswordManagerMediatedSignup(true)
										end

										v9.reportAuthButtonClick(
											module6.Context.CMPasswordPasskeyFallback,
											module6.Button.SavePassword
										)

										if v24 then
											v9.reportAuthButtonClick(
												module6.Context.IosAuthServicePasswordFallback,
												module6.Button.IosAuthServiceSavePasswordSuccess
											)

											module36.reportSuccess(v30)
										end

										iosAuthServiceHealthCounters.reportPasswordSaveSuccess({
											credentialType = "password",
											iosAuthServiceEnabled = v24 == true
										})
									else
										logger:warning("Error registering password: " .. tostring(v32.errorMsg))

										if v24 then
											v9.reportAuthButtonClick(
												module6.Context.IosAuthServicePasswordFallback,
												module6.Button.IosAuthServiceSavePasswordFailure,
												v32.errorMsg or "unknown"
											)

											module36.reportFailure(v30, v32.errorMsg or "unknown")
										end

										iosAuthServiceHealthCounters.reportPasswordSaveFailure({
											credentialType = "password",
											errorCode = (not v32 or v32.errorCode == nil) and "unknown" or tostring(v32.errorCode),
											iosAuthServiceEnabled = v24 == true
										})
									end

									if getFFlagEnableSavePasswordAfterRecovery() and v24 then
										local authenticatedTheme = module19.getAuthenticatedTheme()

										if authenticatedTheme ~= "" then
											setState14(true)
											MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
										end

										module27.ClearThemeOverride()

										v27(module17(v7, v11, v10, v12, launchContext.SignUp))

										setState11(true)
									end
								end,
								function(p4)
									logger:warning("Error registering password: " .. tostring(p4))

									if v24 then
										v9.reportAuthButtonClick(
											module6.Context.IosAuthServicePasswordFallback,
											module6.Button.IosAuthServiceSavePasswordFailure,
											(tostring(p4))
										)

										module36.reportFailure(v30, (tostring(p4)))
									end

									iosAuthServiceHealthCounters.reportPasswordSaveFailure({
										credentialType = "password",
										errorCode = "transportError",
										iosAuthServiceEnabled = v24 == true
									})

									if getFFlagEnableSavePasswordAfterRecovery() and v24 then
										local authenticatedTheme = module19.getAuthenticatedTheme()

										if authenticatedTheme ~= "" then
											setState14(true)
											MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
										end

										module27.ClearThemeOverride()

										v27(module17(v7, v11, v10, v12, launchContext.SignUp))

										setState11(true)
									end
								end
							)
						end

						if getFFlagEnableSavePasswordAfterRecovery() and v24 then
							return fn8()
						end

						local v32

						if shouldWaitForPasswordRegistration then
							v32 = fn8()
							v32:await()
						elseif shouldDelayPasswordRegistration then
							v32 = module7.delay(defineFastInt):andThen(fn8)
						else
							v32 = fn8()
						end

						return v32:andThen(function()
							local authenticatedTheme = module19.getAuthenticatedTheme()

							if authenticatedTheme ~= "" then
								setState14(true)
								MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
							end

							module27.ClearThemeOverride()

							v27(module17(v7, v11, v10, v12, launchContext.SignUp))

							setState11(true)
						end)
					elseif v24 then
						v9.reportAuthButtonClick(
							module6.Context.IosAuthServicePasswordFallback,
							module6.Button.IosAuthServiceSavePasswordSkipped,
							module6.State.IosAuthServiceProtocolNotAvailable
						)

						module36.reportSkipped(module6.State.IosAuthServiceProtocolNotAvailable)
					end
				end

				local authenticatedTheme = module19.getAuthenticatedTheme()

				if authenticatedTheme ~= "" then
					setState14(true)
					MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
				end

				module27.ClearThemeOverride()

				v27(module17(v7, v11, v10, v12, launchContext.SignUp))

				setState11(true)

				return module7.resolve()
			end, function(p3)
				v27(setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = "Authentication.Login.Response.SomethingWentWrong",
					toastIconColorStyle = {
						Color = v25.Theme.Alert.Color,
						Transparency = 0
					},
					slideIn = true
				}))

				setState11(true)
			end)

			return
		end

		v9.reportAuthButtonClick(module6.Context.SignupEmailOnAddAuthMethod, module6.Button.SubmitEmail)

		v27(module23(v7, state7, nil)):andThen(function()
			v9.reportAuthModalShown(module6.Context.SignupEmailOnAddAuthMethod, module6.State.Success)
			module19.setSignupActionRequired("")

			module19.setPasskeySignupUsername("")

			module19.flush()

			local authenticatedTheme = module19.getAuthenticatedTheme()

			if authenticatedTheme ~= "" then
				setState14(true)
				MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
			end

			module27.ClearThemeOverride()

			v27(module17(v7, v11, v10, v12, launchContext.SignUp))

			setState11(true)
		end, function(p3)
			local message = p3 and p3.Message and p3.Message ~= "" and p3.Message or ""

			v9.reportAuthClientError(module6.Context.SignupEmailOnAddAuthMethod, message)

			setState8(message)
			setState9(true)
			setState11(true)
		end)
	end

	local function onActivated()
		if not state12 then
			return
		end

		setState12(false)

		v9.reportAuthButtonClick(
			module6.Context.PasskeySignupPasswordFallback,
			module6.Button.SetupPasskey,
			v21,
			nil,
			nil,
			passkeySignupPasswordFallback
		)
		local v30

		if fFlagEmitPasskeyRegistrationSourceOnFinish then
			v30 = module18(v7, nil, nil, passkeyRegistrationSource.PasskeySignup)
		else
			v30 = module18(v7)
		end

		return v30:andThen(function(p3)
			v9.reportAuthModalShown(module6.Context.SignupPasswordFallbackPasskeyCreated, "success")
			module19.setSignupActionRequired("")

			module19.setPasskeySignupUsername("")

			module19.flush()

			local authenticatedTheme = module19.getAuthenticatedTheme()

			if authenticatedTheme ~= "" then
				setState14(true)
				MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
			end

			module27.ClearThemeOverride()

			v27(module17(v7, v11, v10, v12, launchContext.SignUp))

			return module7.resolve()
		end, function(data)
			if data.name then
				v9.reportAuthModalShown(module6.Context.SignupPasswordFallbackPasskeyCreated, data.name)

				if type(data.body) == "string" then
					v9.reportAuthClientError(
						module6.Context.SignupPasswordFallbackPasskeyCreated,
						data.body,
						data.source
					)
				end
			else
				v9.reportAuthModalShown(module6.Context.SignupPasswordFallbackPasskeyCreated, "unknown")
			end

			setState12(true)
			return module7.resolve()
		end)
	end

	local function fn8()
		v9.reportAuthButtonClick(
			module6.Context.PasskeySignupPasswordFallback,
			module6.Button.Close,
			v21,
			nil,
			nil,
			passkeySignupPasswordFallback
		)
		module19.setSignupActionRequired("")

		module19.setPasskeySignupUsername("")

		module19.flush()

		v27(module16(v7, v8, module20.MultiStepSignupCanceled))
	end

	React.useEffect(function()
		if not defineFastFlag4 and ref.current then
			if shouldDisablePasswordFocus and ref2.current then
				if v29 == Responsive.Input.Directional then
					v28(ref2.current)
				end
			else
				if module33 and ref3 then
					ref3.current = true
				end

				ref.current:CaptureFocus()

				if module33 and ref3 and not ref.current:IsFocused() then
					ref3.current = false
				end
			end
		end

		v9.reportAuthPageload(
			module6.Context.PasskeySignupPasswordFallback,
			v21,
			nil,
			passkeySignupPasswordFallback
		)

		if v15 then
			v9.reportAuthPageload(module6.Context.SignupEmailOnAddAuthMethod)
		end

		default2:logRobloxTelemetryCounter(telemetryConfigs.AddAuthMethodPageMountTelemetryConfig, 1)
	end, {})

	React.useEffect(function()
		if not state14 then
			MemStorageService:Fire(module25.ThemeUpdate, "dark")
			module27.SetDarkThemeOverride()
		end
	end, { v25 })

	React.useEffect(function()
		if shouldUseV2FallbackScreen then
			default:isAvailable(
				default.CredentialsTypes.FIDO2,
				getFIntLuaAppCredentialsProtocolAvailableTimeout()
			):andThen(function(p3)
				local v30 = p3.password and p3.password.isAvailable and true or false

				v9.reportAuthPageload(module6.Context.CMPasswordPasskeySignup, (tostring(v30)))

				setState13(v30)
			end):catch(function(p3)
				logger:warning("Error checking for available credential types. Error: ", p3)
			end)
		end
	end, { shouldUseV2FallbackScreen })

	React.useEffect(function()
		getUserAppLaunchInfo(v7):andThen(function(p3)
			local name = if p3 and p3.responseBody then p3.responseBody.name else nil

			if name and name ~= "" then
				if defineFastFlag6 then
					setState10(name)
				end

				if defineFastFlag7 then
					setState(Models.fromUserInfoRequest(p3).isUnder13)
				end
			else
				module19.setSignupActionRequired("")

				module19.setPasskeySignupUsername("")

				module19.flush()

				if fFlagAddReasonToEveryLogout then
					v27(module16(v7, GuiService, module20.MultiStepSignupResetIncompleteState))
				else
					v27(module16(v7, GuiService))
				end
			end
		end):catch(function(p3)
			module19.setSignupActionRequired("")

			module19.setPasskeySignupUsername("")

			module19.flush()

			if fFlagAddReasonToEveryLogout then
				v27(module16(v7, GuiService, module20.MultiStepSignupResetIncompleteState))
			else
				v27(module16(v7, GuiService))
			end
		end)
	end, {})

	React.useEffect(function()
		if defineFastFlag2 then
			local v30 = module6.State.ALError
			getAccountCreationMetadata(v7):andThen(function(p3)
				if not p3 or not p3.responseBody or p3.responseBody.isEligibleForALSignup ~= true then
					v30 = module6.State.ALCheckFail

					return
				end

				v30 = module6.State.ALCheckSuccess
				setState2(true)
			end):catch(function()
				v30 = module6.State.ALError
			end):finally(function()
				v9.reportAuthPageload(module6.Context.AddAuthMethodPage, v30)
			end)
		end
	end, { v7, v9.reportAuthPageload })
	local v30

	if defineFastFlag6 and state10 and state10 ~= "" then
		v30 = state10
	else
		local passkeySignupUsername = module19.getPasskeySignupUsername()

		v30 = (not passkeySignupUsername or passkeySignupUsername == "")
			and (Players.LocalPlayer and Players.LocalPlayer.Name or "")
			or passkeySignupUsername
	end

	local v31 = React.useCallback(function(p3)
		v9.reportAuthButtonClick(module6.Context.PasskeySignupPasswordFallback, p3)
		module19.setSignupActionRequired("")

		module19.setPasskeySignupUsername("")

		module19.flush()

		local authenticatedTheme = module19.getAuthenticatedTheme()

		if authenticatedTheme ~= "" then
			setState14(true)
			MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
		end

		module27.ClearThemeOverride()

		v27(module17(v7, v11, v10, v12, launchContext.SignUp))
	end, { v12, v9.reportAuthButtonClick, v27, v7, v11, fn, fn2, v10 })

	if showPasskeyEducationalPage and not state4 then
		return React.createElement(passkeyUpsellScreen, {
			resetNavigationHistory = function(p3)
				v9.reportAuthModalShown(
					module6.Context.SignupPasswordFallbackPasskeyCreatedFromEducation,
					"success"
				)
				module19.setSignupActionRequired("")

				module19.setPasskeySignupUsername("")

				module19.flush()

				local authenticatedTheme = module19.getAuthenticatedTheme()

				if authenticatedTheme ~= "" then
					setState14(true)
					MemStorageService:Fire(module25.ThemeUpdate, authenticatedTheme)
				end

				module27.ClearThemeOverride()

				v27(module17(v7, v11, v10, v12, launchContext.SignUp))
			end,
			onDismiss = function()
				setState4(true)
			end,
			source = passkeyUpsellSource.AddAuthMethodPage
		})
	end

	local v32 = v25.Font.BaseSize * v25.Font.Header1.RelativeSize

	return withLocalization({
		userGreetingHeaderText = {
			"Authentication.SignUp.Heading.UserGreetingWithName",
			username = v30
		},
		userGreetingHeaderTextWithPasskeyPassword = {
			"Authentication.SignUp.Heading.UserGreetingWithNameAndPasskeyPassword",
			username = v30
		},
		userPasswordOnlyGreetingHeaderText = {
			"Authentication.SignUp.Title",
			username = v30
		},
		continueText = "Authentication.SignUp.Label.Continue",
		doneText = v20 and "Authentication.SignUp.Label.AddPassword" or "CommonUI.Controls.Action.Done",
		passwordHint = "Authentication.SignUp.Label.Use8CharPassword",
		passwordPlaceholderText = "Authentication.SignUp.Label.PasswordPlaceholder",
		signUpLabel = "Authentication.SignUp.Action.CreateAccount",
		signUpSentenceCaseLabel = "Authentication.SignUp.Action.CreateAccountSentenceCase",
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
		enableFaceIDText = "Authentication.SignUp.Action.EnableFaceId"
	})(function(props)
		local v33

		if shouldUseV2FallbackScreen and v30 then
			if shouldShowCreateAPasswordButton and not state5 then
				v33 = props.userGreetingHeaderText
			elseif v17 then
				v33 = props.faceIDHeadingText
			elseif showPasskeyNudgingHeader then
				v33 = props.createdAccountChooseSigninText
			else
				v33 = props.userGreetingHeaderText
			end
		else
			v33 = props.oneMoreStepText
		end

		local v34

		if shouldShowCreateAPasswordButton and not state5 then
			v34 = props.createAPasswordText
		elseif v17 then
			v34 = props.faceIDDescriptionText
		elseif showPasskeyNudgingParagraph and shouldShowPasskeyOrOTPText then
			v34 = props.createPasskeyOrOTPText
		elseif showPasskeyNudgingParagraph then
			v34 = props.createAccountPasskeyEmphasisDescriptionText
		else
			v34 = props.createAPasswordText
		end

		if module34() and shouldSuppressPasskeyOnAddAuthMethodPage then
			v33 = props.userPasswordOnlyGreetingHeaderText
			v34 = props.ensureNeverLoseAccountText
		end

		local v35 = if v17 then props.enableFaceIDText else props.createAPasskeyLabel
		local v37 = shouldShowCreateAPasswordButton
			and (state5 and showPasskeyBeforePassword and "showCreatePasswordButton" or state5 and "showCreatePasswordButtonPasswordFirst" or "showPasswordSectionOnly")
			or showPasskeyBeforePassword and "passkeyFirst"
			or "passwordFirst"
		local v38 = v6[v37]
		local password = v38.password
		local spacing = v38.spacing
		local continue = v38.continue
		local divider = v38.divider
		local v39 = v38.passkey

		if not v39 then
			v39 = if shouldUseV2FallbackScreen then v38.passkeyV2 else v38.passkeyNonV2
		end

		local v40 = v38.createPasswordButton
		local v41 = not v19 and 24 or v26.Padding.XLarge
		local v42 = not v19 and 5 or v26.Gap.Small
		local v43

		if shouldUseV2FallbackScreen and shouldUsePrimaryPasskeyButton then
			local createElement = React.createElement
			local v45 = {
				LayoutOrder = v39,
				testId = "--auth-signup-button-add-passkey-primary",
				variant = buttonVariant.Emphasis,
				text = v35,
				icon = 0,
				onActivated = 0,
				isDisabled = 0,
				size = 0,
				width = 0,
				buttonRef = 0
			}

			local v46 = if showPasskeyIconOnAddAuthMethodPage then Foundation.Enums.IconName.Key else nil
			v45.icon = v46
			v45.onActivated = onActivated
			v45.isDisabled = not state12
			v45.size = inputSize.Large
			v45.width = UDim.new(1, 0)
			v45.buttonRef = ref2
			v43 = createElement(button2, v45)
		elseif shouldUseV2FallbackScreen and (shouldUseStandardPasskeyButton or v19) then
			local createElement = React.createElement
			local v45 = {
				LayoutOrder = v39,
				testId = "--auth-signup-button-add-passkey-standard",
				variant = buttonVariant.Standard,
				text = v35,
				icon = 0,
				onActivated = 0,
				isDisabled = 0,
				size = 0,
				width = 0,
				buttonRef = 0
			}

			local v46 = if showPasskeyIconOnAddAuthMethodPage then Foundation.Enums.IconName.Key else nil
			v45.icon = v46
			v45.onActivated = onActivated
			v45.isDisabled = not state12
			v45.size = inputSize.Large
			v45.width = UDim.new(1, 0)
			v45.buttonRef = ref2
			v43 = createElement(button2, v45)
		elseif shouldUseV2FallbackScreen then
			v43 = React.createElement(button, {
				layoutOrder = v39,
				buttonType = buttonType.Secondary,
				text = v35,
				size = UDim2.new(1, 0, 0, 48),
				onActivated = onActivated,
				isDisabled = not state12,
				buttonRef = ref2
			})
		else
			v43 = React.createElement(linkButton, {
				layoutOrder = v39,
				text = props.setUpPasskeyLabel,
				onActivated = onActivated,
				isDisabled = not state12,
				buttonRef = ref2
			})
		end

		if v40 then
			local createElement = React.createElement

			local v46 = if shouldUseSecondaryPasswordNextButton then buttonVariant.Standard else buttonVariant.Emphasis
			local v45 = {
				LayoutOrder = v40,
				testId = "--auth-signup-button-create-password",
				variant = v46,
				text = props.createAPasswordButtonText,
				icon = 0,
				onActivated = 0,
				size = 0,
				width = 0
			}
			local v47 = if showPasswordLockIconOnAddAuthMethodPage then Foundation.Enums.IconName.LockClosed else nil
			v45.icon = v47
			function v45.onActivated()
				if module33 then
					v9.reportAuthButtonClick(
						module6.Context.PasskeySignupPasswordFallback,
						module6.Button.Password,
						v21,
						nil,
						nil,
						passkeySignupPasswordFallback
					)
				end

				setState5(false)
			end
			v45.size = inputSize.Large
			v45.width = UDim.new(1, 0)
			v40 = createElement(button2, v45)
		end

		local v44 = continue and (shouldUseSecondaryPasswordNextButton or v19)

		if v44 then
			local createElement = React.createElement
			local v46 = {
				LayoutOrder = if not v20 then continue else nil,
				testId = "--auth-signup-button-continue",
				variant = 0,
				text = 0,
				icon = 0,
				size = 0,
				width = 0,
				onActivated = 0,
				isDisabled = 0
			}

			local v48 = if shouldUseSecondaryPasswordNextButton then buttonVariant.Standard else buttonVariant.Emphasis
			v46.variant = v48

			local v49 = if shouldUseV2FallbackScreen then props.doneText else props.continueText
			v46.text = v49
			local v50 = if showPasswordLockIconOnAddAuthMethodPage then Foundation.Enums.IconName.LockClosed else nil
			v46.icon = v50
			v46.size = inputSize.Large
			v46.width = UDim.new(1, 0)
			v46.onActivated = fn7
			v46.isDisabled = not state11
			v44 = createElement(button2, v46)
		end

		local createElement = React.createElement

		local v47 = if v22 then v26.Color.Surface.Surface_0.Color3 else darkTheme.BackgroundUIDefault.Color

		local createElement2 = React.createElement

		local children = {
			HeaderFrameListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			HeaderPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 25)
			}),
			HeaderFrame = 0,
			Divider = 0,
			ContentFrame = 0
		}

		local createElement3 = React.createElement
		local v52 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 48),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v54

		if not shouldUseV2FallbackScreen then
			v54 = React.createElement(imageSetButton, {
				Size = UDim2.new(0, 36, 0, 36),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ScaleType = Enum.ScaleType.Fit,
				Image = images["icons/navigation/close"],
				ImageColor3 = darkTheme.UIEmphasis.Color,
				ImageTransparency = 0,
				[React.Event.Activated] = fn8
			})
		end

		local v55

		if shouldShowCreateAPasswordButton and not state5 then
			v55 = React.createElement(view, {
				tag = "col",
				Size = UDim2.new(0, 36, 0, 36),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Button = React.createElement(iconButton, {
					testId = "--auth-signup-iconbutton-back",
					icon = iconName.ChevronLargeLeft,
					variant = buttonVariant.Utility,
					size = buttonSize.Medium,
					onActivated = function()
						if module33 then
							v9.reportAuthButtonClick(
								module6.Context.PasskeySignupPasswordFallback,
								module6.Button.Back,
								v21,
								nil,
								nil,
								passkeySignupPasswordFallback
							)
						end

						setState5(true)
					end
				})
			})
		end

		local v56

		if v19 then
			local createElement4 = React.createElement
			local v58 = {
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Text = 0,
				fontStyle = 0,
				TextXAlignment = 0
			}

			local v59 = if v20 then props.signUpSentenceCaseLabel else props.signUpLabel
			v58.Text = v59

			v58.fontStyle = v26.Typography.HeadingSmall
			v58.TextXAlignment = Enum.TextXAlignment.Center
			v56 = createElement4(text, v58)
		else
			v56 = React.createElement("TextLabel", {
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Text = props.signUpLabel,
				TextWrapped = true,
				FontFace = normalizeFontFace(v26.Typography.CaptionLarge.Font),
				TextSize = v32,
				TextColor3 = darkTheme.TextEmphasis.Color,
				TextTransparency = darkTheme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center
			})
		end

		local v57

		if defineFastFlag and shouldShowSetupLaterInCornerWhenEmailProvided then
			v57 = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY
				},
				{
					Button = React.createElement(linkButton, {
						text = props.setupLaterText,
						fontStyle = "CaptionHeader",
						colorStyleDefault = "TextDefault",
						colorStyleHover = "TextDefault",
						onActivated = function()
							v31(module6.Button.SetupLaterCornerButton)
						end
					})
				}
			)
		end

		children.HeaderFrame = createElement3("Frame", v52, {
			LogoutButton = v54,
			HeaderBackButton = v55,
			Title = v56,
			SetupLaterButton = v57
		})

		children.Divider = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 48),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = v22 and 1 or 0,
			BackgroundColor3 = darkTheme.UIEmphasis.Color,
			LayoutOrder = 2
		})

		local createElement4 = React.createElement
		local v59 = {
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 1, -49),
			Position = UDim2.new(0.5, 0, 0, 49),
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v60 = if v19 and v18 then React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(540, 1e999)
		}) else nil
		local children2 = {
			SizeConstraint = v60,
			ContainerListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v42)
			}),
			ContentPadding = 0,
			MultiPageSignupText = 0,
			InstructionsHeadingText = 0,
			InstructionsHeadingBody = 0,
			Spacing = 0,
			PasswordValidator = 0,
			EmailInput = 0,
			ParentEmailDisclaimer = 0,
			Spacing2 = 0,
			ContinueButton = 0,
			DividerWithText = 0,
			CreatePasswordButton = 0,
			PasskeyButton = 0,
			SetupLaterBottomButton = 0
		}

		local createElement5 = React.createElement
		local v62 = {
			PaddingLeft = UDim.new(0, v41),
			PaddingRight = UDim.new(0, v41),
			PaddingTop = 0
		}
		local newUDim = UDim.new

		local v64 = if v19 then v26.Padding.Medium else v5
		v62.PaddingTop = newUDim(0, v64)
		children2.ContentPadding = createElement5("UIPadding", v62)

		local v65 = if defineFastFlag3 and not v19 then React.createElement(module14, {
			layoutOrder = 1,
			titleText = v33,
			helpText = v34
		}) else nil
		children2.MultiPageSignupText = v65
		local v66

		if v19 then
			v66 = React.createElement(text, {
				LayoutOrder = 1,
				Text = v33,
				tag = "size-full-0 auto-y text-heading-medium content-emphasis text-wrap text-align-x-left"
			})
		elseif not defineFastFlag3 then
			v66 = React.createElement("TextLabel", {
				Text = v33,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = v25.Theme.TextEmphasis.Color,
				FontFace = normalizeFontFace(v26.Typography.HeadingSmall.Font),
				TextSize = 24
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 36)
				})
			})
		end

		children2.InstructionsHeadingText = v66
		local v67

		if v19 then
			v67 = React.createElement(text, {
				LayoutOrder = 2,
				Text = v34,
				tag = "size-full-0 auto-y text-body-medium content-default text-wrap text-align-x-left"
			})
		elseif not defineFastFlag3 then
			v67 = React.createElement("TextLabel", {
				Text = v34,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v25.Theme.TextDefault.Color,
				FontFace = normalizeFontFace(v26.Typography.TitleLarge.Font),
				TextSize = 14,
				TextWrapped = true
			}, {})
		end

		children2.InstructionsHeadingBody = v67

		children2.Spacing = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, not v19 and 16 or v26.Gap.Small)
		})
		local v68

		if not (v15 or not password) then
			local createElement6 = React.createElement

			local v71 = if v20 then props.passwordPlaceholderText else nil

			local v72 = if v19 and not state3 then engineFeature and Enum.TextInputType.NewPasswordShown or Enum.TextInputType.PasswordShown else engineFeature and Enum.TextInputType.NewPassword or Enum.TextInputType.Password
			local v70 = {
				layoutOrder = password,
				titleTextKey = "CommonUI.Messages.Label.Password",
				summaryErrorTextKey = "Authentication.SignUp.Label.ErrorsWithPassword",
				placeholderText = v71,
				prerequisiteMet = true,
				textInputType = v72,
				useFoundationTextInput = v19,
				useFoundationTitle = v19,
				foundationTitleIsBold = v20,
				foundationInputSize = 0,
				foundationIconTrailing = 0,
				paddingTopOverride = 0,
				paddingBottomOverride = 0,
				useTrailingPadding = 0,
				contentGapOverride = 0,
				onInputTextChanged = 0,
				onInputTextValidated = 0,
				validator = 0,
				validatorAdditionalProps = 0,
				returnKeyType = 0,
				hidePassword = 0,
				onToggleCallback = 0,
				textBoxFocusedCallback = 0,
				showDetailedError = true,
				textBoxRef = 0
			}

			local v73 = if v19 then inputSize.Large else nil
			v70.foundationInputSize = v73
			local v74

			if v19 then
				v74 = { name = 0, onActivated = 0 }

				local v75 = if state3 then uiConstants.HIDE_PASSWORD_ICON else uiConstants.SHOW_PASSWORD_ICON
				v74.name = v75

				v74.onActivated = fn3
			end

			v70.foundationIconTrailing = v74

			v70.paddingTopOverride = v19 and 0 or nil
			v70.paddingBottomOverride = v19 and 0 or nil
			v70.useTrailingPadding = v20
			local v75 = if v19 then v26.Gap.Small else nil
			v70.contentGapOverride = v75
			v70.onInputTextChanged = fn5
			v70.onInputTextValidated = fn5
			v70.validator = module11
			v70.validatorAdditionalProps = { username = v30 }

			v70.returnKeyType = Enum.ReturnKeyType.Next
			v70.hidePassword = state3
			v70.onToggleCallback = fn3
			v70.textBoxFocusedCallback = fn4

			v70.textBoxRef = ref
			v68 = createElement6(module10, v70)
		end

		children2.PasswordValidator = v68
		local v69

		if v15 and password then
			local createElement6 = React.createElement
			local v71 = {
				textInputType = Enum.TextInputType.Email,
				textInputHeight = 36,
				layoutOrder = password,
				borderState = 0,
				textBarColor = 0,
				onChangeTextCallback = 0,
				labelText = 0,
				labelTextColor = 0,
				errorText = 0,
				Size = 0,
				placeholderText = 0,
				placeholderTextColor = 0
			}

			local v72 = if state9 then authStatefulRoundCornerBorder.BorderState.Error else authStatefulRoundCornerBorder.BorderState.Default
			v71.borderState = v72

			v71.textBarColor = v25.Theme.BackgroundUIContrast.Color
			v71.onChangeTextCallback = fn6

			local v73 = if state then props.parentEmailLabelText else props.emailLabelText
			v71.labelText = v73

			v71.labelTextColor = v25.Theme.TextDefault.Color
			local v74

			if state8 == "" then
				if state9 then
					v74 = props.invalidEmailText
				end
			else
				v74 = state8
			end

			v71.errorText = v74

			v71.Size = UDim2.new(1, 0, 0, 0)
			v71.placeholderText = defineFastString
			v71.placeholderTextColor = v25.Theme.TextDefault.Color
			v69 = createElement6(textInputBoxWithBorder, v71)
		end

		children2.EmailInput = v69

		local v70 = if fFlagEnableAddAuthMethodPageEmailSignup and v15 and state and continue then React.createElement("Frame", {
			LayoutOrder = continue + 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 4) }),
			Label = React.createElement("TextLabel", {
				Text = props.parentEmailDisclaimerText,
				TextColor3 = v25.Theme.TextDefault.Color,
				TextTransparency = v25.Theme.TextDefault.Transparency,
				FontFace = normalizeFontFace(v26.Typography.CaptionSmall.Font),
				TextSize = v25.Font.BaseSize * v25.Font.Footer.RelativeSize,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		}) else nil
		children2.ParentEmailDisclaimer = v70

		local v71 = if spacing and not v20 then React.createElement("Frame", {
			LayoutOrder = spacing,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 8)
		}) else nil
		children2.Spacing2 = v71

		if continue then
			if v20 then
				v44 = React.createElement(view, {
					LayoutOrder = continue,
					tag = "size-full-0 auto-y",
					padding = {
						top = UDim.new(0, v26.Gap.XXLarge - v42)
					}
				}, { Button = v44 })
			elseif not v44 then
				local createElement6 = React.createElement
				local v73 = {
					layoutOrder = continue,
					buttonType = buttonType.PrimaryContextual,
					text = 0,
					size = 0,
					onActivated = 0,
					isDisabled = 0
				}

				local v74 = if shouldUseV2FallbackScreen then props.doneText else props.continueText
				v73.text = v74

				v73.size = UDim2.new(1, 0, 0, 48)
				v73.onActivated = fn7
				v73.isDisabled = not state11
				v44 = createElement6(button, v73)
			end
		else
			v44 = nil
		end

		children2.ContinueButton = v44
		local v72

		if
			shouldUseV2FallbackScreen
			and not shouldSuppressPasskeyOnAddAuthMethodPage
			and not shouldRemoveOrDivider
			and divider
		then
			if v20 and v37 == "passwordFirst" then
				v72 = React.createElement(view, {
					LayoutOrder = divider,
					tag = "size-full-0 auto-y",
					padding = {
						top = UDim.new(0, v26.Gap.Large - v42),
						bottom = UDim.new(0, v26.Gap.Large - v42)
					}
				}, {
					OrDivider = React.createElement(loginV2OrDivider, {
						orText = props.dividerText
					})
				})
			elseif v19 then
				v72 = React.createElement(loginV2OrDivider, {
					orText = props.dividerText,
					layoutOrder = divider
				})
			else
				v72 = React.createElement(dividerWithText, {
					layoutOrder = divider,
					width = 0,
					height = 0,
					size = UDim2.new(1, 0, 0, 32),
					font = v25.Font.BodySmall.Font,
					fontSize = v25.Font.BaseSize * v25.Font.BodySmall.RelativeSize,
					color3 = v25.Theme.TextMuted.Color,
					transparency = v25.Theme.TextMuted.Transparency,
					text = props.dividerText,
					padding = 8
				})
			end
		end

		children2.DividerWithText = v72

		children2.CreatePasswordButton = v40

		if shouldSuppressPasskeyOnAddAuthMethodPage or not v39 then
			v43 = nil
		end

		children2.PasskeyButton = v43
		local v73

		if defineFastFlag and shouldShowSetupLaterInBottomRowWhenEmailProvided then
			v73 = React.createElement(button2, {
				LayoutOrder = 11,
				testId = "--auth-signup-button-setup-later",
				variant = buttonVariant.Utility,
				text = props.setupLaterText,
				size = inputSize.Large,
				width = UDim.new(1, 0),
				onActivated = function()
					v31(module6.Button.SetupLaterRowButton)
				end
			})
		end

		children2.SetupLaterBottomButton = v73
		children.ContentFrame = createElement4("Frame", v59, children2)
		return createElement(
			module9,
			{
				BackgroundTransparency = 0,
				includeStatusBar = true,
				BackgroundColor3 = v47
			},
			{
				PageContent = createElement2(module15, { showFooter = v23 }, children)
			}
		)
	end)
end
