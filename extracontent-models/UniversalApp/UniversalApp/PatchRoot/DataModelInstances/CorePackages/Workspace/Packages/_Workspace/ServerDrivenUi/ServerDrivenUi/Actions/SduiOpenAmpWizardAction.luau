local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local OpenAmpWizardContainer = require(ServerDrivenUiParent.AmpUpsell).OpenAmpWizardContainer
local onAmpWizardCompletion = require(ServerDrivenUi.Actions.onAmpWizardCompletion)
local FFlagLuaAppDismissUnlockUpsell = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppDismissUnlockUpsell
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function noopCompletion(_, _) -- line: 15
end

return function(p3, _, p5, _) -- line: 30
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagLuaAppDismissUnlockUpsell (copy), onAmpWizardCompletion (copy), noopCompletion (copy), OpenAmpWizardContainer (copy)
	local v16 = p3 and p3.actionParams or nil

	if v16 == nil then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenAmpWizard
		}, p5.appPage)

		return
	end

	assert(v16, "actionParams must exist")

	local featureName = v16.featureName

	if featureName == nil then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: featureName",
			propName = "featureName",
			name = SduiActionType.OpenAmpWizard
		}, p5.appPage)

		return
	end

	local entryPointEventCtx = v16.entryPointEventCtx
	local nameSpace = v16.nameSpace
	local skipFacialAgeEstimationWebLinkModal = v16.skipFacialAgeEstimationWebLinkModal
	local dispatch = p5.dependencies.dispatch
	local v22 = if not FFlagLuaAppDismissUnlockUpsell then noopCompletion else onAmpWizardCompletion

	dispatch(OpenAmpWizardContainer(featureName, v22, nil, entryPointEventCtx, nil, nameSpace, skipFacialAgeEstimationWebLinkModal))
end
