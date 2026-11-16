local AppChat = script:FindFirstAncestor("AppChat")

local FFlagAppChatGetDeepValuePreserveFalse = require(AppChat.Flags.FFlagAppChatGetDeepValuePreserveFalse)
local getDeepValue2 = require(script.Parent.getDeepValue2)

if FFlagAppChatGetDeepValuePreserveFalse then
	return getDeepValue2
end

return function(p, value: string)
	for _, v in ipairs(value:split(".")) do
		if not p[v] then
			return nil
		end

		p = p[v]
	end

	return p
end
