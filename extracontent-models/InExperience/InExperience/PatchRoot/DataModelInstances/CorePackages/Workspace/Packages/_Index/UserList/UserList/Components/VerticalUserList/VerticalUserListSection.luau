local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)

require(UserList.Common.Enums)

local View = require(UserListParent.Foundation).View

require(UserList.Common.Types)

local UserListHeader = require(UserList.Components.UserListHeader)
local UserListFooter = require(UserList.Components.UserListFooter)
local VerticalUserList = require(script.Parent.VerticalUserList)
local v8 = game:DefineFastFlag("UserListTightHeaderSpacing", false)

local function VerticalUserListSection(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), View (copy), v8 (copy), UserListHeader (copy), UserListFooter (copy), VerticalUserList (copy)
	local v11 = if not t1.header then nil else React.createElement(View, {
		tag = {
			["size-full-0 auto-y"] = true,
			["padding-bottom-small"] = v8,
			["padding-bottom-large"] = not v8 and t1.isScrollEnabled
		},
		LayoutOrder = if t1.isScrollEnabled then nil else 1
	}, {
		HeaderContent = React.createElement(UserListHeader, t1.header)
	})
	local v12 = if not t1.hasMore or not t1.onLoadMore then nil else React.createElement(View, {
		tag = {
			["size-full-0 auto-y"] = true,
			["padding-top-large"] = v8 or t1.isScrollEnabled
		},
		LayoutOrder = if t1.isScrollEnabled then nil else 3
	}, {
		FooterContent = React.createElement(UserListFooter, {
			hasMore = t1.hasMore,
			onLoadMore = t1.onLoadMore
		})
	})

	if #t1.entities == 0 then
		return nil
	end

	if t1.isScrollEnabled then
		return React.createElement(VerticalUserList, {
			isScrollEnabled = true,
			entities = t1.entities,
			initialRowCount = t1.initialRowCount,
			onRowSelected = t1.onRowSelectedOverride,
			ListHeaderComponent = v11,
			ListFooterComponent = v12,
			renderRow = t1.renderRow,
			layoutOrder = t1.layoutOrder,
			configs = t1.configs
		})
	end

	return React.createElement(View, {
		tag = {
			["col size-full-0 auto-y"] = v8,
			["col gap-large size-full-0 auto-y"] = not v8
		},
		LayoutOrder = t1.layoutOrder
	}, {
		Header = v11,
		List = React.createElement(VerticalUserList, {
			layoutOrder = 2,
			isScrollEnabled = false,
			entities = t1.entities,
			initialRowCount = t1.initialRowCount,
			onRowSelected = t1.onRowSelectedOverride,
			renderRow = t1.renderRow,
			configs = t1.configs
		}),
		Footer = v12
	})
end

return VerticalUserListSection
