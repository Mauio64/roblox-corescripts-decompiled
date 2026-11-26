local module = require("@luauforge/bundled/hHZ")

local function getPaymentSessionId()
	local v5 = module()
	local payment_session_id = if v5 then v5.payment_session_id else nil

	if payment_session_id == "" then
		return nil
	end

	return payment_session_id
end

return getPaymentSessionId
