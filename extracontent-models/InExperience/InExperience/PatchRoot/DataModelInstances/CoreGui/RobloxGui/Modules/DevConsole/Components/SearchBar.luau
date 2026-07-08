local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ScrollingTextBox = require(script.Parent.ScrollingTextBox)
local Constants = require(script.Parent.Parent.Constants)
local v5 = Roact.Component:extend("SearchBar")

function v5.render(p1) -- line: 18
	-- upvalues: Roact (copy), Constants (copy), ScrollingTextBox (copy)
	local size = p1.props.size
	local pos = p1.props.pos
	local frameHeight = p1.props.frameHeight
	local textSize = p1.props.textSize
	local font = p1.props.font
	local searchTerm = p1.props.searchTerm
	local layoutOrder = p1.props.layoutOrder
	local visible = p1.props.visible
	local showClear = p1.props.showClear
	local v16 = frameHeight * 0.6

	return Roact.createElement("Frame", {
		Size = size,
		Position = pos,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BorderColor3 = Constants.Color.BorderGray,
		Visible = visible,
		LayoutOrder = layoutOrder
	}, {
		SearchImage = Roact.createElement("ImageLabel", {
			Name = "SearchIcon",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v16, 0, v16),
			Position = UDim2.new(0, 10, 0.5, -v16 / 2),
			Image = Constants.Image.Search
		}),
		ClearButton = showClear and Roact.createElement("ImageButton", {
			Size = UDim2.new(0, -v16, 0, v16),
			Position = UDim2.new(1, -10, 0.5, -v16 / 2),
			BackgroundTransparency = 1,
			Image = Constants.Image.Clear,
			[Roact.Event.InputEnded] = p1.props.cancelInput
		}),
		InputField = Roact.createElement(ScrollingTextBox, {
			Text = searchTerm and searchTerm or "",
			TextSize = textSize,
			Font = font,
			Size = UDim2.new(1, -(2 * frameHeight), 1, 0),
			Position = UDim2.new(0, 20 + v16, 0, 0),
			ShowNativeInput = true,
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			ClearTextOnFocus = false,
			PlaceholderText = "Search",
			[Roact.Ref] = p1.props.refForParent,
			TextBoxFocusLost = p1.props.focusLost
		})
	})
end

return v5
