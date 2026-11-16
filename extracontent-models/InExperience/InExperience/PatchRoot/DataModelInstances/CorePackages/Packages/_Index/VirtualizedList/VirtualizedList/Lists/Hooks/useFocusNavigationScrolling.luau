local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

require(script.Parent.Parent.FlatList)

local function useFocusNavigationScrolling(data)
	local v = not data.cellRendererKey and "CellRendererView" or data.cellRendererKey
	local v2 = not data.initialIndex and 1 or data.initialIndex
	local listRef = data.listRef
	local onSelectedIndexChanged = data.onSelectedIndexChanged
	local viewOffset = data.viewOffset
	local animated = data.animated == nil or data.animated
	local ref = React.useRef(v2)
	local data2 = data.data

	local v3 = React.useCallback(function(p)
		local offset = p.index * p.averageItemLength

		if listRef and listRef.current then
			listRef.current:scrollToOffset({ offset = offset })
		else
			warn("Animated scrolling failed, the ref to the ScrollView is nil.This could indicate that you are selecting focus before the ScrollView has mounted.")
		end
	end, { listRef })

	return React.useCallback(function(ancestor, _, _, instance): nil
		if not (instance and instance:IsDescendantOf(ancestor)) then
			return nil
		end

		local firstAncestor = instance:FindFirstAncestor(v)

		if not (firstAncestor and firstAncestor.LayoutOrder) then
			return nil
		end

		if
			firstAncestor.LayoutOrder == ref.current
			or firstAncestor.LayoutOrder > #data2
			or firstAncestor.LayoutOrder < 1
		then
			return nil
		end

		ref.current = firstAncestor.LayoutOrder

		if onSelectedIndexChanged then
			onSelectedIndexChanged(ref.current)
		end

		if listRef and listRef.current then
			listRef.current:scrollToIndex({
				index = ref.current,
				animated = animated,
				viewOffset = viewOffset
			})
		else
			return nil
		end

		return nil
	end, { listRef, ref, v, onSelectedIndexChanged, animated, viewOffset, data2 }), v3
end

return useFocusNavigationScrolling
