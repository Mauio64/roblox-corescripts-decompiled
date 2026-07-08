local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local CheckIcon = require(script.Parent.CheckIcon)
local v6 = Roact.Component:extend("AlertViewCheckbox")

v6.defaultProps = {
	Text = "",
	LayoutOrder = 0,
	checked = false,
	onActivated = function() -- line: 12
	end
}

function v6.render(p1) -- line: 16
	-- upvalues: UIBlox (copy), Roact (copy), CheckIcon (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 17
		-- upvalues: Roact (copy), p1 (copy), CheckIcon (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p1.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 35)
		}, {
			List = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			Checkbox = Roact.createElement(CheckIcon, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				checked = p1.props.checked,
				onActivated = p1.props.onActivated
			}),
			Label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(0.7, 0, 1, 0),
				Text = p1.props.Text,
				TextColor3 = p1.props.TextColor3 or p2.Theme.TextDefault.Color,
				TextSize = p1.props.TextSize or p2.Font.Body.RelativeSize * p2.Font.BaseSize,
				Font = p1.props.Font or p2.Font.CaptionSubHeader.Font,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	end)
end

return v6
