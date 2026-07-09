local CorePackages = game:GetService("CorePackages")
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local UpdateUsers = require(CorePackages.Workspace.Packages.UserLib).Thunks.UpdateUsers

return function(p1) -- line: 6
	-- upvalues: Immutable (copy), UpdateUsers (copy)
	return function(p2) -- line: 7
		-- upvalues: p1 (copy), Immutable (copy), UpdateUsers (copy)
		local v6 = p2:getState().Users[p1]

		if v6 then
			local v7 = Immutable.Set(v6, "isFriend", false)

			p2:dispatch(UpdateUsers({ v7 }))
		end
	end
end
