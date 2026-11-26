require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")

return function(p2, p3)
	local userContactsEntities = p3.responseBody.userContactsEntities
	local v5 = {}

	Dash.forEach(userContactsEntities, function(data)
		v5[data.id] = {
			contactName = data.name,
			mutualContacts = data.mutualContacts,
			avatarAssetHashId = data.avatarAssetHashId,
			headshotThumbnailUrl = data.headshotThumbnailUrl,
			avatarThumbnailUrl = data.avatarThumbnailUrl
		}
	end)

	return Dash.join(p2, v5)
end
