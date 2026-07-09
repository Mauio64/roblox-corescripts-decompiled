local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.Luobu.Constants)
local t = require(CorePackages.Packages.t)
local v7 = Roact.PureComponent:extend("TencentNoticeList")

v7.validateProps = t.strictInterface({
	renderItem = t.callback,
	itemList = t.table
})

function v7.render(p1) -- line: 18
	-- upvalues: Constants (copy), withStyle (copy), Roact (copy)
	local renderItem = p1.props.renderItem
	local itemList = p1.props.itemList
	local TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT = Constants.TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT

	return withStyle(function(p2) -- line: 22
		-- upvalues: Roact (copy), itemList (copy), TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT (copy), renderItem (copy)
		local BackgroundDefault = p2.Theme.BackgroundDefault
		local Divider = p2.Theme.Divider
		local t1 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			})
		}

		for i, v in ipairs(itemList) do
			local v18 = i < #itemList
			local t2 = {
				Size = UDim2.new(1, 0, 0, v18 and TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT - 1 or TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT),
				LayoutOrder = i * 2 - 1
			}

			t1["NoticeList_Row_" .. v.noticeId] = renderItem(v, t2)
			t1["NoticeList_Divider_" .. v.noticeId] = v18 and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -24, 0, 1),
				BackgroundColor3 = Divider.Color,
				BackgroundTransparency = Divider.Transparency,
				LayoutOrder = i * 2
			})
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT * #itemList),
			BackgroundColor3 = BackgroundDefault.Color,
			BackgroundTransparency = BackgroundDefault.Transparency,
			BorderColor3 = Divider.Color
		}, t1)
	end)
end

return v7
