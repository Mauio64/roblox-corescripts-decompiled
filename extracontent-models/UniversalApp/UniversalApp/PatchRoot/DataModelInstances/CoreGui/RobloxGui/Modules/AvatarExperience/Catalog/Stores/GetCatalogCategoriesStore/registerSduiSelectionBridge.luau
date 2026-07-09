local function registerSduiSelectionBridge(t1: {[any]: any}, t2: {[any]: any}) -- line: 25
	t1.register("MonolithCatalogSelectionStore", {
		selectCategory = function(s1: string) -- line: 30
			-- upvalues: t2 (copy)
			t2.changeCategory(s1, nil)
		end,
		selectSubcategory = function(s2: string) -- line: 33
			-- upvalues: t2 (copy)
			t2.changeCategory(nil, s2)
		end
	})

	return function() -- line: 38
		-- upvalues: t1 (copy)
		t1.unregister("MonolithCatalogSelectionStore")
	end
end

return registerSduiSelectionBridge
