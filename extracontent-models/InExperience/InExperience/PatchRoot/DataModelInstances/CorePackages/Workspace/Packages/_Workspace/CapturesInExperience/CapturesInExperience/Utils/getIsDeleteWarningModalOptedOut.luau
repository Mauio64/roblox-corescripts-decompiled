local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local getLocalUserId = require(ParentParent.Utils.getLocalUserId)
local getUserIdsFromString = require(ParentParent.Utils.getUserIdsFromString)

return function() -- line: 10
	-- upvalues: AppStorageService (copy), Constants (copy), getUserIdsFromString (copy), getLocalUserId (copy), Players (copy)
	local ok, result = pcall(function() -- line: 11
		-- upvalues: AppStorageService (copy), Constants (copy)
		return AppStorageService:GetItem(Constants.DeleteWarningModalOptOutStorageKey)
	end)

	if ok and (result ~= "" and getUserIdsFromString(result)[getLocalUserId(Players) or ""]) then
		return true
	end

	return false
end
