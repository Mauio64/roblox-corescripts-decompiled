local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function(p2)
	local v5 = useDesignTokens()

	local size_900 = v5.Size.Size_900
	local size_400 = v5.Size.Size_400

	local font = v5.Typography.TitleLarge.Font
	local fontSize_350 = v5.FontSize.FontSize_350
	local emphasis = v5.Color.Content.Emphasis

	local hover = v5.Color.State.Hover

	local v6, v7 = React.useBinding(1e999)

	local function fn(content)
		return React.createElement("TextButton", {
			Size = UDim2.fromOffset(0, size_900),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = hover.Color3,
			BackgroundTransparency = hover.Transparency,
			BorderSizePixel = 0,
			Text = "",
			Interactable = content.onActivated and true or false,
			[React.Event.Activated] = content.onActivated
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, size_400),
				PaddingRight = UDim.new(0, size_400)
			}),
			TextLabel = React.createElement("TextLabel", {
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Text = content.text,
				FontFace = normalizeFontFace(font),
				TextSize = fontSize_350,
				TextColor3 = emphasis.Color3,
				TextTransparency = emphasis.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = v6:map(function(p3)
						return Vector2.new(p3, 1e999)
					end)
				})
			})
		})
	end

	local size_200 = v5.Size.Size_200

	local v8 = {}

	local function fn2(p3)
		v7(p3.AbsoluteSize.X)
	end

	for k, content in p2.contents do
		v8["Pill" .. k] = fn(content)
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p2.LayoutOrder,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = fn2
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, size_200),
			Wraps = true
		}),
		Pills = React.createElement(React.Fragment, {}, v8)
	})
end
