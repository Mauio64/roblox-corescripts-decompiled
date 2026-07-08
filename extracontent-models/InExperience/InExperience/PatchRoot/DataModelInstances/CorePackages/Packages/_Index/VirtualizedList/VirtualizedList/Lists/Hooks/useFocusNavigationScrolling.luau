local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)

require(script.Parent.Parent.FlatList)

local function useFocusNavigationScrolling(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy)
	local v5 = not t1.cellRendererKey and "CellRendererView" or t1.cellRendererKey
	local v6 = not t1.initialIndex and 1 or t1.initialIndex
	local listRef = t1.listRef
	local onSelectedIndexChanged = t1.onSelectedIndexChanged
	local viewOffset = t1.viewOffset
	local v10 = t1.animated == nil or t1.animated
	local v11 = React.useRef(v6)
	local data = t1.data
	local v13 = React.useCallback(function(t2: {[any]: any}) -- line: 50
		-- upvalues: listRef (copy)
		local v15 = t2.index * t2.averageItemLength

		if listRef and listRef.current then
			listRef.current:scrollToOffset({
				offset = v15
			})

			return
		end

		warn("Animated scrolling failed, the ref to the ScrollView is nil.This could indicate that you are selecting focus before the ScrollView has mounted.")
	end, { listRef })

	return React.useCallback(function(p1, _, _, p4) -- line: 64
		-- upvalues: v5 (copy), v11 (copy), data (copy), onSelectedIndexChanged (copy), listRef (copy), v10 (copy), viewOffset (copy)
		if p4 and p4:IsDescendantOf(p1) then
			local v20 = p4:FindFirstAncestor(v5)

			if not v20 or not v20.LayoutOrder then
				return nil
			end

			if v20.LayoutOrder == v11.current or v20.LayoutOrder > #data or v20.LayoutOrder < 1 then
				return nil
			end

			v11.current = v20.LayoutOrder

			if onSelectedIndexChanged then
				onSelectedIndexChanged(v11.current)
			end

			if not listRef or not listRef.current then
				return nil
			end

			listRef.current:scrollToIndex({
				index = v11.current,
				animated = v10,
				viewOffset = viewOffset
			})
		end

		return nil
	end, {
		listRef,
		v11,
		v5,
		onSelectedIndexChanged,
		v10,
		viewOffset,
		data
	}), v13
end

return useFocusNavigationScrolling
