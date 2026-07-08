local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)

require(UserList.Common.Enums)

local View = require(UserListParent.Foundation).View

require(UserList.Common.Types)

local UserListHeader = require(UserList.Components.UserListHeader)
local UserListFooter = require(UserList.Components.UserListFooter)
local VerticalUserList = require(script.Parent.VerticalUserList)

local function VerticalUserListSection(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), View (copy), UserListHeader (copy), UserListFooter (copy), VerticalUserList (copy)
	local v10 = if not t1.header then nil else React.createElement(View, {
		tag = {
			["size-full-0 auto-y"] = true,
			["padding-bottom-large"] = t1.isScrollEnabled
		},
		LayoutOrder = if t1.isScrollEnabled then nil else 1
	}, {
		HeaderContent = React.createElement(UserListHeader, t1.header)
	})
	local v11 = if not t1.hasMore or not t1.onLoadMore then nil else React.createElement(View, {
		tag = {
			["size-full-0 auto-y"] = true,
			["padding-top-large"] = t1.isScrollEnabled
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
			ListHeaderComponent = v10,
			ListFooterComponent = v11,
			renderRow = t1.renderRow,
			layoutOrder = t1.layoutOrder,
			configs = t1.configs
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = t1.layoutOrder
	}, {
		Header = v10,
		List = React.createElement(VerticalUserList, {
			layoutOrder = 2,
			isScrollEnabled = false,
			entities = t1.entities,
			initialRowCount = t1.initialRowCount,
			onRowSelected = t1.onRowSelectedOverride,
			renderRow = t1.renderRow,
			configs = t1.configs
		}),
		Footer = v11
	})
end

return VerticalUserListSection
