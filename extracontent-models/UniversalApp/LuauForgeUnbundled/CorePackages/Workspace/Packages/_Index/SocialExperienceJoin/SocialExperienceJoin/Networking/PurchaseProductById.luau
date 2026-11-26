local url = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Http").Url

return require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Networking/myRoduxNetworking").POST("PurchaseProductById", function(callback, p2, options)
	return callback(url.ECONOMY_URL):path("v1"):path("purchases"):path("products"):id(p2):body(options or {})
end)
