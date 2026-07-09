local Parent = script:FindFirstAncestor("AffiliateLinks").Parent
local Url = require(Parent.Http).Url

require(Parent.Http)

return {
	resolveReferralCode = function(p1, s1: string) -- line: 12
		-- upvalues: Url (copy)
		local v5 = Url:makeQueryString({
			referralCode = s1
		})

		return p1(string.format("%saffiliate-links/v1/links/resolve?%s", Url.APIS_URL, v5), "GET")
	end
}
