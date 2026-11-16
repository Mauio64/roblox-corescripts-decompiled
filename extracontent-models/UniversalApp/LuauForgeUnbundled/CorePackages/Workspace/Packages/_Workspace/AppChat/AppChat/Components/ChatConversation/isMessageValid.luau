local isOverLength = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/isOverLength")
local FFlagAppChatUseGraphemeMessageLength = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseGraphemeMessageLength")

return function(value, p2): boolean
	if FFlagAppChatUseGraphemeMessageLength then
		if isOverLength(value, p2, 300) then
			return false
		end
	elseif p2 < #value then
		return false
	end

	if value:match("^%s*$") then
		return false
	end

	return true
end
