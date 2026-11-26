local openAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AmpUpsell").OpenAmpWizardContainer

local onAmpWizardCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/onAmpWizardCompletion")

local fFlagLuaAppDismissUnlockUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppDismissUnlockUpsell

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local function noopCompletion(p2, p3) end

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenAmpWizard, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local featureName = actionParams.featureName

	if featureName == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenAmpWizard,
				message = "Missing actionParam: featureName",
				propName = "featureName"
			},
			p4.appPage
		)
		return
	end

	local entryPointEventCtx = actionParams.entryPointEventCtx
	local nameSpace = actionParams.nameSpace
	local skipFacialAgeEstimationWebLinkModal = actionParams.skipFacialAgeEstimationWebLinkModal

	p4.dependencies.dispatch(openAmpWizardContainer(
		featureName,
		if fFlagLuaAppDismissUnlockUpsell then onAmpWizardCompletion else noopCompletion,
		nil,
		entryPointEventCtx,
		nil,
		nameSpace,
		skipFacialAgeEstimationWebLinkModal
	))
end
