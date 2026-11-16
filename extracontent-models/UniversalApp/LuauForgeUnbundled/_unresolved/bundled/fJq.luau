local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fJc")
local logger = require("@luauforge/bundled/fJr").Logger
local useDispatch = require("@luauforge/bundled/fJh").Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@luauforge/bundled/fJs").useAppPolicy
local launchContext = require("@luauforge/bundled/fJt").Enums.LaunchContext
local useRoactService = require("@luauforge/bundled/fJu").useRoactService
local module2 = require("@luauforge/bundled/fJv")
local roactNetworking = module2.RoactNetworking
local roactAnalytics = module2.RoactAnalytics

local useNavigationProps = require("@luauforge/bundled/fJw").useNavigationProps

local renderChallenge = require("@luauforge/bundled/fJx").Middleware.RenderChallenge
local challengeType = require("@luauforge/bundled/fJx").Types.ChallengeType
local twoStepVerificationActionType = require("@luauforge/bundled/fJx").Types.TwoStepVerificationActionType

local appStorageUtilities = require("@luauforge/bundled/fJy").Utils.AppStorageUtilities

require("@luauforge/bundled/fJi")
local module3 = require("@luauforge/bundled/fJz")
local module4 = require("@luauforge/bundled/fJA")
local module5 = require("@luauforge/bundled/fJE")
require("@luauforge/bundled/fJj")
local module6 = require("@luauforge/bundled/fJC")
local module7 = require("@luauforge/bundled/fJD")
local module8 = require("@luauforge/bundled/fJK")
local module9 = require("@luauforge/bundled/fJN")
local module10 = require("@luauforge/bundled/fJL")
local module11 = require("@luauforge/bundled/fJH")
local module12 = require("@luauforge/bundled/fJQ")
local module13 = require("@luauforge/bundled/fJS")
local module14 = require("@luauforge/bundled/fJT")
local module15 = require("@luauforge/bundled/fJU")

local getFFlagEnableAutoLoginAfterRecovery = require("@luauforge/bundled/fJI").GetFFlagEnableAutoLoginAfterRecovery

return function(props)
	local v5 = useNavigationProps(function(deeplinkUuid, data)
		local v6 = {
			continuingRecovery = data.continuingRecovery,
			recover2sv = data.recover2sv,
			recoverPassword = data.recoverPassword == nil or data.recoverPassword,
			recoverySessionID = 0,
			identifier = 0,
			deeplinkUuid = 0
		}

		local v7 = if data.continuingRecovery then data.recoverySessionID or nil else nil
		v6.recoverySessionID = v7

		v6.identifier = data.identifier

		v6.deeplinkUuid = deeplinkUuid
		return v6
	end)

	local v6 = {
		monoDeps = props.monoDeps,
		continuingRecovery = v5.continuingRecovery or false,
		recoverySessionId = v5.recoverySessionID or "",
		phonePrefixList = {},
		autofillIdentifier = v5.identifier or "",
		recover2sv = v5.recover2sv or false,
		recoverPassword = v5.recoverPassword or false,
		deeplinkUuid = v5.deeplinkUuid or "",
		modalStateAndProps = { modalState = module7.NONE, props = nil }
	}

	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(roactAnalytics)
	local v10 = useAppPolicy(function(p2)
		return p2
	end)

	local v11, v12 = module.useReducer(module4, v6)

	local launchApp = v11.monoDeps.LaunchApp
	local function fn()
		return v7(launchApp(v8, nil, v9, v10, launchContext.Login))
	end

	local function fn2(p2)
		return renderChallenge(p2)
	end

	local function fn3(p2, errorRaw, fn4, data, p3)
		local fieldData = errorRaw
			and errorRaw.errors
			and errorRaw.errors[1]
			and errorRaw.errors[1].fieldData
			or nil
		local challengeId

		if type(fieldData) == "string" then
			local jsonDecode = HttpService:JSONDecode(fieldData)
			challengeId = jsonDecode and jsonDecode.challengeId or nil
		else
			challengeId = nil
		end

		if challengeId == nil then
			logger:error("Two step verification challenge ID is nil")
			module12.reportTwoStepVerificationChallengeIDIsNil()
		else
			local v13 = nil
			v13 = {
				OnChallengeCompleted = function(p4)
					fn4(challengeId, p4.data.verificationToken)
				end,
				OnChallengeInvalidated = function(p4)
					function v13.OnChallengeCompleted(p5) end
					data.OnChallengeInvalidated(p4)
				end,
				OnChallengeAbandoned = function()
					function v13.OnChallengeCompleted(p4) end
					data.OnChallengeAbandoned()
				end,
				OnChallengeLoadFailed = function(p4)
					function v13.OnChallengeCompleted(p5) end
					data.OnChallengeLoadFailed(p4)
				end
			}

			return fn2({
				title = "Authentication.AccountRecovery.LabelTwoStepVerification",
				challengeType = challengeType.TwoStepVerification,
				challengeParameters = {
					actionType = twoStepVerificationActionType.PasswordReset,
					challengeId = challengeId,
					userId = tostring(p2),
					allowRememberDevice = false,
					clientSupports2svRecovery = module13() and true or false,
					recoverySessionId = p3
				},
				callbacks = v13
			})
		end
	end

	local function handleContinueRecovery(p2, p3, callback, callback2, callback3, p4, p5, p6)
		v7(module8(v8, {
			recoverySessionId = p2,
			userId = p3,
			recover2sv = p4,
			twoStepVerificationChallengeId = p5,
			twoStepVerificationToken = p6
		})):andThen(function(data)
			if not data.isError then
				callback(data.data)
				return
			end

			if data.errorCode == module10.TwoStepVerificationRequired and data.errorRaw ~= nil then
				fn3(p3, data.errorRaw, function(p7, p8)
					handleContinueRecovery(p2, p3, callback, callback2, callback3, p4, p7, p8)
				end, {
					OnChallengeInvalidated = function(p7)
						callback2(module11.UnknownErrorKey)
					end,
					OnChallengeAbandoned = function()
						callback3()
					end,
					OnChallengeLoadFailed = function(p7)
						callback2(module11.UnknownErrorKey)
					end
				}, p2)

				return
			end

			logger:warning("Error continuing recovery: {}", HttpService:JSONEncode(data))
			callback2(data.errorKey or module11.UnknownErrorKey)
		end):await()
	end

	local function launchAppOrGoBack(p2)
		if p2 and getFFlagEnableAutoLoginAfterRecovery() then
			module15.sendPasswordResetEvent(v11.recoverySessionId, "launchApp")
			v7(launchApp(v8, nil, v9, v10, launchContext.Login))
		else
			module15.sendPasswordResetEvent(v11.recoverySessionId, "closeRecoveryFlow")
			props.parentNavigation.goBack()
		end
	end

	local function handleUpdatePassword(p2, p3, p4, p5, p6, callback, callback2, p7, p8, p9)
		v7(module9(v8, {
			targetType = "RecoverySessionID",
			ticket = p2,
			userId = p3,
			password = p5,
			passwordRepeated = p6,
			accountBlob = appStorageUtilities.getAccountBlob() or "",
			twoStepVerificationChallengeId = p7,
			twoStepVerificationToken = p8,
			newEmail = p9
		})):andThen(function(data)
			if data.isError then
				logger:warning("Error resetting password: {}", HttpService:JSONEncode(data))
				callback(data.errorKey or module11.UnknownErrorKey)
			elseif module14() and data.data.shouldPromptCredentialInvalidation then
				v12({
					type = module6.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = module7.INVALIDATE_CREDENTIALS,
							props = {
								onPasswordResetSuccess = function()
									callback2(data.data.shouldAutoLoginFromRecovery)
								end,
								shouldPromptPasskeyAddition = data.data.shouldPromptPasskeyAddition,
								userId = p3,
								username = p4,
								shouldPrompt2svRemoval = data.data.shouldPrompt2svRemoval,
								shouldUpdateEmail = data.data.shouldUpdateEmail,
								email = data.data.shouldUpdateEmail and data.data.recoveryEmail or ""
							}
						}
					}
				})
			elseif module13() and data.data.shouldPromptPasskeyAddition then
				v12({
					type = module6.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = module7.ADD_NEW_PASSKEY,
							props = {
								onPasswordResetSuccess = function()
									callback2(data.data.shouldAutoLoginFromRecovery)
								end,
								shouldUpdateEmail = data.data.shouldUpdateEmail,
								email = data.data.shouldUpdateEmail and data.data.recoveryEmail or "",
								userId = p3,
								username = p4
							}
						}
					}
				})
			elseif module13() and data.data.shouldPrompt2svRemoval then
				v12({
					type = module6.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = module7.SAVE_OR_DELETE_TWO_STEP_METHOD,
							props = {
								onPasswordResetSuccess = function()
									callback2(data.data.shouldAutoLoginFromRecovery)
								end,
								shouldUpdateEmail = data.data.shouldUpdateEmail,
								email = data.data.shouldUpdateEmail and data.data.recoveryEmail or ""
							}
						}
					}
				})
			elseif data.data.shouldUpdateEmail then
				v12({
					type = module6.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = module7.UPDATE_EMAIL,
							props = {
								email = data.data.recoveryEmail,
								onPasswordResetSuccess = function()
									callback2(data.data.shouldAutoLoginFromRecovery)
								end
							}
						}
					}
				})
			else
				callback2(data.data.shouldAutoLoginFromRecovery)
			end
		end):await()
	end

	module.useEffect(function()
		if module13() and props.resetChildNavigationToFirstScreen and v5.continuingRecovery then
			v12({
				type = module6.RESET_RECOVERY_FLOW,
				data = {
					continuingRecovery = v5.continuingRecovery,
					recover2sv = v5.recover2sv or false,
					recoverPassword = v5.recoverPassword or false,
					recoverySessionId = v5.recoverySessionID or "",
					autofillIdentifier = v5.identifier or "",
					deeplinkUuid = v5.deeplinkUuid or ""
				}
			})

			props.resetChildNavigationToFirstScreen()
		end
	end, { v5.deeplinkUuid })

	module.useEffect(function()
		v7(module5(v8)):andThen(function(p2)
			if p2.isError then
				logger:warning("Error getting phone prefix list: {}", HttpService:JSONEncode(p2))
			else
				v12({
					type = module6.SET_PHONE_PREFIX_LIST,
					data = { phonePrefixList = p2.data }
				})
			end
		end)
	end, {})

	return module.createElement(module3.Provider, {
		value = {
			state = v11,
			dispatch = v12,
			parentNavigation = props.parentNavigation,
			utils = {
				launchApp = fn,
				renderChallenge = fn2,
				handleTwoStepVerificationError = fn3,
				handleContinueRecovery = handleContinueRecovery,
				handleUpdatePassword = handleUpdatePassword,
				launchAppOrGoBack = launchAppOrGoBack
			}
		}
	}, props.children)
end
