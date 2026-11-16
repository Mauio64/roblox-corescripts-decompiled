local RoduxCall = script:FindFirstAncestor("RoduxCall")
local parent = RoduxCall.Parent
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local Enums = require(RoduxCall.Enums)

local SuggestedCalleeModel = {}

function SuggestedCalleeModel.new(p)
	assert(SuggestedCalleeModel.isValid(p))

	SuggestedCalleeModel.__index = SuggestedCalleeModel

	setmetatable(p, SuggestedCalleeModel)

	return p
end

function SuggestedCalleeModel.mock(options)
	local v = options or {}

	return (SuggestedCalleeModel.new({
		userId = v.userId or 12345,
		userPresenceType = v.userPresenceType or "Offline",
		lastLocation = ""
	}))
end

function SuggestedCalleeModel.format(p)
	return Cryo.Dictionary.join(p, { userPresenceType = Enums.PresenceType[p.userPresenceType] })
end

SuggestedCalleeModel.isValid = t.strictInterface({
	userId = t.number,
	userPresenceType = function(p): boolean
		return Enums.PresenceType[p] ~= nil
	end,
	lastLocation = t.string
})

return SuggestedCalleeModel
