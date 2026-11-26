local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local ItemCardIcon = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardIcon")

local defineFastFlag = game:DefineFastFlag("AXItemCardBadgeCheckText", false)

local function ItemCardBadge(props)
	local v5 = useTokens()

	local children = {
		ItemCardBadgeCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Border = 0,
		ItemCardBadgeLayout = 0,
		ItemCardBadgePadding = 0
	}

	local v6 = if props.displayBorder then React.createElement("UIStroke", {
		Color = v5.Color.Stroke.Default.Color3,
		Transparency = v5.Color.Stroke.Default.Transparency,
		Thickness = v5.Stroke.Thick
	}) else nil
	children.Border = v6

	children.ItemCardBadgeLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, v5.Gap.XSmall)
	})

	children.ItemCardBadgePadding = React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v5.Padding.Small),
		PaddingRight = UDim.new(0, v5.Padding.Small),
		PaddingTop = UDim.new(0, v5.Padding.Small),
		PaddingBottom = UDim.new(0, v5.Padding.Small)
	})

	for k, v7 in props.content do
		if v7.type == "text" then
			if defineFastFlag then
				if v7.text ~= "" then
					children[v7.text .. tostring(k)] = React.createElement(text, {
						textStyle = v5.Color.Content.Emphasis,
						fontStyle = v5.Typography.TitleSmall,
						LayoutOrder = k,
						Text = v7.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				end
			else
				children[v7.text .. tostring(k)] = React.createElement(text, {
					textStyle = v5.Color.Content.Emphasis,
					fontStyle = v5.Typography.TitleSmall,
					LayoutOrder = k,
					Text = v7.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			end
		else
			children[v7.icon .. tostring(k)] = React.createElement(ItemCardIcon, {
				icon = v7.icon,
				LayoutOrder = k
			})
		end
	end

	return React.createElement("Frame", {
		BackgroundColor3 = v5.Color.OverMedia.OverMedia_100.Color3,
		BackgroundTransparency = v5.Color.OverMedia.OverMedia_100.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}, children)
end

return ItemCardBadge
