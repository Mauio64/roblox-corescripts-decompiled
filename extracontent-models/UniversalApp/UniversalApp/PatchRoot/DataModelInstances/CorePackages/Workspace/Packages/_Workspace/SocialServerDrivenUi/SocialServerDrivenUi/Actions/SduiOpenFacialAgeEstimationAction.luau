local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SocialUpsell = require(Parent.SocialUpsell)
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p1, _, p3, _) -- line: 19
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), AppPage (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), startFacialAgeEstimation (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenFacialAgeEstimation
		}, p3.appPage)

		return
	end

	assert(v14, "actionParams must exist")

	local source = v14.source

	if source == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: source",
			propName = "source",
			name = SduiActionType.OpenFacialAgeEstimation
		}, p3.appPage)
	end

	local v16 = if source ~= AppPage.ProfilePlatform then SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.Unknown else SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.ProfileCompletion

	p3.dependencies.dispatch(startFacialAgeEstimation(v16, nil, nil, source, false))
end
