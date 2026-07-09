local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local ApiFetchUsersPresences = require(Parent.UserLib).Thunks.ApiFetchUsersPresences
local Cryo = require(Parent.Cryo)
local Promise = require(Parent.Promise)

return function(p1, p2) -- line: 7
	-- upvalues: Cryo (copy), Promise (copy), ApiFetchUsersPresences (copy)
	return function(p3) -- line: 8
		-- upvalues: Cryo (copy), p2 (copy), Promise (copy), ApiFetchUsersPresences (copy), p1 (copy)
		local v8 = Cryo.List.map(p2, function(p4) -- line: 9
			return (tostring(p4.id))
		end)

		return Promise.all({ p3:dispatch(ApiFetchUsersPresences(p1, v8)) })
	end
end
