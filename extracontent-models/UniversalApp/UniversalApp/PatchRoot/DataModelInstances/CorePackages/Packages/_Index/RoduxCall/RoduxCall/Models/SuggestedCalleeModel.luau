local RoduxCall = script:FindFirstAncestor("RoduxCall")
local RoduxCallParent = RoduxCall.Parent
local t = require(RoduxCallParent.t)
local Cryo = require(RoduxCallParent.Cryo)
local Enums = require(RoduxCall.Enums)
local t1 = {}

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 21
	-- upvalues: t1 (copy)
	local v9 = p2 or {}

	return (t1.new({
		lastLocation = "",
		userId = v9.userId or 12345,
		userPresenceType = v9.userPresenceType or "Offline"
	}))
end
function t1.format(p3) -- line: 33
	-- upvalues: Cryo (copy), Enums (copy)
	return Cryo.Dictionary.join(p3, {
		userPresenceType = Enums.PresenceType[p3.userPresenceType]
	})
end

t1.isValid = t.strictInterface({
	userId = t.number,
	userPresenceType = function(p4) -- line: 41
		-- upvalues: Enums (copy)
		return Enums.PresenceType[p4] ~= nil
	end,
	lastLocation = t.string
})

return t1
