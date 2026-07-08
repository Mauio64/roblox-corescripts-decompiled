local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local React = require(ParentParent.React)
local useMemo = React.useMemo
local useContext = React.useContext
local t1 = {}
local v7 = React.createContext(nil)

t1.VirtualizedListContext = v7

if _G.__DEV__ then
	v7.displayName = "VirtualizedListContext"
end

function t1.VirtualizedListContextResetter(t2: {[any]: any}) -- line: 96
	-- upvalues: React (copy), v7 (copy)
	local children = t2.children

	return React.createElement(v7.Provider, {
		value = nil
	}, children)
end
function t1.VirtualizedListContextProvider(t3: {[any]: any}) -- line: 109
	-- upvalues: useMemo (copy), React (copy), v7 (copy)
	local children = t3.children
	local value = t3.value
	local v13 = useMemo(function() -- line: 116
		-- upvalues: value (copy)
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

	return React.createElement(v7.Provider, {
		value = v13
	}, children)
end
function t1.VirtualizedListCellContextProvider(t4: {[any]: any}) -- line: 156
	-- upvalues: useContext (copy), v7 (copy), React (copy), Object (copy)
	local cellKey = t4.cellKey
	local children = t4.children
	local v17 = useContext(v7)

	return React.createElement(v7.Provider, {
		value = if v17 ~= nil then Object.assign(table.clone(v17), {
			cellKey = cellKey
		}) else nil
	}, children)
end

return t1
