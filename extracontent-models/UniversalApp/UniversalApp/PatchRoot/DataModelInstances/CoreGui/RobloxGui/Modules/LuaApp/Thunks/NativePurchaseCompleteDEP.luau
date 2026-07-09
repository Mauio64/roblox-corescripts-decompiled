local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Modules = CoreGui.RobloxGui.Modules
local SetUserMembershipType = require(Modules.LuaApp.Actions.SetUserMembershipType)

return function(p1, p2) -- line: 11
	-- upvalues: SetUserMembershipType (copy), Players (copy)
	return function(p3) -- line: 12
		-- upvalues: p2 (copy), p1 (copy), SetUserMembershipType (copy), Players (copy)
		local v8 = p3:getState()

		if p2 then
			local Subscriptions = v8.IAPProducts.Subscriptions

			for _, v in pairs(Subscriptions) do
				if v.mobileProductId == p1 then
					p3:dispatch(SetUserMembershipType(tostring(Players.LocalPlayer.UserId), Enum.MembershipType.Premium))

					return
				end
			end
		end
	end
end
