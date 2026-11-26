local userModel = require("@game/CorePackages/Workspace/Packages/UserLib").Models.UserModel
local updateUsers = require("@game/CorePackages/Workspace/Packages/UserLib").Thunks.UpdateUsers

local function fn(items)
	local result = {}

	for k, item in pairs(items) do
		item.isFriend = true
		item.friendRank = k
		local v5 = userModel.fromDataTable(item)
		result[v5.id] = v5
	end

	return result
end

return function(p2, p3)
	return function(object)
		local v5 = fn(p2)

		if p3 and p3.mockedActions and p3.mockedActions.UpdateUsers then
			p3.mockedActions.UpdateUsers(v5)
		else
			object:dispatch(updateUsers(v5))
		end
	end
end
