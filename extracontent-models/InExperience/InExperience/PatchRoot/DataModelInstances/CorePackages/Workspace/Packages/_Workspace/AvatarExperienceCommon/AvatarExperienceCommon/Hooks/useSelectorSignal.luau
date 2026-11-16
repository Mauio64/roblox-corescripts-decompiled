local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local function fn(p, p2): boolean
	return p == p2
end

local function useSelectorSignal(callback, callback2)
	local v = useStore()
	local state = v:getState()

	local v2, v3 = React.useMemo(function()
		return Signals.createSignal(state)
	end, {})

	React.useEffect(function()
		v3((v:getState()))
		local changedConnection = v.changed:connect(v3)
		return function()
			changedConnection:disconnect()
		end
	end, { v })

	return React.useMemo(function()
		return Signals.createComputed(function(p)
			return callback(v2(p))
		end, callback2 or fn)
	end, { v2, callback, callback2 })
end

return useSelectorSignal
