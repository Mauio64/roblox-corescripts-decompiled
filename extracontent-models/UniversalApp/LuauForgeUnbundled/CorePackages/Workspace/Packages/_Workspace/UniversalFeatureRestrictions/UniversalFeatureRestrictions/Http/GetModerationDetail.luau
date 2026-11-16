local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UrlBuilder").UrlBuilder
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/Promise")
local buildQueryString = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Utils/buildQueryString")

local function GetModerationDetail(p2)
	local v5 = urlBuilder.usermoderation.moderationDetail() .. buildQueryString(p2)

	return Promise.new(function(callback, callback2)
		task.defer(function()
			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(v5, Enum.ThrottlingPriority.Default)
			end)

			if not success then
				callback2({ error = "HTTP request failed", details = result })

				return
			end

			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if success2 then
				callback(result2)
			else
				callback2({ error = "Failed to parse JSON response", details = result2 })
			end
		end)
	end)
end

return GetModerationDetail
