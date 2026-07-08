local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local UserModel = require(SocialLibraries.dependencies).UserModel

return function(p1) -- line: 5
	-- upvalues: UserModel (copy)
	local presence = p1.presence
	local lastLocation = p1.lastLocation

	if presence == UserModel.PresenceType.OFFLINE then
		return "Common.Presence.Label.Offline"
	end

	if presence == UserModel.PresenceType.ONLINE then
		return "Common.Presence.Label.Online"
	end

	if presence == UserModel.PresenceType.IN_GAME or presence == UserModel.PresenceType.IN_STUDIO then
		if lastLocation then
			return (tostring(lastLocation))
		end

		return "Common.Presence.Label.Online"
	end

	return ""
end
