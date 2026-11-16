local parent = script:FindFirstAncestor("AuthCommon").Parent

local Style = require(parent.Style)
local AppFonts = Style.AppFonts

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData

local extended = Roact.PureComponent:extend("LoginSearchBar")

function extended:init()
	self.state = { longText = false }

	self.lastInput = 0
	function self.searchTextChanged(state)
		local longText = state.TextBounds.X > state.AbsoluteSize.X

		if longText ~= self.state.longText then
			state.TextXAlignment = longText and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
			spawn(function()
				self:setState({ longText = longText })
			end)
		end

		if self.props.TextChanged then
			self.lastInput += 1
			local lastInput = self.lastInput
			wait(0.3)

			if lastInput == self.lastInput then
				self.props.TextChanged(state)
			end
		end
	end
end

function extended.render(props)
	local offset = props.props.Size.Y.Offset
	local iconSize = props.props.IconSize
	local textSize = props.props.TextSize
	local placeholderText = props.props.PlaceholderText
	local placeholderColor3 = props.props.PlaceholderColor3
	local text = props.props.Text
	local textColor3 = props.props.TextColor3

	return Roact.createElement(ImageSetLabel, {
		Size = props.props.Size,
		Position = props.props.Position,
		BackgroundTransparency = 1,
		Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
		ImageColor3 = props.props.ImageColor3,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}, {
		SearchIcon = Roact.createElement(ImageSetLabel, {
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Position = UDim2.new(0, offset * 0.5, 0, offset * 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = GetImageData("LuaApp/icons/ic-search-new") or "LuaApp/icons/ic-search-new",
			BackgroundTransparency = 1,
			ImageColor3 = textColor3
		}),
		SearchInput = Roact.createElement("TextBox", {
			Size = UDim2.new(1, -offset - 10, 1, 0),
			Position = UDim2.new(0, offset, 0, 0),
			TextSize = textSize,
			TextColor3 = textColor3,
			PlaceholderText = placeholderText,
			PlaceholderColor3 = placeholderColor3,
			Font = AppFonts.default:getDefault(),
			TextXAlignment = props.state.longText and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Text = text,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			[Roact.Change.Text] = props.searchTextChanged
		})
	})
end

return extended
