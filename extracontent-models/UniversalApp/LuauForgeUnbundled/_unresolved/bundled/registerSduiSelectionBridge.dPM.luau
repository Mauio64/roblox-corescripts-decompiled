local module = require("@luauforge/bundled/dPN")

local function registerSduiSelectionBridge(p2, p3)
	p2.register("MonolithCatalogSelectionStore", {
		selectCategory = function(p4)
			module(p3, p4, nil, { source = "SduiTap" })
		end,
		selectSubcategory = function(p4)
			module(p3, nil, p4, { source = "SduiTap" })
		end
	})

	return function()
		p2.unregister("MonolithCatalogSelectionStore")
	end
end

return registerSduiSelectionBridge
