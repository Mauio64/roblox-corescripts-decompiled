local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Cryo")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
local flatList = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/VirtualizedList").FlatList
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

local useEntities = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntities")
local useEntitySelectionHandler = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntitySelectionHandler")
local useRenderEntity = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useRenderEntity")
local useFixedRowLayout = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useFixedRowLayout")

local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowSelectionOriginSource")
local FFlagUserListDisableVirtualizationConfig = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListDisableVirtualizationConfig")
local fFlagUserListFixedRowHeightConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListFixedRowHeightConfig

local v5 = if fFlagUserListCtaIntegrationEnabled then require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta") else nil

local v6 = { BackgroundTransparency = 1, ScrollBarThickness = 0, BorderSizePixel = 0 }

local joined = Cryo.Dictionary.join(v6, { Selectable = false })

local v7 = { BackgroundTransparency = 1 }

local function keyExtractor(p2, p3)
	return p2
end

local function VerticalUserList(props)
	local v8 = useEntities(props.entities)

	local onRowSelected = props.onRowSelected
	local v10 = if FFlagUserListRowSelectionOriginSource then props.rowSelectionConfig else nil
	local v11 = useEntitySelectionHandler(onRowSelected, v10)

	local v12 = React.useMemo(function()
		if not (props.initialRowCount and props.initialRowCount < #props.entities) then
			return props.entities
		end

		local result = {}

		for i = 1, props.initialRowCount do
			table.insert(result, props.entities[i])
		end

		return result
	end, { props.entities, props.initialRowCount })

	local v13 = React.useMemo(function()
		local ids = {}

		for k, v14 in v12 do
			table.insert(ids, v14.id)
		end

		return ids
	end, { v12 })

	local v15 = {
		entitiesMap = v8.entitiesMap,
		onActivated = v11,
		renderRow = props.renderRow,
		configs = props.configs,
		layoutMode = Enums.LayoutMode.Vertical,
		firstRowRef = 0
	}
	local v16 = if fFlagUserListSurfaceExtensions then props.firstRowRef else nil
	v15.firstRowRef = v16
	local v17 = useRenderEntity(v15)
	local v18

	if fFlagUserListFixedRowHeightConfig then
		local v20 = not (props.configs == nil) and props.configs.fixedRowHeight == true
		v18 = useFixedRowLayout(v20, props.ListHeaderComponent and true or false)
	else
		v18 = nil
	end

	local function fn(p2)
		local item = p2.item
		local index = p2.index
		local v20 = if fFlagUserListFixedRowHeightConfig and v18 then v18.itemSize else nil
		return v17(item, index, v20)
	end

	local v21 = React.useCallback(fn, { v17, if fFlagUserListFixedRowHeightConfig then v18 else nil })

	if #props.entities == 0 then
		return nil
	end

	if not props.isScrollEnabled then
		return React.createElement(
			view,
			{
				tag = "size-full-0 auto-y col gap-xxsmall",
				LayoutOrder = props.layoutOrder
			},
			{
				EntityRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function()
					local children = {}

					for i, v22 in ipairs(v13) do
						children[i] = React.createElement(
							view,
							{ key = v22, tag = "size-full-0 auto-y", LayoutOrder = i },
							{ Content = v17(v22, i) }
						)
					end

					return children
				end, { v13, v17 })))
			}
		)
	end

	local createElement = React.createElement
	local v23 = { tag = "size-full-0 fill", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v26 = {
		data = v13,
		renderItem = v21,
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

	local v27 = if fFlagUserListFixedRowHeightConfig and v18 then v18.getItemLayout else nil
	v26.getItemLayout = v27

	local v28 = if fFlagUserListSurfaceExtensions then props.onEndReached else nil
	v26.onEndReached = v28

	local v29 = if fFlagUserListSurfaceExtensions and props.configs and props.configs.disableRowActivation then joined else v6
	v26.style = v29

	v26.contentContainerStyle = v7

	local v30 = if fFlagUserListFixedRowHeightConfig and v18 and props.ListHeaderComponent then React.createElement(
		view,
		{ tag = "size-full-0 auto-y", onAbsoluteSizeChanged = v18.onHeaderSizeChanged },
		{ Header = props.ListHeaderComponent }
	) else props.ListHeaderComponent
	v26.ListHeaderComponent = v30

	v26.ListFooterComponent = props.ListFooterComponent
	return createElement(view, v23, { List = createElement2(flatList, v26) })
end

local function VerticalUserListWithCta(p2)
	local v8 = not (v5 == nil) and p2.ctaConfig ~= nil

	if v8 then
		return React.createElement(v5.CtaRenderRowBridge, {
			ctaConfig = p2.ctaConfig,
			renderRow = p2.renderRow,
			render = function(renderRow)
				local clone = table.clone(p2)
				clone.renderRow = renderRow
				return React.createElement(VerticalUserList, clone)
			end
		})
	end

	return React.createElement(VerticalUserList, p2)
end

if fFlagUserListCtaIntegrationEnabled then
	return VerticalUserListWithCta
end

return VerticalUserList
