local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local context = dependencies.SocialLibraries.Context
local react = dependencies.React

local Context = require(script.Context)

return {
	Context = Context,
	Provider = Context.Provider,
	Consumer = Context.Consumer,
	with = context.getWith(Context),
	connect = context.getConnect(Context),
	useContext = function()
		return (react.useContext(Context))
	end
}
