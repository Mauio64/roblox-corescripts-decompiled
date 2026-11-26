local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local OdpAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpAnalytics")
local WizardSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardSpinner")
local Types = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/Types")
local useOdpVerification = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/useOdpVerification")
local FFlagAmpV2WizardVerificationDiagnostics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardVerificationDiagnostics")

local vendorOutcome = Types.VendorOutcome

local function createOdpVerificationNode(p2)
	local function OdpVerificationNode(props)
		local props2 = props.props
		local report = props.report
		local v5 = OdpAnalytics.useOdpAnalytics(props.ctx)

		local v7 = {
			sessionId = props2.sessionId or "",
			method = p2,
			flowId = 0,
			analyticsSessionId = 0,
			onSettled = 0
		}

		local v8 = if FFlagAmpV2WizardVerificationDiagnostics and props.ctx.analytics then props.ctx.analytics.flowId else nil
		v7.flowId = v8

		local v9 = if FFlagAmpV2WizardVerificationDiagnostics then props.ctx.analyticsSessionId else nil
		v7.analyticsSessionId = v9
		function v7.onSettled(data)
			if data.outcome == vendorOutcome.Submitted then
				report("Submitted")
				return
			end

			if data.outcome == vendorOutcome.Cancelled then
				report("Cancel")
				return
			end

			v5.verificationFailed(p2, data.failure)

			if FFlagAmpV2WizardVerificationDiagnostics then
				report("Failure", {
					reason = data.failure,
					diagnostic = data.diagnostic
				})
			else
				report("Failure", { reason = data.failure })
			end
		end

		useOdpVerification(v7)

		return React.createElement(WizardSpinner)
	end

	return OdpVerificationNode
end

return createOdpVerificationNode
