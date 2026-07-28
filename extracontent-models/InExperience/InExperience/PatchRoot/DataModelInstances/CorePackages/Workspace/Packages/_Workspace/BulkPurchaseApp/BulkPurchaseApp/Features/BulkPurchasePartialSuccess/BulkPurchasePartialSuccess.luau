local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
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

local function toCardPropsWithId(p1, s1: string) -- line: 32
	local v28 = table.clone(p1)

	v28.id = s1

	return v28
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

local function mapTokens(p2) -- line: 58
	return {
		boxBackground = p2.Color.Surface.Surface_100.Color3,
		boxPadding = p2.Size.Size_600,
		boxCornerRadius = p2.Radius.Medium,
		buttonMarginTop = p2.Size.Size_400,
		buttonHeight = p2.Size.Size_900,
		lineItemSpacing = p2.Size.Size_100,
		noticeFontStyle = p2.Typography.BodyLarge,
		noticeColorStyle = p2.Color.Content.Muted,
		noticeMarginBottom = p2.Size.Size_600,
		successColor = p2.Color.System.Success,
		failureColor = p2.Color.System.Alert
	}
end
local function mapBulkPurchasePartialSuccessItemsToRowPresentation(t2: {[any]: any}, t3: {[any]: any}, p3, p4) -- line: 74
	-- upvalues: ItemStatusToItemStatusKey (copy), React (copy), ItemCardThumbnail (copy)
	local t4 = {}

	for _, v36 in t2 do
		local v37 = t3[ItemStatusToItemStatusKey[v36.status]]
		local v38 = if v36.status ~= Enum.MarketplaceItemPurchaseStatus.Success then p4 else p3
		local t5 = {
			type = "text",
			text = v37,
			colorStyle = v38
		}
		local t6 = {
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = v36.image
			}),
			title = v36.name,
			priceLineContent = { t5 }
		}
		local id = v36.id
		local v42 = table.clone(t6)

		v42.id = id
		table.insert(t4, v42)
	end

	return t4
end
local function BulkPurchasePartialSuccess(t7: {[any]: any}) -- line: 111
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useLocalization (copy), t1 (copy), ItemStatusKeyToLocalizationKey (copy), React (copy), FullPagePrompt (copy), StyledTextLabel (copy), FullPagePromptTwoPanelLayout (copy), FullPagePromptScrollList (copy), ItemListHeader (copy), ItemList (copy), mapBulkPurchasePartialSuccessItemsToRowPresentation (copy), Divider (copy), Box (copy), PriceBoxLine_DEPRECATED (copy), Button (copy), ButtonType (copy)
	local v44 = useDesignTokens(mapTokens)
	local v45 = useLocalization(t1)
	local v46 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v47, v48 = React.useBinding(Vector2.new(0, 0))
	local v49 = #t7.successfulItems > 0

	return React.createElement(FullPagePrompt, {
		onClose = t7.onDismiss,
		title = if not v49 then v45.unsuccessfulHeading else v45.heading
	}, React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v44.noticeMarginBottom)
	}), React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p5) -- line: 137
			-- upvalues: v48 (copy)
			v48(p5.AbsoluteSize)
		end
	}, React.createElement(StyledTextLabel, {
		layoutOrder = 1,
		fontStyle = v44.noticeFontStyle,
		colorStyle = v44.noticeColorStyle,
		text = v45.notice,
		automaticSize = Enum.AutomaticSize.XY
	})), React.createElement(FullPagePromptTwoPanelLayout, {
		LayoutOrder = 2,
		size = v47:map(function(vector2: Vector2) -- line: 151
			-- upvalues: v44 (copy)
			return UDim2.new(1, 0, 1, -(vector2.Y + v44.noticeMarginBottom))
		end),
		startSlot = React.createElement(FullPagePromptScrollList, {
			LayoutOrder = 1,
			size = React.createBinding(UDim2.fromScale(1, 1))
		}, React.createElement(ItemListHeader, {
			LayoutOrder = 1,
			heading = v45.itemListUnsuccessfulHeading,
			itemCount = v45.itemListUnsuccessfulCount:gsub("{.*}", (tostring(#t7.unsuccessfulItems)))
		}), React.createElement(ItemList, {
			LayoutOrder = 2,
			items = mapBulkPurchasePartialSuccessItemsToRowPresentation(t7.unsuccessfulItems, v46, v44.successColor, v44.failureColor)
		}), if not v49 then nil else React.createElement(Divider, {
			LayoutOrder = 3
		}), if not v49 then nil else React.createElement(ItemListHeader, {
			LayoutOrder = 4,
			heading = v45.itemListSuccessfulHeading,
			itemCount = v45.itemListSuccessfulCount:gsub("{.*}", (tostring(#t7.successfulItems)))
		}), if not v49 then nil else React.createElement(ItemList, {
			LayoutOrder = 5,
			items = mapBulkPurchasePartialSuccessItemsToRowPresentation(t7.successfulItems, v46, v44.successColor, v44.failureColor)
		})),
		endSlot = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v44.buttonMarginTop)
		}), React.createElement(Box, {
			BorderSizePixel = 0,
			padding = v44.boxPadding,
			cornerRadius = UDim.new(0, v44.boxCornerRadius),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v44.boxBackground
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v44.lineItemSpacing)
			}),
			RobuxSpent = React.createElement(PriceBoxLine_DEPRECATED, {
				highlight = true,
				LayoutOrder = 1,
				text = v45.robuxSpent,
				amount = t7.robuxSpent
			}),
			CurrentBalance = React.createElement(PriceBoxLine_DEPRECATED, {
				LayoutOrder = 2,
				text = v45.currentBalance,
				amount = t7.currentBalance
			})
		}), React.createElement(Button, {
			text = v45.dismissCTA,
			onActivated = t7.onDismiss,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, v44.buttonHeight)
		}))
	}))
end

return BulkPurchasePartialSuccess
