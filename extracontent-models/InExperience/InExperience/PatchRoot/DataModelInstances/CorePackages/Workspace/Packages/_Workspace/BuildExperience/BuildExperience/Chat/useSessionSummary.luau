local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.DataHydration.CreatorAgentChat)

local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local parseSessionStream = require(script.Parent.parseSessionStream)

local function useSessionSummary(p1) -- line: 25
	-- upvalues: React (copy), SignalsReact (copy), parseSessionStream (copy)
	local v7 = React.useCallback(function(p2) -- line: 26
		-- upvalues: p1 (copy)
		return p1.getMergedHistory(p2)
	end, { p1 })
	local v8 = SignalsReact.useSignalState(v7)

	return React.useMemo(function() -- line: 30
		-- upvalues: parseSessionStream (copy), v8 (copy), p1 (copy)
		local v10 = parseSessionStream(v8, {
			sessionId = p1.getCasSessionId()
		})

		return {
			subagentTaskState = v10.subagentTaskState,
			hasPublishedTurn = v10.includesPublishTool
		}
	end, {
		v8,
		p1
	})
end

return useSessionSummary
