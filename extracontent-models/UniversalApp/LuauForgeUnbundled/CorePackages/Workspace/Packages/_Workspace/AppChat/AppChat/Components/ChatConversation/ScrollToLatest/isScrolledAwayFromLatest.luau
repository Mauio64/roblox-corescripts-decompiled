local FIntAppChatScrollToLatestThresholdPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatScrollToLatestThresholdPercent")

local function isScrolledAwayFromLatest(p2, p3, p4): boolean
	if p3 <= 0 then
		return false
	end

	return p3 * math.max(0, p4 or FIntAppChatScrollToLatestThresholdPercent) / 100 < p2
end

return isScrolledAwayFromLatest
