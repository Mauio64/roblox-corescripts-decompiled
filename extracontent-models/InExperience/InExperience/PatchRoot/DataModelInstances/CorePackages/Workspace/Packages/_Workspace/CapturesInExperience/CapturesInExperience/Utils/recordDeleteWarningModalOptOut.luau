local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)

local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getLocalUserId = require(parent.Utils.getLocalUserId)
local getUserIdsFromString = require(parent.Utils.getUserIdsFromString)

return function(p)
	local success, result = pcall(function()
		return AppStorageService:GetItem(Constants.DeleteWarningModalOptOutStorageKey)
	end)

	if not success then
		return
	end

	local userIdsFromString = getUserIdsFromString(result)
	userIdsFromString[getLocalUserId(Players) or ""] = true
	local joined = table.concat(Dash.keys(userIdsFromString), ",")

	local success2, _ = pcall(function()
		AppStorageService:SetItem(Constants.DeleteWarningModalOptOutStorageKey, joined)
		AppStorageService:Flush()
	end)

	if not success2 then
		return
	end

	p.fireEvent(EventNames.CapturesDeleteWarningModalOptedOut)
end
