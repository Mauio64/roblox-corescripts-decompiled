local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Types)
local createEvent = require(ViewRecycler.Internal.createEvent)
local readDenseRange = require(script.Parent.readDenseRange)

local function createTranslatedDataSource(getItemCount, getItem, getItemKey, callback)
	local event = createEvent()
	local v = 0
	local v2 = nil

	return {
		getItemCount = getItemCount,
		getItem = getItem,
		getItemKey = getItemKey,
		getItems = function(p, p2)
			return readDenseRange(getItemCount(), getItem, p, p2)
		end,
		subscribe = function(callback2)
			if v == 0 then
				v2 = callback(event.fire)
			end

			v += 1
			local v3 = event.connect(callback2)
			local v4 = true
			return function()
				if not v4 then
					return
				end

				v4 = false
				v3()
				v -= 1

				if v == 0 and v2 ~= nil then
					v2()
					v2 = nil
				end
			end
		end
	}
end

return createTranslatedDataSource
