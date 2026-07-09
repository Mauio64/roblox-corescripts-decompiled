local Parent = script:FindFirstAncestor("InGameAssetReporting").Parent
local React = require(Parent.React)
local useStyle = require(Parent.UIBlox).Core.Style.useStyle

local function ReportTextEntry(t1: {[any]: any}) -- line: 13
	-- upvalues: useStyle (copy), React (copy)
	local v6 = useStyle()
	local BodyFont = v6.Font.Body.Font
	local BaseSize = v6.Font.BaseSize
	local Theme = v6.Theme

	return React.createElement("Frame", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = v6.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		ReportCommentTextBox = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			PlaceholderText = t1.placeholderText,
			Font = BodyFont,
			Text = t1.text,
			TextSize = BaseSize,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			RichText = false,
			MultiLine = true,
			TextWrapped = true,
			ClearTextOnFocus = false,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			[React.Change.Text] = function(p1) -- line: 56
				-- upvalues: t1 (copy)
				if t1.text ~= p1.Text then
					t1.onUpdate(p1.Text)
				end
			end
		})
	})
end

return ReportTextEntry
