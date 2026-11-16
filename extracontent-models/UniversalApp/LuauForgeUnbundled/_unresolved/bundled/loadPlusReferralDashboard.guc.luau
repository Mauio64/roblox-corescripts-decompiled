local module = require("@luauforge/bundled/gtY")
local module2 = require("@luauforge/bundled/gub")
local module3 = require("@luauforge/bundled/gud")
local module4 = require("@luauforge/bundled/guh")

local function fetchBenefits(p2)
	module3():andThen(function(p3)
		p2.setBenefits(p3)
	end):catch(function() end)
end

local function loadPlusReferralDashboard()
	local v5 = module.get()
	local screenLoadStatus = v5.getScreenLoadStatus(false)

	if screenLoadStatus == module2.Loading or screenLoadStatus == module2.Ready then
		if v5.getBenefits(false) == nil and screenLoadStatus == module2.Ready then
			fetchBenefits(v5)
		end
	else
		v5.setScreenLoadStatus(module2.Loading)

		local Players = game:GetService("Players")
		local localPlayer = Players.LocalPlayer
		local userId = if localPlayer then tostring(localPlayer.UserId) else nil

		module4():andThen(function(p2)
			v5.setShareUrl(p2.deepLinkUrl)
			v5.setAnalyticsMetadata({
				referrerId = userId,
				referralCode = p2.deepLinkUrl
			})

			v5.setScreenLoadStatus(module2.Ready)
		end):catch(function()
			v5.setShareUrl(nil)
			v5.setScreenLoadStatus(module2.Invalid)
		end)

		fetchBenefits(v5)
	end
end

return loadPlusReferralDashboard
