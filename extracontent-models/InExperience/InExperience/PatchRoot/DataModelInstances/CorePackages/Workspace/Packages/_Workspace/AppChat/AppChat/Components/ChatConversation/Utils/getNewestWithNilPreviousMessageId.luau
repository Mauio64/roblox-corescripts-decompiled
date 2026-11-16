local AppChat = script:FindFirstAncestor("AppChat")
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p)
	local deepValue = getDeepValue(p, "keys")
	local deepValue2 = getDeepValue(p, "values")

	for _, v in pairs(deepValue) do
		if deepValue2[v] and deepValue2[v].previousMessageId == nil then
			return v
		end
	end

	return nil
end
