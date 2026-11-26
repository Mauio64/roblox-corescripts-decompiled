local module = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/useClientCacheFallbackBannerConfig")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/Signals")
local gameSortLoadSource = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/Utils").GameSortLoadSource

return {
	ClientCacheFallbackBanner = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/ClientCacheFallbackBanner"),
	useClientCacheFallbackBannerConfig = module,
	Signals = module2,
	GameSortLoadSource = gameSortLoadSource
}
