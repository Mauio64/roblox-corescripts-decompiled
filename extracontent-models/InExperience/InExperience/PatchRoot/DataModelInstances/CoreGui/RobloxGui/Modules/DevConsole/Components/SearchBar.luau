local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local ScrollingTextBox = require(script.Parent.ScrollingTextBox)

local Constants = require(script.Parent.Parent.Constants)

local extended = Roact.Component:extend("SearchBar")

function extended.render(p)
	local size = p.props.size
	local pos = p.props.pos
	local frameHeight = p.props.frameHeight

	local textSize = p.props.textSize
	local font = p.props.font
	local searchTerm = p.props.searchTerm
	local layoutOrder = p.props.layoutOrder

	local visible = p.props.visible
	local clearButton = p.props.showClear

	local v = frameHeight * 0.6

	local createElement = Roact.createElement
	local v2 = {
		Size = size,
		Position = pos,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BorderColor3 = Constants.Color.BorderGray,
		Visible = visible,
		LayoutOrder = layoutOrder
	}

	local v3 = {
		SearchImage = Roact.createElement("ImageLabel", {
			Name = "SearchIcon",
			Size = UDim2.new(0, v, 0, v),
			Position = UDim2.new(0, 10, 0.5, -v / 2),
			BackgroundTransparency = 1,
			Image = Constants.Image.Search
		}),
		ClearButton = 0,
		InputField = 0
	}

	if clearButton then
		clearButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0, -v, 0, v),
			Position = UDim2.new(1, -10, 0.5, -v / 2),
			BackgroundTransparency = 1,
			Image = Constants.Image.Clear,
			[Roact.Event.InputEnded] = p.props.cancelInput
		})
	end

	v3.ClearButton = clearButton

	v3.InputField = Roact.createElement(ScrollingTextBox, {
		Text = searchTerm and searchTerm or "",
		TextSize = textSize,
		Font = font,
		Size = UDim2.new(1, -(2 * frameHeight), 1, 0),
		Position = UDim2.new(0, 20 + v, 0, 0),
		ShowNativeInput = true,
		TextColor3 = Constants.Color.Text,
		BackgroundTransparency = 1,
		TextXAlignment = 0,
		ClearTextOnFocus = false,
		PlaceholderText = "Search",
		[Roact.Ref] = p.props.refForParent,
		TextBoxFocusLost = p.props.focusLost
	})
	return createElement("Frame", v2, v3)
end

return extended
