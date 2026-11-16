local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.DataHydration.CreatorAgentChat)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local parseSessionStream = require(script.Parent.parseSessionStream)

local function useSessionSummary(p)
	local v = React.useCallback(function(p2)
		return p.getMergedHistory(p2)
	end, { p })
	local v2 = SignalsReact.useSignalState(v)
	return React.useMemo(function()
		local v3 = parseSessionStream(v2, { sessionId = p.getCasSessionId() })

		return {
			subagentTaskState = v3.subagentTaskState,
			hasPublishedTurn = v3.includesPublishTool
		}
	end, { v2, p })
end

return useSessionSummary
