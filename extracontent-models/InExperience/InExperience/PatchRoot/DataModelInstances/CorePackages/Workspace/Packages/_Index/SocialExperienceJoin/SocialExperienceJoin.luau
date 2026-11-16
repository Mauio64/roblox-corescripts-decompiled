local SocialExperienceJoin = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	installReducer = require(script.Rodux.installReducer)
}
local Constants = require(script.Common.Constants)
SocialExperienceJoin.RoduxKey = Constants.RODUX_KEY
SocialExperienceJoin.PurchaseExperienceModal = require(script.Components.PurchaseExperienceModal)
SocialExperienceJoin.UnableToJoinExperienceModal = require(script.Components.UnableToJoinExperienceModal)
SocialExperienceJoin.useJoinUserInExperience = require(script.Hooks.useJoinUserInExperience)
return SocialExperienceJoin
