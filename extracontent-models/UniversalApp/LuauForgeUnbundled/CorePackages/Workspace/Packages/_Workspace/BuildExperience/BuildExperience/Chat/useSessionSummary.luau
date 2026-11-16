require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local parseSessionStream = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/parseSessionStream")

local function useSessionSummary(p2)
	local v5 = React.useCallback(function(p3)
		return p2.getMergedHistory(p3)
	end, { p2 })
	local v6 = SignalsReact.useSignalState(v5)
	return React.useMemo(function()
		local v7 = parseSessionStream(v6, { sessionId = p2.getCasSessionId() })

		return {
			subagentTaskState = v7.subagentTaskState,
			hasPublishedTurn = v7.includesPublishTool
		}
	end, { v6, p2 })
end

return useSessionSummary
