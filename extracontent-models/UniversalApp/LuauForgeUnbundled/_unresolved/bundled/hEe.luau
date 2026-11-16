local module = require("@luauforge/bundled/fsy")

local module2 = require("@luauforge/bundled/hDz")

local module3 = require("@luauforge/bundled/hEf")

return function(data, p2)
	if not module2() then
		data.reportButtonClicked(module.Context.QuickLogin, module.Button.EnterDeviceCode)
	elseif module3() then
		data.reportAuthButtonClick(
			module.Context.QuickLogin,
			module.Button.EnterDeviceCode,
			nil,
			nil,
			nil,
			nil,
			p2
		)
	else
		data.reportButtonClickedWithCType(module.Context.QuickLogin, module.Button.EnterDeviceCode, p2)
	end
end
