local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")

local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local getLocalUserId = require(parent.Utils.getLocalUserId)
local getUserIdsFromString = require(parent.Utils.getUserIdsFromString)

return function(): boolean
	local success, result = pcall(function()
		return AppStorageService:GetItem(Constants.DeleteWarningModalOptOutStorageKey)
	end)

	if success and result ~= "" and getUserIdsFromString(result)[getLocalUserId(Players) or ""] then
		return true
	end

	return false
end
