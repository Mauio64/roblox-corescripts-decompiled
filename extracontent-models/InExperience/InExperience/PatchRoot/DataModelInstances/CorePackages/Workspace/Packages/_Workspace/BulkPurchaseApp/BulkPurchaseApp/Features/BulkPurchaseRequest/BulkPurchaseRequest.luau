local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local LocalizationRoactContext = require(BulkPurchaseAppParent.Localization).LocalizationRoactContext
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ReactFocusNavigation = require(BulkPurchaseAppParent.ReactFocusNavigation)
local FullPagePrompt = require(BulkPurchaseApp.Components.FullPagePrompt)
local PriceBox = require(BulkPurchaseApp.Components.PriceBox)
local LineItemLayout = require(BulkPurchaseApp.Components.LineItemLayout)
local FullPagePromptTwoPanelLayout = require(BulkPurchaseApp.Components.FullPagePromptTwoPanelLayout)
local Divider = require(BulkPurchaseApp.Components.Divider)
local FullPagePromptScrollList = require(BulkPurchaseApp.Components.FullPagePromptScrollList)
local FFlagFixVP8143 = require(BulkPurchaseApp.Flags.FFlagFixVP8143)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local ItemList = require(BulkPurchaseApp.Components.ItemList)

require(BulkPurchaseAppParent.AvatarExperienceCommon)

local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

require(BulkPurchaseApp.Store.Types)
require(script.Parent.BulkPurchaseRequestItem)
require(script.Parent.BulkPurchaseRequestOwnedItem)
require(script.Parent.BulkPurchaseRequestUnpurchasableItem)

local ItemPresentationMapper = require(script.Parent.ItemPresentationMapper)
local mapItemsToRowPresentation = ItemPresentationMapper.mapItemsToRowPresentation
local mapOwnedItemsToRowPresentation = ItemPresentationMapper.mapOwnedItemsToRowPresentation
local mapUnpurchasableItemsToRowPresentation = ItemPresentationMapper.mapUnpurchasableItemsToRowPresentation
local t1 = {
	heading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.Heading",
	listHeading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemListPurchaseHeading",
	itemCount = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemListPurchaseCount",
	itemOwned = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemOwned"
}

local function BulkPurchaseRequest(t2: {[any]: any}) -- line: 63
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), LocalizationRoactContext (copy), ReactFocusNavigation (copy), FFlagFixVP8143 (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ItemStatusKeyToLocalizationKey (copy), mapItemsToRowPresentation (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy), mapOwnedItemsToRowPresentation (copy), mapUnpurchasableItemsToRowPresentation (copy), FullPagePrompt (copy), FullPagePromptTwoPanelLayout (copy), LineItemLayout (copy), StyledTextLabel (copy), FullPagePromptScrollList (copy), ItemList (copy), Divider (copy), PriceBox (copy)
	local v28 = useLocalization(t1)
	local v29 = React.useContext(LocalizationRoactContext)
	local v30, v31 = ReactFocusNavigation.useDefaultFocusBehavior()
	local v32 = if not FFlagFixVP8143 then nil else React.useCallback(function(p1) -- line: 68
		-- upvalues: t2 (copy), v30 (copy)
		if typeof(t2.purchaseButtonRef) == "table" then
			t2.purchaseButtonRef.current = p1
		end

		if typeof(v30) == "function" then
			v30(p1)

			return
		end

		if typeof(v30) == "table" then
			v30.current = p1
		end
	end, { t2.purchaseButtonRef })
	local v33 = useDesignTokens()
	local t3 = {
		LineHeight = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Typography.Body.LineHeight else v33.Typography.BodyLarge.LineHeight,
		Font = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Typography.Subheader.Font else v33.Typography.TitleLarge.Font,
		FontSize = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Typography.Body.FontSize else v33.Typography.BodyLarge.FontSize,
		LetterSpacing = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Typography.Body.LetterSpacing else v33.Typography.BodyLarge.LetterSpacing
	}
	local v35 = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Color.Text.Emphasis else v33.Color.Content.Emphasis
	local v36, v37 = React.useBinding(Vector2.new(0, 0))
	local v38 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v39 = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Color.Common.Success else v33.Color.System.Success
	local v40 = if not FFlagRenameDeprecatedUIBloxTokens then v33.Semantic.Color.Common.Alert else v33.Color.System.Alert
	local v41 = mapItemsToRowPresentation(t2.items, if not FFlagBulkPurchaseEnablePurchaseOptions then nil else v29)
	local t4 = {}
	local v43 = mapOwnedItemsToRowPresentation(t2.ownedItems, v35, v28)
	local v44 = mapUnpurchasableItemsToRowPresentation(t2.unpurchasableItems, v38, v39, v40)

	table.move(v43, 1, #v43, #t4 + 1, t4)
	table.move(v44, 1, #v44, #t4 + 1, t4)

	local v45 = #t4 > 0

	return React.createElement(FullPagePrompt, {
		onClose = t2.onClose,
		title = v28.heading,
		ref = v31
	}, React.createElement(FullPagePromptTwoPanelLayout, {
		size = React.createBinding(UDim2.fromScale(1, 1)),
		startSlot = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v33.Global.Space_300 else v33.Size.Size_600)
		}), React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			[React.Change.AbsoluteSize] = function(p2) -- line: 163
				-- upvalues: v37 (copy)
				v37(p2.AbsoluteSize)
			end
		}, React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v33.Global.Space_125 else v33.Size.Size_250)
		}), React.createElement(LineItemLayout, {
			LayoutOrder = 1,
			startSlot = React.createElement(StyledTextLabel, {
				fontStyle = t3,
				colorStyle = v35,
				text = v28.listHeading
			}),
			endSlot = React.createElement(StyledTextLabel, {
				fontStyle = t3,
				colorStyle = v35,
				text = v28.itemCount:gsub("{.*}", (tostring(#t2.items)))
			})
		})), React.createElement(FullPagePromptScrollList, {
			LayoutOrder = 2,
			size = v36:map(function(vector2: Vector2) -- line: 194
				-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), v33 (copy)
				return UDim2.new(1, 0, 1, -(vector2.Y + if not FFlagRenameDeprecatedUIBloxTokens then v33.Global.Space_300 else v33.Size.Size_600))
			end)
		}, React.createElement(ItemList, {
			items = v41
		}), if not v45 then nil else React.createElement(Divider), if not v45 then nil else React.createElement(ItemList, {
			items = t4
		}))),
		endSlot = React.createElement(PriceBox, {
			currentBalance = t2.currentBalance,
			totalCost = t2.totalCost,
			discountInformation = t2.discountInformation,
			missingRobux = t2.currentBalance - t2.totalCost < 0,
			onAccept = t2.onAccept,
			buttonRef = if not FFlagFixVP8143 then v30 else v32,
			isDisabled = t2.isDisabled
		})
	}))
end

return BulkPurchaseRequest
