local useUserAgreements = require(script.useUserAgreements)
local FetchUpdatedUserAgreements = require(script.FetchUpdatedUserAgreements)
local FetchSignupUserAgreements = require(script.FetchSignupUserAgreements)
local UserAgreementsCounterNames = require(script.UserAgreementsCounterNames)
local UserAgreementErrorCodes = require(script.UserAgreementErrorCodes)
local UserAgreementUtils = require(script.UserAgreementUtils)
local UserAgreementsList = require(script.Components.UserAgreementsList)

return {
	["jest.config"] = script["jest.config"],
	useUserAgreements = useUserAgreements,
	FetchUpdatedUserAgreements = FetchUpdatedUserAgreements,
	FetchSignupUserAgreements = FetchSignupUserAgreements,
	UserAgreementsCounterNames = UserAgreementsCounterNames,
	UserAgreementErrorCodes = UserAgreementErrorCodes,
	UserAgreementUtils = UserAgreementUtils,
	UserAgreementsList = UserAgreementsList
}
