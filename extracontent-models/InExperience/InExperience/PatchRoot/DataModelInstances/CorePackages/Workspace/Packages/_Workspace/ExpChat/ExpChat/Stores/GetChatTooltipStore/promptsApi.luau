local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local UrlBuilder = require(Parent.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local ExpChatShared = require(Parent.ExpChatShared)
local v7 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local v9 = UrlBuilder2.new({
	path = "modals-api/v1/prompts",
	base = UrlBase.APIS,
	query = {
		entryPoint = "InExperienceChatWindowOpen",
		promptStyle = "Modal"
	}
})()
local v10 = UrlBuilder2.new({
	path = "modals-api/v1/prompts/impression",
	base = UrlBase.APIS
})()
local u11 = nil

return {
	fetchAllTooltipEligibility = function(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 86
		-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), u11 (ref), HttpService (copy), v9 (copy), v7 (copy)
		if not FFlagExpChatUseUnifiedTooltipStore then
			return
		end

		if u11 ~= nil then
			if p1 then
				p1({
					customPrompts = u11
				})
			end

			return
		end

		HttpService:RequestInternal({
			Method = "GET",
			Url = v9,
			Headers = {
				Accept = "application/json"
			}
		}):Start(function(_, p4) -- line: 106
			-- upvalues: HttpService (copy), u11 (ref), p1 (copy), v7 (copy), p2 (copy)
			if p4.StatusCode == 200 then
				local ok, result = pcall(function() -- line: 108
					-- upvalues: HttpService (copy), p4 (copy)
					return HttpService:JSONDecode(p4.Body)
				end)

				if ok and result then
					local customPrompts = result.customPrompts

					if type(customPrompts) ~= "table" then
						customPrompts = {}
					end

					u11 = customPrompts

					if p1 then
						p1({
							customPrompts = customPrompts
						})

						return
					end
				else
					u11 = {}
					v7:error("Failed to decode ChatTooltip eligibility response")

					if p2 then
						p2()

						return
					end
				end
			else
				u11 = {}
				v7:error("ChatTooltip eligibility request failed: {} {}", tostring(p4.StatusCode), p4.StatusMessage or "")

				if p2 then
					p2()
				end
			end
		end)
	end,
	reportImpression = function(s1: string) -- line: 49
		-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), HttpService (copy), v10 (copy), v7 (copy)
		if not FFlagExpChatUseUnifiedTooltipStore then
			return
		end

		local json = HttpService:JSONEncode({
			promptType = s1,
			promptId = s1
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = v10,
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = json
		}):Start(function(_, p6) -- line: 68
			-- upvalues: v7 (copy), s1 (copy)
			if p6.StatusCode == 200 then
				v7:debug("ChatTooltip impression reported: {}", s1)

				return
			end

			v7:error("ChatTooltip impression failed for {}: {} {}", s1, tostring(p6.StatusCode), p6.StatusMessage or "")
		end)
	end
}
