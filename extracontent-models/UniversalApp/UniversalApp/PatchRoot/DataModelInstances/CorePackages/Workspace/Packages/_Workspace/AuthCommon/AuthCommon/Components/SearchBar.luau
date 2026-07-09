local Parent = script:FindFirstAncestor("AuthCommon").Parent
local AppFonts = require(Parent.Style).AppFonts
local Roact = require(Parent.Roact)
local ImageSetLabel = require(Parent.UIBlox).Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local v6 = Roact.PureComponent:extend("LoginSearchBar")

function v6.init(p1) -- line: 18
	p1.state = {
		longText = false
	}
	p1.lastInput = 0

	function p1.searchTextChanged(p2) -- line: 25
		-- upvalues: p1 (copy)
		local v17 = p2.TextBounds.X > p2.AbsoluteSize.X

		if v17 ~= p1.state.longText then
			p2.TextXAlignment = v17 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
			spawn(function() -- line: 29
				-- upvalues: p1 (copy), v17 (copy)
				p1:setState({
					longText = v17
				})
			end)
		end

		if p1.props.TextChanged then
			p1.lastInput = p1.lastInput + 1

			local lastInput = p1.lastInput

			wait(0.3)

			if lastInput == p1.lastInput then
				p1.props.TextChanged(p2)
			end
		end
	end
end
function v6.render(p3) -- line: 47
	-- upvalues: Roact (copy), ImageSetLabel (copy), GetImageData (copy), AppFonts (copy)
	local YOffset = p3.props.Size.Y.Offset
	local IconSize = p3.props.IconSize
	local propsTextSize = p3.props.TextSize
	local PlaceholderText = p3.props.PlaceholderText
	local PlaceholderColor3 = p3.props.PlaceholderColor3
	local propsText = p3.props.Text
	local propsTextColor3 = p3.props.TextColor3

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = p3.props.Size,
		Position = p3.props.Position,
		Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
		ImageColor3 = p3.props.ImageColor3,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}, {
		SearchIcon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, IconSize, 0, IconSize),
			Position = UDim2.new(0, YOffset * 0.5, 0, YOffset * 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = GetImageData("LuaApp/icons/ic-search-new") or "LuaApp/icons/ic-search-new",
			ImageColor3 = propsTextColor3
		}),
		SearchInput = Roact.createElement("TextBox", {
			Size = UDim2.new(1, -YOffset - 10, 1, 0),
			Position = UDim2.new(0, YOffset, 0, 0),
			TextSize = propsTextSize,
			TextColor3 = propsTextColor3,
			PlaceholderText = PlaceholderText,
			PlaceholderColor3 = PlaceholderColor3,
			Font = AppFonts.default:getDefault(),
			TextXAlignment = p3.state.longText and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Text = propsText,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			[Roact.Change.Text] = p3.searchTextChanged
		})
	})
end

return v6
