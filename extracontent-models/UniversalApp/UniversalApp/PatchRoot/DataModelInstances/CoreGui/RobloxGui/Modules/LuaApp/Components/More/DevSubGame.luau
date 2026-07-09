local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local withStyle = UIBlox.Style.withStyle
local v7 = Roact.PureComponent:extend("DevSubGame")
local _ = {
	LEFT = 24,
	TOP = 13,
	BOTTOM = 13,
	RIGHT = 22
}

v7.defaultProps = {
	layoutOrder = 0
}

function v7.render(p1) -- line: 36
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy)
	local props = p1.props
	local game2 = props.game
	local subNames = props.subNames
	local activeSubs = props.activeSubs
	local active = props.active
	local dividerDisabled = props.dividerDisabled
	local onActivated = props.onActivated
	local layoutOrder = props.layoutOrder
	local maxSize = props.maxSize

	return withStyle(function(p2) -- line: 47
		-- upvalues: Roact (copy), maxSize (copy), layoutOrder (copy), onActivated (copy), game2 (copy), active (copy), subNames (copy), DEPRECATED_ImageSetLabel (copy), activeSubs (copy), dividerDisabled (copy)
		return Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, maxSize.Y),
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = onActivated
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = maxSize
			}),
			ContentFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingTop = UDim.new(0, 13),
					PaddingBottom = UDim.new(0, 13),
					PaddingRight = UDim.new(0, 22)
				}),
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Icon = Roact.createElement("ImageLabel", {
					LayoutOrder = 1,
					Size = UDim2.new(0, 44, 0, 44),
					BackgroundTransparency = game2.icon == nil and 0 or 1,
					Image = game2.icon,
					ImageTransparency = not active and 0.5 or 0
				}),
				TextFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, -64, 1, 0)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12)
					}),
					Title = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 22),
						Font = p2.Font.Header2.Font,
						TextSize = p2.Font.BaseSize * p2.Font.Header2.RelativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = p2.Theme.TextEmphasis.Color,
						TextTransparency = active and p2.Theme.TextEmphasis.Transparency or p2.Theme.TextEmphasis.Transparency * 0.5,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = game2.name
					}),
					List = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.new(0, 0, 1, 0),
						Size = UDim2.new(1, 0, 0, 17),
						Font = p2.Font.Body.Font,
						TextSize = p2.Font.BaseSize * p2.Font.Body.RelativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = p2.Theme.TextDefault.Color,
						TextTransparency = active and p2.Theme.TextDefault.Transparency or p2.Theme.TextDefault.Transparency * 0.5,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = table.concat(subNames, ", ")
					})
				}),
				Circle = Roact.createElement(DEPRECATED_ImageSetLabel, {
					LayoutOrder = 3,
					Image = "LuaApp/graphic/gr-counter-slot-32x32",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 20, 0, 20),
					ImageTransparency = if not active then p2.Theme.UIDefault.Transparency else 0,
					ImageColor3 = p2.Theme.UIDefault.Color
				}, { Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Visible = active,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Font = p2.Font.Footer.Font,
					TextSize = p2.Font.BaseSize * p2.Font.Footer.RelativeSize,
					TextColor3 = p2.Theme.TextDefault.Color,
					TextTransparency = p2.Theme.TextDefault.Transparency,
					Text = activeSubs
				}) })
			}),
			Divider = not dividerDisabled and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = p2.Theme.Divider.Color,
				BackgroundTransparency = active and p2.Theme.Divider.Transparency or 0.5,
				Size = UDim2.new(1, -80, 0, 1),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return v7
