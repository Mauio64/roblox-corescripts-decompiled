local scriptParent = script.Parent
local lazyRequire = require(scriptParent.LazyRequire).lazyRequire

if game:DefineFastFlag("LuaAppLazyRequireSocialLibsDeps", false) then
	return {
		CollisionMatchers = lazyRequire(scriptParent.CollisionMatchers),
		GenericPagination = lazyRequire(scriptParent.GenericPagination),
		httpRequest = lazyRequire(scriptParent.httpRequest),
		llama = lazyRequire(scriptParent.llama),
		Mock = lazyRequire(scriptParent.Mock),
		NetworkingAccountInformation = lazyRequire(scriptParent.NetworkingAccountInformation),
		NetworkingAccountSettings = lazyRequire(scriptParent.NetworkingAccountSettings),
		NetworkingAliases = lazyRequire(scriptParent.NetworkingAliases),
		NetworkingBlocking = lazyRequire(scriptParent.NetworkingBlocking),
		NetworkingCall = lazyRequire(scriptParent.NetworkingCall),
		NetworkingChat = lazyRequire(scriptParent.NetworkingChat),
		NetworkingContacts = lazyRequire(scriptParent.NetworkingContacts),
		NetworkingCurrentlyWearing = lazyRequire(scriptParent.NetworkingCurrentlyWearing),
		NetworkingGames = lazyRequire(scriptParent.NetworkingGames),
		NetworkingPremiumFeatures = lazyRequire(scriptParent.NetworkingPremiumFeatures),
		NetworkingPresence = lazyRequire(scriptParent.NetworkingPresence),
		NetworkingUsers = lazyRequire(scriptParent.NetworkingUsers),
		NetworkingUserSettings = lazyRequire(scriptParent.NetworkingUserSettings),
		RoactFitComponents = lazyRequire(scriptParent.RoactFitComponents),
		RoduxAliases = lazyRequire(scriptParent.RoduxAliases),
		RoduxCall = lazyRequire(scriptParent.RoduxCall),
		RoduxGames = lazyRequire(scriptParent.RoduxGames),
		RoduxNetworking = lazyRequire(scriptParent.RoduxNetworking),
		RoduxPresence = lazyRequire(scriptParent.RoduxPresence),
		RoduxUserPermissions = lazyRequire(scriptParent.RoduxUserPermissions),
		RoduxUsers = lazyRequire(scriptParent.RoduxUsers),
		SocialLibraries = lazyRequire(scriptParent.SocialLibraries)
	}
end

return {
	CollisionMatchers = require(scriptParent.CollisionMatchers),
	GenericPagination = require(scriptParent.GenericPagination),
	httpRequest = require(scriptParent.httpRequest),
	llama = require(scriptParent.llama),
	Mock = require(scriptParent.Mock),
	NetworkingAccountInformation = require(scriptParent.NetworkingAccountInformation),
	NetworkingAccountSettings = require(scriptParent.NetworkingAccountSettings),
	NetworkingAliases = require(scriptParent.NetworkingAliases),
	NetworkingBlocking = require(scriptParent.NetworkingBlocking),
	NetworkingCall = require(scriptParent.NetworkingCall),
	NetworkingChat = require(scriptParent.NetworkingChat),
	NetworkingContacts = require(scriptParent.NetworkingContacts),
	NetworkingCurrentlyWearing = require(scriptParent.NetworkingCurrentlyWearing),
	NetworkingGames = require(scriptParent.NetworkingGames),
	NetworkingPremiumFeatures = require(scriptParent.NetworkingPremiumFeatures),
	NetworkingPresence = require(scriptParent.NetworkingPresence),
	NetworkingUsers = require(scriptParent.NetworkingUsers),
	NetworkingUserSettings = require(scriptParent.NetworkingUserSettings),
	RoactFitComponents = require(scriptParent.RoactFitComponents),
	RoduxAliases = require(scriptParent.RoduxAliases),
	RoduxCall = require(scriptParent.RoduxCall),
	RoduxGames = require(scriptParent.RoduxGames),
	RoduxNetworking = require(scriptParent.RoduxNetworking),
	RoduxPresence = require(scriptParent.RoduxPresence),
	RoduxUserPermissions = require(scriptParent.RoduxUserPermissions),
	RoduxUsers = require(scriptParent.RoduxUsers),
	SocialLibraries = require(scriptParent.SocialLibraries)
}
