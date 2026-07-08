local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local ItemCardIcon = require(script.Parent.ItemCardIcon)
local v7 = game:DefineFastFlag("AXItemCardBadgeCheckText", false)

local function ItemCardBadge(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), React (copy), v7 (copy), FoundationText (copy), ItemCardIcon (copy)
	local v10 = useTokens()
	local t2 = {
		ItemCardBadgeCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Border = if not t1.displayBorder then nil else React.createElement("UIStroke", {
			Color = v10.Color.Stroke.Default.Color3,
			Transparency = v10.Color.Stroke.Default.Transparency,
			Thickness = v10.Stroke.Thick
		}),
		ItemCardBadgeLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v10.Gap.XSmall)
		}),
		ItemCardBadgePadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v10.Padding.Small),
			PaddingRight = UDim.new(0, v10.Padding.Small),
			PaddingTop = UDim.new(0, v10.Padding.Small),
			PaddingBottom = UDim.new(0, v10.Padding.Small)
		})
	}

	for v12, v13 in t1.content do
		if v13.type == "text" then
			if v7 then
				if v13.text ~= "" then
					t2[v13.text .. tostring(v12)] = React.createElement(FoundationText, {
						textStyle = v10.Color.Content.Emphasis,
						fontStyle = v10.Typography.TitleSmall,
						LayoutOrder = v12,
						Text = v13.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				end
			else
				t2[v13.text .. tostring(v12)] = React.createElement(FoundationText, {
					textStyle = v10.Color.Content.Emphasis,
					fontStyle = v10.Typography.TitleSmall,
					LayoutOrder = v12,
					Text = v13.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			end
		else
			t2[v13.icon .. tostring(v12)] = React.createElement(ItemCardIcon, {
				icon = v13.icon,
				LayoutOrder = v12
			})
		end
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = v10.Color.OverMedia.OverMedia_100.Color3,
		BackgroundTransparency = v10.Color.OverMedia.OverMedia_100.Transparency,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}, t2)
end

return ItemCardBadge
