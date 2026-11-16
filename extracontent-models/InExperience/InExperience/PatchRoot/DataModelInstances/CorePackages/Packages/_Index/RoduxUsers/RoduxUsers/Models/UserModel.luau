game:DefineFastFlag("EnableHasVerifiedBadgeUserModelValidation", false)

local MockId = require(script.Parent.MockId)

local UserModel = {}

function UserModel.new(p)
	assert(UserModel.isValid(p))

	UserModel.__index = UserModel

	setmetatable(p, UserModel)

	return p
end

function UserModel.mock(options)
	local v = options or {}

	return (UserModel.new({
		id = v.id or MockId(),
		username = v.username or "UN_" .. tostring(math.random(100000, 99999999)),
		displayName = v.displayName or "DN_" .. tostring(math.random(100000, 99999999)),
		hasVerifiedBadge = v.hasVerifiedBadge or false,
		created = v.created or ""
	}))
end

function UserModel.isValid(data): (boolean, string)
	if not data then
		return false, "Expected user information to be given"
	end

	if not data.id then
		return false, "Expected user's id to be given"
	end

	if data.id ~= "0" and not data.username then
		return false, "Expected user's username to be given"
	end

	if not data.displayName then
		return false, "Expected user's displayName to be given"
	end

	if game:GetFastFlag("EnableHasVerifiedBadgeUserModelValidation") and data.hasVerifiedBadge == nil then
		return false, "Expected user's hasVerifiedBadge to be given"
	end

	return true, "Valid UserModel"
end

function UserModel.isEqual(data, data2): boolean
	if game:GetFastFlag("EnableHasVerifiedBadgeUserModelValidation") then
		return data.id == data2.id
			and data.username == data2.username
			and data.displayName == data2.displayName
			and data.hasVerifiedBadge == data2.hasVerifiedBadge
	end

	return data.id == data2.id and data.username == data2.username and data.displayName == data2.displayName
end

return UserModel
