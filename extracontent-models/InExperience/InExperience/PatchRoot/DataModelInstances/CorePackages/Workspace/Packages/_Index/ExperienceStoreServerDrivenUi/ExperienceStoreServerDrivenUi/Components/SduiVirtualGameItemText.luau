local parent = script:FindFirstAncestor("ExperienceStoreServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local TextSize = require(parent.TextSize)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Tooltip = Foundation.Tooltip
local useTokens = Foundation.Hooks.useTokens

local IconName = Foundation.Enums.IconName
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local v = {
	pendingReceiptTooltip = "Purchasing.PurchaseDialog.Message.PendingDeveloperProductOnHome"
}

local function resolveTag(value: string?, p: string) -- 13 equivalent calls inferred from this helper
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return p
end

local function resolveIconStyle(p, p2) -- 2 equivalent calls inferred from this helper
	return if p == nil then p2 else p
end

local function SduiVirtualGameItemText(props)
	local v2 = useTokens()
	local v3 = useLocalization(v)
	local pendingReceiptsCountText = props.pendingReceiptsCountText
	local v4

	if typeof(pendingReceiptsCountText) == "string" then
		v4 = pendingReceiptsCountText ~= ""
	else
		v4 = false
	end

	if not v4 then
		pendingReceiptsCountText = nil
	end

	local text = props.pendingReceiptsTooltipText

	if v4 then
		if typeof(text) ~= "string" or text == "" then
			text = v3.pendingReceiptTooltip
		end
	else
		text = nil
	end

	local v5

	if typeof(props.title) == "string" then
		v5 = props.title ~= ""
	else
		v5 = false
	end

	local v6 = (props.titleMaxLines == nil or not (props.titleMaxLines > 0)) and 2 or props.titleMaxLines
	local fontStyle

	if props.titleFontStyle == nil then
		fontStyle = v2.Typography.TitleMedium
	else
		fontStyle = props.titleFontStyle
	end

	local textSizeOffset = TextSize.getTextSizeStore(false).getTextSizeOffset(false)

	local v7 = not v5 and 0 or math.ceil(v6 * (fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset))
	local v8

	if typeof(props.priceText) == "string" then
		v8 = props.priceText ~= ""
	else
		v8 = false
	end

	local v9

	if v8 then
		if props.showBasePriceCrossed == true and props.basePriceText ~= nil then
			v9 = props.basePriceText ~= ""
		else
			v9 = false
		end
	else
		v9 = v8
	end

	local hideRobuxIconInPrice = props.hideRobuxIconInPrice == true

	local size = props.priceRobuxIconSize == nil and "Small" or props.priceRobuxIconSize

	local iconStyle = resolveIconStyle(props.priceRobuxIconStyle, v2.Color.Content.Emphasis) -- inferred equivalent call
	local size2 = props.basePriceRobuxIconSize == nil and "XSmall" or props.basePriceRobuxIconSize

	local iconStyle2 = resolveIconStyle(props.basePriceRobuxIconStyle, v2.Color.Content.Muted) -- inferred equivalent call

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = resolveTag(props.tag, "col fill auto-xy"), -- inferred equivalent call
		testId = props.testId
	}
	local title

	if v5 then
		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = 1,
			Text = props.title,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			fontStyle = fontStyle,
			Size = UDim2.new(1, 0, 0, v7),
			tag = resolveTag( -- inferred equivalent call
				props.titleTag,
				"size-full-0 text-wrap text-align-x-left text-truncate-end content-emphasis"
			),
			testId = 0
		}
		local testId

		if props.testId then
			testId = `{props.testId}--title`
		end

		v11.testId = testId
		title = createElement2(Text, v11)
	end

	local priceRow

	if v8 or v4 then
		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = 2,
			tag = resolveTag(props.priceRowTag, "row align-y-center gap-small auto-xy"), -- inferred equivalent call
			testId = 0
		}
		local testId

		if props.testId then
			testId = `{props.testId}--price-row`
		end

		v11.testId = testId
		local currentPrice

		if v8 then
			local createElement3 = React.createElement
			local v12 = {
				LayoutOrder = 1,
				tag = resolveTag(props.currentPriceTag, "row align-y-center gap-xsmall auto-xy"), -- inferred equivalent call
				testId = 0
			}
			local testId2

			if props.testId then
				testId2 = `{props.testId}--current-price`
			end

			v12.testId = testId2
			local robuxIcon

			if not hideRobuxIconInPrice then
				local createElement4 = React.createElement
				local v13 = {
					name = IconName.Robux,
					size = size,
					style = iconStyle,
					LayoutOrder = 1,
					testId = 0
				}
				local testId3

				if props.testId then
					testId3 = `{props.testId}--price-robux-icon`
				end

				v13.testId = testId3
				robuxIcon = createElement4(Icon, v13)
			end

			currentPrice = createElement3(View, v12, {
				RobuxIcon = robuxIcon,
				Price = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.priceText,
					tag = resolveTag(props.priceTextTag, "auto-xy text-align-x-left text-body-medium content-emphasis") -- inferred equivalent call
				})
			})
		end

		local basePrice

		if v9 then
			local createElement3 = React.createElement
			local v12 = {
				LayoutOrder = 2,
				tag = resolveTag(props.basePriceTag, "auto-xy"), -- inferred equivalent call
				testId = 0
			}
			local testId2

			if props.testId then
				testId2 = `{props.testId}--base-price`
			end

			v12.testId = testId2

			local createElement4 = React.createElement
			local v13 = {
				tag = resolveTag(props.basePriceContentTag, "row align-y-center gap-xsmall auto-xy") -- inferred equivalent call
			}

			local createElement5 = React.createElement
			local v14 = {
				name = IconName.Robux,
				size = size2,
				style = iconStyle2,
				LayoutOrder = 1,
				testId = 0
			}
			local testId3

			if props.testId then
				testId3 = `{props.testId}--base-price-robux-icon`
			end

			v14.testId = testId3
			local children = {
				Content = createElement4(View, v13, {
					RobuxIcon = createElement5(Icon, v14),
					Price = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.basePriceText,
						tag = resolveTag( -- inferred equivalent call
							props.basePriceTextTag,
							"auto-xy text-align-x-left text-body-small content-muted"
						)
					})
				}),
				Strikethrough = 0
			}

			local createElement6 = React.createElement
			local v15 = {
				tag = resolveTag( -- inferred equivalent call
					props.strikethroughTag,
					"bg-system-neutral position-center-center anchor-center-center"
				),
				Size = UDim2.new(1, 0, 0, 1),
				ZIndex = 2,
				testId = 0
			}
			local testId4

			if props.testId then
				testId4 = `{props.testId}--base-price-strikethrough`
			end

			v15.testId = testId4
			children.Strikethrough = createElement6(View, v15)
			basePrice = createElement3(View, v12, children)
		end

		local ownedCount

		if v4 then
			local createElement3 = React.createElement
			local v12 = {
				LayoutOrder = 3,
				tag = resolveTag(props.ownedCountTag, "row align-y-center gap-xsmall auto-xy"), -- inferred equivalent call
				testId = 0
			}
			local testId2

			if props.testId then
				testId2 = `{props.testId}--owned-count`
			end

			v12.testId = testId2
			local dot

			if v8 then
				local createElement4 = React.createElement
				local v13 = {
					LayoutOrder = 1,
					Text = resolveTag(props.ownedCountSeparatorText, "·"), -- inferred equivalent call
					tag = resolveTag(props.ownedCountSeparatorTag, "auto-xy text-body-medium content-default"), -- inferred equivalent call
					testId = 0
				}
				local testId3

				if props.testId then
					testId3 = `{props.testId}--owned-count-separator`
				end

				v13.testId = testId3
				dot = createElement4(Text, v13)
			end

			local createElement4 = React.createElement

			local v13 = {
				LayoutOrder = 2,
				title = "",
				text = text,
				side = PopoverSide.Top,
				align = PopoverAlign.Center
			}

			local createElement5 = React.createElement
			local v14 = {
				tag = "auto-xy",
				onStateChanged = function(_) end,
				testId = 0
			}
			local testId3

			if props.testId then
				testId3 = `{props.testId}--owned-count-tooltip`
			end

			v14.testId = testId3

			local createElement6 = React.createElement
			local v15 = {
				Text = pendingReceiptsCountText,
				tag = resolveTag(props.ownedCountTextTag, "auto-xy text-body-medium content-muted"), -- inferred equivalent call
				testId = 0
			}
			local testId4

			if props.testId then
				testId4 = `{props.testId}--owned-count-label`
			end

			v15.testId = testId4
			ownedCount = createElement3(View, v12, {
				Dot = dot,
				Label = createElement4(Tooltip, v13, createElement5(View, v14, {
					Text = createElement6(Text, v15)
				}))
			})
		end

		priceRow = createElement2(View, v11, {
			CurrentPrice = currentPrice,
			BasePrice = basePrice,
			OwnedCount = ownedCount
		})
	end

	return createElement(View, v10, { Title = title, PriceRow = priceRow })
end

return React.memo(SduiVirtualGameItemText)
