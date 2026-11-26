require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")

local function createSduiErrorLogger(p2, p3, p4)
	local clone = table.clone(p2)

	local __sduiReportError = clone.__sduiReportError or p2.reportError
	local v5 = p3 or clone.__sduiErrorContext
	clone.__sduiReportError = __sduiReportError
	clone.__sduiErrorContext = v5
	function clone.reportError(p5, data, p6, ...)
		local clone2 = table.clone(data)

		if not data.fullName and not data.rctPath and not data.templateId and v5 then
			addSduiErrorContextFields(clone2, v5)
		end

		clone2.name = clone2.name or p4
		__sduiReportError(p5, clone2, p6, ...)
	end
	return clone
end

return createSduiErrorLogger
