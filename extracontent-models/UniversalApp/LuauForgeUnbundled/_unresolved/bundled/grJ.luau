local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")

local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/egs")

local module2 = require("@luauforge/bundled/dFu")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")

local module4 = require("@luauforge/bundled/ehB")
local module5 = require("@luauforge/bundled/geZ")
local module6 = require("@luauforge/bundled/egt")
local module7 = require("@luauforge/bundled/dKv")

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module8 = require("@luauforge/bundled/grK")

local module9 = require("@luauforge/bundled/grM")
local module10 = require("@luauforge/bundled/grN")
local module11 = require("@luauforge/bundled/fvN")
local module12 = require("@luauforge/bundled/gfK")

local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local module13 = require("@luauforge/bundled/gif")
local module14 = require("@luauforge/bundled/grO")
local module15 = require("@luauforge/bundled/gfH")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local module16 = require("@luauforge/bundled/grP")

local getUserIdsFromString = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/getUserIdsFromString")
local module18 = require("@luauforge/bundled/dFm")
local module19 = require("@luauforge/bundled/dzE")
local module20 = require("@luauforge/bundled/gfG")
local module21 = require("@luauforge/bundled/ggu")
local constants = module21.Constants
local default = module21.CredentialsProtocol.default

local module22 = require("@luauforge/bundled/ghR")
local module23 = require("@luauforge/bundled/grR")

local module24 = require("@luauforge/bundled/grS")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local fFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local fFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish
local getFFlagEnableSavePasswordAfterRecovery = SharedFlags.GetFFlagEnableSavePasswordAfterRecovery

local module26 = require("@luauforge/bundled/grT")
local module27 = require("@luauforge/bundled/fzS")
local module28 = require("@luauforge/bundled/ggs")
local module29 = require("@luauforge/bundled/dzD")
local module30 = require("@luauforge/bundled/fzT")
local eventStreamConstants = module30.EventStreamConstants
local iosAuthServiceHealthCounters = module30.RobloxTelemetry.IosAuthServiceHealthCounters
local accountSwitcherConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.AccountSwitcherConstants
local passkeyRegistrationSource = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.PasskeyRegistrationSource
local module31 = require("@luauforge/bundled/grU")

local v5 = {
	[statusCodes.TOO_MANY_REQUESTS] = "throttled",
	[statusCodes.INTERNAL_SERVER_ERROR] = "serverError",
	[statusCodes.BAD_REQUEST] = "badRequest",
	[statusCodes.NOT_FOUND] = "notFound"
}

local function coarseSignupErrorBucket(code, data, data2)
	if code ~= nil then
		if code == data2.Captcha then
			return "captcha"
		end

		if code == data2.TooManyAttempts then
			return "throttled"
		end

		if code == data2.InvalidBirthdate then
			return "birthdayInvalid"
		end

		if code == data2.InvalidUsername then
			return "usernameInvalid"
		end

		if code == data2.UsernameAlreadyTaken then
			return "usernameTaken"
		end

		if
			code == data2.InvalidPassword
			or code == data2.UsernameAndPasswordTheSame
			or code == data2.PasswordTooSimple
		then
			return "passwordInvalid"
		end

		if code == data2.InvalidEmail then
			return "emailInvalid"
		end

		if code == data2.UnavailableInRegion then
			return "unavailableInRegion"
		end
	end

	if typeof(data) == "table" and data.HttpError == Enum.HttpError.OK then
		return v5[data.StatusCode] or "unknown"
	end

	return "unknown"
end

local interface = t.interface({
	birthday = t.string,
	username = t.string,
	password = t.string,
	gender = t.string,
	locale = t.optional(t.string),
	email = t.optional(t.string),
	verifiedSignupVoucher = t.optional(t.string)
})

local interface2 = t.interface({
	username = t.string,
	isExpressSignup = t.literal(true)
})

local interface3 = t.interface({
	signupType = t.literal("Express"),
	agreementIds = t.optional(t.array(t.string)),
	locale = t.optional(t.string)
})

local union = t.union(interface, interface2, interface3)

local function signUpRequest(p2, data, p3, p4)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		if data.signupType == "Express" then
			return module8.expressLinkedSignup(
				p2,
				data.locale or LocalizationService.RobloxLocaleId,
				data.agreementIds
			)
		end

		return module8.singleSignOnSignup(p2, data)
	elseif p4 then
		return module8.verifiedSignup(p2, data, p3)
	else
		return module8.signUpV2(p2, data, p3)
	end
end

return function(p2, p3, object, p4, p5, p6, p7, p8, p9, p10, p11, p12, data, p13, p14)
	return function(object2)
		assert(union(p8))

		local function proceedPostSignup(p15, p16)
			if module22 == true then
				local v6 = Models.fromLocalStorage()

				if v6 and v6.userId ~= -1 then
					object2:dispatch(module28())
					local setAccountSwitchStatus = module20.setAccountSwitchStatus

					local v7 = if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then accountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus else module29.Auth.AccountSwitcherSwitchedStatus
					setAccountSwitchStatus(v7)

					module20.flush()

					if module23 then
						GuiService:BroadcastNotification("", module11.DID_SWITCH_ACCOUNT)
					else
						GuiService:BroadcastNotification("", module11.DID_LOG_OUT)
					end

					return
				end

				module20.flush()
			end

			if p16 then
				object2:dispatch(module7({
					{ name = module2.AddAuthMethodPage }
				}))
			else
				object2:dispatch(module5(p2, p3, p6, p7, module15.SignUp))
			end
		end

		return signUpRequest(p2, p8, p5, p9):andThen(function(p15)
			if p10 then
				module20.setSignupActionRequired("auth")
				module20.setPasskeySignupUsername(p8.username)
			end

			if module22 == true then
				module20.setAccountBlob(p15.responseBody.accountBlob)
			end

			module20.flush()

			object:BroadcastNotification("", module11.DID_SIGN_UP)

			module13(module14.Success, 1)
			iosAuthServiceHealthCounters.reportSignupSuccess({
				credentialType = "password",
				iosAuthServiceEnabled = p13 == true
			})

			data.reportAuthFormInteraction(
				module27.Context.SinglePageSignUpScreen,
				eventStreamConstants.Field.SignupSuccess,
				nil,
				p14
			)

			local v6 = p8.username and p8.password and string.len(p8.password) > 0

			local v7 = p12 and p8.password and p13

			if (not module24() or v6) and not (fFlagDisableMemStorageServicePasswordEvent or v7) then
				MemStorageService:Fire(
					module12.AuthenticatedCredentials,
					HttpService:JSONEncode({
						cvalue = p8.username,
						password = p8.password,
						authType = "signup"
					})
				)
			end

			local function continuePostSignup()
				if p10 and p11 then
					local v8

					if fFlagEmitPasskeyRegistrationSourceOnFinish then
						v8 = module26(p2, nil, nil, passkeyRegistrationSource.PasskeySignup)
					else
						v8 = module26(p2)
					end

					return v8:andThen(function(p16)
						module20.setSignupActionRequired("")
						data.reportAuthModalShown(module27.Context.SignupPasskeyCreated, "success")

						module20.flush()
						proceedPostSignup(p15, false)
						return module.resolve()
					end, function(data2)
						if data2.name then
							data.reportAuthModalShown(module27.Context.SignupPasskeyCreated, data2.name)

							if type(data2.body) == "string" then
								data.reportAuthClientError(
									module27.Context.SignupPasskeyCreated,
									data2.body,
									data2.source
								)
							end
						else
							data.reportAuthModalShown(module27.Context.SignupPasskeyCreated, "unknown")
						end

						module20.flush()
						proceedPostSignup(p15, true)
						return module.resolve()
					end)
				end

				module20.flush()
				proceedPostSignup(p15, p10)

				return module.resolve()
			end

			if p12 and p8.password then
				local jsonEncode = HttpService:JSONEncode({
					username = p8.username,
					password = p8.password
				})

				local function fn()
					if p13 then
						data.reportAuthButtonClick(
							module27.Context.IosAuthServiceSignup,
							module27.Button.IosAuthServiceSavePasswordAttempted
						)

						module31.reportAttempted(p8.username)
					end

					return default:registerCredentials(
						default.CredentialsTypes.password,
						jsonEncode,
						constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
					):andThen(
						function(json)
							local v9 = not json and {} or HttpService:JSONDecode(json)

							if v9 and v9.errorCode == nil then
								logger:info("Successfully registered password.")

								data.reportAuthButtonClick(
									module27.Context.CMPasswordSignup,
									module27.Button.SavePassword
								)

								if p13 then
									data.reportAuthButtonClick(
										module27.Context.IosAuthServiceSignup,
										module27.Button.IosAuthServiceSavePasswordSuccess
									)

									module31.reportSuccess(p8.username)
								end

								iosAuthServiceHealthCounters.reportPasswordSaveSuccess({
									credentialType = "password",
									iosAuthServiceEnabled = p13 == true
								})
							else
								logger:warning("Error registering password: ", v9.errorMsg)

								if p13 then
									data.reportAuthButtonClick(
										module27.Context.IosAuthServiceSignup,
										module27.Button.IosAuthServiceSavePasswordFailure,
										v9.errorMsg or "unknown"
									)

									module31.reportFailure(p8.username, v9.errorMsg or "unknown")
								end

								iosAuthServiceHealthCounters.reportPasswordSaveFailure({
									credentialType = "password",
									errorCode = (not v9 or v9.errorCode == nil) and "unknown" or tostring(v9.errorCode),
									iosAuthServiceEnabled = p13 == true
								})
							end

							if getFFlagEnableSavePasswordAfterRecovery() and p13 then
								return continuePostSignup()
							end

							return nil
						end,
						function(p16)
							logger:warning("Error registering password: ", p16)

							if p13 then
								data.reportAuthButtonClick(
									module27.Context.IosAuthServiceSignup,
									module27.Button.IosAuthServiceSavePasswordFailure,
									(tostring(p16))
								)

								module31.reportFailure(p8.username, (tostring(p16)))
							end

							iosAuthServiceHealthCounters.reportPasswordSaveFailure({
								credentialType = "password",
								errorCode = "transportError",
								iosAuthServiceEnabled = p13 == true
							})

							if getFFlagEnableSavePasswordAfterRecovery() and p13 then
								return continuePostSignup()
							end

							return nil
						end
					)
				end

				if getFFlagEnableSavePasswordAfterRecovery() and p13 then
					return fn()
				end

				fn()
			elseif p13 then
				if p12 then
					if not p8.password then
						data.reportAuthButtonClick(
							module27.Context.IosAuthServiceSignup,
							module27.Button.IosAuthServiceSavePasswordSkipped,
							module27.State.IosAuthServiceMissingCredentials
						)

						module31.reportSkipped(module27.State.IosAuthServiceMissingCredentials)
					end
				else
					data.reportAuthButtonClick(
						module27.Context.IosAuthServiceSignup,
						module27.Button.IosAuthServiceSavePasswordSkipped,
						module27.State.IosAuthServiceProtocolNotAvailable
					)

					module31.reportSkipped(module27.State.IosAuthServiceProtocolNotAvailable)
				end
			end

			return continuePostSignup()
		end, function(data2)
			local success, result = pcall(function()
				return HttpService:JSONDecode(data2.Body)
			end)

			if success then
				local code = result.errors and result.errors[1] and result.errors[1].code

				module13(module14.Failure, 1)
				local v6 = p9 and module10 or module9
				iosAuthServiceHealthCounters.reportSignupFailure({
					credentialType = "password",
					errorCode = coarseSignupErrorBucket(code, data2, v6),
					iosAuthServiceEnabled = p13 == true
				})

				if code and code == v6.Captcha then
					module13(module14.FailureCaptcha, 1)
				elseif code and code == v6.TooManyAttempts then
					module13(module14.FailureThrottled, 1)
				elseif code and code == v6.InvalidBirthdate then
					module13(module14.FailureBirthdayInvalid, 1)
				elseif code and code == v6.InvalidUsername then
					module13(module14.FailureUsernameInvalid, 1)
				elseif code and code == v6.UsernameAlreadyTaken then
					module13(module14.FailureUsernameTaken, 1)
				elseif code and code == v6.InvalidPassword then
					module13(module14.FailurePasswordInvalid, 1)
				elseif code and code == v6.UsernameAndPasswordTheSame then
					module13(module14.FailurePasswordMatchesUsername, 1)
				elseif code and code == v6.PasswordTooSimple then
					module13(module14.FailurePasswordTooSimple, 1)
				elseif code == v6.UnavailableInRegion then
					module13(module14.FailureUnavailableInRegion, 1)
				elseif
					data2.HttpError == Enum.HttpError.OK
					and data2.StatusCode == statusCodes.TOO_MANY_REQUESTS
				then
					module13(module14.FailureThrottled, 1)
				elseif
					data2.HttpError == Enum.HttpError.OK
					and data2.StatusCode == statusCodes.INTERNAL_SERVER_ERROR
				then
					module13(module14.FailureInternalServerError, 1)
				elseif
					data2.HttpError == Enum.HttpError.OK
					and data2.StatusCode == statusCodes.BAD_REQUEST
				then
					module13(module14.FailureBadRequest, 1)
				elseif
					data2.HttpError == Enum.HttpError.OK
					and data2.StatusCode == statusCodes.NOT_FOUND
				then
					module13(module14.FailureNotFound, 1)
				else
					module13(module14.FailureUnknownError, 1)
				end

				if code == v6.Captcha then
					module16(result)

					local v7, v8 = getUserIdsFromString(result)

					local v9 = {
						name = module2.CaptchaNative,
						detail = "",
						extraProps = {
							captchaCallback = p4,
							captchaType = "signup",
							captchaId = v7,
							dxBlob = v8,
							backNavigationDisabledWhileLoading = true
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v9))
					else
						object2:dispatch(module4(v9))
					end
				elseif code == v6.InvalidEmail then
					object2:dispatch(module18({
						toastType = module19.NetworkingError,
						toastMessage = "Authentication.SignUp.Response.InvalidEmail"
					}))
				elseif code == v6.InvalidPassword then
					object2:dispatch(module18({
						toastType = module19.NetworkingError,
						toastMessage = "Authentication.SignUp.Response.PasswordComplexity"
					}))
				elseif code == v6.UnavailableInRegion then
					object2:dispatch(module18({
						toastType = module19.NetworkingError,
						toastMessage = "Authentication.SignUp.Description.RobloxNotAvailableInRegion"
					}))
				elseif
					(module22 ~= true or code ~= v6.EmptyAccountSwitchBlobRequired)
					and code ~= v6.ParentEmptyAccountSwitchBlobRequired
				then
					object2:dispatch(module6({ HttpError = Enum.HttpError.OK }))
				end

				return module.reject(code)
			end

			iosAuthServiceHealthCounters.reportSignupFailure({
				credentialType = "password",
				errorCode = "unknown",
				iosAuthServiceEnabled = p13 == true
			})

			object2:dispatch(module6({ HttpError = Enum.HttpError.OK }))
			return module.reject()
		end)
	end
end
