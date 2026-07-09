local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v8 = Roact.PureComponent:extend("MoreList")

v8.defaultProps = {
	LayoutOrder = 1
}

function v8.render(p1) -- line: 19
	-- upvalues: ArgCheck (copy), Roact (copy), Constants (copy), FFlagEnableFlyoutSidePanel (copy), withStyle (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local itemList = p1.props.itemList
	local renderItem = p1.props.renderItem
	local rowHeight = p1.props.rowHeight

	ArgCheck.isType(renderItem, "function", "MoreList.props.renderItem")

	if not itemList or #itemList == 0 then
		return
	end

	local function v14(p2, p3) -- line: 31
		-- upvalues: itemList (copy), Roact (copy), rowHeight (copy), renderItem (copy), Constants (copy), FFlagEnableFlyoutSidePanel (copy), propsLayoutOrder (copy)
		local t1 = {}
		local n1 = 0

		t1.Layout = (#itemList[1] > 1 or #itemList > 1) and Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})

		for i, v in ipairs(itemList) do
			for i2, v2 in ipairs(v) do
				n1 += 1

				local v23 = i2 < #v or i < #itemList
				local t2 = {
					Size = UDim2.new(1, 0, 0, v23 and rowHeight - 1 or rowHeight),
					LayoutOrder = n1 * 2 - 1
				}

				t1["Row" .. n1] = renderItem(v2, t2)

				if v23 then
					local v25 = v2.icon and Constants.MORE_PAGE_TEXT_PADDING_WITH_ICON or Constants.MORE_PAGE_ROW_PADDING_LEFT

					if FFlagEnableFlyoutSidePanel then
						v25 = Constants.MORE_PAGE_ROW_PADDING_LEFT
					end

					t1["Divider" .. n1] = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(1, -v25, 0, 1),
						BackgroundColor3 = p3.Color,
						BackgroundTransparency = p3.Transparency,
						LayoutOrder = n1 * 2
					})
				end
			end
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, rowHeight * n1),
			BackgroundColor3 = p2.Color,
			BackgroundTransparency = p2.Transparency,
			BorderColor3 = p3.Color,
			LayoutOrder = propsLayoutOrder
		}, t1)
	end

	return withStyle(function(p4) -- line: 78
		-- upvalues: v14 (copy)
		return v14(p4.Theme.BackgroundDefault, p4.Theme.Divider)
	end)
end

return v8
