local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)

local function createHistoryReplayReporter(data)
	local getHistoricalCount = data and data.getHistoricalCount
	local clock = data and data.clock or os.clock
	local report = data and data.report or ExpChatShared.Analytics.reportHistoryReplayed
	local v = clock()
	local total = 0

	return function(p: number)
		total += p
		report(total, not getHistoricalCount and 0 or getHistoricalCount(), (math.round((clock() - v) * 1000)))
	end
end

return createHistoryReplayReporter
