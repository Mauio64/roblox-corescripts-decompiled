local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/deferred/fAy")
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("TencentNoticeList")

extended.validateProps = t.strictInterface({
	renderItem = t.callback,
	itemList = t.table
})

function extended.render(p2)
	local renderItem = p2.props.renderItem
	local itemList = p2.props.itemList
	local TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT = module.TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT
	return withStyle(function(p3)
		local backgroundDefault = p3.Theme.BackgroundDefault
		local divider = p3.Theme.Divider
		local v5 = {}
		v5.Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})

		for i, item in ipairs(itemList) do
			local v6 = i < #itemList
			local v7 = {
				Size = UDim2.new(
					1,
					0,
					0,
					v6 and TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT - 1 or TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT
				),
				LayoutOrder = i * 2 - 1
			}

			v5["NoticeList_Row_" .. item.noticeId] = renderItem(item, v7)
			v5["NoticeList_Divider_" .. item.noticeId] = v6 and Roact.createElement("Frame", {
				Size = UDim2.new(1, -24, 0, 1),
				BackgroundColor3 = divider.Color,
				BackgroundTransparency = divider.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = i * 2
			})
		end

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, TENCENT_NOTICE_CENTER_PAGE_ROW_HEIGHT * #itemList),
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = backgroundDefault.Transparency,
			BorderSizePixel = 0,
			BorderColor3 = divider.Color,
			LayoutOrder = 1
		}, v5)
	end)
end

return extended
