local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList
require(UserList.Common.Types)
local Enums = require(UserList.Common.Enums)

local useEntities = require(UserList.Hooks.useEntities)
local useEntitySelectionHandler = require(UserList.Hooks.useEntitySelectionHandler)
local useRenderEntity = require(UserList.Hooks.useRenderEntity)
local useFixedRowLayout = require(UserList.Hooks.useFixedRowLayout)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags2.FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require(UserList.Flags.FFlagUserListRowSelectionOriginSource)
local FFlagUserListDisableVirtualizationConfig = require(UserList.Flags.FFlagUserListDisableVirtualizationConfig)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListFixedRowHeightConfig = SharedFlags3.FFlagUserListFixedRowHeightConfig
local Cta

if FFlagUserListCtaIntegrationEnabled then
	Cta = require(UserList.Cta)
else
	Cta = nil
end

local v = { BackgroundTransparency = 1, ScrollBarThickness = 0, BorderSizePixel = 0 }

local joined = Cryo.Dictionary.join(v, { Selectable = false })

local contentContainerStyle = { BackgroundTransparency = 1 }

local function keyExtractor(p, _)
	return p
end

local function VerticalUserList(props)
	local v2 = useEntities(props.entities)

	local onRowSelected = props.onRowSelected
	local v3

	if FFlagUserListRowSelectionOriginSource then
		v3 = props.rowSelectionConfig
	end

	local onActivated = useEntitySelectionHandler(onRowSelected, v3)

	local v4 = React.useMemo(function()
		if not (props.initialRowCount and props.initialRowCount < #props.entities) then
			return props.entities
		end

		local result = {}

		for i = 1, props.initialRowCount do
			table.insert(result, props.entities[i])
		end

		return result
	end, { props.entities, props.initialRowCount })

	local v5 = React.useMemo(function()
		local ids = {}

		for _, v5 in v4 do
			table.insert(ids, v5.id)
		end

		return ids
	end, { v4 })

	local v6 = {
		entitiesMap = v2.entitiesMap,
		onActivated = onActivated,
		renderRow = props.renderRow,
		configs = props.configs,
		layoutMode = Enums.LayoutMode.Vertical,
		firstRowRef = 0
	}
	local firstRowRef

	if FFlagUserListSurfaceExtensions then
		firstRowRef = props.firstRowRef
	end

	v6.firstRowRef = firstRowRef
	local v7 = useRenderEntity(v6)
	local v8

	if FFlagUserListFixedRowHeightConfig then
		local v9

		if props.configs == nil then
			v9 = false
		else
			v9 = props.configs.fixedRowHeight == true
		end

		v8 = useFixedRowLayout(v9, props.ListHeaderComponent and true or false)
	else
		v8 = nil
	end

	local useCallback = React.useCallback
	local function fn(p)
		local item = p.item
		local index = p.index
		local v9

		if FFlagUserListFixedRowHeightConfig and v8 then
			v9 = v8.itemSize
		end

		return v7(item, index, v9)
	end

	local v9

	if FFlagUserListFixedRowHeightConfig then
		v9 = v8
	end

	local renderItem = useCallback(fn, { v7, v9 })

	if #props.entities == 0 then
		return nil
	end

	if not props.isScrollEnabled then
		return React.createElement(
			View,
			{ tag = "size-full-0 auto-y col gap-xxsmall", LayoutOrder = props.layoutOrder },
			{
				EntityRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function()
					local children = {}

					for i, v10 in ipairs(v5) do
						children[i] = React.createElement(
							View,
							{ key = v10, tag = "size-full-0 auto-y", LayoutOrder = i },
							{ Content = v7(v10, i) }
						)
					end

					return children
				end, { v5, v7 })))
			}
		)
	end

	local createElement = React.createElement
	local v10 = { tag = "size-full-0 fill", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v11 = {
		data = v5,
		renderItem = renderItem,
		keyExtractor = keyExtractor,
		windowSize = 3,
		initialNumToRender = 10,
		onEndReachedThreshold = 2,
		disableVirtualization = FFlagUserListDisableVirtualizationConfig and props.configs and props.configs.disableVirtualization and true or nil,
		getItemLayout = 0,
		onEndReached = 0,
		style = 0,
		contentContainerStyle = 0,
		ListHeaderComponent = 0,
		ListFooterComponent = 0
	}
	local getItemLayout

	if FFlagUserListFixedRowHeightConfig and v8 then
		getItemLayout = v8.getItemLayout
	end

	v11.getItemLayout = getItemLayout
	local onEndReached

	if FFlagUserListSurfaceExtensions then
		onEndReached = props.onEndReached
	end

	v11.onEndReached = onEndReached
	local style

	if FFlagUserListSurfaceExtensions and props.configs and props.configs.disableRowActivation then
		style = joined
	else
		style = v
	end

	v11.style = style

	v11.contentContainerStyle = contentContainerStyle
	local listHeaderComponent

	if FFlagUserListFixedRowHeightConfig and v8 and props.ListHeaderComponent then
		listHeaderComponent = React.createElement(
			View,
			{ tag = "size-full-0 auto-y", onAbsoluteSizeChanged = v8.onHeaderSizeChanged },
			{ Header = props.ListHeaderComponent }
		)
	else
		listHeaderComponent = props.ListHeaderComponent
	end

	v11.ListHeaderComponent = listHeaderComponent

	v11.ListFooterComponent = props.ListFooterComponent
	return createElement(View, v10, { List = createElement2(FlatList, v11) })
end

local function VerticalUserListWithCta(p)
	local v2

	if Cta == nil then
		v2 = false
	else
		v2 = p.ctaConfig ~= nil
	end

	if v2 then
		return React.createElement(Cta.CtaRenderRowBridge, {
			ctaConfig = p.ctaConfig,
			renderRow = p.renderRow,
			render = function(renderRow)
				local clone = table.clone(p)
				clone.renderRow = renderRow
				return React.createElement(VerticalUserList, clone)
			end
		})
	end

	return React.createElement(VerticalUserList, p)
end

if FFlagUserListCtaIntegrationEnabled then
	return VerticalUserListWithCta
end

return VerticalUserList
