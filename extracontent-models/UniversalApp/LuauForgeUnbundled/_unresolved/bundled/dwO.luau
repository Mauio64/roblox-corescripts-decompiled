local apiFetchUsersPresences = require("@game/CorePackages/Workspace/Packages/UserLib").Thunks.ApiFetchUsersPresences
local module = require("@luauforge/bundled/dtf")
local module2 = require("@luauforge/bundled/dtg")

return function(p2, p3)
	return function(object)
		local mapped = module.List.map(p3, function(p4)
			return (tostring(p4.id))
		end)

		return module2.all({ object:dispatch(apiFetchUsersPresences(p2, mapped)) })
	end
end
