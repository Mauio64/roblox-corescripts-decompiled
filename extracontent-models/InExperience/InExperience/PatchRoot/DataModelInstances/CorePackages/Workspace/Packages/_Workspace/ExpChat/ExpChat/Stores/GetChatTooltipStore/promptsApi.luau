local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local UrlBuilder = require(Parent.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local ExpChatShared = require(Parent.ExpChatShared)
local v7 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local v9 = game:DefineFastFlag("ExpChatUseTooltipPromptStyle", false)
local v10 = UrlBuilder2.new({
	path = "modals-api/v1/prompts",
	base = UrlBase.APIS,
	query = {
		entryPoint = "InExperienceChatWindowOpen",
		promptStyle = not v9 and "Modal" or "Tooltip"
	}
})()
local v11 = UrlBuilder2.new({
	path = "modals-api/v1/prompts/impression",
	base = UrlBase.APIS
})()
local u12 = nil

return {
	fetchAllTooltipEligibility = function(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 87
		-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), u12 (ref), HttpService (copy), v10 (copy), v7 (copy)
		if not FFlagExpChatUseUnifiedTooltipStore then
			return
		end

		if u12 ~= nil then
			if p1 then
				p1({
					customPrompts = u12
				})
			end

			return
		end

		HttpService:RequestInternal({
			Method = "GET",
			Url = v10,
			Headers = {
				Accept = "application/json"
			}
		}):Start(function(_, p4) -- line: 107
			-- upvalues: HttpService (copy), u12 (ref), p1 (copy), v7 (copy), p2 (copy)
			if p4.StatusCode == 200 then
				local ok, result = pcall(function() -- line: 109
					-- upvalues: HttpService (copy), p4 (copy)
					return HttpService:JSONDecode(p4.Body)
				end)

				if ok and result then
					local customPrompts = result.customPrompts

					if type(customPrompts) ~= "table" then
						customPrompts = {}
					end

					u12 = customPrompts

					if p1 then
						p1({
							customPrompts = customPrompts
						})

						return
					end
				else
					u12 = {}
					v7:error("Failed to decode ChatTooltip eligibility response")

					if p2 then
						p2()

						return
					end
				end
			else
				u12 = {}
				v7:error("ChatTooltip eligibility request failed: {} {}", tostring(p4.StatusCode), p4.StatusMessage or "")

				if p2 then
					p2()
				end
			end
		end)
	end,
	reportImpression = function(s1: string) -- line: 50
		-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), HttpService (copy), v11 (copy), v7 (copy)
		if not FFlagExpChatUseUnifiedTooltipStore then
			return
		end

		local json = HttpService:JSONEncode({
			promptType = s1,
			promptId = s1
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = v11,
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = json
		}):Start(function(_, p6) -- line: 69
			-- upvalues: v7 (copy), s1 (copy)
			if p6.StatusCode == 200 then
				v7:debug("ChatTooltip impression reported: {}", s1)

				return
			end

			v7:error("ChatTooltip impression failed for {}: {} {}", s1, tostring(p6.StatusCode), p6.StatusMessage or "")
		end)
	end
}
