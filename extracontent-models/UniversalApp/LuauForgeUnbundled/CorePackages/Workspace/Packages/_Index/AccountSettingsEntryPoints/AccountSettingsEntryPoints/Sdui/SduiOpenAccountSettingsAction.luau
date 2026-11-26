local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local AccountSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsPage")
local openAccountSettings = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/openAccountSettings")

local personalizedRecommendations = AccountSettingsPage.PersonalizedRecommendations

local function SduiOpenAccountSettingsAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams
	local surfaceKey = actionParams and actionParams.surfaceKey

	if typeof(surfaceKey) == "string" and not string.match(surfaceKey, "^%s*$") then
		openAccountSettings(personalizedRecommendations, { surfaceKey = surfaceKey })
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenAccountSettings,
				message = `Missing or invalid surfaceKey {surfaceKey}`
			},
			p4.appPage
		)
	end
end

return SduiOpenAccountSettingsAction
