local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialUpsell")

local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local socialUpsellType = SocialUpsell.Enums.SocialUpsellType
local upsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenFacialAgeEstimation,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local source = actionParams.source

	if source == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenFacialAgeEstimation,
				message = "Missing actionParam: source",
				propName = "source"
			},
			p4.appPage
		)
	end

	local v5 = if source == appPage.ProfilePlatform then socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.ProfileCompletion else socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.Unknown

	p4.dependencies.dispatch(startFacialAgeEstimation(v5, nil, nil, source, false))
end
