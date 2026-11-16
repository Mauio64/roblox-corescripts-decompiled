local userSettingsService = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Services/userSettingsService")

return {
	ConsentName = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/ConsentName"),
	UserSetting = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/UserSetting"),
	useLegallySensitiveContentAndActions = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/useTranslatedLegallySensitiveContentAndActions"),
	updateUserSettings = userSettingsService.updateUserSettings,
	updateUserSettingV2 = userSettingsService.updateUserSettingV2
}
