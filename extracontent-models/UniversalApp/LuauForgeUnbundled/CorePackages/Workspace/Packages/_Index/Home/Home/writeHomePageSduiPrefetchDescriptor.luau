local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

local function writeHomePageSduiPrefetchDescriptor(p2)
	local jsonEncode = HttpService:JSONEncode({ enabledCapabilities = p2 })

	local success, result = pcall(function()
		return AppStorageService:GetItem("HomePageSduiCapabilities")
	end)

	if success and result == jsonEncode then
		return
	end

	pcall(function()
		AppStorageService:SetItem("HomePageSduiCapabilities", jsonEncode)
		AppStorageService:Flush()
	end)
end

return writeHomePageSduiPrefetchDescriptor
