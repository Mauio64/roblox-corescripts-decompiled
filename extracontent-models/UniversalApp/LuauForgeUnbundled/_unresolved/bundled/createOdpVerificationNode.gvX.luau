local module = require("@luauforge/bundled/gvb")

require("@luauforge/bundled/gvc")
local module2 = require("@luauforge/bundled/gvl")
local LoadingStatePage = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Container/LoadingStatePage")
local module4 = require("@luauforge/bundled/gvW")
local module5 = require("@luauforge/bundled/gvY")
local module6 = require("@luauforge/bundled/gwf")

local vendorOutcome = module4.VendorOutcome

local function createOdpVerificationNode(p2)
	local function OdpVerificationNode(props)
		local props2 = props.props
		local report = props.report
		local v5 = module2.useOdpAnalytics(props.ctx)

		local v7 = {
			sessionId = props2.sessionId or "",
			method = p2,
			flowId = 0,
			analyticsSessionId = 0,
			onSettled = 0
		}

		local v8 = if module6 and props.ctx.analytics then props.ctx.analytics.flowId else nil
		v7.flowId = v8

		local v9 = if module6 then props.ctx.analyticsSessionId else nil
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

			if module6 then
				report("Failure", {
					reason = data.failure,
					diagnostic = data.diagnostic
				})
			else
				report("Failure", { reason = data.failure })
			end
		end

		module5(v7)

		return module.createElement(LoadingStatePage)
	end

	return OdpVerificationNode
end

return createOdpVerificationNode
