local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local FFlagLuaAppDefaultHttpRetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v5 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 7
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("WithReferralRewardTooltipInfoHttpRetryCount", 4)
})
local Url = require(CorePackages.Workspace.Packages.Http).Url
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Cryo = require(CorePackages.Packages.Cryo)

function GetReferralRewardTooltipInfo() -- line: 19
	-- upvalues: Url (copy), v5 (copy)
	local v12 = Url:makeQueryString({
		UniverseId = game.GameId
	})
	local v13 = string.format("%sreferral-reward-metadata/v1/get-reward-metadata?%s", Url.APIS_URL, v12)

	return v5(v13, "GET")
end
function withReferralRewardTooltipInfo(p4) -- line: 27
	-- upvalues: Cryo (copy), React (copy), useLocalization (copy)
	return function(p5) -- line: 28
		-- upvalues: Cryo (copy), React (copy), useLocalization (copy), p4 (copy)
		local v16 = Cryo.Dictionary.join(p5, {
			referralRewardTooltipText = ""
		})
		local v17, v18 = React.useState("")

		React.useEffect(function() -- line: 33
			-- upvalues: v18 (copy)
			GetReferralRewardTooltipInfo():andThen(function(p6) -- line: 34
				-- upvalues: v18 (copy)
				if p6 and (p6.responseBody and p6.responseBody.name) then
					v18(p6.responseBody.name)
					task.delay(4, function() -- line: 37
						-- upvalues: v18 (copy)
						v18("")
					end)
				end
			end):catch(function(p7) -- line: 41
				warn(p7)
			end)
		end, {})

		local v19 = useLocalization({
			referralRewardTooltipText = {
				"CoreScripts.TopBar.RobloxMenuReferralRewardTooltip",
				referralRewardName = v17
			}
		})

		if v17 ~= "" then
			v16 = Cryo.Dictionary.join(v16, {
				referralRewardTooltipText = v19.referralRewardTooltipText
			})
		end

		return React.createElement(p4, v16)
	end
end

return withReferralRewardTooltipInfo
