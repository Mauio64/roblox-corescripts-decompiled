local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ChatCardEmphasisContext = require(script.Parent.ChatCardEmphasisContext)
local ChatCardEmphasisPositionContext = require(script.Parent.ChatCardEmphasisPositionContext)

local function useChatCardEmphasis(p: number?, value: number?)
	local v = React.useContext(ChatCardEmphasisContext)
	local v2 = React.useMemo(function()
		return {}
	end, {})
	local v3 = React.useContext(ChatCardEmphasisPositionContext)

	React.useLayoutEffect(function()
		if v == nil or p == nil then
			return nil
		end

		v.register(v2, p, value or 0, v3)
		return function()
			v.unregister(v2)
		end
	end, { v, v2, p, value, v3 })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return v ~= nil and v.getEmphasizedKey(p2) == v2
		end)
	end, { v, v2 })
	local v5 = SignalsReact.useSignalState(v4)
	return if v ~= nil then v5 else nil
end

return useChatCardEmphasis
