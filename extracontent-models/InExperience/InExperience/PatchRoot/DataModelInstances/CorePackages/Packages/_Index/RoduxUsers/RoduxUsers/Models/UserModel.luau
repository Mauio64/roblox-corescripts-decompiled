game:DefineFastFlag("EnableHasVerifiedBadgeUserModelValidation", false)

local MockId = require(script.Parent.MockId)
local t1 = {}

function t1.new(p1) -- line: 7
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 19
	-- upvalues: t1 (copy), MockId (copy)
	local v5 = p2 or {}

	return (t1.new({
		id = v5.id or MockId(),
		username = v5.username or "UN_" .. tostring(math.random(100000, 99999999)),
		displayName = v5.displayName or "DN_" .. tostring(math.random(100000, 99999999)),
		hasVerifiedBadge = v5.hasVerifiedBadge or false,
		created = v5.created or ""
	}))
end
function t1.isValid(p3) -- line: 33
	if not p3 then
		return false, "Expected user information to be given"
	end

	if not p3.id then
		return false, "Expected user's id to be given"
	end

	if p3.id ~= "0" and not p3.username then
		return false, "Expected user's username to be given"
	end

	if not p3.displayName then
		return false, "Expected user's displayName to be given"
	end

	if game:GetFastFlag("EnableHasVerifiedBadgeUserModelValidation") and p3.hasVerifiedBadge == nil then
		return false, "Expected user's hasVerifiedBadge to be given"
	end

	return true, "Valid UserModel"
end
function t1.isEqual(p4, p5) -- line: 52
	if game:GetFastFlag("EnableHasVerifiedBadgeUserModelValidation") then
		return p4.id == p5.id and (p4.username == p5.username and (p4.displayName == p5.displayName and p4.hasVerifiedBadge == p5.hasVerifiedBadge))
	end

	return p4.id == p5.id and (p4.username == p5.username and p4.displayName == p5.displayName)
end

return t1
