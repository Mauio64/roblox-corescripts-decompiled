local DiscoveryAppLaunchTracker = require(script.DiscoveryAppLaunchTracker)

return {
	["jest.config"] = script["jest.config"],
	DiscoveryAppLaunchTracker = DiscoveryAppLaunchTracker,
	Flags = require(script.Flags)
}
