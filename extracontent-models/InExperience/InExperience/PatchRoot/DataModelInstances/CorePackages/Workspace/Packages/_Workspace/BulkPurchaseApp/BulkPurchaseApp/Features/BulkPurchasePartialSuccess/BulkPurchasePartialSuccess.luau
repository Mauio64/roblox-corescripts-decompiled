local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local FullPagePrompt = require(BulkPurchaseApp.Components.FullPagePrompt)
local FullPagePromptTwoPanelLayout = require(BulkPurchaseApp.Components.FullPagePromptTwoPanelLayout)
local Divider = require(BulkPurchaseApp.Components.Divider)
local ItemListHeader = require(BulkPurchaseApp.Components.ItemListHeader)
local FullPagePromptScrollList = require(BulkPurchaseApp.Components.FullPagePromptScrollList)
local Box = require(BulkPurchaseApp.Components.Box)
local PriceBoxLine_DEPRECATED = require(BulkPurchaseApp.Components.PriceBoxLine_DEPRECATED)

require(parent.Style)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local ItemList = require(BulkPurchaseApp.Components.ItemList)
require(parent.AvatarExperienceCommon)

local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

local function toCardPropsWithId(p, id: string) -- 1 equivalent call inferred from this helper
	local clone = table.clone(p)
	clone.id = id
	return clone
end

local v = {
	heading = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.Heading",
	unsuccessfulHeading = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorHeading",
	notice = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.Notice",
	itemListSuccessfulCount = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.ItemListSuccessfulCount",
	itemListUnsuccessfulCount = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.ItemListUnsuccessfulCount",
	itemListSuccessfulHeading = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.ItemListSuccessfulHeading",
	itemListUnsuccessfulHeading = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.ItemListUnsuccessfulHeading",
	robuxSpent = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.PriceBox.RobuxSpent",
	currentBalance = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.PriceBox.CurrentBalance",
	dismissCTA = "CoreScripts.BulkPurchasePrompt.PartialPurchaseCompletedPrompt.PriceBox.DismissCTA"
}

local function mapTokens(data)
	return {
		boxBackground = data.Color.Surface.Surface_100.Color3,
		boxPadding = data.Size.Size_600,
		boxCornerRadius = data.Radius.Medium,
		buttonMarginTop = data.Size.Size_400,
		buttonHeight = data.Size.Size_900,
		lineItemSpacing = data.Size.Size_100,
		noticeFontStyle = data.Typography.BodyLarge,
		noticeColorStyle = data.Color.Content.Muted,
		noticeMarginBottom = data.Size.Size_600,
		successColor = data.Color.System.Success,
		failureColor = data.Color.System.Alert
	}
end

local function mapBulkPurchasePartialSuccessItemsToRowPresentation(items, p, successColor, failureColor)
	local result = {}

	for _, item in items do
		local text = p[ItemStatusToItemStatusKey[item.status]]
		local colorStyle

		if item.status == Enum.MarketplaceItemPurchaseStatus.Success then
			colorStyle = successColor
		else
			colorStyle = failureColor
		end

		table.insert(result, toCardPropsWithId({ -- inferred equivalent call
			presentationSlot = React.createElement(ItemCardThumbnail, { url = item.image }),
			title = item.name,
			priceLineContent = {
				{ type = "text", text = text, colorStyle = colorStyle }
			}
		}, item.id))
	end

	return result
end

local function BulkPurchasePartialSuccess(props)
	local v2 = useDesignTokens(mapTokens)
	local v3 = useLocalization(v)
	local v4 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v5, v6 = React.useBinding(Vector2.new(0, 0))
	local v7 = #props.successfulItems > 0

	local createElement = React.createElement

	local v8 = { onClose = props.onDismiss, title = 0 }
	local title = if v7 then v3.heading else v3.unsuccessfulHeading
	v8.title = title

	local element = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v2.noticeMarginBottom)
	})

	local element2 = React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p)
			v6(p.AbsoluteSize)
		end
	}, React.createElement(StyledTextLabel, {
		fontStyle = v2.noticeFontStyle,
		colorStyle = v2.noticeColorStyle,
		text = v3.notice,
		layoutOrder = 1,
		automaticSize = Enum.AutomaticSize.XY
	}))

	local createElement2 = React.createElement
	local children = {
		LayoutOrder = 2,
		size = v5:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 1, -(vector2.Y + v2.noticeMarginBottom))
		end),
		startSlot = 0,
		endSlot = 0
	}

	local createElement3 = React.createElement

	local v9 = {
		LayoutOrder = 1,
		size = React.createBinding(UDim2.fromScale(1, 1))
	}
	local element3 = React.createElement(ItemListHeader, {
		heading = v3.itemListUnsuccessfulHeading,
		itemCount = v3.itemListUnsuccessfulCount:gsub("{.*}", (tostring(#props.unsuccessfulItems))),
		LayoutOrder = 1
	})

	local element4 = React.createElement(ItemList, {
		items = mapBulkPurchasePartialSuccessItemsToRowPresentation(
			props.unsuccessfulItems,
			v4,
			v2.successColor,
			v2.failureColor
		),
		LayoutOrder = 2
	})
	local v10

	if v7 then
		v10 = React.createElement(Divider, { LayoutOrder = 3 })
	end

	local v11

	if v7 then
		v11 = React.createElement(ItemListHeader, {
			heading = v3.itemListSuccessfulHeading,
			itemCount = v3.itemListSuccessfulCount:gsub("{.*}", (tostring(#props.successfulItems))),
			LayoutOrder = 4
		})
	end

	local v12

	if v7 then
		v12 = React.createElement(ItemList, {
			items = mapBulkPurchasePartialSuccessItemsToRowPresentation(
				props.successfulItems,
				v4,
				v2.successColor,
				v2.failureColor
			),
			LayoutOrder = 5
		})
	end

	children.startSlot = createElement3(FullPagePromptScrollList, v9, element3, element4, v10, v11, v12)

	children.endSlot = React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v2.buttonMarginTop)
		}),
		React.createElement(Box, {
			padding = v2.boxPadding,
			cornerRadius = UDim.new(0, v2.boxCornerRadius),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v2.boxBackground,
			BorderSizePixel = 0
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v2.lineItemSpacing)
			}),
			RobuxSpent = React.createElement(PriceBoxLine_DEPRECATED, {
				text = v3.robuxSpent,
				amount = props.robuxSpent,
				highlight = true,
				LayoutOrder = 1
			}),
			CurrentBalance = React.createElement(PriceBoxLine_DEPRECATED, {
				text = v3.currentBalance,
				amount = props.currentBalance,
				LayoutOrder = 2
			})
		}),
		React.createElement(Button, {
			text = v3.dismissCTA,
			onActivated = props.onDismiss,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, v2.buttonHeight)
		})
	)
	return createElement(FullPagePrompt, v8, element, element2, createElement2(FullPagePromptTwoPanelLayout, children))
end

return BulkPurchasePartialSuccess
