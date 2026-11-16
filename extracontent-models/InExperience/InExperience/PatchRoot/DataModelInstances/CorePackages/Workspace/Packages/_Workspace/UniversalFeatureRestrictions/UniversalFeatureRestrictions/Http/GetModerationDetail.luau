local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local parent = UniversalFeatureRestrictions.Parent

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Promise = require(parent.Promise)
local buildQueryString = require(UniversalFeatureRestrictions.Utils.buildQueryString)

local function GetModerationDetail(p)
	local v = urlBuilder.usermoderation.moderationDetail() .. buildQueryString(p)

	return Promise.new(function(callback, callback2)
		task.defer(function()
			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(v, Enum.ThrottlingPriority.Default)
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
