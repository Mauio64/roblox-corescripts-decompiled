local AppChat = script:FindFirstAncestor("AppChat")

local FIntAppChatScrollToLatestThresholdPercent = require(AppChat.Flags.FIntAppChatScrollToLatestThresholdPercent)

local function isScrolledAwayFromLatest(p: number, p2: number, p3: number?): boolean
	return not (p2 <= 0) and p2 * math.max(0, p3 or FIntAppChatScrollToLatestThresholdPercent) / 100 < p
end

return isScrolledAwayFromLatest
