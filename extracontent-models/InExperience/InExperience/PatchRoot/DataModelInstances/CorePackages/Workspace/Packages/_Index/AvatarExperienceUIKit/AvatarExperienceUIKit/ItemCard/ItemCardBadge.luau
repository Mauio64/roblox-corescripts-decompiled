local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local ItemCardIcon = require(script.Parent.ItemCardIcon)

local defineFastFlag = game:DefineFastFlag("AXItemCardBadgeCheckText", false)

local function ItemCardBadge(props)
	local v = useTokens()

	local children = {
		ItemCardBadgeCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Border = 0,
		ItemCardBadgeLayout = 0,
		ItemCardBadgePadding = 0
	}
	local border

	if props.displayBorder then
		border = React.createElement("UIStroke", {
			Color = v.Color.Stroke.Default.Color3,
			Transparency = v.Color.Stroke.Default.Transparency,
			Thickness = v.Stroke.Thick
		})
	end

	children.Border = border

	children.ItemCardBadgeLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, v.Gap.XSmall)
	})

	children.ItemCardBadgePadding = React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v.Padding.Small),
		PaddingRight = UDim.new(0, v.Padding.Small),
		PaddingTop = UDim.new(0, v.Padding.Small),
		PaddingBottom = UDim.new(0, v.Padding.Small)
	})

	for k, v2 in props.content do
		if v2.type == "text" then
			if defineFastFlag then
				if v2.text ~= "" then
					children[v2.text .. tostring(k)] = React.createElement(Text, {
						textStyle = v.Color.Content.Emphasis,
						fontStyle = v.Typography.TitleSmall,
						LayoutOrder = k,
						Text = v2.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				end
			else
				children[v2.text .. tostring(k)] = React.createElement(Text, {
					textStyle = v.Color.Content.Emphasis,
					fontStyle = v.Typography.TitleSmall,
					LayoutOrder = k,
					Text = v2.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			end
		else
			children[v2.icon .. tostring(k)] = React.createElement(ItemCardIcon, {
				icon = v2.icon,
				LayoutOrder = k
			})
		end
	end

	return React.createElement("Frame", {
		BackgroundColor3 = v.Color.OverMedia.OverMedia_100.Color3,
		BackgroundTransparency = v.Color.OverMedia.OverMedia_100.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}, children)
end

return ItemCardBadge
