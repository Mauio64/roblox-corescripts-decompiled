local friendRequestOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/Enums").FriendRequestOriginSource

local function getFriendRequestOriginText(p2, data)
	if p2 == friendRequestOriginSource.QrCode then
		return data.fromQrCode
	end

	if p2 == friendRequestOriginSource.PhoneContactImporter then
		return data.fromContacts
	end

	if p2 == friendRequestOriginSource.PlayerSearch then
		return data.fromSearch
	end

	return nil
end

return getFriendRequestOriginText
