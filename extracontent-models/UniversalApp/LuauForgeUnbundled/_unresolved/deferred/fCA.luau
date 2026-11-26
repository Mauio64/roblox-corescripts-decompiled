local module = require("@luauforge/bundled/dzE")
local module2 = require("@luauforge/bundled/dFm")
local module3 = require("@luauforge/deferred/fCB")
local module4 = require("@luauforge/deferred/fCD")

return function(p2)
	return function(object)
		local v6 = module4[module3(p2)]

		object:dispatch(module2({
			toastType = module.PurchaseMessage,
			toastMessage = v6
		}))
	end
end
