local module = require("@luauforge/deferred/hnp")
local context = require("@luauforge/deferred/hmD").SocialLibraries.Context

return {
	Class = require("@luauforge/deferred/hnq"),
	Context = module,
	connect = context.getConnect(module),
	with = context.getWith(module)
}
