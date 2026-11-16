local module = require("@luauforge/bundled/dwB")
local module2 = require("@luauforge/bundled/dCh")
local module3 = require("@luauforge/deferred/fva")
local module4 = require("@luauforge/deferred/fvc")

return function(p2)
	return function(object)
		local v5 = module4[module3(p2)]

		object:dispatch(module2({
			toastType = module.PurchaseMessage,
			toastMessage = v5
		}))
	end
end
