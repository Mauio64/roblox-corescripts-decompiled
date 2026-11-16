local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialPolicies/SharedFlags").isSubjectToDesktopPolicies

local function SharePolicies(data)
	return {
		getAccountProviderName = function()
			return data.AccountProviderName or ""
		end,
		shouldShowGameDetailsShareButton = function()
			if isSubjectToDesktopPolicies() then
				return false
			end

			return data.GameDetailsShareButton or false
		end,
		shouldShowCatalogShareButton = function()
			if isSubjectToDesktopPolicies() then
				return false
			end

			return data.CatalogShareButton or false
		end,
		shouldShareToAccountProvider = function()
			return data.ShareToAccountProvider or false
		end,
		shouldInviteFromAccountProvider = function()
			return data.InviteFromAccountProvider or false
		end,
		getShareToAccountProviderTimeout = function()
			return data.ShareToAccountProviderTimeout or 5
		end
	}
end

return SharePolicies
