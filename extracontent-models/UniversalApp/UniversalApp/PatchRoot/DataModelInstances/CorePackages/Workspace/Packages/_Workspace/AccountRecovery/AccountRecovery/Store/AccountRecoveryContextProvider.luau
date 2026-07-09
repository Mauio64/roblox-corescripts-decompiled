local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local React = require(AccountRecoveryParent.React)
local Logger = require(AccountRecoveryParent.Loggers).Logger
local useDispatch = require(AccountRecoveryParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(AccountRecoveryParent.UniversalAppPolicy).useAppPolicy
local LaunchContext = require(AccountRecoveryParent.AppStartup).Enums.LaunchContext
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(AccountRecoveryParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local useNavigationProps = require(AccountRecoveryParent.RobloxAppNavigation).useNavigationProps
local RenderChallenge = require(AccountRecoveryParent.GenericChallenges).Middleware.RenderChallenge
local ChallengeType = require(AccountRecoveryParent.GenericChallenges).Types.ChallengeType
local TwoStepVerificationActionType = require(AccountRecoveryParent.GenericChallenges).Types.TwoStepVerificationActionType
local AppStorageUtilities = require(AccountRecoveryParent.AuthCommon).Utils.AppStorageUtilities

require(AccountRecovery.Store.State)

local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local AccountRecoveryStateReducer = require(AccountRecovery.Store.AccountRecoveryStateReducer)
local PhonePrefixList = require(AccountRecovery.Thunks.PhonePrefixList)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)
local ModalState = require(AccountRecovery.Enums.ModalState)
local ContinueRecovery = require(AccountRecovery.Thunks.ContinueRecovery)
local ResetPassword = require(AccountRecovery.Thunks.ResetPassword)
local AccountRecoveryErrorCodes = require(AccountRecovery.Enums.AccountRecoveryErrorCodes)
local Constants = require(AccountRecovery.Components.Constants)
local MetricsService = require(AccountRecovery.Analytics.MetricsService)
local GetFFlagEnable2SVRecovery = require(AccountRecovery.Flags.GetFFlagEnable2SVRecovery)
local EventService = require(AccountRecovery.Analytics.EventService)
local GetFFlagEnableAutoLoginAfterRecovery = require(AccountRecoveryParent.SharedFlags).GetFFlagEnableAutoLoginAfterRecovery

return function(t1: {[any]: any}) -- line: 75
	-- upvalues: useNavigationProps (copy), ModalState (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), useAppPolicy (copy), React (copy), AccountRecoveryStateReducer (copy), LaunchContext (copy), RenderChallenge (copy), PhonePrefixList (copy), HttpService (copy), Logger (copy), MetricsService (copy), ChallengeType (copy), TwoStepVerificationActionType (copy), GetFFlagEnable2SVRecovery (copy), ContinueRecovery (copy), AccountRecoveryErrorCodes (copy), Constants (copy), ResetPassword (copy), GetFFlagEnableAutoLoginAfterRecovery (copy), EventService (copy), AppStorageUtilities (copy), AccountRecoveryActionType (copy), AccountRecoveryContext (copy)
	local v35 = useNavigationProps(function(s1: string, p1) -- line: 77
		return {
			continuingRecovery = p1.continuingRecovery,
			recover2sv = p1.recover2sv,
			recoverPassword = p1.recoverPassword == nil or p1.recoverPassword,
			recoverySessionID = p1.continuingRecovery and p1.recoverySessionID or nil,
			identifier = p1.identifier,
			deeplinkUuid = s1
		}
	end)
	local t2 = {
		monoDeps = t1.monoDeps,
		continuingRecovery = v35.continuingRecovery or false,
		recoverySessionId = v35.recoverySessionID or "",
		phonePrefixList = {},
		autofillIdentifier = v35.identifier or "",
		recover2sv = v35.recover2sv or false,
		recoverPassword = v35.recoverPassword or false,
		deeplinkUuid = v35.deeplinkUuid or "",
		modalStateAndProps = {
			props = nil,
			modalState = ModalState.NONE
		}
	}
	local v37 = useDispatch()
	local v38 = useRoactService(RoactNetworking)
	local v39 = useRoactService(RoactAnalytics)
	local v40 = useAppPolicy(function(p2) -- line: 112
		return p2
	end)
	local v41, v42 = React.useReducer(AccountRecoveryStateReducer, t2)
	local LaunchApp = v41.monoDeps.LaunchApp

	local function v44(p3) -- line: 124
		-- upvalues: RenderChallenge (copy)
		return RenderChallenge(p3)
	end
	local function v45(n1: number, t3: {[any]: any}, p4: ((...any) -> ...any), t4: {[any]: any}, s2: string?) -- line: 133
		-- upvalues: HttpService (copy), Logger (copy), MetricsService (copy), v44 (copy), ChallengeType (copy), TwoStepVerificationActionType (copy), GetFFlagEnable2SVRecovery (copy)
		local v56 = t3 and (not not t3.errors and (not not t3.errors[1] and t3.errors[1].fieldData)) or nil
		local v57

		if type(v56) ~= "string" then
			v57 = nil
		else
			local data = HttpService:JSONDecode(v56)

			v57 = data and data.challengeId or nil
		end

		local v59 = v57

		if v59 == nil then
			Logger:error("Two step verification challenge ID is nil")
			MetricsService.reportTwoStepVerificationChallengeIDIsNil()

			return
		end

		local t11 = nil

		t11 = {
			OnChallengeCompleted = function(t5: {[any]: any}) -- line: 155
				-- upvalues: p4 (copy), v59 (copy)
				p4(v59, t5.data.verificationToken)
			end,
			OnChallengeInvalidated = function(t6: {[any]: any}) -- line: 163
				-- upvalues: t11 (ref), t4 (copy)
				function t11.OnChallengeCompleted(_: {[any]: any}) -- line: 164
				end

				t4.OnChallengeInvalidated(t6)
			end,
			OnChallengeAbandoned = function() -- line: 167
				-- upvalues: t11 (ref), t4 (copy)
				function t11.OnChallengeCompleted(_: {[any]: any}) -- line: 168
				end

				t4.OnChallengeAbandoned()
			end,
			OnChallengeLoadFailed = function(t9: {[any]: any}) -- line: 171
				-- upvalues: t11 (ref), t4 (copy)
				function t11.OnChallengeCompleted(_: {[any]: any}) -- line: 172
				end

				t4.OnChallengeLoadFailed(t9)
			end
		}

		return v44({
			title = "Authentication.AccountRecovery.LabelTwoStepVerification",
			challengeType = ChallengeType.TwoStepVerification,
			challengeParameters = {
				allowRememberDevice = false,
				actionType = TwoStepVerificationActionType.PasswordReset,
				challengeId = v59,
				userId = tostring(n1),
				clientSupports2svRecovery = not not GetFFlagEnable2SVRecovery(),
				recoverySessionId = s2
			},
			callbacks = t11
		})
	end
	local function handleContinueRecovery(s3: string, n2: number, p5: ((...any) -> ...any), p6: ((...any) -> ...any), p7: ((...any) -> ...any), b1: boolean?, s4: string?, s5: string?) -- line: 207
		-- upvalues: v37 (copy), ContinueRecovery (copy), v38 (copy), AccountRecoveryErrorCodes (copy), v45 (copy), handleContinueRecovery (copy), Constants (copy), Logger (copy), HttpService (copy)
		v37(ContinueRecovery(v38, {
			recoverySessionId = s3,
			userId = n2,
			recover2sv = b1,
			twoStepVerificationChallengeId = s4,
			twoStepVerificationToken = s5
		})):andThen(function(p8) -- line: 218
			-- upvalues: AccountRecoveryErrorCodes (copy), v45 (copy), n2 (copy), handleContinueRecovery (copy), s3 (copy), p5 (copy), p6 (copy), p7 (copy), b1 (copy), Constants (copy), Logger (copy), HttpService (copy)
			if p8.isError then
				if p8.errorCode == AccountRecoveryErrorCodes.TwoStepVerificationRequired and p8.errorRaw ~= nil then
					v45(n2, p8.errorRaw, function(s6: string?, s7: string?) -- line: 227
						-- upvalues: handleContinueRecovery (copy), s3 (copy), n2 (copy), p5 (copy), p6 (copy), p7 (copy), b1 (copy)
						handleContinueRecovery(s3, n2, p5, p6, p7, b1, s6, s7)
					end, {
						OnChallengeInvalidated = function(_) -- line: 240
							-- upvalues: p6 (copy), Constants (copy)
							p6(Constants.UnknownErrorKey)
						end,
						OnChallengeAbandoned = function() -- line: 243
							-- upvalues: p7 (copy)
							p7()
						end,
						OnChallengeLoadFailed = function(_) -- line: 246
							-- upvalues: p6 (copy), Constants (copy)
							p6(Constants.UnknownErrorKey)
						end
					}, s3)

					return
				end

				Logger:warning("Error continuing recovery: {}", HttpService:JSONEncode(p8))
				p6(p8.errorKey or Constants.UnknownErrorKey)

				return
			end

			p5(p8.data)
		end):await()
	end

	React.useEffect(function() -- line: 383
		-- upvalues: GetFFlagEnable2SVRecovery (copy), t1 (copy), v35 (copy), v42 (copy), AccountRecoveryActionType (copy)
		if GetFFlagEnable2SVRecovery() and (t1.resetChildNavigationToFirstScreen and v35.continuingRecovery) then
			v42({
				type = AccountRecoveryActionType.RESET_RECOVERY_FLOW,
				data = {
					continuingRecovery = v35.continuingRecovery,
					recover2sv = v35.recover2sv or false,
					recoverPassword = v35.recoverPassword or false,
					recoverySessionId = v35.recoverySessionID or "",
					autofillIdentifier = v35.identifier or "",
					deeplinkUuid = v35.deeplinkUuid or ""
				}
			})
			t1.resetChildNavigationToFirstScreen()
		end
	end, { v35.deeplinkUuid })
	React.useEffect(function() -- line: 404
		-- upvalues: v37 (copy), PhonePrefixList (copy), v38 (copy), Logger (copy), HttpService (copy), v42 (copy), AccountRecoveryActionType (copy)
		v37(PhonePrefixList(v38)):andThen(function(p11) -- line: 405
			-- upvalues: Logger (copy), HttpService (copy), v42 (copy), AccountRecoveryActionType (copy)
			if p11.isError then
				Logger:warning("Error getting phone prefix list: {}", HttpService:JSONEncode(p11))

				return
			end

			v42({
				type = AccountRecoveryActionType.SET_PHONE_PREFIX_LIST,
				data = {
					phonePrefixList = p11.data
				}
			})
		end)
	end, {})

	return React.createElement(AccountRecoveryContext.Provider, {
		value = {
			state = v41,
			dispatch = v42,
			parentNavigation = t1.parentNavigation,
			utils = {
				launchApp = function() -- line: 120
					-- upvalues: v37 (copy), LaunchApp (copy), v38 (copy), v39 (copy), v40 (copy), LaunchContext (copy)
					return v37(LaunchApp(v38, nil, v39, v40, LaunchContext.Login))
				end,
				renderChallenge = v44,
				handleTwoStepVerificationError = v45,
				handleContinueRecovery = handleContinueRecovery,
				handleUpdatePassword = function(s8: string, n3: number, s9: string, s10: string, s11: string, p12: ((...any) -> ...any), p13: ((...any) -> ...any), s12: string?, s13: string?, s14: string?) -- line: 296
					-- upvalues: AppStorageUtilities (copy), v37 (copy), ResetPassword (copy), v38 (copy), Logger (copy), HttpService (copy), Constants (copy), GetFFlagEnable2SVRecovery (copy), v42 (copy), AccountRecoveryActionType (copy), ModalState (copy)
					local v93 = AppStorageUtilities.getAccountBlob() or ""

					v37(ResetPassword(v38, {
						targetType = "RecoverySessionID",
						ticket = s8,
						userId = n3,
						password = s10,
						passwordRepeated = s11,
						accountBlob = v93,
						twoStepVerificationChallengeId = s12,
						twoStepVerificationToken = s13,
						newEmail = s14
					})):andThen(function(p14) -- line: 319
						-- upvalues: Logger (copy), HttpService (copy), p12 (copy), Constants (copy), GetFFlagEnable2SVRecovery (copy), v42 (copy), AccountRecoveryActionType (copy), ModalState (copy), p13 (copy), n3 (copy), s9 (copy)
						if p14.isError then
							Logger:warning("Error resetting password: {}", HttpService:JSONEncode(p14))
							p12(p14.errorKey or Constants.UnknownErrorKey)

							return
						end

						if GetFFlagEnable2SVRecovery() and p14.data.shouldPromptPasskeyAddition then
							v42({
								type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
								data = {
									modalStateAndProps = {
										modalState = ModalState.ADD_NEW_PASSKEY,
										props = {
											onPasswordResetSuccess = function() -- line: 334
												-- upvalues: p13 (copy), p14 (copy)
												p13(p14.data.shouldAutoLoginFromRecovery)
											end,
											shouldUpdateEmail = p14.data.shouldUpdateEmail,
											email = p14.data.shouldUpdateEmail and p14.data.recoveryEmail or "",
											userId = n3,
											username = s9
										}
									}
								}
							})

							return
						end

						if GetFFlagEnable2SVRecovery() and p14.data.shouldPrompt2svRemoval then
							v42({
								type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
								data = {
									modalStateAndProps = {
										modalState = ModalState.SAVE_OR_DELETE_TWO_STEP_METHOD,
										props = {
											onPasswordResetSuccess = function() -- line: 352
												-- upvalues: p13 (copy), p14 (copy)
												p13(p14.data.shouldAutoLoginFromRecovery)
											end,
											shouldUpdateEmail = p14.data.shouldUpdateEmail,
											email = p14.data.shouldUpdateEmail and p14.data.recoveryEmail or ""
										}
									}
								}
							})

							return
						end

						if p14.data.shouldUpdateEmail then
							v42({
								type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
								data = {
									modalStateAndProps = {
										modalState = ModalState.UPDATE_EMAIL,
										props = {
											email = p14.data.recoveryEmail,
											onPasswordResetSuccess = function() -- line: 369
												-- upvalues: p13 (copy), p14 (copy)
												p13(p14.data.shouldAutoLoginFromRecovery)
											end
										}
									}
								}
							})

							return
						end

						p13(p14.data.shouldAutoLoginFromRecovery)
					end):await()
				end,
				launchAppOrGoBack = function(b2: boolean?) -- line: 286
					-- upvalues: GetFFlagEnableAutoLoginAfterRecovery (copy), EventService (copy), v41 (copy), v37 (copy), LaunchApp (copy), v38 (copy), v39 (copy), v40 (copy), LaunchContext (copy), t1 (copy)
					if b2 and GetFFlagEnableAutoLoginAfterRecovery() then
						EventService.sendPasswordResetEvent(v41.recoverySessionId, "launchApp")
						v37(LaunchApp(v38, nil, v39, v40, LaunchContext.Login))

						return
					end

					EventService.sendPasswordResetEvent(v41.recoverySessionId, "closeRecoveryFlow")
					t1.parentNavigation.goBack()
				end
			}
		}
	}, t1.children)
end
