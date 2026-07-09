local AppChat = script:FindFirstAncestor("AppChat")
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p1) -- line: 4
	-- upvalues: getDeepValue (copy)
	local v4 = getDeepValue(p1, "keys")
	local v5 = getDeepValue(p1, "values")

	for _, v in pairs(v4) do
		if v5[v] and v5[v].previousMessageId == nil then
			return v
		end
	end

	return nil
end
