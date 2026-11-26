local Players = game:GetService("Players")

local module = require("@luauforge/bundled/gIj")

return function(p2, p3)
	return function(object)
		local state = object:getState()

		if p3 then
			local subscriptions = state.IAPProducts.Subscriptions

			for k, subscription in pairs(subscriptions) do
				if subscription.mobileProductId == p2 then
					object:dispatch(module(
						tostring(Players.LocalPlayer.UserId),
						Enum.MembershipType.Premium
					))

					return
				end
			end
		end
	end
end
