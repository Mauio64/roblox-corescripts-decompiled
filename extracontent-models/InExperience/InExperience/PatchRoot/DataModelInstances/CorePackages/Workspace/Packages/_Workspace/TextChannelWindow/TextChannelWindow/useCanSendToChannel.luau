local parent = script.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local findLocalTextSource = require(script.Parent.findLocalTextSource)

return {
	useCanSendToChannel = function(instance, p: string?)
		local state, setState = React.useState(function()
			return findLocalTextSource(instance, p)
		end)

		local v = React.useCallback(function()
			setState(findLocalTextSource(instance, p))
		end, { instance, p })

		React.useEffect(v, { v })
		local v2

		if instance then
			v2 = instance.ChildAdded
		end

		useEventConnection(v2, v, { v })
		local v3

		if instance then
			v3 = instance.ChildRemoved
		end

		useEventConnection(v3, v, { v })

		local function evaluateCanSend() -- 2 equivalent calls inferred from this helper
			return instance == nil or p == nil or state ~= nil and state.CanSend
		end

		local state2, setState2 = React.useState(evaluateCanSend)

		React.useEffect(function()
			setState2(evaluateCanSend()) -- inferred equivalent call
		end, { instance, p, state })
		local v4

		if state then
			v4 = state:GetPropertyChangedSignal("CanSend")
		end

		useEventConnection(v4, function()
			setState2(evaluateCanSend()) -- inferred equivalent call
		end, { instance, p, state })

		return state2
	end
}
