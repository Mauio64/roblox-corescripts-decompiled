local Parent = script:FindFirstAncestor("SocialLinksRodux").Parent
local Rodux = require(Parent.Rodux)
local Cryo = require(Parent.Cryo)
local FFlagProfileEnableSocialNetworksUsernames = require(Parent.SharedFlags).FFlagProfileEnableSocialNetworksUsernames
local t1 = {
	"facebook",
	"twitter",
	"youtube",
	"twitch",
	"guilded"
}

return function(p1) -- line: 51
	-- upvalues: Rodux (copy), FFlagProfileEnableSocialNetworksUsernames (copy), Cryo (copy), t1 (copy)
	local SocialLinksNetworking = p1.SocialLinksNetworking

	return Rodux.createReducer({}, {
		[SocialLinksNetworking.GetSocialLinks.Succeeded.name] = function(p2, p3) -- line: 55
			-- upvalues: FFlagProfileEnableSocialNetworksUsernames (copy), Cryo (copy), t1 (copy)
			local str = tostring(p3.namedIds.users)

			if FFlagProfileEnableSocialNetworksUsernames then
				local t2 = {}

				if p3.queryArgs.alwaysReturnUrls then
					Cryo.List.map(t1, function(p4) -- line: 60
						-- upvalues: t2 (copy), p3 (copy), p2 (copy), str (copy)
						t2[p4] = {
							url = p3.responseBody[p4],
							username = if not p2[str] then nil else p2[str][p4].username
						}
					end)
				else
					Cryo.List.map(t1, function(p5) -- line: 67
						-- upvalues: t2 (copy), p2 (copy), str (copy), p3 (copy)
						t2[p5] = {
							url = if not p2[str] then nil else p2[str][p5].url,
							username = p3.responseBody[p5]
						}
					end)
				end

				return Cryo.Dictionary.union(p2, {
					[str] = t2
				})
			end

			return Cryo.Dictionary.join(p2, {
				[str] = p3.responseBody
			})
		end
	})
end
