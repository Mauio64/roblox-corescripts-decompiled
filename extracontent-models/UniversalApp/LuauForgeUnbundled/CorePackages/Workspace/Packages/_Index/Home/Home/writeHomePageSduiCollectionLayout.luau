local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

local function writeHomePageSduiCollectionLayout(p2)
	local jsonEncode = HttpService:JSONEncode({
		itemsPerRow = p2.items_per_row,
		rowsAboveFold = p2.rows_above_fold
	})

	local success, result = pcall(function()
		return AppStorageService:GetItem("HomePageSduiCollectionLayout")
	end)

	if success and result == jsonEncode then
		return
	end

	pcall(function()
		AppStorageService:SetItem("HomePageSduiCollectionLayout", jsonEncode)
		AppStorageService:Flush()
	end)
end

return writeHomePageSduiCollectionLayout
