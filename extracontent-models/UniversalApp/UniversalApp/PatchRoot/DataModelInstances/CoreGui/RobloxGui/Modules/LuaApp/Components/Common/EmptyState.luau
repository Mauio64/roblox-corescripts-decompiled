local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withLocalization = require(Modules.LuaApp.withLocalization)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local v14 = Images["icons/status/oof_xlarge"]
local v15 = Images["icons/common/refresh"]
local v16 = Roact.PureComponent:extend("EmptyState")

v16.validateProps = t.interface({
	text = t.string,
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	reloadAction = t.optional(t.callback)
})

function v16.render(p1) -- line: 35
	-- upvalues: withLocalization (copy), withStyle (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), v14 (copy), Button (copy), ButtonType (copy), v15 (copy)
	return withLocalization({
		emptyText = p1.props.text
	})(function(p2) -- line: 38
		-- upvalues: withStyle (copy), TextService (copy), Roact (copy), p1 (copy), ImageSetLabel (copy), IconSize (copy), v14 (copy), Button (copy), ButtonType (copy), v15 (copy)
		return withStyle(function(p3) -- line: 39
			-- upvalues: p2 (copy), TextService (copy), Roact (copy), p1 (copy), ImageSetLabel (copy), IconSize (copy), v14 (copy), Button (copy), ButtonType (copy), v15 (copy)
			local emptyText = p2.emptyText
			local BodyFont = p3.Font.Body.Font
			local v22 = p3.Font.BaseSize * p3.Font.Body.RelativeSize
			local TextSize = TextService:GetTextSize(emptyText, v22, BodyFont, Vector2.new(1000, 1000))

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = p1.props.position,
				Size = p1.props.size
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 0),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				EmptyIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
					Image = v14,
					ImageColor3 = p3.Theme.IconDefault.Color,
					ImageTransparency = p3.Theme.IconDefault.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}),
				Padding1 = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 12)
				}),
				Text = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					TextWrapped = true,
					LayoutOrder = 3,
					Size = UDim2.fromOffset(TextSize.X, TextSize.Y),
					Text = emptyText,
					Font = BodyFont,
					TextSize = v22,
					TextColor3 = p3.Theme.TextMuted.Color,
					TextTransparency = p3.Theme.TextMuted.Transparency
				}),
				Padding2 = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 24)
				}),
				ReloadButton = p1.props.reloadAction and Roact.createElement(Button, {
					layoutOrder = 5,
					buttonType = ButtonType.Secondary,
					size = UDim2.fromOffset(312, 48),
					icon = v15,
					onActivated = p1.props.reloadAction
				})
			})
		end)
	end)
end

return v16
