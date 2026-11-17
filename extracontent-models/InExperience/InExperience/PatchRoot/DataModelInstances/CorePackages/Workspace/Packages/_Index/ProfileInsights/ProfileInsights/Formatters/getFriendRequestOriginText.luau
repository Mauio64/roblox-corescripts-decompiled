local ProfileInsights = script:FindFirstAncestor("ProfileInsights")

local Enums = require(ProfileInsights.Enums)
local FriendRequestOriginSource = Enums.FriendRequestOriginSource

local function getFriendRequestOriginText(p: number?, data)
	if p == FriendRequestOriginSource.QrCode then
		return data.fromQrCode
	end

	if p == FriendRequestOriginSource.PhoneContactImporter then
		return data.fromContacts
	end

	if p == FriendRequestOriginSource.PlayerSearch then
		return data.fromSearch
	end

	return nil
end

return getFriendRequestOriginText
