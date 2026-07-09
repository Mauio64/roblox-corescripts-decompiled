local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getLocalUserId = require(ParentParent.Utils.getLocalUserId)
local getUserIdsFromString = require(ParentParent.Utils.getUserIdsFromString)

return function(p1) -- line: 14
	-- upvalues: AppStorageService (copy), Constants (copy), getUserIdsFromString (copy), getLocalUserId (copy), Players (copy), Dash (copy), EventNames (copy)
	local ok, result = pcall(function() -- line: 15
		-- upvalues: AppStorageService (copy), Constants (copy)
		return AppStorageService:GetItem(Constants.DeleteWarningModalOptOutStorageKey)
	end)

	if not ok then
		return
	end

	local v13 = getUserIdsFromString(result)

	v13[getLocalUserId(Players) or ""] = true

	local v14 = table.concat(Dash.keys(v13), ",")
	local ok2, _ = pcall(function() -- line: 28
		-- upvalues: AppStorageService (copy), Constants (copy), v14 (copy)
		AppStorageService:SetItem(Constants.DeleteWarningModalOptOutStorageKey, v14)
		AppStorageService:Flush()
	end)

	if not ok2 then
		return
	end

	p1.fireEvent(EventNames.CapturesDeleteWarningModalOptedOut)
end
