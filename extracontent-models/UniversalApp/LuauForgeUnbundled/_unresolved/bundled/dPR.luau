local logging = require("@luauforge/bundled/dPS").Logging

local v5 = nil

local v6 = {}

return {
	register = function(p2, p3)
		v5 = { ownerId = p2, handlers = p3 }
	end,
	unregister = function(p2)
		if v5 and v5.ownerId == p2 then
			v5 = nil
		end
	end,
	registerFocusedSortHandler = function(p2, p3)
		for k, v7 in v6 do
			if v7.ownerId == p2 then
				v6[k] = { ownerId = p2, handler = p3 }
				return
			end
		end

		table.insert(v6, { ownerId = p2, handler = p3 })
	end,
	unregisterFocusedSortHandler = function(p2)
		for k, v7 in v6 do
			if v7.ownerId == p2 then
				table.remove(v6, k)
				break
			end
		end
	end,
	selectCategory = function(p2)
		if v5 and v5.handlers then
			v5.handlers.selectCategory(p2)
		end
	end,
	selectSubcategory = function(p2)
		if v5 and v5.handlers then
			v5.handlers.selectSubcategory(p2)
		end
	end,
	requestFocusedSort = function(p2)
		local v7 = v6[#v6]

		if v7 then
			v7.handler(p2)
		else
			logging.warn("MarketplaceCatalogSduiSelectionBridge.requestFocusedSort: " .. "no focused-sort handler registered for sortId=" .. tostring(p2 and p2.sortId) .. "; SDUI See All button will appear dead.")
		end
	end
}
