local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/PurchaseItemsTypes")

local function getIsInsufficientRobuxError(p2)
	local success, result = pcall(function(): boolean
		local message = HttpService:JSONDecode(p2.Body).message or ""
		return string.find(message, "InsufficientTotalBalance") ~= nil
	end)

	if success then
		return result
	end

	return false
end

return getIsInsufficientRobuxError
