local module = require("@luauforge/deferred/hcL")
local context = require("@luauforge/deferred/hbU").SocialLibraries.Context

return {
	Context = module,
	Provider = module.Provider,
	Consumer = module.Consumer,
	with = context.getWith(module),
	connect = context.getConnect(module)
}
