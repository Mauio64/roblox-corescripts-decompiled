local ParentParent = script.Parent.Parent
local CollectionViews = require(ParentParent.CollectionViews)
local Display = require(ParentParent.Display)
local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore

local function pinViewportForLayout(vector2: Vector2) -- line: 25
	-- upvalues: getMainCollectionLayoutStore (copy), Display (copy)
	if getMainCollectionLayoutStore then
		getMainCollectionLayoutStore(false).setDefaultContentRegionWidth(vector2.X)
	end

	local getDesignSpaceViewportWidth = nil
	local v8 = Display.GetDisplayStore(false)
	local getViewportSize = v8.getViewportSize

	function v8.getViewportSize(_) -- line: 34
		-- upvalues: vector2 (copy)
		return vector2
	end

	if v8.getDesignSpaceViewportWidth then
		getDesignSpaceViewportWidth = v8.getDesignSpaceViewportWidth

		function v8.getDesignSpaceViewportWidth(_) -- line: 40
			-- upvalues: vector2 (copy)
			return vector2.X
		end
	end

	return function() -- line: 45
		-- upvalues: getMainCollectionLayoutStore (copy), v8 (copy), getViewportSize (copy), getDesignSpaceViewportWidth (ref)
		if getMainCollectionLayoutStore then
			getMainCollectionLayoutStore(false).setDefaultContentRegionWidth(nil)
		end

		if v8 then
			v8.getViewportSize = getViewportSize

			if getDesignSpaceViewportWidth then
				v8.getDesignSpaceViewportWidth = getDesignSpaceViewportWidth
			end
		end
	end
end

return pinViewportForLayout
