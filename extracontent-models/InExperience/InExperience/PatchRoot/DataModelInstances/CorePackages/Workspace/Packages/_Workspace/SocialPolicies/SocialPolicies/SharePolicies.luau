local ParentParent = script.Parent.Parent
local isSubjectToDesktopPolicies = require(ParentParent.SharedFlags).isSubjectToDesktopPolicies

local function SharePolicies(p1) -- line: 5
	-- upvalues: isSubjectToDesktopPolicies (copy)
	return {
		getAccountProviderName = function() -- line: 7
			-- upvalues: p1 (copy)
			return p1.AccountProviderName or ""
		end,
		shouldShowGameDetailsShareButton = function() -- line: 10
			-- upvalues: isSubjectToDesktopPolicies (copy), p1 (copy)
			if isSubjectToDesktopPolicies() then
				return false
			end

			return p1.GameDetailsShareButton or false
		end,
		shouldShowCatalogShareButton = function() -- line: 17
			-- upvalues: isSubjectToDesktopPolicies (copy), p1 (copy)
			if isSubjectToDesktopPolicies() then
				return false
			end

			return p1.CatalogShareButton or false
		end,
		shouldShareToAccountProvider = function() -- line: 24
			-- upvalues: p1 (copy)
			return p1.ShareToAccountProvider or false
		end,
		shouldInviteFromAccountProvider = function() -- line: 27
			-- upvalues: p1 (copy)
			return p1.InviteFromAccountProvider or false
		end,
		getShareToAccountProviderTimeout = function() -- line: 30
			-- upvalues: p1 (copy)
			return p1.ShareToAccountProviderTimeout or 5
		end
	}
end

return SharePolicies
