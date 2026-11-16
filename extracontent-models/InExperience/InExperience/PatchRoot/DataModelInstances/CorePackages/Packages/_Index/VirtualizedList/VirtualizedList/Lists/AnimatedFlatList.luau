local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local FlatList = require(script.Parent.FlatList)

local Hooks = require(script.Parent.Hooks)
local useFocusNavigationScrolling = Hooks.useFocusNavigationScrolling

local function AnimatedFlatList(props)
	local ref = React.useRef(nil)
	local onSelectionChanged, onScrollToIndexFailed = useFocusNavigationScrolling({
		listRef = props.listRef or ref,
		onSelectedIndexChanged = props.onSelectedIndexChanged,
		initialIndex = props.initialScrollIndex,
		cellRendererKey = props.cellRendererKey,
		viewOffset = props.viewOffset,
		animated = props.animated,
		data = props.data
	})

	local assign = Object.assign
	local clone = table.clone(props)
	local v = {
		viewOffset = Object.None,
		animated = Object.None,
		onSelectedIndexChanged = Object.None,
		ref = props.listRef or ref,
		onScrollToIndexFailed = 0,
		onSelectionChanged = 0
	}

	if props.getItemLayout then
		onScrollToIndexFailed = nil
	end

	v.onScrollToIndexFailed = onScrollToIndexFailed
	v.onSelectionChanged = onSelectionChanged
	local v2 = assign(clone, v)

	return React.createElement(FlatList, v2)
end

return AnimatedFlatList
