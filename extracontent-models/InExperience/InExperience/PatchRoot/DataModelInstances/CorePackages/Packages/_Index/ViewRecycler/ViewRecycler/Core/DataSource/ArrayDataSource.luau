local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Types)

local KeyUtils = require(script.Parent.KeyUtils)

local function fn() end

local function createArrayDataSource(p, callback)
	local clone = table.clone(p)
	local keysFor = KeyUtils.keysFor(clone, callback)
	return {
		getItemCount = function()
			return #clone
		end,
		getItem = function(p2)
			return clone[p2]
		end,
		getItemKey = function(p2)
			return keysFor[p2]
		end,
		getItems = function(p2, p3)
			return table.move(clone, p2, p3, 1, {})
		end,
		subscribe = function(_)
			return fn
		end
	}
end

return createArrayDataSource
