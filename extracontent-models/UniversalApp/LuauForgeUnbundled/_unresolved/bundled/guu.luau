local module = require("@luauforge/bundled/guv")
local module2 = require("@luauforge/bundled/gux")
local module3 = require("@luauforge/bundled/guB")
require("@luauforge/bundled/guy")

return {
	Enum = { ProductType = module3 },
	PaymentsProtocol = module,
	PaymentsProtocolConstants = module2,
	Flags = {}
}
