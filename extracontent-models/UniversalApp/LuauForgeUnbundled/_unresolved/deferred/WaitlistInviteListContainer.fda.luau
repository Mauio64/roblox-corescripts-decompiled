local module = require("@luauforge/deferred/eko")

local module2 = require("@luauforge/deferred/fdb")
local module3 = require("@luauforge/deferred/fde")

local function WaitlistInviteListContainer(p2)
	local v5 = module2()

	if #v5.rows == 0 then
		return nil
	end

	return module.createElement(module3, {
		rows = v5.rows,
		onInvite = v5.onInvite,
		onImpression = v5.onImpression,
		LayoutOrder = p2.LayoutOrder
	})
end

return WaitlistInviteListContainer
