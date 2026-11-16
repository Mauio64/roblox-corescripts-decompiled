local installReducer = require(script.Rodux.installReducer)
local Chips = require(script.Containers.Chips)
local UserLists = require(script.Containers.UserLists)

local SocialProof = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"]
}
local Constants = require(script.Common.Constants)
SocialProof.RoduxKey = Constants.RODUX_KEY
SocialProof.installReducer = installReducer
SocialProof.Chips = Chips
SocialProof.UserLists = UserLists
return SocialProof
