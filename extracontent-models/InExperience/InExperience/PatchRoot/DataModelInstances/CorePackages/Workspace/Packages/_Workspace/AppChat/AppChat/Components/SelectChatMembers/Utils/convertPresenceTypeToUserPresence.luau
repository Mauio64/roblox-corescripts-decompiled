local Parent = script:FindFirstAncestor("AppChat").Parent
local UserModel = require(Parent.UserLib).Models.UserModel
local PresenceType = require(Parent.GraphQLServer).types.PresenceType

return function(p1) -- line: 9
	-- upvalues: PresenceType (copy), UserModel (copy)
	if p1 == PresenceType.Online then
		return UserModel.PresenceType.ONLINE
	end

	if p1 == PresenceType.InGame then
		return UserModel.PresenceType.IN_GAME
	end

	if p1 == PresenceType.InStudio then
		return UserModel.PresenceType.IN_STUDIO
	end

	return UserModel.PresenceType.OFFLINE
end
