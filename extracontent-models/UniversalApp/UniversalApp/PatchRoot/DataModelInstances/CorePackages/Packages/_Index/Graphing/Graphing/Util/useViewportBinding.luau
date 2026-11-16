local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local CanvasContext = require(Graphing.CanvasContext)
require(Graphing.Types)
local UseViewportBinding = {}

function UseViewportBinding.useViewportBinding(callback, items)
	local v = React.useContext(CanvasContext)
	local viewportRectGetter = v.viewportRectGetter

	local v2 = { viewportRectGetter }

	if items then
		for _, item in items do
			table.insert(v2, item)
		end
	end

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			viewportRectGetter(p)
			return callback(v)
		end)
	end, v2)

	return SignalsReact.useSignalBinding(v3)
end

function UseViewportBinding.useViewportVisibility(callback, items)
	local v = React.useContext(CanvasContext)
	local viewportRectGetter = v.viewportRectGetter

	local v2 = { viewportRectGetter }

	if items then
		for _, item in items do
			table.insert(v2, item)
		end
	end

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			viewportRectGetter(p)
			return callback(v)
		end)
	end, v2)

	return SignalsReact.useSignalState(v3)
end

return UseViewportBinding
