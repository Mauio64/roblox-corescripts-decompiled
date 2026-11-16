local t = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/t")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local v5 = options or {}

	return (class.new({
		canSeeRegroupPromptToast = v5.canSeeRegroupPromptToast or false,
		canSeeRegroupJoinButton = v5.canSeeRegroupJoinButton or false
	}))
end

function class.format(p2)
	return (class.new({
		canSeeRegroupPromptToast = p2.canSeeRegroupPromptToast,
		canSeeRegroupJoinButton = p2.canSeeRegroupJoinButton
	}))
end

class.isValid = t.interface({
	canSeeRegroupPromptToast = t.boolean,
	canSeeRegroupJoinButton = t.boolean
})

return class
