local Enums = require(script.Enums)

local AuthCommon = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	Components = require(script.Components),
	Common = require(script.Common),
	Actions = require(script.Actions),
	Enums = Enums,
	Http = require(script.Http),
	Models = require(script.Models),
	Thunks = require(script.Thunks),
	Utils = require(script.Utils),
	Reducers = require(script.Reducers),
	Analytics = require(script.Analytics),
	installReducer = require(script.Reducers.installReducer)
}
local Constants = require(script.Common.Constants)
AuthCommon.RoduxKey = Constants.RODUX_KEY
AuthCommon.Hooks = require(script.Hooks)
AuthCommon.EventReceivers = require(script.EventReceivers)
AuthCommon.Experiments = require(script.Experiments)
AuthCommon.Stores = require(script.Stores)
AuthCommon.DesignTokenMappers = require(script.DesignTokenMappers)
AuthCommon.Flags = {
	FFlagEnableCrossDeviceApproverDialog = require(script.Flags.FFlagEnableCrossDeviceApproverDialog)
}
return AuthCommon
