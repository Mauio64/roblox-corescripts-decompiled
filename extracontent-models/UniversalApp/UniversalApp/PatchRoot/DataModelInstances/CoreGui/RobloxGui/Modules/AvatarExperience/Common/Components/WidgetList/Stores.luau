local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local createFetchMarketplaceStore = require(script.createFetchMarketplaceStore)

return {
	getFetchMarketplaceStore = Signals.createComputed(createFetchMarketplaceStore)
}
