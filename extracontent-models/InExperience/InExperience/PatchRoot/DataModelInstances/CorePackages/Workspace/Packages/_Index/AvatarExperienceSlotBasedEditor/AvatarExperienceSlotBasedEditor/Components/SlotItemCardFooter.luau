local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Responsive = require(Parent.Responsive)
local FFlagAXAddTextXAlignmentProp = require(Parent.AvatarExperienceFlags).FFlagAXAddTextXAlignmentProp
local FFlagAXCustomizeMakeupSupport = require(Parent.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport

local function SlotItemCardFooter(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), FoundationText (copy), FFlagAXCustomizeMakeupSupport (copy), FFlagAXAddTextXAlignmentProp (copy)
	local v11 = useTokens()
	local v12 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

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
			Padding = UDim.new(0, v11.Gap.XSmall)
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
				Padding = UDim.new(0, v11.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = if not t1.title then nil else React.createElement(FoundationText, {
				textStyle = v11.Color.Content.Emphasis,
				fontStyle = if not v12 then if not FFlagAXCustomizeMakeupSupport then v11.Typography.LabelMedium else v11.Typography.CaptionMedium else v11.Typography.CaptionSmall,
				LayoutOrder = if not FFlagAXCustomizeMakeupSupport then t1.LayoutOrder else 1,
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
