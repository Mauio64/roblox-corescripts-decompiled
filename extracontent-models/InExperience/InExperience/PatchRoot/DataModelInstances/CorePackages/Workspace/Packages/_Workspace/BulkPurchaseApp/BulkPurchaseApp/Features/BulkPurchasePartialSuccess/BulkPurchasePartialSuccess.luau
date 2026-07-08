local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
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

require(BulkPurchaseAppParent.Style)

local ItemCardThumbnail = require(BulkPurchaseAppParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local ItemList = require(BulkPurchaseApp.Components.ItemList)

require(BulkPurchaseAppParent.AvatarExperienceCommon)

local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

local function toCardPropsWithId(p1, s1: string) -- line: 34
	local v29 = table.clone(p1)

	v29.id = s1

	return v29
end

local t1 = {
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

local function mapTokens(p2) -- line: 60
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		boxBackground = ((if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Color.Background.Contrast else p2.Color.Surface.Surface_100)).Color3,
		boxPadding = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_300 else p2.Size.Size_600,
		boxCornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Radius.Medium else p2.Radius.Medium,
		buttonMarginTop = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_200 else p2.Size.Size_400,
		buttonHeight = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_450 else p2.Size.Size_900,
		lineItemSpacing = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_50 else p2.Size.Size_100,
		noticeFontStyle = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Typography.Body else p2.Typography.BodyLarge,
		noticeColorStyle = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Color.Text.Muted else p2.Color.Content.Muted,
		noticeMarginBottom = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_300 else p2.Size.Size_600,
		successColor = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Color.Common.Success else p2.Color.System.Success,
		failureColor = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Color.Common.Alert else p2.Color.System.Alert
	}
end
local function mapBulkPurchasePartialSuccessItemsToRowPresentation(t2: {[any]: any}, t3: {[any]: any}, p3, p4) -- line: 90
	-- upvalues: ItemStatusToItemStatusKey (copy), React (copy), ItemCardThumbnail (copy)
	local t4 = {}

	for _, v37 in t2 do
		local v38 = t3[ItemStatusToItemStatusKey[v37.status]]
		local v39 = if v37.status ~= Enum.MarketplaceItemPurchaseStatus.Success then p4 else p3
		local t5 = {
			type = "text",
			text = v38,
			colorStyle = v39
		}
		local t6 = {
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = v37.image
			}),
			title = v37.name,
			priceLineContent = { t5 }
		}
		local id = v37.id
		local v43 = table.clone(t6)

		v43.id = id
		table.insert(t4, v43)
	end

	return t4
end
local function BulkPurchasePartialSuccess(t7: {[any]: any}) -- line: 127
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useLocalization (copy), t1 (copy), ItemStatusKeyToLocalizationKey (copy), React (copy), FullPagePrompt (copy), StyledTextLabel (copy), FullPagePromptTwoPanelLayout (copy), FullPagePromptScrollList (copy), ItemListHeader (copy), ItemList (copy), mapBulkPurchasePartialSuccessItemsToRowPresentation (copy), Divider (copy), Box (copy), PriceBoxLine_DEPRECATED (copy), Button (copy), ButtonType (copy)
	local v45 = useDesignTokens(mapTokens)
	local v46 = useLocalization(t1)
	local v47 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v48, v49 = React.useBinding(Vector2.new(0, 0))
	local v50 = #t7.successfulItems > 0

	return React.createElement(FullPagePrompt, {
		onClose = t7.onDismiss,
		title = if not v50 then v46.unsuccessfulHeading else v46.heading
	}, React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v45.noticeMarginBottom)
	}), React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p5) -- line: 153
			-- upvalues: v49 (copy)
			v49(p5.AbsoluteSize)
		end
	}, React.createElement(StyledTextLabel, {
		layoutOrder = 1,
		fontStyle = v45.noticeFontStyle,
		colorStyle = v45.noticeColorStyle,
		text = v46.notice,
		automaticSize = Enum.AutomaticSize.XY
	})), React.createElement(FullPagePromptTwoPanelLayout, {
		LayoutOrder = 2,
		size = v48:map(function(vector2: Vector2) -- line: 167
			-- upvalues: v45 (copy)
			return UDim2.new(1, 0, 1, -(vector2.Y + v45.noticeMarginBottom))
		end),
		startSlot = React.createElement(FullPagePromptScrollList, {
			LayoutOrder = 1,
			size = React.createBinding(UDim2.fromScale(1, 1))
		}, React.createElement(ItemListHeader, {
			LayoutOrder = 1,
			heading = v46.itemListUnsuccessfulHeading,
			itemCount = v46.itemListUnsuccessfulCount:gsub("{.*}", (tostring(#t7.unsuccessfulItems)))
		}), React.createElement(ItemList, {
			LayoutOrder = 2,
			items = mapBulkPurchasePartialSuccessItemsToRowPresentation(t7.unsuccessfulItems, v47, v45.successColor, v45.failureColor)
		}), if not v50 then nil else React.createElement(Divider, {
			LayoutOrder = 3
		}), if not v50 then nil else React.createElement(ItemListHeader, {
			LayoutOrder = 4,
			heading = v46.itemListSuccessfulHeading,
			itemCount = v46.itemListSuccessfulCount:gsub("{.*}", (tostring(#t7.successfulItems)))
		}), if not v50 then nil else React.createElement(ItemList, {
			LayoutOrder = 5,
			items = mapBulkPurchasePartialSuccessItemsToRowPresentation(t7.successfulItems, v47, v45.successColor, v45.failureColor)
		})),
		endSlot = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v45.buttonMarginTop)
		}), React.createElement(Box, {
			BorderSizePixel = 0,
			padding = v45.boxPadding,
			cornerRadius = UDim.new(0, v45.boxCornerRadius),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v45.boxBackground
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v45.lineItemSpacing)
			}),
			RobuxSpent = React.createElement(PriceBoxLine_DEPRECATED, {
				highlight = true,
				LayoutOrder = 1,
				text = v46.robuxSpent,
				amount = t7.robuxSpent
			}),
			CurrentBalance = React.createElement(PriceBoxLine_DEPRECATED, {
				LayoutOrder = 2,
				text = v46.currentBalance,
				amount = t7.currentBalance
			})
		}), React.createElement(Button, {
			text = v46.dismissCTA,
			onActivated = t7.onDismiss,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, v45.buttonHeight)
		}))
	}))
end

return BulkPurchasePartialSuccess
