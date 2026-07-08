local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SocialUpsell = require(Parent.SocialUpsell)
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function getEntrySurface(s1: string) -- line: 19
	-- upvalues: AppPage (copy), UpsellEntrySurfaceType (copy)
	if s1 == AppPage.Home then
		return UpsellEntrySurfaceType.Homepage
	end

	if s1 == AppPage.ProfilePlatform then
		return UpsellEntrySurfaceType.ProfileCompletion
	end

	return UpsellEntrySurfaceType.Unknown
end

local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam
local getCallbackParam = SduiActionParams.getCallbackParam

local function SduiOpenFacialAgeEstimationAction(p1, _, p3, _) -- line: 36
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), getStringParam (copy), SocialUpsellType (copy), AppPage (copy), UpsellEntrySurfaceType (copy), getBooleanParam (copy), getCallbackParam (copy), startFacialAgeEstimation (copy)
	local v21 = p1 and p1.actionParams or nil

	if v21 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenFacialAgeEstimation
		}, p3.appPage)

		return
	end

	local source = v21.source

	if source == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: source",
			propName = "source",
			name = SduiActionType.OpenFacialAgeEstimation
		}, p3.appPage)

		return
	end

	local v23 = getStringParam(v21, "context", SocialUpsellType.FacialAgeEstimation .. if source ~= AppPage.Home then if source ~= AppPage.ProfilePlatform then UpsellEntrySurfaceType.Unknown else UpsellEntrySurfaceType.ProfileCompletion else UpsellEntrySurfaceType.Homepage)
	local v24 = getBooleanParam(v21, "isInExperience", false)
	local v25 = getCallbackParam(v21, "onSuccess")
	local v26 = getCallbackParam(v21, "onFailure")

	p3.dependencies.dispatch(startFacialAgeEstimation(v23, v25, v26, source, v24))
end

return SduiOpenFacialAgeEstimationAction
