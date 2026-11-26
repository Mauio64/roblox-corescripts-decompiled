local module = require("@luauforge/bundled/fzS")

local module2 = require("@luauforge/bundled/fJl")

local module3 = require("@luauforge/bundled/hPg")

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
