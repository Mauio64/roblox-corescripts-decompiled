local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local LocalizationRoactContext = require(BulkPurchaseAppParent.Localization).LocalizationRoactContext
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local StyledTextLabel = require(BulkPurchaseAppParent.UIBlox).App.Text.StyledTextLabel
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

local function BulkPurchaseRequest(t2: {[any]: any}) -- line: 61
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), LocalizationRoactContext (copy), ReactFocusNavigation (copy), FFlagFixVP8143 (copy), useDesignTokens (copy), ItemStatusKeyToLocalizationKey (copy), mapItemsToRowPresentation (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy), mapOwnedItemsToRowPresentation (copy), mapUnpurchasableItemsToRowPresentation (copy), FullPagePrompt (copy), FullPagePromptTwoPanelLayout (copy), LineItemLayout (copy), StyledTextLabel (copy), FullPagePromptScrollList (copy), ItemList (copy), Divider (copy), PriceBox (copy)
	local v26 = useLocalization(t1)
	local v27 = React.useContext(LocalizationRoactContext)
	local v28, v29 = ReactFocusNavigation.useDefaultFocusBehavior()
	local v30 = if not FFlagFixVP8143 then nil else React.useCallback(function(p1) -- line: 66
		-- upvalues: t2 (copy), v28 (copy)
		if typeof(t2.purchaseButtonRef) == "table" then
			t2.purchaseButtonRef.current = p1
		end

		if typeof(v28) == "function" then
			v28(p1)

			return
		end

		if typeof(v28) == "table" then
			v28.current = p1
		end
	end, { t2.purchaseButtonRef })
	local v31 = useDesignTokens()
	local t3 = {
		LineHeight = v31.Typography.BodyLarge.LineHeight,
		Font = v31.Typography.TitleLarge.Font,
		FontSize = v31.Typography.BodyLarge.FontSize,
		LetterSpacing = v31.Typography.BodyLarge.LetterSpacing
	}
	local Emphasis = v31.Color.Content.Emphasis
	local v34, v35 = React.useBinding(Vector2.new(0, 0))
	local v36 = useLocalization(ItemStatusKeyToLocalizationKey)
	local Success = v31.Color.System.Success
	local Alert = v31.Color.System.Alert
	local v39 = mapItemsToRowPresentation(t2.items, if not FFlagBulkPurchaseEnablePurchaseOptions then nil else v27)
	local t4 = {}
	local v41 = mapOwnedItemsToRowPresentation(t2.ownedItems, Emphasis, v26)
	local v42 = mapUnpurchasableItemsToRowPresentation(t2.unpurchasableItems, v36, Success, Alert)

	table.move(v41, 1, #v41, #t4 + 1, t4)
	table.move(v42, 1, #v42, #t4 + 1, t4)

	local v43 = #t4 > 0

	return React.createElement(FullPagePrompt, {
		onClose = t2.onClose,
		title = v26.heading,
		ref = v29
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
			Padding = UDim.new(0, v31.Size.Size_600)
		}), React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			[React.Change.AbsoluteSize] = function(p2) -- line: 134
				-- upvalues: v35 (copy)
				v35(p2.AbsoluteSize)
			end
		}, React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v31.Size.Size_250)
		}), React.createElement(LineItemLayout, {
			LayoutOrder = 1,
			startSlot = React.createElement(StyledTextLabel, {
				fontStyle = t3,
				colorStyle = Emphasis,
				text = v26.listHeading
			}),
			endSlot = React.createElement(StyledTextLabel, {
				fontStyle = t3,
				colorStyle = Emphasis,
				text = v26.itemCount:gsub("{.*}", (tostring(#t2.items)))
			})
		})), React.createElement(FullPagePromptScrollList, {
			LayoutOrder = 2,
			size = v34:map(function(vector2: Vector2) -- line: 158
				-- upvalues: v31 (copy)
				return UDim2.new(1, 0, 1, -(vector2.Y + v31.Size.Size_600))
			end)
		}, React.createElement(ItemList, {
			items = v39
		}), if not v43 then nil else React.createElement(Divider), if not v43 then nil else React.createElement(ItemList, {
			items = t4
		}))),
		endSlot = React.createElement(PriceBox, {
			currentBalance = t2.currentBalance,
			totalCost = t2.totalCost,
			discountInformation = t2.discountInformation,
			missingRobux = t2.currentBalance - t2.totalCost < 0,
			onAccept = t2.onAccept,
			buttonRef = if not FFlagFixVP8143 then v28 else v30,
			isDisabled = t2.isDisabled
		})
	}))
end

return BulkPurchaseRequest
