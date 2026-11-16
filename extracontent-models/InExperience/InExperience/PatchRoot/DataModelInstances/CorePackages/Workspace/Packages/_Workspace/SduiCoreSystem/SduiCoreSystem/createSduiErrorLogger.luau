local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)

local function createSduiErrorLogger(p, p2, p3: string?)
	local clone = table.clone(p)

	local __sduiReportError = clone.__sduiReportError or p.reportError
	local sduiErrorContext = p2 or clone.__sduiErrorContext
	clone.__sduiReportError = __sduiReportError
	clone.__sduiErrorContext = sduiErrorContext
	function clone.reportError(p4, data, p5: string, ...)
		local clone2 = table.clone(data)

		if not data.fullName and not data.rctPath and not data.templateId and sduiErrorContext then
			addSduiErrorContextFields(clone2, sduiErrorContext)
		end

		clone2.name = clone2.name or p3
		__sduiReportError(p4, clone2, p5, ...)
	end
	return clone
end

return createSduiErrorLogger
