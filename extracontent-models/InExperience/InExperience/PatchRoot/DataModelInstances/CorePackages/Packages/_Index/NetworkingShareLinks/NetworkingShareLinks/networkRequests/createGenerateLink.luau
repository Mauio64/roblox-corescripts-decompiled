local SHARELINKS_URL = require(script.Parent.Parent.SHARELINKS_URL)

require(script.Parent.Parent.networkingShareLinkTypes)

local Packages = script:FindFirstAncestor("Packages")
local tutils = require(Packages.tutils)
local HttpService = game:GetService("HttpService")

return function(p1) -- line: 9
	-- upvalues: tutils (copy), SHARELINKS_URL (copy), HttpService (copy)
	local v6 = p1.roduxNetworking.POST({
		Name = "create-link"
	}, function(p2, p3) -- line: 14
		-- upvalues: tutils (copy), SHARELINKS_URL (copy), HttpService (copy)
		local v9 = tutils.deepCopy(p3)

		v9.linkType = nil

		return p2(SHARELINKS_URL):path("v1"):path("create-link"):body({
			linkType = p3.linkType,
			data = if next(v9) == nil then nil else HttpService:JSONEncode(v9)
		})
	end)

	if p1.useMockedResponse then
		v6.Mock.clear()
		v6.Mock.reply(function() -- line: 27
			return {
				responseBody = {
					linkId = "42685"
				}
			}
		end)
	end

	return v6
end
