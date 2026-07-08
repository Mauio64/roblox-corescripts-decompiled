local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Object = require(ParentParent.LuauPolyfill).Object
local FlatList = require(script.Parent.FlatList)
local useFocusNavigationScrolling = require(script.Parent.Hooks).useFocusNavigationScrolling

local function AnimatedFlatList(p1) -- line: 38
	-- upvalues: React (copy), useFocusNavigationScrolling (copy), Object (copy), FlatList (copy)
	local v8 = React.useRef(nil)
	local v9, v10 = useFocusNavigationScrolling({
		listRef = p1.listRef or v8,
		onSelectedIndexChanged = p1.onSelectedIndexChanged,
		initialIndex = p1.initialScrollIndex,
		cellRendererKey = p1.cellRendererKey,
		viewOffset = p1.viewOffset,
		animated = p1.animated,
		data = p1.data
	})
	local v11 = Object.assign(table.clone(p1), {
		viewOffset = Object.None,
		animated = Object.None,
		onSelectedIndexChanged = Object.None,
		ref = p1.listRef or v8,
		onScrollToIndexFailed = if not p1.getItemLayout then v10 else nil,
		onSelectionChanged = v9
	})

	return React.createElement(FlatList, v11)
end

return AnimatedFlatList
