local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.Parent.React)
local Renderers = {}

function Renderers.byState(callback, options)
	return {
		type = "byState",
		callback = callback,
		config = options or {}
	}
end

function Renderers.byBinding(callback)
	return { type = "byBinding", callback = callback }
end

return Renderers
