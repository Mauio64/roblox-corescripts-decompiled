local AppChat = script:FindFirstAncestor("AppChat")

local isOverLength = require(AppChat.Utils.isOverLength)
local FFlagAppChatUseGraphemeMessageLength = require(AppChat.Flags.FFlagAppChatUseGraphemeMessageLength)

return function(value, p): boolean
	if FFlagAppChatUseGraphemeMessageLength then
		if isOverLength(value, p, 300) then
			return false
		end
	elseif p < #value then
		return false
	end

	return not value:match("^%s*$")
end
