local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local SafeFlags = require(parent.SafeFlags)
local Object = LuauPolyfill.Object

local v = SafeFlags.createGetFFlag("MemoizeVirtualizedListContext")()

local React = require(parent.React)
local useMemo = React.useMemo
local useContext = React.useContext

local context = React.createContext(nil)
local VirtualizedListContext = {}
VirtualizedListContext.VirtualizedListContext = context

if _G.__DEV__ then
	context.displayName = "VirtualizedListContext"
end

function VirtualizedListContext.VirtualizedListContextResetter(p)
	local children = p.children
	return React.createElement(context.Provider, { value = nil }, children)
end

function VirtualizedListContext.VirtualizedListContextProvider(p)
	local children = p.children
	local value = p.value

	local v2 = useMemo(function()
		return {
			cellKey = nil,
			getScrollMetrics = value.getScrollMetrics,
			horizontal = value.horizontal,
			getOutermostParentListRef = value.getOutermostParentListRef,
			getNestedChildState = value.getNestedChildState,
			registerAsNestedChild = value.registerAsNestedChild,
			unregisterAsNestedChild = value.unregisterAsNestedChild,
			debugInfo = {
				cellKey = value.debugInfo.cellKey,
				horizontal = value.debugInfo.horizontal,
				listKey = value.debugInfo.listKey,
				parent = value.debugInfo.parent
			}
		}
	end, {
		value.getScrollMetrics,
		value.horizontal,
		value.getOutermostParentListRef,
		value.getNestedChildState,
		value.registerAsNestedChild,
		value.unregisterAsNestedChild,
		value.debugInfo.cellKey,
		value.debugInfo.horizontal,
		value.debugInfo.listKey,
		value.debugInfo.parent
	})

	return React.createElement(context.Provider, { value = v2 }, children)
end

function VirtualizedListContext.VirtualizedListCellContextProvider(p)
	local cellKey = p.cellKey
	local children = p.children
	local v2 = useContext(context)
	local v3

	if v then
		v3 = useMemo(function()
			if v2 == nil then
				return nil
			end

			return (Object.assign(table.clone(v2), { cellKey = cellKey }))
		end, { v2, cellKey })
	end

	local createElement = React.createElement
	local provider = context.Provider

	if not v then
		if v2 == nil then
			v3 = nil
		else
			v3 = Object.assign(table.clone(v2), { cellKey = cellKey })
		end
	end

	return createElement(provider, { value = v3 }, children)
end

return VirtualizedListContext
