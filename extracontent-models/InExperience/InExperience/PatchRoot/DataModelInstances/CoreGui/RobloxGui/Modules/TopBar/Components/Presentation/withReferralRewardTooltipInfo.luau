local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local HttpRequest = require(CorePackages.Packages.HttpRequest)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local config = HttpRequest.config
local v = {
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("WithReferralRewardTooltipInfoHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local Http = require(CorePackages.Workspace.Packages.Http)
local Url = Http.Url
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Cryo = require(CorePackages.Packages.Cryo)

function GetReferralRewardTooltipInfo()
	local queryString = Url:makeQueryString({ UniverseId = game.GameId })

	return v2(string.format("%sreferral-reward-metadata/v1/get-reward-metadata?%s", Url.APIS_URL, queryString), "GET")
end

function withReferralRewardTooltipInfo(p)
	return function(p2)
		local joined = Cryo.Dictionary.join(p2, { referralRewardTooltipText = "" })

		local state, setState = React.useState("")
		React.useEffect(function()
			GetReferralRewardTooltipInfo():andThen(function(p3)
				if p3 and p3.responseBody and p3.responseBody.name then
					setState(p3.responseBody.name)
					task.delay(4, function()
						setState("")
					end)
				end
			end):catch(function(p3)
				warn(p3)
			end)
		end, {})
		local v3 = useLocalization({
			referralRewardTooltipText = {
				"CoreScripts.TopBar.RobloxMenuReferralRewardTooltip",
				referralRewardName = state
			}
		})

		if state ~= "" then
			joined = Cryo.Dictionary.join(joined, {
				referralRewardTooltipText = v3.referralRewardTooltipText
			})
		end

		return React.createElement(p, joined)
	end
end

return withReferralRewardTooltipInfo
