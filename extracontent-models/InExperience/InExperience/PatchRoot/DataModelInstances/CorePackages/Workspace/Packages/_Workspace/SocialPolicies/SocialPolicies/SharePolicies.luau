local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function SharePolicies(data)
	return {
		getAccountProviderName = function()
			return data.AccountProviderName or ""
		end,
		shouldShowGameDetailsShareButton = function()
			return not isSubjectToDesktopPolicies() and (data.GameDetailsShareButton or false)
		end,
		shouldShowCatalogShareButton = function()
			return not isSubjectToDesktopPolicies() and (data.CatalogShareButton or false)
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
