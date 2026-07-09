local Parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(Parent.UIBlox)
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Responsive = require(Parent.Responsive)
local Core = UIBlox.Core
local App = UIBlox.App
local useStyle = Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local Images = App.ImageSet.Images
local IconButton = App.Button.IconButton
local IconSize = App.ImageSet.Enum.IconSize
local ImageSetLabel = Core.ImageSet.ImageSetLabel
local getIconSize = App.ImageSet.getIconSize
local v15 = Images["icons/navigation/close"]

local function InlinePrompt(t1: {[any]: any}) -- line: 54
	-- upvalues: useStyle (copy), getIconSize (copy), IconSize (copy), React (copy), Responsive (copy), ImageSetLabel (copy), Button (copy), Cryo (copy), IconButton (copy), v15 (copy)
	local v18 = useStyle()
	local Tokens = v18.Tokens
	local v20 = not t1.onDismiss and 0 or getIconSize(IconSize.Small)
	local v21 = (not t1.iconImage and 0 or 36) + v20
	local v22 = React.useRef(nil)
	local v23 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v24 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UILayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = if not v23 then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top
		}),
		Icon = if not t1.iconImage then nil else React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			Selectable = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(36, 36),
			Image = t1.iconImage,
			ImageColor3 = Tokens.Color.Content.Emphasis.Color3,
			ImageTransparency = Tokens.Color.Content.Emphasis.Transparency
		}),
		MiddleFrame = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v21, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UILayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 12)
			}),
			Text = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				TextLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 12)
				}),
				Title = React.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = true,
					TextScaled = false,
					Text = t1.titleMessage,
					TextColor3 = v18.Tokens.Color.Content.Emphasis.Color3,
					TextTransparency = v18.Tokens.Color.Content.Emphasis.Transparency,
					TextSize = v18.Tokens.Typography.CaptionLarge.FontSize,
					Font = v18.Tokens.Typography.CaptionLarge.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LineHeight = v18.Tokens.LineHeight.LineHeight_140
				}),
				Subline = if not t1.sublineMessage then nil else React.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextWrapped = true,
					TextScaled = false,
					LineHeight = 1,
					Text = t1.sublineMessage,
					TextColor3 = v18.Tokens.Color.Content.Default.Color3,
					TextTransparency = v18.Tokens.Color.Content.Default.Transparency,
					TextSize = v18.Tokens.Typography.BodySmall.FontSize,
					Font = v18.Tokens.Typography.BodySmall.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}),
			Button = if v23 or not t1.buttonProps then nil else React.createElement(Button, Cryo.Dictionary.join({
				layoutOrder = 2,
				size = UDim2.new(0, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.XY
			}, t1.buttonProps))
		}),
		DismissButtonFrame = if not t1.onDismiss then nil else React.createElement(IconButton, {
			backgroundTransparency = 1,
			layoutOrder = 3,
			icon = v15,
			iconSize = IconSize.Small,
			size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
			onActivated = t1.onDismiss
		})
	})

	return React.createElement("Frame", {
		BackgroundTransparency = t1.backgroundTransparency or Tokens.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = t1.backgroundColor3 or Tokens.Color.Surface.Surface_300.Color3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		ref = v22
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		ContainerRef = React.createElement(Responsive.ContainerRef.Provider, {
			value = v22
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			}),
			UILayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 12)
			}),
			HorizontalContent = v24,
			Button = if not v23 or not t1.buttonProps then nil else React.createElement(Button, Cryo.Dictionary.join({
				fitContent = false,
				layoutOrder = 2,
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.XY
			}, t1.buttonProps))
		})
	})
end

return InlinePrompt
