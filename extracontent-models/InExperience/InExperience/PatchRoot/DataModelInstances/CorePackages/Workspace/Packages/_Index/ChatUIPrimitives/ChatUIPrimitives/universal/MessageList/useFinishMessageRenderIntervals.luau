local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useFinishChatWindowMessageRenderIntervals = require(ChatUIPrimitives.Hooks.useFinishChatWindowMessageRenderIntervals)
require(script.Parent.groupMessages)

local function useFinishMessageRenderIntervals(callback)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			return callback(p).id
		end)
	end, { callback })
	local v2 = SignalsReact.useSignalState(v)
	local v3 = useFinishChatWindowMessageRenderIntervals((React.useCallback(function()
		return v2
	end, { v2 })))
	React.useEffect(function()
		v3()
	end, { v3 })
end

return useFinishMessageRenderIntervals
