local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Responsive = require(Parent.Responsive)
local FFlagAXAddTextXAlignmentProp = require(Parent.AvatarExperienceFlags).FFlagAXAddTextXAlignmentProp

local function SlotItemCardFooter(t1: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), FoundationText (copy), FFlagAXAddTextXAlignmentProp (copy)
	local v10 = useTokens()
	local v11 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v10.Gap.XSmall)
		}),
		ItemCardFooterInfo = if not t1.title then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v10.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = if not t1.title then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				textStyle = v10.Color.Content.Emphasis,
				fontStyle = if not v11 then v10.Typography.CaptionMedium else v10.Typography.CaptionSmall,
				Text = t1.title,
				TextXAlignment = if not FFlagAXAddTextXAlignmentProp or not t1.TextXAlignment then Enum.TextXAlignment.Left else t1.TextXAlignment,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextTruncate = Enum.TextTruncate.SplitWord
			})
		})
	})
end

return SlotItemCardFooter
