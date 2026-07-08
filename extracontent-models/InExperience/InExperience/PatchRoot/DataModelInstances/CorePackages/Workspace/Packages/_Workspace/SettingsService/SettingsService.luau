local SettingsService = require(script.SettingsService)

require(script.Types)

local SettingEnum = require(script.SettingEnum)
local ValueChangedSignal = require(script.ValueChangedSignal)
local AvailabilitySignal = require(script.AvailabilitySignal)
local VisibilitySignal = require(script.VisibilitySignal)

return {
	SettingEnum = SettingEnum,
	SettingsService = SettingsService,
	ValueChangedSignal = ValueChangedSignal,
	AvailabilitySignal = AvailabilitySignal,
	VisibilitySignal = VisibilitySignal,
	["jest.config"] = script["jest.config"]
}
