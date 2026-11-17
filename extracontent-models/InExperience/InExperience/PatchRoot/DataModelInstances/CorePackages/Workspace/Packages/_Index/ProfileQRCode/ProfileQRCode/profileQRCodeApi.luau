local ProfileQRCodeApi = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script.Parent["jest.config"],
	FFlagProfileQRCodeGamepadBackFix = require(script.Parent.Flags.FFlagProfileQRCodeGamepadBackFix)
}
local Rodux = require(script.Parent.Rodux)
ProfileQRCodeApi.installReducer = Rodux.installReducer
ProfileQRCodeApi.ProfileQRCodeEntryPoint = require(script.Parent.Components.ProfileQRCodeEntryPoint)
local Constants = require(script.Parent.Common.Constants)
ProfileQRCodeApi.RoduxKey = Constants.RODUX_KEY
local TextKeys = require(script.Parent.Common.TextKeys)
ProfileQRCodeApi.TitleKey = TextKeys.Title
return ProfileQRCodeApi
