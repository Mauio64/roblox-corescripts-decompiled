local UserService = game:GetService("UserService")

function getDisplayNameFromUserId(p: string)
	local success, result = pcall(function()
		return UserService:GetUserInfosByUserIdsAsync({ (tonumber(p)) })[1]
	end)

	return if success then result.DisplayName else ""
end

return getDisplayNameFromUserId
