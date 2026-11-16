local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local UserListHeader = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserListHeader")

local UserListFooter = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserListFooter")
local VerticalUserList = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/VerticalUserList/VerticalUserList")

local defineFastFlag = game:DefineFastFlag("UserListTightHeaderSpacing", false)
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local FFlagUserListRowSelectionOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowSelectionOriginSource")

local function VerticalUserListSection(props)
	local v5

	if props.header then
		v5 = React.createElement(view, {
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

	local v6

	if props.hasMore and props.onLoadMore then
		v6 = React.createElement(view, {
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
		local v8 = {
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
		local v9 = if FFlagUserListRowSelectionOriginSource then props.rowSelectionConfig else nil
		v8.rowSelectionConfig = v9
		v8.ListHeaderComponent = v5
		v8.ListFooterComponent = v6
		v8.renderRow = props.renderRow
		local v10 = if fFlagUserListCtaIntegrationEnabled then props.ctaConfig else nil
		v8.ctaConfig = v10
		v8.layoutOrder = props.layoutOrder
		v8.configs = props.configs

		local v11 = if fFlagUserListSurfaceExtensions then props.onEndReached else nil
		v8.onEndReached = v11
		local v12 = if fFlagUserListSurfaceExtensions then props.firstRowRef else nil
		v8.firstRowRef = v12
		return createElement(VerticalUserList, v8)
	else
		local createElement = React.createElement
		local v8 = {
			tag = {
				["col size-full-0 auto-y"] = defineFastFlag,
				["col gap-large size-full-0 auto-y"] = not defineFastFlag
			},
			LayoutOrder = props.layoutOrder
		}

		local createElement2 = React.createElement
		local v11 = {
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
		local v12 = if FFlagUserListRowSelectionOriginSource then props.rowSelectionConfig else nil
		v11.rowSelectionConfig = v12
		v11.renderRow = props.renderRow
		local v13 = if fFlagUserListCtaIntegrationEnabled then props.ctaConfig else nil
		v11.ctaConfig = v13

		v11.configs = props.configs

		local v14 = if fFlagUserListSurfaceExtensions then props.firstRowRef else nil
		v11.firstRowRef = v14
		return createElement(view, v8, {
			Header = v5,
			List = createElement2(VerticalUserList, v11),
			Footer = v6
		})
	end
end

return VerticalUserListSection
