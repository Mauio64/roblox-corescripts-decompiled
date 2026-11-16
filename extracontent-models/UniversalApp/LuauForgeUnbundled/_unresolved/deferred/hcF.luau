local module = require("@luauforge/deferred/hcG")
local context = require("@luauforge/deferred/hbU").SocialLibraries.Context

return {
	Class = require("@luauforge/deferred/hcH"),
	Context = module,
	connect = context.getConnect(module),
	with = context.getWith(module)
}
