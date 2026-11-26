local module = require("@luauforge/bundled/gWA")
local module2 = require("@luauforge/bundled/gWC")
local module3 = require("@luauforge/bundled/gWG")
require("@luauforge/bundled/gWD")

return {
	Enum = { ProductType = module3 },
	PaymentsProtocol = module,
	PaymentsProtocolConstants = module2,
	Flags = {}
}
