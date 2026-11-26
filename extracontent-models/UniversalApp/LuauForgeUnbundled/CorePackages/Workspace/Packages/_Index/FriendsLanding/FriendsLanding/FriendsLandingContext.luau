local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local context = dependencies.SocialLibraries.Context
local react = dependencies.React

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext/Context")

return {
	Context = module2,
	Provider = module2.Provider,
	Consumer = module2.Consumer,
	with = context.getWith(module2),
	connect = context.getConnect(module2),
	useContext = function()
		return react.useContext(module2)
	end
}
