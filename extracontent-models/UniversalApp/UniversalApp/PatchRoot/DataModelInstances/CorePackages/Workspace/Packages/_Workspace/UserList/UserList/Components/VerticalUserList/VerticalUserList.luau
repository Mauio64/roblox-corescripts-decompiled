local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local View = require(UserListParent.Foundation).View
local FlatList = require(UserListParent.VirtualizedList).FlatList

require(UserList.Common.Types)

local Enums = require(UserList.Common.Enums)
local useEntities = require(UserList.Hooks.useEntities)
local useEntitySelectionHandler = require(UserList.Hooks.useEntitySelectionHandler)
local useRenderEntity = require(UserList.Hooks.useRenderEntity)
local t1 = {
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = 0
}
local t2 = {
	BackgroundTransparency = 1
}

local function keyExtractor(p1, _) -- line: 52
	return p1
end
local function VerticalUserList(t3: {[any]: any}) -- line: 56
	-- upvalues: useEntities (copy), useEntitySelectionHandler (copy), React (copy), useRenderEntity (copy), Enums (copy), View (copy), FlatList (copy), keyExtractor (copy), t1 (copy), t2 (copy)
	local v17 = useEntities(t3.entities)
	local v18 = useEntitySelectionHandler(t3.onRowSelected)
	local v19 = React.useMemo(function() -- line: 61
		-- upvalues: t3 (copy)
		if t3.initialRowCount and t3.initialRowCount < #t3.entities then
			local t4 = {}

			for i = 1, t3.initialRowCount do
				table.insert(t4, t3.entities[i])
			end

			return t4
		end

		return t3.entities
	end, {
		t3.entities,
		t3.initialRowCount
	})
	local v20 = React.useMemo(function() -- line: 73
		-- upvalues: v19 (copy)
		local t5 = {}

		for _, v27 in v19 do
			table.insert(t5, v27.id)
		end

		return t5
	end, { v19 })
	local v21 = useRenderEntity({
		entitiesMap = v17.entitiesMap,
		onActivated = v18,
		renderRow = t3.renderRow,
		configs = t3.configs,
		layoutMode = Enums.LayoutMode.Vertical
	})
	local v22 = React.useCallback(function(p3) -- line: 90
		-- upvalues: v21 (copy)
		return v21(p3.item, p3.index)
	end, { v21 })

	if #t3.entities == 0 then
		return nil
	end

	if t3.isScrollEnabled then
		return React.createElement(View, {
			tag = "size-full-0 fill",
			LayoutOrder = t3.layoutOrder
		}, {
			List = React.createElement(FlatList, {
				windowSize = 3,
				initialNumToRender = 10,
				onEndReachedThreshold = 2,
				data = v20,
				renderItem = v22,
				keyExtractor = keyExtractor,
				style = t1,
				contentContainerStyle = t2,
				ListHeaderComponent = t3.ListHeaderComponent,
				ListFooterComponent = t3.ListFooterComponent
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-xxsmall",
		LayoutOrder = t3.layoutOrder
	}, {
		EntityRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function() -- line: 127
			-- upvalues: v20 (copy), React (copy), View (copy), v21 (copy)
			local t6 = {}

			for i, v in ipairs(v20) do
				t6[i] = React.createElement(View, {
					tag = "size-full-0 auto-y",
					key = v,
					LayoutOrder = i
				}, {
					Content = v21(v, i)
				})
			end

			return t6
		end, {
			v20,
			v21
		})))
	})
end

return VerticalUserList
