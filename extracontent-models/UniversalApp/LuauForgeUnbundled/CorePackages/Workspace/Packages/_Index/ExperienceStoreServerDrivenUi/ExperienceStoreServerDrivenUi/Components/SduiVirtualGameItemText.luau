local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Foundation")
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/TextSize")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local tooltip = Foundation.Tooltip
local useTokens = Foundation.Hooks.useTokens

local iconName = Foundation.Enums.IconName
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local v5 = {
	pendingReceiptTooltip = "Purchasing.PurchaseDialog.Message.PendingDeveloperProductOnHome"
}

local function resolveTag(value, p2)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return p2
end

local function resolveIconStyle(p2, p3)
	if p2 == nil then
		return p3
	end

	return p2
end

local function SduiVirtualGameItemText(props)
	local v6 = useTokens()
	local v7 = useLocalization(v5)
	local pendingReceiptsCountText = props.pendingReceiptsCountText
	local v8 = typeof(pendingReceiptsCountText) == "string" and pendingReceiptsCountText ~= ""

	if not v8 then
		pendingReceiptsCountText = nil
	end

	local v9 = props.pendingReceiptsTooltipText

	if v8 then
		if typeof(v9) ~= "string" or v9 == "" then
			v9 = v7.pendingReceiptTooltip
		end
	else
		v9 = nil
	end

	local v10 = typeof(props.title) == "string" and props.title ~= ""
	local v11 = (props.titleMaxLines == nil or not (props.titleMaxLines > 0)) and 2 or props.titleMaxLines

	local v12 = if props.titleFontStyle == nil then v6.Typography.TitleMedium else props.titleFontStyle
	local textSizeOffset = TextSize.getTextSizeStore(false).getTextSizeOffset(false)

	local v13 = not v10 and 0 or math.ceil(v11 * (v12.LineHeight * v12.FontSize + textSizeOffset))

	local v14 = typeof(props.priceText) == "string" and props.priceText ~= ""
	local v15

	if v14 then
		if props.showBasePriceCrossed == true and props.basePriceText ~= nil then
			v15 = props.basePriceText ~= ""
		else
			v15 = false
		end
	else
		v15 = v14
	end

	local hideRobuxIconInPrice = props.hideRobuxIconInPrice == true

	local v17 = props.priceRobuxIconSize == nil and "Small" or props.priceRobuxIconSize

	local v18 = props.priceRobuxIconStyle
	local emphasis = v6.Color.Content.Emphasis

	if v18 == nil then
		v18 = emphasis
	end

	local v19 = props.basePriceRobuxIconSize == nil and "XSmall" or props.basePriceRobuxIconSize

	local v20 = props.basePriceRobuxIconStyle
	local muted = v6.Color.Content.Muted

	if v20 == nil then
		v20 = muted
	end

	local createElement = React.createElement
	local v22 = { LayoutOrder = props.layoutOrder, tag = 0, testId = 0 }
	local tag = props.tag
	v22.tag = (typeof(tag) ~= "string" or tag == "") and "col fill auto-xy" or tag
	v22.testId = props.testId
	local v24

	if v10 then
		local createElement2 = React.createElement
		local v26 = {
			LayoutOrder = 1,
			Text = props.title,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			fontStyle = v12,
			Size = UDim2.new(1, 0, 0, v13),
			tag = 0,
			testId = 0
		}
		local titleTag = props.titleTag
		v26.tag = (typeof(titleTag) ~= "string" or titleTag == "")
			and "size-full-0 text-wrap text-align-x-left text-truncate-end content-emphasis"
			or titleTag
		local v27 = if props.testId then `{props.testId}--title` else nil
		v26.testId = v27
		v24 = createElement2(text, v26)
	end

	local v25

	if v14 or v8 then
		local createElement2 = React.createElement

		local priceRowTag = props.priceRowTag
		local v27 = {
			LayoutOrder = 2,
			tag = (typeof(priceRowTag) ~= "string" or priceRowTag == "") and "row align-y-center gap-small auto-xy" or priceRowTag,
			testId = 0
		}

		local v28 = if props.testId then `{props.testId}--price-row` else nil
		v27.testId = v28
		local v30

		if v14 then
			local createElement3 = React.createElement

			local currentPriceTag = props.currentPriceTag
			local v32 = {
				LayoutOrder = 1,
				tag = (typeof(currentPriceTag) ~= "string" or currentPriceTag == "") and "row align-y-center gap-xsmall auto-xy" or currentPriceTag,
				testId = 0
			}

			local v33 = if props.testId then `{props.testId}--current-price` else nil
			v32.testId = v33
			local v35

			if not hideRobuxIconInPrice then
				local createElement4 = React.createElement
				local v37 = {
					name = iconName.Robux,
					size = v17,
					style = v18,
					LayoutOrder = 1,
					testId = 0
				}

				local v38 = if props.testId then `{props.testId}--price-robux-icon` else nil
				v37.testId = v38
				v35 = createElement4(icon, v37)
			end

			local createElement4 = React.createElement
			local v37 = { LayoutOrder = 2, Text = props.priceText, tag = 0 }
			local priceTextTag = props.priceTextTag
			v37.tag = (typeof(priceTextTag) ~= "string" or priceTextTag == "")
				and "auto-xy text-align-x-left text-body-medium content-emphasis"
				or priceTextTag
			v30 = createElement3(view, v32, {
				RobuxIcon = v35,
				Price = createElement4(text, v37)
			})
		end

		local v31

		if v15 then
			local createElement3 = React.createElement

			local basePriceTag = props.basePriceTag
			local v33 = {
				LayoutOrder = 2,
				tag = (typeof(basePriceTag) ~= "string" or basePriceTag == "") and "auto-xy" or basePriceTag,
				testId = 0
			}

			local v34 = if props.testId then `{props.testId}--base-price` else nil
			v33.testId = v34

			local createElement4 = React.createElement
			local basePriceContentTag = props.basePriceContentTag
			local v36 = {
				tag = (typeof(basePriceContentTag) ~= "string" or basePriceContentTag == "") and "row align-y-center gap-xsmall auto-xy" or basePriceContentTag
			}

			local createElement5 = React.createElement
			local v38 = {
				name = iconName.Robux,
				size = v19,
				style = v20,
				LayoutOrder = 1,
				testId = 0
			}

			local v39 = if props.testId then `{props.testId}--base-price-robux-icon` else nil
			v38.testId = v39
			local children2 = { RobuxIcon = createElement5(icon, v38), Price = 0 }

			local createElement6 = React.createElement
			local v41 = { LayoutOrder = 2, Text = props.basePriceText, tag = 0 }
			local basePriceTextTag = props.basePriceTextTag
			v41.tag = (typeof(basePriceTextTag) ~= "string" or basePriceTextTag == "")
				and "auto-xy text-align-x-left text-body-small content-muted"
				or basePriceTextTag
			children2.Price = createElement6(text, v41)
			local children = {
				Content = createElement4(view, v36, children2),
				Strikethrough = 0
			}

			local createElement7 = React.createElement
			local strikethroughTag = props.strikethroughTag
			local v43 = {
				tag = (typeof(strikethroughTag) ~= "string" or strikethroughTag == "") and "bg-system-neutral position-center-center anchor-center-center" or strikethroughTag,
				Size = UDim2.new(1, 0, 0, 1),
				ZIndex = 2,
				testId = 0
			}

			local v44 = if props.testId then `{props.testId}--base-price-strikethrough` else nil
			v43.testId = v44
			children.Strikethrough = createElement7(view, v43)
			v31 = createElement3(view, v33, children)
		end

		local v32

		if v8 then
			local createElement3 = React.createElement

			local ownedCountTag = props.ownedCountTag
			local v34 = {
				LayoutOrder = 3,
				tag = (typeof(ownedCountTag) ~= "string" or ownedCountTag == "") and "row align-y-center gap-xsmall auto-xy" or ownedCountTag,
				testId = 0
			}

			local v35 = if props.testId then `{props.testId}--owned-count` else nil
			v34.testId = v35
			local v37

			if v14 then
				local createElement4 = React.createElement

				local ownedCountSeparatorText = props.ownedCountSeparatorText
				local v39 = {
					LayoutOrder = 1,
					Text = (typeof(ownedCountSeparatorText) ~= "string" or ownedCountSeparatorText == "") and "·" or ownedCountSeparatorText,
					tag = 0,
					testId = 0
				}

				local ownedCountSeparatorTag = props.ownedCountSeparatorTag
				v39.tag = (typeof(ownedCountSeparatorTag) ~= "string" or ownedCountSeparatorTag == "")
					and "auto-xy text-body-medium content-default"
					or ownedCountSeparatorTag
				local v40 = if props.testId then `{props.testId}--owned-count-separator` else nil
				v39.testId = v40
				v37 = createElement4(text, v39)
			end

			local createElement4 = React.createElement

			local v39 = {
				LayoutOrder = 2,
				title = "",
				text = v9,
				side = popoverSide.Top,
				align = popoverAlign.Center
			}

			local createElement5 = React.createElement

			local v42 = if props.testId then `{props.testId}--owned-count-tooltip` else nil

			local createElement6 = React.createElement

			local ownedCountTextTag = props.ownedCountTextTag
			local v45 = {
				Text = pendingReceiptsCountText,
				tag = (typeof(ownedCountTextTag) ~= "string" or ownedCountTextTag == "") and "auto-xy text-body-medium content-muted" or ownedCountTextTag,
				testId = 0
			}

			local v46 = if props.testId then `{props.testId}--owned-count-label` else nil
			v45.testId = v46
			v32 = createElement3(view, v34, {
				Dot = v37,
				Label = createElement4(tooltip, v39, createElement5(view, {
					tag = "auto-xy",
					onStateChanged = function(p2) end,
					testId = v42
				}, { Text = createElement6(text, v45) }))
			})
		end

		v25 = createElement2(view, v27, {
			CurrentPrice = v30,
			BasePrice = v31,
			OwnedCount = v32
		})
	end

	return createElement(view, v22, { Title = v24, PriceRow = v25 })
end

return React.memo(SduiVirtualGameItemText)
