local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2, p3) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p2, "string", "premiumUpsellCancelled event expects assetId")
	ArgCheck.isType(p3, "boolean", "premiumUpsellCancelled event expects isBundle")
	p1:sendTelemetryEvent("PremiumUpsell", not p3 and "AssetPremiumUpsellCanceled" or "BundlePremiumUpsellCanceled", {
		Location = "Catalog",
		BundleID = p2
	})
end
