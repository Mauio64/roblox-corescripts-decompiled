local module = require("@luauforge/bundled/efK")
local Rodux = require("@game/CorePackages/Workspace/Packages/Rodux")

local module3 = require("@luauforge/bundled/efG")

return Rodux.createReducer({}, {
	[module3.GetFollowingExists.Succeeded.name] = function(p2, p3)
		local v6 = {}
		module.List.every(p3.responseBody.followings, function(data): boolean
			v6[tostring(data.userId)] = {
				isFollowing = data.isFollowing,
				isFollowed = data.isFollowed
			}

			return true
		end)

		return module.Dictionary.join(p2, v6)
	end
})
