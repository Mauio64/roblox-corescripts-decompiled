local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local onAmpWizardCompletion = require(ServerDrivenUi.Actions.onAmpWizardCompletion)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDismissUnlockUpsell = SharedFlags.FFlagLuaAppDismissUnlockUpsell

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function noopCompletion(_, _) end

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenAmpWizard, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local featureName = actionParams.featureName

	if featureName == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenAmpWizard,
				message = "Missing actionParam: featureName",
				propName = "featureName"
			},
			p2.appPage
		)
		return
	end

	local entryPointEventCtx = actionParams.entryPointEventCtx
	local nameSpace = actionParams.nameSpace
	local skipFacialAgeEstimationWebLinkModal = actionParams.skipFacialAgeEstimationWebLinkModal

	local dispatch = p2.dependencies.dispatch
	local v

	if FFlagLuaAppDismissUnlockUpsell then
		v = onAmpWizardCompletion
	else
		v = noopCompletion
	end

	dispatch(OpenAmpWizardContainer(
		featureName,
		v,
		nil,
		entryPointEventCtx,
		nil,
		nameSpace,
		skipFacialAgeEstimationWebLinkModal
	))
end
