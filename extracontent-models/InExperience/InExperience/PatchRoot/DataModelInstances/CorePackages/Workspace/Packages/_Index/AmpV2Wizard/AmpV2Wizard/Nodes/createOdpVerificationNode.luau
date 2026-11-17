local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

require(AmpV2Wizard.Types)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local Types = require(AmpV2Wizard.OdpVerification.Types)
local useOdpVerification = require(AmpV2Wizard.OdpVerification.useOdpVerification)
local FFlagAmpV2WizardVerificationDiagnostics = require(AmpV2Wizard.FFlagAmpV2WizardVerificationDiagnostics)

local VendorOutcome = Types.VendorOutcome

local function createOdpVerificationNode(method)
	local function OdpVerificationNode(props)
		local props2 = props.props
		local report = props.report
		local v = OdpAnalytics.useOdpAnalytics(props.ctx)

		local v2 = {
			sessionId = props2.sessionId or "",
			method = method,
			flowId = 0,
			analyticsSessionId = 0,
			onSettled = 0
		}
		local flowId

		if FFlagAmpV2WizardVerificationDiagnostics and props.ctx.analytics then
			flowId = props.ctx.analytics.flowId
		end

		v2.flowId = flowId
		local analyticsSessionId

		if FFlagAmpV2WizardVerificationDiagnostics then
			analyticsSessionId = props.ctx.analyticsSessionId
		end

		v2.analyticsSessionId = analyticsSessionId
		function v2.onSettled(data)
			if data.outcome == VendorOutcome.Submitted then
				report("Submitted")
				return
			end

			if data.outcome == VendorOutcome.Cancelled then
				report("Cancel")
				return
			end

			v.verificationFailed(method, data.failure)

			if FFlagAmpV2WizardVerificationDiagnostics then
				report("Failure", { reason = data.failure, diagnostic = data.diagnostic })
			else
				report("Failure", { reason = data.failure })
			end
		end

		useOdpVerification(v2)

		return React.createElement(WizardSpinner)
	end

	return OdpVerificationNode
end

return createOdpVerificationNode
