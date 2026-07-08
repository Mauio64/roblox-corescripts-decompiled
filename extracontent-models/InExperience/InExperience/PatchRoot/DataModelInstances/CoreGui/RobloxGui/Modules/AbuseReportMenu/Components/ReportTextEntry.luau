local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle

local function ReportTextEntry(t1: {[any]: any}) -- line: 11
	-- upvalues: useStyle (copy), React (copy)
	local v6 = useStyle()
	local BodyFont = v6.Font.Body.Font
	local FontSize_400 = v6.Tokens.FontSize.FontSize_400
	local Theme = v6.Theme

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 40 + v6.Tokens.Size.Size_600 + 20),
		BackgroundTransparency = v6.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
		AutomaticSize = Enum.AutomaticSize.Y
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
		AbuseReportsText = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40 + v6.Tokens.Size.Size_600),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			PlaceholderText = t1.placeholderText,
			Font = BodyFont,
			Text = t1.text,
			TextSize = FontSize_400,
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
			[React.Event.FocusLost] = function() -- line: 54
			end,
			[React.Event.Focused] = function() -- line: 55
			end,
			[React.Change.AbsoluteSize] = function() -- line: 56
			end,
			[React.Change.Text] = function(p1) -- line: 57
				-- upvalues: t1 (copy)
				if t1.text ~= p1.Text then
					t1.onUpdate(p1.Text)
				end
			end
		})
	})
end

return ReportTextEntry
