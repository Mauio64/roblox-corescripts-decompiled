local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetGameFollowingStatus = require(Modules.LuaApp.Actions.SetGameFollowingStatus)
local SetGameFollow = require(Modules.LuaApp.Actions.SetGameFollow)

return function(p1, p2) -- line: 6
	-- upvalues: SetGameFollowingStatus (copy), Immutable (copy), SetGameFollow (copy)
	local v7 = p1 or {}

	if p2.type == SetGameFollowingStatus.name then
		return (Immutable.Set(v7, p2.universeId, {
			canFollow = p2.canFollow,
			isFollowed = p2.isFollowed
		}))
	end

	if p2.type == SetGameFollow.name then
		local v8 = v7[p2.universeId]

		if v8 then
			local v9 = Immutable.Set(v8, "isFollowed", p2.isFollowed)

			v7 = Immutable.Set(v7, p2.universeId, v9)
		end
	end

	return v7
end
