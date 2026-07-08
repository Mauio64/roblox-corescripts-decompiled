local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Context = dependencies.SocialLibraries.Context
local React = dependencies.React
local Context2 = require(script.Context)

return {
	Context = Context2,
	Provider = Context2.Provider,
	Consumer = Context2.Consumer,
	with = Context.getWith(Context2),
	connect = Context.getConnect(Context2),
	useContext = function() -- line: 14
		-- upvalues: React (copy), Context2 (copy)
		return (React.useContext(Context2))
	end
}
