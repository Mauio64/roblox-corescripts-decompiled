local ParentParent = script.Parent.Parent.Parent
local UIBlox = require(ParentParent.UIBlox)
local React = require(ParentParent.React)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local v8 = Roact.PureComponent:extend("SubscriptionTitle")

v8.validateProps = t.strictInterface({
	name = t.string,
	displayPrice = t.string,
	subscriptionProviderName = t.string,
	period = t.string,
	disclaimerText = t.string,
	layoutOrder = t.number,
	contentHeight = t.number,
	itemIcon = t.any
})

local function createSubscriptionInfo(t1: {[any]: any}, p1) -- line: 53
	-- upvalues: withStyle (copy), React (copy)
	return withStyle(function(p2) -- line: 54
		-- upvalues: React (copy), t1 (copy), p1 (copy)
		local Theme = p2.Theme
		local BodyFont = p2.Font.Body.Font

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = t1.layoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = p1 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}, {
			AppName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = t1.subscriptionProviderName,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = p1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = t1.layoutOrder
			})
		}, {
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 20,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = t1.name,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = p1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = t1.layoutOrder + 1
			})
		}, {
			PriceFrame = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = t1.layoutOrder + 2
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = p1 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal
				}),
				Price = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = t1.displayPrice,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = p1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = t1.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				}),
				Period = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = t1.period,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = p1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = t1.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				})
			})
		}, {
			DisclaimerText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 16),
				Text = t1.disclaimerText,
				TextColor3 = Theme.TextDefault.Color,
				Font = BodyFont,
				TextXAlignment = p1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = t1.layoutOrder + 3
			})
		})
	end)
end
local function createCompactSubscriptionTitle(p3) -- line: 157
	-- upvalues: React (copy), ImageSetLabel (copy), withStyle (copy)
	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local t3 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 24)
		}),
		Icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 96, 0, 96),
			ScaleType = Enum.ScaleType.Fit,
			AutomaticSize = Enum.AutomaticSize.X,
			Image = p3.itemIcon
		})
	}
	local v18 = true

	t3.SubscriptionInfo = withStyle(function(p4) -- line: 54
		-- upvalues: React (copy), p3 (copy), v18 (copy)
		local Theme = p4.Theme
		local BodyFont = p4.Font.Body.Font

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p3.layoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v18 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}, {
			AppName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = p3.subscriptionProviderName,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = v18 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p3.layoutOrder
			})
		}, {
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 20,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = p3.name,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = v18 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p3.layoutOrder + 1
			})
		}, {
			PriceFrame = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = p3.layoutOrder + 2
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = v18 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal
				}),
				Price = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = p3.displayPrice,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = v18 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = p3.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				}),
				Period = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = p3.period,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = v18 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = p3.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				})
			})
		}, {
			DisclaimerText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 16),
				Text = p3.disclaimerText,
				TextColor3 = Theme.TextDefault.Color,
				Font = BodyFont,
				TextXAlignment = v18 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p3.layoutOrder + 3
			})
		})
	end)

	return createElement("Frame", t2, t3)
end
local function createNormalSubscriptionTitle(p5) -- line: 182
	-- upvalues: React (copy), ImageSetLabel (copy), withStyle (copy)
	local createElement = React.createElement
	local t4 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local t5 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 24)
		}),
		Icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 96, 0, 96),
			ScaleType = Enum.ScaleType.Fit,
			AutomaticSize = Enum.AutomaticSize.X,
			Image = p5.itemIcon
		})
	}
	local v23 = false

	t5.SubscriptionInfo = withStyle(function(p6) -- line: 54
		-- upvalues: React (copy), p5 (copy), v23 (copy)
		local Theme = p6.Theme
		local BodyFont = p6.Font.Body.Font

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p5.layoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v23 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}, {
			AppName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = p5.subscriptionProviderName,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p5.layoutOrder
			})
		}, {
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 20,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 20),
				Text = p5.name,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = BodyFont,
				TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p5.layoutOrder + 1
			})
		}, {
			PriceFrame = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = p5.layoutOrder + 2
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = v23 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal
				}),
				Price = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = p5.displayPrice,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = p5.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				}),
				Period = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 16,
					RichText = true,
					TextWrapped = true,
					Size = UDim2.new(0, 0, 0, 16),
					Text = p5.period,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = BodyFont,
					TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					LayoutOrder = p5.layoutOrder + 1,
					AutomaticSize = Enum.AutomaticSize.X
				})
			})
		}, {
			DisclaimerText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 16),
				Text = p5.disclaimerText,
				TextColor3 = Theme.TextDefault.Color,
				Font = BodyFont,
				TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				LayoutOrder = p5.layoutOrder + 3
			})
		})
	end)

	return createElement("Frame", t4, t5)
end

function v8.getTitleHeight(_, p8) -- line: 207
	if p8 > 216 then
		return 216
	end

	return 96
end
function v8.render(p9) -- line: 215
	-- upvalues: createNormalSubscriptionTitle (copy), createCompactSubscriptionTitle (copy)
	if p9.props.contentHeight > 216 then
		return createNormalSubscriptionTitle(p9.props)
	end

	return createCompactSubscriptionTitle(p9.props)
end

return v8
