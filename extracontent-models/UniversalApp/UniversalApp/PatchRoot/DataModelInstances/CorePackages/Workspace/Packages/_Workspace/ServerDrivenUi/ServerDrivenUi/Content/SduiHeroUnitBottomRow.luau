local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local FFlagLuaAppAlignHeroUnitBottomRowCtaButton = require(Parent.SharedFlags).FFlagLuaAppAlignHeroUnitBottomRowCtaButton

local function SduiHeroUnitBottomRow(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), React (copy), FFlagLuaAppAlignHeroUnitBottomRowCtaButton (copy)
	local layoutOrder = t1.layoutOrder
	local zIndex = t1.zIndex
	local position = t1.position
	local v10 = useTokens()
	local BodySmall = v10.Typography.BodySmall
	local Gray_400Color3 = v10.Color.Extended.Gray.Gray_400.Color3
	local v13 = React.useMemo(function() -- line: 36
		-- upvalues: t1 (copy), React (copy), BodySmall (copy), Gray_400Color3 (copy)
		if t1.rightLabelContent then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			}, {
				Content = t1.rightLabelContent
			})
		end

		if t1.labelText and t1.labelText ~= "" then
			return React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, BodySmall.FontSize * BodySmall.LineHeight),
				Text = t1.labelText,
				TextSize = BodySmall.FontSize,
				Font = BodySmall.Font,
				TextColor3 = Gray_400Color3,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.SplitWord,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			})
		end

		return nil
	end, {
		t1.rightLabelContent,
		t1.labelText,
		BodySmall,
		Gray_400Color3
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v10.Size.Size_1000),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = position,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			ItemLineAlignment = if not FFlagLuaAppAlignHeroUnitBottomRowCtaButton then Enum.ItemLineAlignment.Center else Enum.ItemLineAlignment.Automatic
		}),
		CTAButtonContainer = if not FFlagLuaAppAlignHeroUnitBottomRowCtaButton then React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ButtonContent = t1.ctaButton
		}) else t1.ctaButton,
		LabelContainer = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Label = v13
		})
	})
end

return React.memo(SduiHeroUnitBottomRow)
