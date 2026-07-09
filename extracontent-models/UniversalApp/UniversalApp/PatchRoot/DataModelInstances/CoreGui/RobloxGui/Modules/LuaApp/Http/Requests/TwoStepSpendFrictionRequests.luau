local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return {
	status = function(p1) -- line: 13
		-- upvalues: Url (copy)
		return p1(string.format("%sv2/spend-friction/two-step-verification/status", Url.ECONOMY_URL), "GET")
	end,
	generate = function(p2) -- line: 19
		-- upvalues: Url (copy)
		return p2(string.format("%sv2/spend-friction/two-step-verification/generate", Url.ECONOMY_URL), "POST", {
			postBody = "",
			maxRetryCount = 0
		})
	end,
	redeem = function(p3, s1: string, s2: string) -- line: 25
		-- upvalues: Url (copy), HttpService (copy)
		local v9 = string.format("%sv2/spend-friction/two-step-verification/redeem", Url.ECONOMY_URL)
		local json = HttpService:JSONEncode({
			challengeToken = s1,
			verificationToken = s2
		})

		return p3(v9, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end
}
