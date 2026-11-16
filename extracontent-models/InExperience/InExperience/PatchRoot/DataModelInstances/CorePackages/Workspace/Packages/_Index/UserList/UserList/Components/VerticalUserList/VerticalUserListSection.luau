local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
require(UserList.Common.Enums)
local Foundation = require(parent.Foundation)
local View = Foundation.View
require(UserList.Common.Types)
local UserListHeader = require(UserList.Components.UserListHeader)

local UserListFooter = require(UserList.Components.UserListFooter)
local VerticalUserList = require(script.Parent.VerticalUserList)

local defineFastFlag = game:DefineFastFlag("UserListTightHeaderSpacing", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags2.FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require(UserList.Flags.FFlagUserListRowSelectionOriginSource)

local function VerticalUserListSection(props)
	local v

	if props.header then
		v = React.createElement(View, {
			tag = {
				["size-full-0 auto-y"] = true,
				["padding-bottom-small"] = defineFastFlag,
				["padding-bottom-large"] = not defineFastFlag and props.isScrollEnabled
			},
			LayoutOrder = not props.isScrollEnabled and 1 or nil
		}, {
			HeaderContent = React.createElement(UserListHeader, props.header)
		})
	end

	local v2

	if props.hasMore and props.onLoadMore then
		v2 = React.createElement(View, {
			tag = {
				["size-full-0 auto-y"] = true,
				["padding-top-large"] = defineFastFlag or props.isScrollEnabled
			},
			LayoutOrder = not props.isScrollEnabled and 3 or nil
		}, {
			FooterContent = React.createElement(UserListFooter, {
				hasMore = props.hasMore,
				onLoadMore = props.onLoadMore
			})
		})
	end

	if #props.entities == 0 then
		return nil
	end

	if props.isScrollEnabled then
		local createElement = React.createElement
		local v3 = {
			entities = props.entities,
			initialRowCount = props.initialRowCount,
			onRowSelected = props.onRowSelectedOverride,
			rowSelectionConfig = 0,
			ListHeaderComponent = 0,
			ListFooterComponent = 0,
			renderRow = 0,
			ctaConfig = 0,
			layoutOrder = 0,
			configs = 0,
			isScrollEnabled = true,
			onEndReached = 0,
			firstRowRef = 0
		}
		local rowSelectionConfig

		if FFlagUserListRowSelectionOriginSource then
			rowSelectionConfig = props.rowSelectionConfig
		end

		v3.rowSelectionConfig = rowSelectionConfig
		v3.ListHeaderComponent = v
		v3.ListFooterComponent = v2
		v3.renderRow = props.renderRow
		local ctaConfig

		if FFlagUserListCtaIntegrationEnabled then
			ctaConfig = props.ctaConfig
		end

		v3.ctaConfig = ctaConfig
		v3.layoutOrder = props.layoutOrder
		v3.configs = props.configs
		local onEndReached

		if FFlagUserListSurfaceExtensions then
			onEndReached = props.onEndReached
		end

		v3.onEndReached = onEndReached
		local firstRowRef

		if FFlagUserListSurfaceExtensions then
			firstRowRef = props.firstRowRef
		end

		v3.firstRowRef = firstRowRef
		return createElement(VerticalUserList, v3)
	else
		local createElement = React.createElement
		local v3 = {
			tag = {
				["col size-full-0 auto-y"] = defineFastFlag,
				["col gap-large size-full-0 auto-y"] = not defineFastFlag
			},
			LayoutOrder = props.layoutOrder
		}

		local createElement2 = React.createElement
		local v4 = {
			entities = props.entities,
			initialRowCount = props.initialRowCount,
			onRowSelected = props.onRowSelectedOverride,
			rowSelectionConfig = 0,
			renderRow = 0,
			ctaConfig = 0,
			layoutOrder = 2,
			configs = 0,
			isScrollEnabled = false,
			firstRowRef = 0
		}
		local rowSelectionConfig

		if FFlagUserListRowSelectionOriginSource then
			rowSelectionConfig = props.rowSelectionConfig
		end

		v4.rowSelectionConfig = rowSelectionConfig
		v4.renderRow = props.renderRow
		local ctaConfig

		if FFlagUserListCtaIntegrationEnabled then
			ctaConfig = props.ctaConfig
		end

		v4.ctaConfig = ctaConfig

		v4.configs = props.configs
		local firstRowRef

		if FFlagUserListSurfaceExtensions then
			firstRowRef = props.firstRowRef
		end

		v4.firstRowRef = firstRowRef
		return createElement(View, v3, {
			Header = v,
			List = createElement2(VerticalUserList, v4),
			Footer = v2
		})
	end
end

return VerticalUserListSection
