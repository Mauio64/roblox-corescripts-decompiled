local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)

require("@luauforge/bundled/fRq")
local module = require("@luauforge/bundled/fsz")
local module2 = require("@luauforge/bundled/fQJ")
local module3 = require("@luauforge/bundled/fTp")

local module4 = require("@luauforge/bundled/fvl")
local module5 = require("@luauforge/bundled/fRo")
local module6 = require("@luauforge/bundled/fTq")

local module7 = require("@luauforge/bundled/fTr")
game:DefineFastFlag("EnableSkipVPCSignupFlow2", false)
game:DefineFastFlag("BypassIXPSkipVPCSignup", false)

local events = module.Events
local eventStreamConstants = module.EventStreamConstants
local kisaComplianceUtils = module2.KISAComplianceUtils
local analyticsEvents = module2.Analytics.AnalyticsEvents
local eventConstants = module2.Analytics.EventConstants
local constants = module3.Constants
local validateCode = module3.Thunks.ValidateCode

local function collectKoreaKISAConsent(data)
	local dispatch = data.dispatch
	local signUpInfo = data.signUpInfo
	local setIsConsentStepActive = data.setIsConsentStepActive

	return Promise.new(function(callback, callback2)
		local function abandon()
			analyticsEvents.sendButtonClickEvent(
				eventConstants.ctx.kisaAgreements,
				eventConstants.origin.signup,
				eventConstants.btn.cancel
			)

			setIsConsentStepActive(false)
			callback2({ isHandled = true })
		end

		local function openAgreements(p2, p3)
			analyticsEvents.sendPageLoadEvent(
				eventConstants.ctx.kisaAgreements,
				eventConstants.origin.signup
			)
			dispatch(module5({
				agreements = data.agreements,
				onAgreeFunction = function(p4)
					analyticsEvents.sendButtonClickEvent(
						eventConstants.ctx.kisaAgreements,
						eventConstants.origin.signup,
						eventConstants.btn.agree
					)

					local agreedUserAgreements = kisaComplianceUtils.getAgreedUserAgreements(p4)
					local parentalConsentAgreementId = data.appPolicy.getParentalConsentAgreementId()

					if p3 and parentalConsentAgreementId and parentalConsentAgreementId ~= "" then
						table.insert(agreedUserAgreements, parentalConsentAgreementId)
					end

					setIsConsentStepActive(false)
					callback(Cryo.Dictionary.join(p2, {
						agreementIds = agreedUserAgreements
					}))
				end,
				onAbandonFunction = abandon,
				isUnderAgeFlow = p3
			}))
		end

		if data.age ~= nil and not (module7 <= data.age) then
			if
				game:GetFastFlag("EnableSkipVPCSignupFlow2")
				and (data.shouldSkipVPCSignupFlow or game:GetFastFlag("BypassIXPSkipVPCSignup"))
			then
				events.authPageload(
					eventStreamConstants.Context.KISAU14Signup,
					eventStreamConstants.State.SkipVPC
				)

				callback(signUpInfo)
			else
				events.authPageload(
					eventStreamConstants.Context.KISAU14Signup,
					eventStreamConstants.State.LaunchParentSignUpOtp
				)

				setIsConsentStepActive(true)
				dispatch(module6({
					origin = constants.otpServiceOriginSignup,
					codeLength = 6,
					enterEmailTitleKey = constants.translationKeys.parentEmailTitleKey,
					enterEmailDescriptionKey = constants.translationKeys.sendParentVerificationCodeKey,
					enterCodeTitleKey = constants.translationKeys.oneTimeCodeTitleKey,
					enterCodeDescriptionKey = constants.translationKeys.oneTimeCodeHelpDescriptionKey,
					complianceCheckboxMessageKey = constants.translationKeys.parentalConsentModalDescriptionKey,
					onSubmitCode = function(p2, p3)
						return validateCode(data.networking, {
							origin = constants.otpServiceOriginSignup,
							contactType = constants.otpServiceContactType,
							passCode = p3,
							otpSessionToken = p2
						})():andThen(function()
							dispatch(module4())
							openAgreements(Cryo.Dictionary.join(signUpInfo, {
								otpSession = {
									otpSessionToken = tostring(p2),
									otpContactType = constants.otpServiceContactType
								}
							}), true)
						end)
					end,
					onModalAbandoned = abandon,
					screenSize = data.screenSize
				}))
			end

			return
		end

		setIsConsentStepActive(true)
		openAgreements(signUpInfo, false)
	end)
end

return collectKoreaKISAConsent
