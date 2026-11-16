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

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListComposeRenderRowWithCta = SharedFlags2.FFlagUserListComposeRenderRowWithCta
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags3.FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require(UserList.Flags.FFlagUserListRowSelectionOriginSource)
local FFlagUserListDisableVirtualizationConfig = require(UserList.Flags.FFlagUserListDisableVirtualizationConfig)
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

	local renderItem = React.useCallback(function(p)
		return v7(p.item, p.index)
	end, { v7 })

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

					for i, v8 in ipairs(v5) do
						children[i] = React.createElement(
							View,
							{ key = v8, tag = "size-full-0 auto-y", LayoutOrder = i },
							{ Content = v7(v8, i) }
						)
					end

					return children
				end, { v5, v7 })))
			}
		)
	end

	local createElement = React.createElement
	local v8 = { tag = "size-full-0 fill", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v9 = {
		data = v5,
		renderItem = renderItem,
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
	local onEndReached

	if FFlagUserListSurfaceExtensions then
		onEndReached = props.onEndReached
	end

	v9.onEndReached = onEndReached
	local style

	if FFlagUserListSurfaceExtensions and props.configs and props.configs.disableRowActivation then
		style = joined
	else
		style = v
	end

	v9.style = style

	v9.contentContainerStyle = contentContainerStyle
	v9.ListHeaderComponent = props.ListHeaderComponent
	v9.ListFooterComponent = props.ListFooterComponent
	return createElement(View, v8, { List = createElement2(FlatList, v9) })
end

local function VerticalUserListWithCta(p)
	local v2

	if Cta == nil or p.ctaConfig == nil then
		v2 = false
	else
		v2 = p.renderRow == nil
	end

	if FFlagUserListComposeRenderRowWithCta then
		if Cta == nil then
			v2 = false
		else
			v2 = p.ctaConfig ~= nil
		end
	end

	if not v2 then
		return React.createElement(VerticalUserList, p)
	end

	local createElement = React.createElement
	local ctaRenderRowBridge = Cta.CtaRenderRowBridge
	local v3 = { ctaConfig = p.ctaConfig, renderRow = 0, render = 0 }
	local renderRow2

	if FFlagUserListComposeRenderRowWithCta then
		renderRow2 = p.renderRow
	end

	v3.renderRow = renderRow2
	function v3.render(renderRow)
		local clone = table.clone(p)
		clone.renderRow = renderRow
		return React.createElement(VerticalUserList, clone)
	end

	return createElement(ctaRenderRowBridge, v3)
end

if FFlagUserListCtaIntegrationEnabled then
	return VerticalUserListWithCta
end

return VerticalUserList
