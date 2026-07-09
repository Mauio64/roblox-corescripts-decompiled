local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local Promise = require(Modules.LuaApp.Promise)
local AppPage = require(Modules.LuaApp.AppPage)
local User = require(script.Parent.User)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local SignUpRequests = require(Modules.LuaApp.Http.Requests.SignUpRequests)
local SignUpV2ErrorCodes = require(Modules.LuaApp.Enum.SignUpV2ErrorCodes)
local VerifiedSignupErrorCodes = require(Modules.LuaApp.Enum.VerifiedSignupErrorCodes)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local AppSignupCounterNames = require(Modules.LuaApp.Analytics.Events.AppSignupCounterNames)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local GetDxBlob = require(Modules.LuaApp.Thunks.Captcha.GetDxBlob)
local GetCaptchaData = require(Modules.LuaApp.Thunks.Captcha.GetCaptchaData)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local CredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol)
local Constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local FFlagLuaEnableDidSwitchAccount = require(Modules.LuaApp.Flags.FFlagLuaEnableDidSwitchAccount)
local GetFFlagConditionallyFireAuthenticatedCredentials = require(Modules.LuaApp.Flags.GetFFlagConditionallyFireAuthenticatedCredentials)
local GetFFlagFixAuthlessPasskeyPopupAccountCreation = require(Modules.LuaApp.Flags.GetFFlagFixAuthlessPasskeyPopupAccountCreation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local FFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local GetFFlagEnableSavePasswordAfterRecovery = SharedFlags.GetFFlagEnableSavePasswordAfterRecovery
local RegisterPasskey = require(Modules.LuaApp.Thunks.Authentication.RegisterPasskey)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local Constants2 = require(Modules.LuaApp.Constants)
local EventStreamConstants2 = require(CorePackages.Workspace.Packages.AuthAnalytics).EventStreamConstants
local AccountSwitcherConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.AccountSwitcherConstants
local iosAuthServiceSignupPasswordSave = require(Modules.LuaApp.Analytics.Events.Auth.iosAuthServiceSignupPasswordSave)
local v50 = t.interface({
	birthday = t.string,
	username = t.string,
	password = t.string,
	gender = t.string,
	locale = t.optional(t.string),
	email = t.optional(t.string),
	verifiedSignupVoucher = t.optional(t.string)
})

local function signUpRequest(p1, p2, p3, p4) -- line: 86
	-- upvalues: getAppFeaturePolicies (copy), SignUpRequests (copy)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return SignUpRequests.singleSignOnSignup(p1, p2)
	end

	if p4 then
		return SignUpRequests.verifiedSignup(p1, p2, p3)
	end

	return SignUpRequests.signUpV2(p1, p2, p3)
end

return function(p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18) -- line: 98
	-- upvalues: v50 (copy), FFlagEnableLuaAccountSwitch (copy), User (copy), ResetAppState (copy), AppStorageUtilities (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants2 (copy), GetFFlagFixAuthlessPasskeyPopupAccountCreation (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), ResetNavigationHistory (copy), AppPage (copy), LaunchApp (copy), LaunchContext (copy), signUpRequest (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), EventStreamConstants (copy), EventStreamConstants2 (copy), GetFFlagConditionallyFireAuthenticatedCredentials (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), RegisterPasskey (copy), Promise (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), VerifiedSignupErrorCodes (copy), SignUpV2ErrorCodes (copy), StatusCodes (copy), GetDxBlob (copy), GetCaptchaData (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), ToastType (copy), SetNetworkingErrorToast (copy)
	return function(p19) -- line: 114
		-- upvalues: v50 (copy), p12 (copy), FFlagEnableLuaAccountSwitch (copy), User (copy), ResetAppState (copy), AppStorageUtilities (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants2 (copy), GetFFlagFixAuthlessPasskeyPopupAccountCreation (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), ResetNavigationHistory (copy), AppPage (copy), LaunchApp (copy), p5 (copy), p6 (copy), p10 (copy), p11 (copy), LaunchContext (copy), signUpRequest (copy), p9 (copy), p13 (copy), p14 (copy), p7 (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), p17 (copy), EventStreamConstants (copy), EventStreamConstants2 (copy), p16 (copy), p18 (copy), GetFFlagConditionallyFireAuthenticatedCredentials (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), p15 (copy), RegisterPasskey (copy), Promise (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), VerifiedSignupErrorCodes (copy), SignUpV2ErrorCodes (copy), StatusCodes (copy), GetDxBlob (copy), GetCaptchaData (copy), p8 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), ToastType (copy), SetNetworkingErrorToast (copy)
		assert(v50(p12))

		local function proceedPostSignup(p20, p21) -- line: 117
			-- upvalues: FFlagEnableLuaAccountSwitch (copy), User (copy), p19 (copy), ResetAppState (copy), AppStorageUtilities (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants2 (copy), GetFFlagFixAuthlessPasskeyPopupAccountCreation (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), ResetNavigationHistory (copy), AppPage (copy), LaunchApp (copy), p5 (copy), p6 (copy), p10 (copy), p11 (copy), LaunchContext (copy)
			if FFlagEnableLuaAccountSwitch == true then
				local v74 = User.fromLocalStorage()

				if v74 and v74.userId ~= -1 then
					p19:dispatch(ResetAppState())
					AppStorageUtilities.setAccountSwitchStatus(if not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then Constants2.Auth.AccountSwitcherSwitchedStatus else AccountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus)

					if not GetFFlagFixAuthlessPasskeyPopupAccountCreation() then
						AppStorageUtilities.setAccountBlob(p20.responseBody.accountBlob)
					end

					AppStorageUtilities.flush()

					if FFlagLuaEnableDidSwitchAccount then
						GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)

						return
					end

					GuiService:BroadcastNotification("", NotificationType.DID_LOG_OUT)

					return
				end

				if not GetFFlagFixAuthlessPasskeyPopupAccountCreation() then
					AppStorageUtilities.setAccountBlob(p20.responseBody.accountBlob)
				end

				AppStorageUtilities.flush()

				if p21 then
					p19:dispatch(ResetNavigationHistory({{
						name = AppPage.AddAuthMethodPage
					}}))

					return
				end

				p19:dispatch(LaunchApp(p5, p6, p10, p11, LaunchContext.SignUp))

				return
			end

			if p21 then
				p19:dispatch(ResetNavigationHistory({{
					name = AppPage.AddAuthMethodPage
				}}))

				return
			end

			p19:dispatch(LaunchApp(p5, p6, p10, p11, LaunchContext.SignUp))
		end

		return signUpRequest(p5, p12, p9, p13):andThen(function(p22) -- line: 168
			-- upvalues: GetFFlagFixAuthlessPasskeyPopupAccountCreation (copy), p14 (copy), AppStorageUtilities (copy), p12 (copy), FFlagEnableLuaAccountSwitch (copy), p7 (copy), NotificationType (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), p17 (copy), EventStreamConstants (copy), EventStreamConstants2 (copy), p16 (copy), p18 (copy), GetFFlagConditionallyFireAuthenticatedCredentials (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), p15 (copy), RegisterPasskey (copy), p5 (copy), proceedPostSignup (copy), Promise (copy), iosAuthServiceSignupPasswordSave (copy), default (copy), Constants (copy), Logger (copy), GetFFlagEnableSavePasswordAfterRecovery (copy)
			if GetFFlagFixAuthlessPasskeyPopupAccountCreation() then
				if p14 then
					AppStorageUtilities.setSignupActionRequired("auth")
					AppStorageUtilities.setPasskeySignupUsername(p12.username)
				end

				if FFlagEnableLuaAccountSwitch == true then
					AppStorageUtilities.setAccountBlob(p22.responseBody.accountBlob)
				end

				AppStorageUtilities.flush()
			end

			p7:BroadcastNotification("", NotificationType.DID_SIGN_UP)
			reportEphemeralCounter(AppSignupCounterNames.Success, 1)
			p17.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants2.Field.SignupSuccess)

			local v76 = p12.username and (p12.password and string.len(p12.password) > 0)
			local v77 = p16 and (p12.password and p18)

			if (not GetFFlagConditionallyFireAuthenticatedCredentials() or v76) and not FFlagDisableMemStorageServicePasswordEvent and not v77 then
				MemStorageService:Fire(MemStorageKeys.AuthenticatedCredentials, HttpService:JSONEncode({
					authType = "signup",
					cvalue = p12.username,
					password = p12.password
				}))
			end

			local function continuePostSignup() -- line: 220
				-- upvalues: p14 (copy), GetFFlagFixAuthlessPasskeyPopupAccountCreation (copy), AppStorageUtilities (copy), p12 (copy), p15 (copy), RegisterPasskey (copy), p5 (copy), p17 (copy), EventStreamConstants (copy), proceedPostSignup (copy), p22 (copy), Promise (copy)
				if p14 then
					if not GetFFlagFixAuthlessPasskeyPopupAccountCreation() then
						AppStorageUtilities.setSignupActionRequired("auth")
						AppStorageUtilities.setPasskeySignupUsername(p12.username)
					end

					if p15 then
						return RegisterPasskey(p5):andThen(function(_) -- line: 228
							-- upvalues: AppStorageUtilities (copy), p17 (copy), EventStreamConstants (copy), proceedPostSignup (copy), p22 (copy), Promise (copy)
							AppStorageUtilities.setSignupActionRequired("")
							p17.reportAuthModalShown(EventStreamConstants.Context.SignupPasskeyCreated, "success")
							AppStorageUtilities.flush()
							proceedPostSignup(p22, false)

							return Promise.resolve()
						end, function(p24) -- line: 238
							-- upvalues: p17 (copy), EventStreamConstants (copy), AppStorageUtilities (copy), proceedPostSignup (copy), p22 (copy), Promise (copy)
							if p24.name then
								p17.reportAuthModalShown(EventStreamConstants.Context.SignupPasskeyCreated, p24.name)

								if type(p24.body) == "string" then
									p17.reportAuthClientError(EventStreamConstants.Context.SignupPasskeyCreated, p24.body, p24.source)
								end
							else
								p17.reportAuthModalShown(EventStreamConstants.Context.SignupPasskeyCreated, "unknown")
							end

							AppStorageUtilities.flush()
							proceedPostSignup(p22, true)

							return Promise.resolve()
						end)
					end
				end

				AppStorageUtilities.flush()
				proceedPostSignup(p22, p14)

				return Promise.resolve()
			end

			if p16 and p12.password then
				local t1 = {
					username = p12.username,
					password = p12.password
				}
				local json = HttpService:JSONEncode(t1)

				local function v81() -- line: 283
					-- upvalues: p17 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), p12 (copy), default (copy), json (copy), Constants (copy), HttpService (copy), Logger (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), p18 (copy), continuePostSignup (copy)
					p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordAttempted)
					iosAuthServiceSignupPasswordSave.reportAttempted(p12.username)

					return default:registerCredentials(default.CredentialsTypes.password, json, Constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p25) -- line: 295
						-- upvalues: HttpService (copy), Logger (copy), p17 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), p12 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), p18 (copy), continuePostSignup (copy)
						local v93 = if not p25 then {} else HttpService:JSONDecode(p25)

						if v93 and v93.errorCode == nil then
							Logger:info("Successfully registered password.")
							p17.reportAuthButtonClick(EventStreamConstants.Context.CMPasswordSignup, EventStreamConstants.Button.SavePassword)
							p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordSuccess)
							iosAuthServiceSignupPasswordSave.reportSuccess(p12.username)
						else
							Logger:warning("Error registering password: ", v93.errorMsg)
							p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordFailure, v93.errorMsg or "unknown")
							iosAuthServiceSignupPasswordSave.reportFailure(p12.username, v93.errorMsg or "unknown")
						end

						if GetFFlagEnableSavePasswordAfterRecovery() and p18 then
							return continuePostSignup()
						end

						return nil
					end, function(p26) -- line: 331
						-- upvalues: Logger (copy), p17 (copy), EventStreamConstants (copy), iosAuthServiceSignupPasswordSave (copy), p12 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), p18 (copy), continuePostSignup (copy)
						Logger:warning("Error registering password: ", p26)
						p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordFailure, (tostring(p26)))
						iosAuthServiceSignupPasswordSave.reportFailure(p12.username, (tostring(p26)))

						if GetFFlagEnableSavePasswordAfterRecovery() and p18 then
							return continuePostSignup()
						end

						return nil
					end)
				end

				if GetFFlagEnableSavePasswordAfterRecovery() and p18 then
					return v81()
				end

				v81()
			elseif not p16 then
				p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordSkipped, EventStreamConstants.State.IosAuthServiceProtocolNotAvailable)
				iosAuthServiceSignupPasswordSave.reportSkipped(EventStreamConstants.State.IosAuthServiceProtocolNotAvailable)
			elseif not p12.password then
				p17.reportAuthButtonClick(EventStreamConstants.Context.IosAuthServiceSignup, EventStreamConstants.Button.IosAuthServiceSavePasswordSkipped, EventStreamConstants.State.IosAuthServiceMissingCredentials)
				iosAuthServiceSignupPasswordSave.reportSkipped(EventStreamConstants.State.IosAuthServiceMissingCredentials)
			end

			return continuePostSignup()
		end, function(p27) -- line: 381
			-- upvalues: HttpService (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), p13 (copy), VerifiedSignupErrorCodes (copy), SignUpV2ErrorCodes (copy), StatusCodes (copy), GetDxBlob (copy), GetCaptchaData (copy), AppPage (copy), p8 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p19 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), ToastType (copy), FFlagEnableLuaAccountSwitch (copy), SetNetworkingErrorToast (copy), Promise (copy)
			local ok, result = pcall(function() -- line: 382
				-- upvalues: HttpService (copy), p27 (copy)
				return HttpService:JSONDecode(p27.Body)
			end)

			if ok then
				local v85 = result.errors and (result.errors[1] and result.errors[1].code)

				reportEphemeralCounter(AppSignupCounterNames.Failure, 1)

				local v86 = p13 and VerifiedSignupErrorCodes or SignUpV2ErrorCodes

				if v85 and v85 == v86.Captcha then
					reportEphemeralCounter(AppSignupCounterNames.FailureCaptcha, 1)
				elseif v85 and v85 == v86.TooManyAttempts then
					reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
				elseif v85 and v85 == v86.InvalidBirthdate then
					reportEphemeralCounter(AppSignupCounterNames.FailureBirthdayInvalid, 1)
				elseif v85 and v85 == v86.InvalidUsername then
					reportEphemeralCounter(AppSignupCounterNames.FailureUsernameInvalid, 1)
				elseif v85 and v85 == v86.UsernameAlreadyTaken then
					reportEphemeralCounter(AppSignupCounterNames.FailureUsernameTaken, 1)
				elseif v85 and v85 == v86.InvalidPassword then
					reportEphemeralCounter(AppSignupCounterNames.FailurePasswordInvalid, 1)
				elseif v85 and v85 == v86.UsernameAndPasswordTheSame then
					reportEphemeralCounter(AppSignupCounterNames.FailurePasswordMatchesUsername, 1)
				elseif v85 and v85 == v86.PasswordTooSimple then
					reportEphemeralCounter(AppSignupCounterNames.FailurePasswordTooSimple, 1)
				elseif v85 == v86.UnavailableInRegion then
					reportEphemeralCounter(AppSignupCounterNames.FailureUnavailableInRegion, 1)
				elseif p27.HttpError == Enum.HttpError.OK and p27.StatusCode == StatusCodes.TOO_MANY_REQUESTS then
					reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
				elseif p27.HttpError == Enum.HttpError.OK and p27.StatusCode == StatusCodes.INTERNAL_SERVER_ERROR then
					reportEphemeralCounter(AppSignupCounterNames.FailureInternalServerError, 1)
				elseif p27.HttpError == Enum.HttpError.OK and p27.StatusCode == StatusCodes.BAD_REQUEST then
					reportEphemeralCounter(AppSignupCounterNames.FailureBadRequest, 1)
				elseif p27.HttpError == Enum.HttpError.OK and p27.StatusCode == StatusCodes.NOT_FOUND then
					reportEphemeralCounter(AppSignupCounterNames.FailureNotFound, 1)
				else
					reportEphemeralCounter(AppSignupCounterNames.FailureUnknownError, 1)
				end

				if v85 == v86.Captcha then
					GetDxBlob(result)

					local v87, v88 = GetCaptchaData(result)
					local t2 = {
						detail = "",
						name = AppPage.CaptchaNative,
						extraProps = {
							captchaType = "signup",
							backNavigationDisabledWhileLoading = true,
							captchaCallback = p8,
							captchaId = v87,
							dxBlob = v88
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v15.down(v15.fromLegacyPage(t2))
					else
						p19:dispatch(NavigateDown(t2))
					end
				elseif v85 == v86.InvalidEmail then
					p19:dispatch(SetCurrentToastMessage({
						toastMessage = "Authentication.SignUp.Response.InvalidEmail",
						toastType = ToastType.NetworkingError
					}))
				elseif v85 == v86.InvalidPassword then
					p19:dispatch(SetCurrentToastMessage({
						toastMessage = "Authentication.SignUp.Response.PasswordComplexity",
						toastType = ToastType.NetworkingError
					}))
				elseif v85 == v86.UnavailableInRegion then
					p19:dispatch(SetCurrentToastMessage({
						toastMessage = "Authentication.SignUp.Description.RobloxNotAvailableInRegion",
						toastType = ToastType.NetworkingError
					}))
				elseif (FFlagEnableLuaAccountSwitch ~= true or v85 ~= v86.EmptyAccountSwitchBlobRequired) and v85 ~= v86.ParentEmptyAccountSwitchBlobRequired then
					p19:dispatch(SetNetworkingErrorToast({
						HttpError = Enum.HttpError.OK
					}))
				end

				return Promise.reject(v85)
			end

			p19:dispatch(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))

			return Promise.reject()
		end)
	end
end
