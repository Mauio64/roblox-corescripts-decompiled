local UserService = game:GetService("UserService")

function getDisplayNameFromUserId(s1: string) -- line: 3
	-- upvalues: UserService (copy)
	local ok, result = pcall(function() -- line: 4
		-- upvalues: UserService (copy), s1 (copy)
		return UserService:GetUserInfosByUserIdsAsync({ (tonumber(s1)) })[1]
	end)

	if ok then
		return result.DisplayName
	end

	return ""
end

return getDisplayNameFromUserId
