local appPage = require("@luauforge/bundled/hTK").AppPage

local module = require("@luauforge/bundled/hTE")
local module2 = require("@luauforge/bundled/hTQ")

local startFacialAgeEstimation = module2.Thunks.startFacialAgeEstimation
local socialUpsellType = module2.Enums.SocialUpsellType
local upsellEntrySurfaceType = module2.Analytics.Enum.UpsellEntrySurfaceType

local sduiErrorType = module.SduiErrors.SduiErrorType
local sduiActionType = module.SduiActionType

local function getEntrySurface(p2)
	if p2 == appPage.Home then
		return upsellEntrySurfaceType.Homepage
	end

	if p2 == appPage.ProfilePlatform then
		return upsellEntrySurfaceType.ProfileCompletion
	end

	return upsellEntrySurfaceType.Unknown
end

local sduiActionParams = module.SduiActionParams
local getStringParam = sduiActionParams.getStringParam
local getBooleanParam = sduiActionParams.getBooleanParam
local getCallbackParam = sduiActionParams.getCallbackParam

local module3 = require("@luauforge/bundled/hTR")

local function SduiOpenFacialAgeEstimationAction(p2, p3, p4, p5)
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
		return
	end

	local facialAgeEstimation = socialUpsellType.FacialAgeEstimation
	local v7

	if source == appPage.Home then
		v7 = upsellEntrySurfaceType.Homepage
	elseif source == appPage.ProfilePlatform then
		v7 = upsellEntrySurfaceType.ProfileCompletion
	else
		v7 = upsellEntrySurfaceType.Unknown
	end

	local v8 = getStringParam(actionParams, "context", facialAgeEstimation .. v7)
	local booleanParam = getBooleanParam(actionParams, "isInExperience", false)
	local callbackParam = getCallbackParam(actionParams, "onSuccess")
	local callbackParam2 = getCallbackParam(actionParams, "onFailure")

	if not module3 then
		p4.dependencies.dispatch(startFacialAgeEstimation(
			v8,
			callbackParam,
			callbackParam2,
			source,
			booleanParam
		))

		return
	end

	local booleanParam2 = getBooleanParam(actionParams, "shouldIncludeVpc", true)
	p4.dependencies.dispatch(startFacialAgeEstimation(
		v8,
		callbackParam,
		callbackParam2,
		source,
		booleanParam,
		booleanParam2
	))
end

return SduiOpenFacialAgeEstimationAction
