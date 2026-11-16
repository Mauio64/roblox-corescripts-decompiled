local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

require(ViewRecyclerReact.ReactAdapter.Private.CompositionPlacement)
require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)
local Signals = require(ViewRecyclerReact.Parent.Signals)

local function selectViewType(callback, callback2)
	if type(callback) == "function" then
		return Signals.createComputed(function(p)
			return callback2(callback(p))
		end)
	end

	local v = callback2(callback)
	return function(_)
		return v
	end
end

return selectViewType
