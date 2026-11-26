local FFlagAppChatGetDeepValuePreserveFalse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGetDeepValuePreserveFalse")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")

if FFlagAppChatGetDeepValuePreserveFalse then
	return getDeepValue2
end

return function(p2, value)
	for i, v5 in ipairs(value:split(".")) do
		if not p2[v5] then
			return nil
		end

		p2 = p2[v5]
	end

	return p2
end
