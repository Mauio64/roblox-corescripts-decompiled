local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Checkbox = Foundation.Checkbox

local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)
local Divider = require(Dependencies.Divider)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withStyle = UIBlox.Style.withStyle

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("BlockPlayerItem")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.number),
	size = t.UDim2,
	text = t.string,
	description = t.string,
	icon = t.union(t.string, t.table),
	iconSize = t.UDim2,
	isDisabled = t.optional(t.boolean),
	isCheckBoxSelected = t.boolean,
	onCheckBoxActivated = t.callback
})

extended.defaultProps = { isDisabled = false, isCheckBoxSelected = false }

function extended:init()
	function self.onClicked()
		if self.props.onCheckBoxActivated and not self.props.isDisabled then
			self.props.onCheckBoxActivated(not self.props.isCheckBoxSelected)
		end
	end
end

function extended.render(p)
	local props = p.props

	return withStyle(function(p2)
		local _theme = p2.Theme
		return Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder,
			Size = props.size,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			[Roact.Event.Activated] = p.onClicked
		}, {
			BlockIcon = Roact.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = props.icon,
				ImageTransparency = props.isDisabled and 0.5 or nil,
				Position = UDim2.new(0, 16, 0.5, 0),
				Size = props.iconSize
			}),
			CheckBoxFrame = Roact.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -20, 0.5, 0),
					Size = UDim2.fromOffset(24, 24)
				},
				{
					CheckBox = Roact.createElement(Checkbox, {
						label = "",
						isDisabled = props.isDisabled,
						onActivated = props.onCheckBoxActivated,
						isChecked = props.isCheckBoxSelected
					})
				}
			),
			TextFrame = Roact.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 60, 0.5, 0),
					Size = UDim2.new(1, -124, 1, 0)
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					Text = Roact.createElement(ThemedTextLabel, {
						LayoutOrder = 1,
						TextTransparency = props.isDisabled and 0.5 or nil,
						AutomaticSize = Enum.AutomaticSize.XY,
						fontKey = "SubHeader1",
						themeKey = "TextEmphasis",
						Text = props.text,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Description = Roact.createElement(ThemedTextLabel, {
						LayoutOrder = 2,
						TextTransparency = props.isDisabled and 0.5 or nil,
						AutomaticSize = Enum.AutomaticSize.XY,
						fontKey = "Footer",
						TextWrapped = true,
						themeKey = "TextDefault",
						Text = props.description,
						TextXAlignment = Enum.TextXAlignment.Left,
						LineHeight = 1.25
					})
				}
			),
			Divider = Roact.createElement(Divider, { Position = UDim2.new(0, 0, 1, 0) })
		})
	end)
end

return extended
