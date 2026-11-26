local immutable = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Immutable
local updateUsers = require("@luauforge/bundled/ciE").Thunks.UpdateUsers

return function(p2)
	return function(object)
		local user = object:getState().Users[p2]

		if user then
			object:dispatch(updateUsers({ (immutable.Set(user, "isFriend", false)) }))
		end
	end
end
