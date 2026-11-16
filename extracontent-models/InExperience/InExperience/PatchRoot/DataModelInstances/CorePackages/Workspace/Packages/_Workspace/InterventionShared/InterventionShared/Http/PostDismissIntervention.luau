local parent = script:FindFirstAncestor("InterventionShared").Parent

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local function PostDismissIntervention(intervention_id: string)
	local dismissIntervention = urlBuilder.usermoderation.dismissIntervention()
	local jsonEncode = HttpService:JSONEncode({ intervention_id = intervention_id })

	return Promise.new(function(callback, callback2)
		task.defer(function()
			local success, result = pcall(function()
				return HttpRbxApiService:PostAsyncFullUrl(
					dismissIntervention,
					jsonEncode,
					Enum.ThrottlingPriority.Default
				)
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

return PostDismissIntervention
