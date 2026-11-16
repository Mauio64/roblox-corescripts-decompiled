local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

require(ViewRecyclerReact.Parent.React)
require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
require(ViewRecyclerReact.Parent.Signals)

local object = setmetatable({}, { __mode = "k" })
local RecyclableViewRegistry = {}

function RecyclableViewRegistry.register(callback, p)
	object[callback] = p
end

function RecyclableViewRegistry.isRegistered(p): boolean
	return object[p] ~= nil
end

function RecyclableViewRegistry.getMetadata(callback)
	return object[callback]
end

return RecyclableViewRegistry
