local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local userModel = dependencies.UserModel

return function(p)
	local presence = p.presence
	local lastLocation = p.lastLocation

	if presence == userModel.PresenceType.OFFLINE then
		return "Common.Presence.Label.Offline"
	end

	if presence == userModel.PresenceType.ONLINE then
		return "Common.Presence.Label.Online"
	end

	if presence ~= userModel.PresenceType.IN_GAME and presence ~= userModel.PresenceType.IN_STUDIO then
		return ""
	end

	if lastLocation then
		return (tostring(lastLocation))
	end

	return "Common.Presence.Label.Online"
end
