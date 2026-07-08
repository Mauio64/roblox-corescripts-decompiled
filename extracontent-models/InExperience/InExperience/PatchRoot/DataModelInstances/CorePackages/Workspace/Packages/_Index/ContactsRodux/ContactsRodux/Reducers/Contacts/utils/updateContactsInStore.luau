local ParentParent = script.Parent.Parent.Parent.Parent
local Types = ParentParent.Types
local ParentParentParent = ParentParent.Parent

require(Types.ActionTypes)
require(Types.ReducerTypes)

local Dash = require(ParentParentParent.Dash)

return function(p1, p2) -- line: 8
	-- upvalues: Dash (copy)
	local userContactsEntities = p2.responseBody.userContactsEntities
	local t1 = {}

	Dash.forEach(userContactsEntities, function(p3) -- line: 12
		-- upvalues: t1 (copy)
		t1[p3.id] = {
			contactName = p3.name,
			mutualContacts = p3.mutualContacts,
			avatarAssetHashId = p3.avatarAssetHashId,
			headshotThumbnailUrl = p3.headshotThumbnailUrl,
			avatarThumbnailUrl = p3.avatarThumbnailUrl
		}
	end)

	return Dash.join(p1, t1)
end
