local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module2 = require("@luauforge/bundled/dzD")

local module3 = require("@luauforge/bundled/dKL")
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

local extended = Roact.PureComponent:extend("MoreList")

extended.defaultProps = { LayoutOrder = 1 }

function extended.render(p2)
	local layoutOrder = p2.props.LayoutOrder
	local itemList = p2.props.itemList
	local renderItem = p2.props.renderItem
	local rowHeight = p2.props.rowHeight

	module.isType(renderItem, "function", "MoreList.props.renderItem")

	if not itemList or #itemList == 0 then
		return
	end

	local function fn(backgroundDefault, divider)
		local children = {}
		local count = 0

		children.Layout = (#itemList[1] > 1 or #itemList > 1)
			and Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			})

		for i, list in ipairs(itemList) do
			for j, item in ipairs(list) do
				count += 1
				local v6 = j < #list or i < #itemList
				local v7 = {
					Size = UDim2.new(1, 0, 0, v6 and rowHeight - 1 or rowHeight),
					LayoutOrder = count * 2 - 1
				}

				children["Row" .. count] = renderItem(item, v7)

				if not v6 then
					continue
				end

				local v8 = item.icon and module2.MORE_PAGE_TEXT_PADDING_WITH_ICON
					or module2.MORE_PAGE_ROW_PADDING_LEFT

				if module3 then
					v8 = module2.MORE_PAGE_ROW_PADDING_LEFT
				end

				children["Divider" .. count] = Roact.createElement("Frame", {
					Size = UDim2.new(1, -v8, 0, 1),
					BackgroundColor3 = divider.Color,
					BackgroundTransparency = divider.Transparency,
					BorderSizePixel = 0,
					LayoutOrder = count * 2
				})
			end
		end

		local createElement = Roact.createElement
		local ref = Roact.Ref
		local v8 = if fFlagUnifyConsoleSettingsPage then p2.props.defaultFocusRef else nil
		local v7 = {
			[ref] = v8,
			Size = UDim2.new(1, 0, 0, rowHeight * count),
			BackgroundColor3 = backgroundDefault.Color
		}
		local v9 = if p2.props.backgroundTransparency == nil then backgroundDefault.Transparency else p2.props.backgroundTransparency
		v7.BackgroundTransparency = v9

		v7.BorderSizePixel = 0
		v7.BorderColor3 = divider.Color
		v7.LayoutOrder = layoutOrder
		return createElement("Frame", v7, children)
	end

	return withStyle(function(p3)
		return fn(p3.Theme.BackgroundDefault, p3.Theme.Divider)
	end)
end

return extended
