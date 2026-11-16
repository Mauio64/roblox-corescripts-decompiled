local function isPlatformInviteUIEnabled()
	local v = game:GetEngineFeature("PlatformFriendsService")

	if v then
		local PlatformFriendsService = game:GetService("PlatformFriendsService")
		return (PlatformFriendsService:IsInviteFriendsEnabled())
	end

	return v
end

return isPlatformInviteUIEnabled
