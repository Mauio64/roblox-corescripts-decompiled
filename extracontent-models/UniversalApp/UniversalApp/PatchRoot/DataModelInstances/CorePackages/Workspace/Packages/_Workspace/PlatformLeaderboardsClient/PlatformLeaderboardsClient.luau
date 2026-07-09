local v1 = if not game:DefineFastFlag("PlatformLeaderboardEnabled_DEV", false) then nil else require(script.PlatformLeaderboardClientStore)

return {
	["jest.config"] = script["jest.config"],
	PlatformLeaderboardClientStore = v1
}
