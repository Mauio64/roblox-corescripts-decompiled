local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local JavascriptHybrid = require(GenericChallenges.Types.JavascriptHybrid)
local HttpService = game:GetService("HttpService")

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: HttpService (copy), JavascriptHybrid (copy)
	return function(s1: string) -- line: 30
		-- upvalues: HttpService (copy), JavascriptHybrid (copy), t1 (copy)
		local data = HttpService:JSONDecode(s1)

		if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or not data.params or not data.params.params) then
			return
		end

		local params = data.params.params

		if params.feature == JavascriptHybrid.Feature.ChallengeParsed and params.data.parsed == false then
			t1.OnChallengeLoadFailed(params)

			return
		end

		if params.feature == JavascriptHybrid.Feature.ChallengeInitialized and params.data.initialized == false then
			t1.OnChallengeLoadFailed(params)

			return
		end

		if t1.Hooks ~= nil then
			for _, v9 in t1.Hooks do
				if v9(params) then
					return
				end
			end
		end

		if params.feature == JavascriptHybrid.Feature.ChallengeCompleted then
			if params.data ~= nil then
				t1.OnChallengeCompleted(params)

				return
			end

			if t1.OnChallengeAbandoned ~= nil then
				t1.OnChallengeAbandoned()

				return
			end

			t1.OnChallengeLoadFailed(params)

			return
		end

		if params.feature == JavascriptHybrid.Feature.ChallengeInvalidated then
			t1.OnChallengeInvalidated(params)

			return
		end

		if data.params.params.feature == JavascriptHybrid.Feature.ChallengeDisplayed and t1.OnChallengeDisplayed ~= nil then
			t1.OnChallengeDisplayed(params)
		end
	end
end
