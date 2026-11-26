local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Responsive")

local fFlagAXAddTextXAlignmentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXAddTextXAlignmentProp

local function SlotItemCardFooter(props)
	local v5 = useTokens()
	local v6 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}
	local v9 = {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.Gap.XSmall)
		}),
		ItemCardFooterInfo = 0
	}
	local v10

	if props.title then
		local createElement2 = React.createElement
		local v12 = {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}

		local v13 = {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v5.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = 0
		}
		local v14

		if props.title then
			local createElement3 = React.createElement
			local v16 = {
				textStyle = v5.Color.Content.Emphasis,
				fontStyle = 0,
				LayoutOrder = 1,
				Text = 0,
				TextXAlignment = 0,
				Size = 0,
				AutomaticSize = 0,
				TextTruncate = 0
			}

			local v17 = if v6 then v5.Typography.CaptionSmall else v5.Typography.CaptionMedium
			v16.fontStyle = v17

			v16.Text = props.title
			local v18 = if fFlagAXAddTextXAlignmentProp and props.TextXAlignment then props.TextXAlignment else Enum.TextXAlignment.Left
			v16.TextXAlignment = v18

			v16.Size = UDim2.fromScale(1, 0)
			v16.AutomaticSize = Enum.AutomaticSize.Y
			v16.TextTruncate = Enum.TextTruncate.SplitWord
			v14 = createElement3(text, v16)
		end

		v13.ItemCardFooterInfoTitle = v14
		v10 = createElement2("Frame", v12, v13)
	end

	v9.ItemCardFooterInfo = v10
	return createElement("Frame", v8, v9)
end

return SlotItemCardFooter
