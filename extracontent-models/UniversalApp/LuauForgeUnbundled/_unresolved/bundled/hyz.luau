local module = require("@luauforge/bundled/hwV")
local sduiErrorType = module.SduiErrors.SduiErrorType
local getStringParam = module.SduiActionParams.getStringParam

return {
	reportInvalid = function(p2, p3, p4, p5)
		p3.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = p4, propName = p5 },
			p3.appPage
		)
	end,
	getParams = function(p2, p3, p4)
		local actionParams = p3 and p3.actionParams

		if actionParams ~= nil then
			return actionParams
		end

		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = "Missing actionParams", propName = nil },
			p4.appPage
		)

		return nil
	end,
	getRequiredString = function(p2, p3, p4, p5)
		local stringParam = getStringParam(p3, p4)

		if stringParam ~= nil and stringParam ~= "" then
			return stringParam
		end

		local formatted = `Invalid or missing {p4}: {p3[p4]}`
		p5.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = formatted, propName = p4 },
			p5.appPage
		)

		return nil
	end
}
