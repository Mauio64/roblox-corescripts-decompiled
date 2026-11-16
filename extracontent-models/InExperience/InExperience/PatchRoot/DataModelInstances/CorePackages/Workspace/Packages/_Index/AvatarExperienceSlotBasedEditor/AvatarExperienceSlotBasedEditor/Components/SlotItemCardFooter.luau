local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Responsive = require(parent.Responsive)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddTextXAlignmentProp = AvatarExperienceFlags.FFlagAXAddTextXAlignmentProp

local function SlotItemCardFooter(props)
	local v = useTokens()
	local v2 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}
	local v4 = {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v.Gap.XSmall)
		}),
		ItemCardFooterInfo = 0
	}
	local itemCardFooterInfo

	if props.title then
		local createElement2 = React.createElement
		local v5 = {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}

		local v6 = {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = 0
		}
		local itemCardFooterInfoTitle

		if props.title then
			local createElement3 = React.createElement
			local v7 = {
				textStyle = v.Color.Content.Emphasis,
				fontStyle = 0,
				LayoutOrder = 1,
				Text = 0,
				TextXAlignment = 0,
				Size = 0,
				AutomaticSize = 0,
				TextTruncate = 0
			}
			local fontStyle

			if v2 then
				fontStyle = v.Typography.CaptionSmall
			else
				fontStyle = v.Typography.CaptionMedium
			end

			v7.fontStyle = fontStyle

			v7.Text = props.title
			local textXAlignment

			if FFlagAXAddTextXAlignmentProp and props.TextXAlignment then
				textXAlignment = props.TextXAlignment
			else
				textXAlignment = Enum.TextXAlignment.Left
			end

			v7.TextXAlignment = textXAlignment

			v7.Size = UDim2.fromScale(1, 0)
			v7.AutomaticSize = Enum.AutomaticSize.Y
			v7.TextTruncate = Enum.TextTruncate.SplitWord
			itemCardFooterInfoTitle = createElement3(Text, v7)
		end

		v6.ItemCardFooterInfoTitle = itemCardFooterInfoTitle
		itemCardFooterInfo = createElement2("Frame", v5, v6)
	end

	v4.ItemCardFooterInfo = itemCardFooterInfo
	return createElement("Frame", v3, v4)
end

return SlotItemCardFooter
