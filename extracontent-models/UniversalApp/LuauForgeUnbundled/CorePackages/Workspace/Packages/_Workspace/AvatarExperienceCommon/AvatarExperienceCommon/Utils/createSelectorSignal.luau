local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useSelectorSignal")

local function fn(p2, p3): boolean
	return p2 == p3
end

local function createSelectorSignal(object, callback, p2)
	local state = object:getState()
	local signal, v5 = Signals.createSignal(state)

	object.changed:connect(v5)

	return Signals.createComputed(function(p3)
		return callback(signal(p3))
	end, p2 or fn)
end

return createSelectorSignal
