local PaymentsProtocol = require(script.PaymentsProtocol)
local PaymentsProtocolConstants = require(script.PaymentsProtocolConstants)
local ProductType = require(script.Enums.ProductType)

require(script.PaymentsProtocolTypes)

return {
	Enum = {
		ProductType = ProductType
	},
	PaymentsProtocol = PaymentsProtocol,
	PaymentsProtocolConstants = PaymentsProtocolConstants,
	Flags = {}
}
