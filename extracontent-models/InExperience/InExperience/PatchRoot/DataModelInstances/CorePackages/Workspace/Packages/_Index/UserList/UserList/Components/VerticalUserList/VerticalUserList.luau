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
local FFlagUserListCtaIntegrationEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaIntegrationEnabled
local v11 = if not FFlagUserListCtaIntegrationEnabled then nil else require(UserList.Cta)
local t1 = {
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = 0
}
local t2 = {
	BackgroundTransparency = 1
}

local function keyExtractor(p1, _) -- line: 58
	return p1
end
local function VerticalUserList(t3: {[any]: any}) -- line: 62
	-- upvalues: useEntities (copy), useEntitySelectionHandler (copy), React (copy), useRenderEntity (copy), Enums (copy), View (copy), FlatList (copy), keyExtractor (copy), t1 (copy), t2 (copy)
	local v20 = useEntities(t3.entities)
	local v21 = useEntitySelectionHandler(t3.onRowSelected)
	local v22 = React.useMemo(function() -- line: 67
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
	local v23 = React.useMemo(function() -- line: 79
		-- upvalues: v22 (copy)
		local t5 = {}

		for _, v31 in v22 do
			table.insert(t5, v31.id)
		end

		return t5
	end, { v22 })
	local v24 = useRenderEntity({
		entitiesMap = v20.entitiesMap,
		onActivated = v21,
		renderRow = t3.renderRow,
		configs = t3.configs,
		layoutMode = Enums.LayoutMode.Vertical
	})
	local v25 = React.useCallback(function(p3) -- line: 96
		-- upvalues: v24 (copy)
		return v24(p3.item, p3.index)
	end, { v24 })

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
				data = v23,
				renderItem = v25,
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
		EntityRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function() -- line: 133
			-- upvalues: v23 (copy), React (copy), View (copy), v24 (copy)
			local t6 = {}

			for i, v in ipairs(v23) do
				t6[i] = React.createElement(View, {
					tag = "size-full-0 auto-y",
					key = v,
					LayoutOrder = i
				}, {
					Content = v24(v, i)
				})
			end

			return t6
		end, {
			v23,
			v24
		})))
	})
end
local function VerticalUserListWithCta(t7: {[any]: any}) -- line: 151
	-- upvalues: v11 (copy), React (copy), VerticalUserList (copy)
	if v11 ~= nil and (t7.ctaConfig ~= nil and t7.renderRow == nil) then
		return React.createElement(v11.CtaRenderRowBridge, {
			ctaConfig = t7.ctaConfig,
			render = function(p4) -- line: 157
				-- upvalues: t7 (copy), React (copy), VerticalUserList (copy)
				local v37 = table.clone(t7)

				v37.renderRow = p4

				return React.createElement(VerticalUserList, v37)
			end
		})
	end

	return React.createElement(VerticalUserList, t7)
end

if FFlagUserListCtaIntegrationEnabled then
	return VerticalUserListWithCta
end

return VerticalUserList
