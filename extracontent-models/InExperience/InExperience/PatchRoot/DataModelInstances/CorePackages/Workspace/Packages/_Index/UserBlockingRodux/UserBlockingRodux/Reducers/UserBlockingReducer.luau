local UserBlockingRodux = script:FindFirstAncestor("UserBlockingRodux")
local isBlockedByMe = require(UserBlockingRodux.Reducers.UserBlocking.isBlockedByMe)
local t1 = {
	isBlockedByMe = {}
}

return function(p1) -- line: 9
	-- upvalues: isBlockedByMe (copy), t1 (copy)
	local v5 = isBlockedByMe(p1)

	return function(p2, p3) -- line: 12
		-- upvalues: t1 (copy), v5 (copy)
		local v8 = p2 or t1

		return {
			isBlockedByMe = v5(v8.isBlockedByMe, p3)
		}
	end
end
