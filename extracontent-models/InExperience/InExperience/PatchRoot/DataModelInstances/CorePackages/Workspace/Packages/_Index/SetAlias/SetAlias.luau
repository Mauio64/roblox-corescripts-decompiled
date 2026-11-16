local SetAlias = {
	["SetAliasModal"] = nil,
	["SetAliasModal"] = nil,
	["SetAliasModal"] = nil,
	SetAliasModal = require(script.Components.SetAliasModal),
	Analytics = require(script.Analytics)
}
local Constants = require(script.Common.Constants)
SetAlias.RoduxKey = Constants.RODUX_KEY
SetAlias.installReducer = require(script.installReducer)
SetAlias["jest.config"] = script["jest.config"]
return SetAlias
