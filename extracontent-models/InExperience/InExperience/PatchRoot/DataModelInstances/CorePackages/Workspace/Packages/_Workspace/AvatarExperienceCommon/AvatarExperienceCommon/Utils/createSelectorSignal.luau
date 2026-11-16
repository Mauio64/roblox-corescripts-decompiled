local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local Signals = require(parent.Signals)

require(AvatarExperienceCommon.Hooks.useSelectorSignal)

local function fn(p, p2): boolean
	return p == p2
end

local function createSelectorSignal(object, callback, p)
	local state = object:getState()
	local signal, v = Signals.createSignal(state)

	object.changed:connect(v)

	return Signals.createComputed(function(p2)
		return callback(signal(p2))
	end, p or fn)
end

return createSelectorSignal
