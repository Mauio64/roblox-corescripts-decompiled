local userSettingsService = require(script.Services.userSettingsService)

return {
	["jest.config"] = script["jest.config"],
	ConsentName = require(script.Enums.ConsentName),
	UserSetting = require(script.Enums.UserSetting),
	useLegallySensitiveContentAndActions = require(script.useTranslatedLegallySensitiveContentAndActions),
	updateUserSettings = userSettingsService.updateUserSettings,
	updateUserSettingV2 = userSettingsService.updateUserSettingV2
}
