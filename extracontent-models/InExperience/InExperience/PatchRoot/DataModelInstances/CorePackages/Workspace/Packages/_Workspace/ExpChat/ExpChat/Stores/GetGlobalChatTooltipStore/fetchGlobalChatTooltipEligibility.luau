local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ExpChat").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local url = urlBuilder.new({
	base = UrlBase.APIS,
	path = "modals-api/v1/prompts",
	query = { entryPoint = "InExperienceChatWindowOpen", promptStyle = "Modal" }
})()

local url2 = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts/impression" })()

local shouldShowTooltip = nil

local function fetchGlobalChatTooltipEligibility(callback, callback2)
	if shouldShowTooltip == nil then
		HttpService:RequestInternal({
			Url = url,
			Method = "GET",
			Headers = { Accept = "application/json" }
		}):Start(function(_, data)
			if data.StatusCode == 200 then
				local success, result = pcall(function()
					return HttpService:JSONDecode(data.Body)
				end)

				if success and result then
					local customPrompts = result.customPrompts
					local shouldShowTooltip2

					if customPrompts == nil or type(customPrompts) ~= "table" then
						shouldShowTooltip2 = false
					else
						shouldShowTooltip2 = customPrompts.GlobalChatTooltip ~= nil
					end

					shouldShowTooltip = shouldShowTooltip2

					if callback then
						callback({ shouldShowTooltip = shouldShowTooltip2 })
					end
				else
					shouldShowTooltip = false
					v:error("Failed to decode GlobalChatTooltip eligibility response")

					if callback2 then
						callback2()
					end
				end
			else
				shouldShowTooltip = false
				v:error(
					"GlobalChatTooltip eligibility request failed: {} {}",
					tostring(data.StatusCode),
					data.StatusMessage or ""
				)

				if callback2 then
					callback2()
				end
			end
		end)
	elseif callback then
		callback({ shouldShowTooltip = shouldShowTooltip })
	end
end

return {
	fetchEligibility = fetchGlobalChatTooltipEligibility,
	reportImpression = function()
		HttpService:RequestInternal({
			Url = url2,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({
				promptType = "GlobalChatTooltip",
				promptId = "GlobalChatTooltip"
			})
		}):Start(function(_, p)
			if p.StatusCode == 200 then
				v:debug("GlobalChatTooltip impression reported")
			else
				v:error("GlobalChatTooltip impression failed: {} {}", tostring(p.StatusCode), p.StatusMessage or "")
			end
		end)
	end
}
