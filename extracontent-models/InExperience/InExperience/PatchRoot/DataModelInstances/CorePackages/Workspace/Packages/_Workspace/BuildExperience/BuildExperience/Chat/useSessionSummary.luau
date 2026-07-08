local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.DataHydration.CreatorAgentChat)

local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local parseSessionStream = require(script.Parent.parseSessionStream)

local function useSessionSummary(p1) -- line: 25
	-- upvalues: SignalsReact (copy), React (copy), parseSessionStream (copy)
	local v7 = SignalsReact.useSignalState(p1.getMergedHistory)

	return React.useMemo(function() -- line: 27
		-- upvalues: parseSessionStream (copy), v7 (copy), p1 (copy)
		local v8 = parseSessionStream(v7, {
			sessionId = p1.getCasSessionId()
		})

		return {
			subagentTaskState = v8.subagentTaskState,
			hasPublishedTurn = v8.includesPublishTool
		}
	end, {
		v7,
		p1
	})
end

return useSessionSummary
