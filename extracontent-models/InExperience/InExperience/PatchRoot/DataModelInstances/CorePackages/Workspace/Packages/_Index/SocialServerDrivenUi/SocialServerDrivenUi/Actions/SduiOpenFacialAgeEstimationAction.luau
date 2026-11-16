local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SocialUpsell = require(parent.SocialUpsell)

local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenFacialAgeEstimation, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local source = actionParams.source

	if source == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenFacialAgeEstimation,
				message = "Missing actionParam: source",
				propName = "source"
			},
			p2.appPage
		)
	end

	local v

	if source == AppPage.ProfilePlatform then
		v = SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.ProfileCompletion
	else
		v = SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.Unknown
	end

	p2.dependencies.dispatch(startFacialAgeEstimation(v, nil, nil, source, false))
end
