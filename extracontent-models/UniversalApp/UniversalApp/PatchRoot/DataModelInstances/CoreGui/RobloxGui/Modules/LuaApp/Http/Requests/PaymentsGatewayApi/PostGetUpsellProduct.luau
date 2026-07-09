local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

require(CorePackages.Workspace.Packages.Http)

local function PostGetUpsellProduct(p1, p2, n1: number, n2: number, n3: number?, s1: string?, n4: number?) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	return p1(UrlBuilder.economy.paymentsGateway.getUpsellProduct(), "POST", {
		postBody = HttpService:JSONEncode({
			upsell_platform = p2,
			user_robux_balance = n1,
			attempt_robux_amount = n2,
			item_product_id = n3,
			item_name = s1,
			universe_id = n4
		})
	})
end

return PostGetUpsellProduct
