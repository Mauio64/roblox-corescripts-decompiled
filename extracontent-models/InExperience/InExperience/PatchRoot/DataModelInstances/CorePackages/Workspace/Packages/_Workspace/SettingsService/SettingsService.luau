local SettingsService = require(script.SettingsService)
require(script.Types)
return {
	SettingEnum = require(script.SettingEnum),
	SettingsService = SettingsService,
	ValueChangedSignal = require(script.ValueChangedSignal),
	AvailabilitySignal = require(script.AvailabilitySignal),
	VisibilitySignal = require(script.VisibilitySignal),
	["jest.config"] = script["jest.config"]
}
