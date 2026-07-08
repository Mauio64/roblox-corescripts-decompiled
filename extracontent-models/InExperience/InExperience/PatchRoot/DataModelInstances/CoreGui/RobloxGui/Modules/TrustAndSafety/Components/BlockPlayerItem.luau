local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local Divider = require(Dependencies.Divider)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v12 = Roact.PureComponent:extend("BlockPlayerItem")

v12.validateProps = t.strictInterface({
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
v12.defaultProps = {
	isDisabled = false,
	isCheckBoxSelected = false
}

function v12.init(p1) -- line: 39
	function p1.onClicked() -- line: 40
		-- upvalues: p1 (copy)
		if p1.props.onCheckBoxActivated and not p1.props.isDisabled then
			p1.props.onCheckBoxActivated(not p1.props.isCheckBoxSelected)
		end
	end
end
function v12.render(p2) -- line: 47
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), Checkbox (copy), ThemedTextLabel (copy), Divider (copy)
	local props = p2.props

	return withStyle(function(p3) -- line: 50
		-- upvalues: Roact (copy), props (copy), p2 (copy), ImageSetLabel (copy), Checkbox (copy), ThemedTextLabel (copy), Divider (copy)
		local _ = p3.Theme

		return Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder,
			Size = props.size,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			[Roact.Event.Activated] = p2.onClicked
		}, {
			BlockIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Image = props.icon,
				ImageTransparency = if not props.isDisabled then nil else 0.5,
				Position = UDim2.new(0, 16, 0.5, 0),
				Size = props.iconSize
			}),
			CheckBoxFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -20, 0.5, 0),
				Size = UDim2.fromOffset(24, 24)
			}, {
				CheckBox = Roact.createElement(Checkbox, {
					label = "",
					isDisabled = props.isDisabled,
					onActivated = props.onCheckBoxActivated,
					isChecked = props.isCheckBoxSelected
				})
			}),
			TextFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 60, 0.5, 0),
				Size = UDim2.new(1, -124, 1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Text = Roact.createElement(ThemedTextLabel, {
					LayoutOrder = 1,
					fontKey = "SubHeader1",
					themeKey = "TextEmphasis",
					TextTransparency = if not props.isDisabled then nil else 0.5,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = props.text,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Description = Roact.createElement(ThemedTextLabel, {
					LayoutOrder = 2,
					fontKey = "Footer",
					TextWrapped = true,
					themeKey = "TextDefault",
					LineHeight = 1.25,
					TextTransparency = if not props.isDisabled then nil else 0.5,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = props.description,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			Divider = Roact.createElement(Divider, {
				Position = UDim2.new(0, 0, 1, 0)
			})
		})
	end)
end

return v12
