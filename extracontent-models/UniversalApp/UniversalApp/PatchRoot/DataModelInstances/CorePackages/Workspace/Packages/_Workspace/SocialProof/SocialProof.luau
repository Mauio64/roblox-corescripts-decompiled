local installReducer = require(script.Rodux.installReducer)
local Chips = require(script.Containers.Chips)
local UserLists = require(script.Containers.UserLists)

return {
	["jest.config"] = script["jest.config"],
	RoduxKey = require(script.Common.Constants).RODUX_KEY,
	installReducer = installReducer,
	Chips = Chips,
	UserLists = UserLists
}
