local AppStorageService = game:GetService("AppStorageService")

local defineFastString = game:DefineFastString("CampaignNewBadgeSeenKey", "")

local v5 = {}

function v5.parseLastOpened(p2, value)
	if p2 and typeof(value) == "string" then
		return tonumber(value) or 0
	end

	return nil
end

function v5.getLastOpened()
	local success, result = pcall(function()
		return AppStorageService:GetItem(defineFastString)
	end)

	return v5.parseLastOpened(success, result)
end

function v5.setLastOpened(p2)
	return (pcall(function()
		AppStorageService:SetItem(defineFastString, (tostring(p2)))
		AppStorageService:Flush()
	end))
end

return v5
