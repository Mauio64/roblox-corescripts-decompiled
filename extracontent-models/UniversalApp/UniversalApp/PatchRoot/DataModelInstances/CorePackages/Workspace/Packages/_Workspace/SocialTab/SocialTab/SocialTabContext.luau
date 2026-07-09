local SocialTab = script:FindFirstAncestor("SocialTab")
local Context = require(script.Context)
local Context2 = require(SocialTab.dependencies).SocialLibraries.Context

return {
	Context = Context,
	Provider = Context.Provider,
	Consumer = Context.Consumer,
	with = Context2.getWith(Context),
	connect = Context2.getConnect(Context)
}
