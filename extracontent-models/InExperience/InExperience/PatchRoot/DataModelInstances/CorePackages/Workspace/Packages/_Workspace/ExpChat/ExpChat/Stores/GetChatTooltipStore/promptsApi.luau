local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ExpChat").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local defineFastFlag = game:DefineFastFlag("ExpChatUseTooltipPromptStyle", false)

local url = urlBuilder.new({
	base = UrlBase.APIS,
	path = "modals-api/v1/prompts",
	query = {
		entryPoint = "InExperienceChatWindowOpen",
		promptStyle = defineFastFlag and "Tooltip" or "Modal"
	}
})()

local url2 = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts/impression" })()

local customPrompts2 = nil
local PromptsApi = {}

function PromptsApi.fetchAllTooltipEligibility(callback, callback2)
	if not FFlagExpChatUseUnifiedTooltipStore then
		return
	end

	if customPrompts2 == nil then
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
					local customPrompts3 = type(customPrompts) ~= "table" and {} or customPrompts

					customPrompts2 = customPrompts3

					if callback then
						callback({ customPrompts = customPrompts3 })
					end
				else
					customPrompts2 = {}
					v:error("Failed to decode ChatTooltip eligibility response")

					if callback2 then
						callback2()
					end
				end
			else
				customPrompts2 = {}
				v:error(
					"ChatTooltip eligibility request failed: {} {}",
					tostring(data.StatusCode),
					data.StatusMessage or ""
				)

				if callback2 then
					callback2()
				end
			end
		end)
	elseif callback then
		callback({ customPrompts = customPrompts2 })
	end
end

function PromptsApi.reportImpression(p: string)
	if not FFlagExpChatUseUnifiedTooltipStore then
		return
	end

	HttpService:RequestInternal({
		Url = url2,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ promptType = p, promptId = p })
	}):Start(function(_, p2)
		if p2.StatusCode == 200 then
			v:debug("ChatTooltip impression reported: {}", p)
		else
			v:error("ChatTooltip impression failed for {}: {} {}", p, tostring(p2.StatusCode), p2.StatusMessage or "")
		end
	end)
end

return PromptsApi
