local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactUtils").Hooks.RoactRodux.useStore

local function fn(p2, p3): boolean
	return p2 == p3
end

local function useSelectorSignal(callback, p2)
	local v5 = useStore()
	local state = v5:getState()

	local v6, v7 = React.useMemo(function()
		return Signals.createSignal(state)
	end, {})

	React.useEffect(function()
		v7((v5:getState()))
		local changedConnection = v5.changed:connect(v7)
		return function()
			changedConnection:disconnect()
		end
	end, { v5 })

	return React.useMemo(function()
		return Signals.createComputed(function(p3)
			return callback(v6(p3))
		end, p2 or fn)
	end, { v6, callback, p2 })
end

return useSelectorSignal
