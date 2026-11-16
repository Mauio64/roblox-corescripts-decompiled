local parent = script.Parent.Parent.Parent.Parent
local types = parent.Types
local parent2 = parent.Parent
require(types.ActionTypes)
require(types.ReducerTypes)
local Dash = require(parent2.Dash)

return function(p, p2)
	local userContactsEntities = p2.responseBody.userContactsEntities
	local v = {}

	Dash.forEach(userContactsEntities, function(data)
		v[data.id] = {
			contactName = data.name,
			mutualContacts = data.mutualContacts,
			avatarAssetHashId = data.avatarAssetHashId,
			headshotThumbnailUrl = data.headshotThumbnailUrl,
			avatarThumbnailUrl = data.avatarThumbnailUrl
		}
	end)

	return Dash.join(p, v)
end
