local AccountSettingsEntryPoints = script:FindFirstAncestor("AccountSettingsEntryPoints")
local parent = AccountSettingsEntryPoints.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local AccountSettingsPage = require(AccountSettingsEntryPoints.AccountSettingsPage)
local openAccountSettings = require(AccountSettingsEntryPoints.openAccountSettings)

local PersonalizedRecommendations = AccountSettingsPage.PersonalizedRecommendations

local function SduiOpenAccountSettingsAction(p, _, p2, _)
	local actionParams = p and p.actionParams
	local surfaceKey = actionParams and actionParams.surfaceKey

	if typeof(surfaceKey) == "string" and not string.match(surfaceKey, "^%s*$") then
		openAccountSettings(PersonalizedRecommendations, { surfaceKey = surfaceKey })
	else
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenAccountSettings,
				message = `Missing or invalid surfaceKey {surfaceKey}`
			},
			p2.appPage
		)
	end
end

return SduiOpenAccountSettingsAction
