local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Cryo")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
local flatList = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/VirtualizedList").FlatList
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

local useEntities = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntities")
local useEntitySelectionHandler = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntitySelectionHandler")
local useRenderEntity = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useRenderEntity")

local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListComposeRenderRowWithCta = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListComposeRenderRowWithCta
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowSelectionOriginSource")
local FFlagUserListDisableVirtualizationConfig = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListDisableVirtualizationConfig")

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

	local v18 = React.useCallback(function(p2)
		return v17(p2.item, p2.index)
	end, { v17 })

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

					for i, v19 in ipairs(v13) do
						children[i] = React.createElement(
							view,
							{ key = v19, tag = "size-full-0 auto-y", LayoutOrder = i },
							{ Content = v17(v19, i) }
						)
					end

					return children
				end, { v13, v17 })))
			}
		)
	end

	local createElement = React.createElement
	local v20 = { tag = "size-full-0 fill", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v23 = {
		data = v13,
		renderItem = v18,
		keyExtractor = keyExtractor,
		windowSize = 3,
		initialNumToRender = 10,
		onEndReachedThreshold = 2,
		disableVirtualization = FFlagUserListDisableVirtualizationConfig and props.configs and props.configs.disableVirtualization and true or nil,
		onEndReached = 0,
		style = 0,
		contentContainerStyle = 0,
		ListHeaderComponent = 0,
		ListFooterComponent = 0
	}

	local v24 = if fFlagUserListSurfaceExtensions then props.onEndReached else nil
	v23.onEndReached = v24

	local v25 = if fFlagUserListSurfaceExtensions and props.configs and props.configs.disableRowActivation then joined else v6
	v23.style = v25

	v23.contentContainerStyle = v7
	v23.ListHeaderComponent = props.ListHeaderComponent
	v23.ListFooterComponent = props.ListFooterComponent
	return createElement(view, v20, { List = createElement2(flatList, v23) })
end

local function VerticalUserListWithCta(p2)
	local v8 = not (v5 == nil or p2.ctaConfig == nil) and p2.renderRow == nil

	if fFlagUserListComposeRenderRowWithCta then
		v8 = not (v5 == nil) and p2.ctaConfig ~= nil
	end

	if not v8 then
		return React.createElement(VerticalUserList, p2)
	end

	local createElement = React.createElement
	local ctaRenderRowBridge = v5.CtaRenderRowBridge
	local v9 = { ctaConfig = p2.ctaConfig, renderRow = 0, render = 0 }
	local v10 = if fFlagUserListComposeRenderRowWithCta then p2.renderRow else nil
	v9.renderRow = v10
	function v9.render(renderRow)
		local clone = table.clone(p2)
		clone.renderRow = renderRow
		return React.createElement(VerticalUserList, clone)
	end

	return createElement(ctaRenderRowBridge, v9)
end

if fFlagUserListCtaIntegrationEnabled then
	return VerticalUserListWithCta
end

return VerticalUserList
