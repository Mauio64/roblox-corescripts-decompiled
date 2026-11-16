local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local JavascriptHybrid = require(GenericChallenges.Types.JavascriptHybrid)

local HttpService = game:GetService("HttpService")

return function(data)
	return function(json: string)
		local jsonDecode = HttpService:JSONDecode(json)

		if
			jsonDecode.moduleID ~= JavascriptHybrid.Module.Navigation
			or jsonDecode.functionName ~= JavascriptHybrid.Function.navigateToFeature
			or not (jsonDecode.params and jsonDecode.params.params)
		then
			return
		end

		local params = jsonDecode.params.params

		if params.feature == JavascriptHybrid.Feature.ChallengeParsed and params.data.parsed == false then
			data.OnChallengeLoadFailed(params)
			return
		end

		if params.feature == JavascriptHybrid.Feature.ChallengeInitialized and params.data.initialized == false then
			data.OnChallengeLoadFailed(params)
			return
		end

		if data.Hooks ~= nil then
			for _, hook in data.Hooks do
				if hook(params) then
					return
				end
			end
		end

		if params.feature == JavascriptHybrid.Feature.ChallengeCompleted then
			if params.data ~= nil then
				data.OnChallengeCompleted(params)
			elseif data.OnChallengeAbandoned == nil then
				data.OnChallengeLoadFailed(params)
			else
				data.OnChallengeAbandoned()
			end
		elseif params.feature == JavascriptHybrid.Feature.ChallengeInvalidated then
			data.OnChallengeInvalidated(params)
		elseif
			jsonDecode.params.params.feature == JavascriptHybrid.Feature.ChallengeDisplayed
			and data.OnChallengeDisplayed ~= nil
		then
			data.OnChallengeDisplayed(params)
		end
	end
end
