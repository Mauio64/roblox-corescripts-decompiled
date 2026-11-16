local module = require("@luauforge/deferred/eeO")

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled

return function(value, p2, p3, callback)
	local state, setState = module.useState(value or 0)

	if fFlagAddFriendsUserListEnabled then
		module.useEffect(function()
			setState(value or 0)
		end, { value })
	end

	local state2, setState2 = module.useState(1)

	return module.useCallback(function()
		callback()
		setState2(state * p3 + 1)

		local v5 = math.ceil(p2 / p3) - 2

		if v5 <= 0 then
			v5 = math.floor(p2 / p3)
		end

		setState(state + v5)
	end, { state, p2, callback, p3 }), state, state2
end
