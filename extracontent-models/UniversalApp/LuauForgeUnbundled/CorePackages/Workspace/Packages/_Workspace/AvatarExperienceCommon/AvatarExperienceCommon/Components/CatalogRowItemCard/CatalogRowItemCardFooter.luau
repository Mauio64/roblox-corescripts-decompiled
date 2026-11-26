local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/VerifiedBadges")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit")
local itemCardPriceLine = AvatarExperienceUIKit.ItemCardComponents.ItemCardPriceLine
local itemCardTitle = AvatarExperienceUIKit.ItemCardComponents.ItemCardTitle
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TimedOptionType")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local fFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local fFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip

local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

local function CatalogRowItemCardFooter(props)
	local v5 = useTokens()
	local selectedTimedOptionPrice, setSelectedTimedOptionPrice

	if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then
		selectedTimedOptionPrice = props.selectedTimedOptionPrice
		setSelectedTimedOptionPrice = props.setSelectedTimedOptionPrice
	else
		selectedTimedOptionPrice = nil
		setSelectedTimedOptionPrice = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		if not (props.priceLineContent and #props.priceLineContent > 0) then
			return children
		end

		for k, v6 in props.priceLineContent do
			local joined = Cryo.Dictionary.omit(v6, { "strikethrough" })

			if
				(fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard)
				and selectedTimedOptionPrice
				and v6.type == "price"
			then
				if v6.isOriginalPrice and props.timedOptions then
					local v7 = selectedTimedOptionPrice

					for k2, timedOption in props.timedOptions do
						if
							timedOption.price == selectedTimedOptionPrice
							and timedOption.discountInformation
						then
							v7 = timedOption.discountInformation.originalPrice
							break
						end
					end

					joined = Cryo.Dictionary.join(joined, { price = v7 })

					if
						v7 == selectedTimedOptionPrice
						and (not fFlagAXMISWithOffers or fFlagAXMISWithOffers and not v6.shouldShowOriginalPrice)
					then
						continue
					end
				else
					joined = Cryo.Dictionary.join(joined, {
						price = selectedTimedOptionPrice
					})
				end
			end

			if fFlagAXMISWithOffers and v6.priceInRobuxDiscountedByOffers then
				joined = Cryo.Dictionary.join(joined, {
					price = v6.priceInRobuxDiscountedByOffers
				})
			end

			if
				(fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard)
				and v6.strikethrough
			then
				joined = Cryo.Dictionary.join(joined, {
					colorStyle = v5.Color.Content.Muted,
					iconSize = iconSize.XSmall,
					fontStyle = v5.Typography.BodySmall
				})
			end

			local formatted = `PriceLine{k}`
			local createElement = React.createElement
			local view = Foundation.View

			local v8 = {
				ItemCardPriceLine = React.createElement(itemCardPriceLine, {
					content = joined
				}),
				Strikethrough = 0
			}
			local v9

			if v6.strikethrough then
				local createElement2 = React.createElement
				local view2 = Foundation.View

				local v11 = if fFlagAXMISSmallUIChanges then UDim2.new(1, 0, 0, 1) else nil
				v9 = createElement2(view2, {
					tag = "bg-system-neutral anchor-center-center position-center-center size-full-50",
					Size = v11
				})
			end

			v8.Strikethrough = v9
			children[formatted] = createElement(view, {
				tag = "auto-xy",
				LayoutOrder = k
			}, v8)
		end

		return children
	end

	local priceLineContent = props.priceLineContent
	local v7

	if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then
		v7 = selectedTimedOptionPrice
	end

	local timedOptions

	if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then
		timedOptions = props.timedOptions
	end

	local v8 = if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then v5 else nil
	local v9 = useMemo(fn, { priceLineContent, v7, timedOptions, v8 })
	local v10

	if fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard then
		v10 = props.priceLineContent and #props.priceLineContent > 0 and true or props.timedOptions
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v11 = {
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		LayoutOrder = props.LayoutOrder,
		tag = "fill self-stretch"
	}
	local onRemove

	if fFlagAXGifting then
		onRemove = props.onRemove or props.giftButton
	else
		onRemove = fFlagAXDurables2Option and props.onRemove
	end

	local v13

	if onRemove then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local view3 = Foundation.View

		local v17 = {
			ItemCardFooterTitle = React.createElement(itemCardTitle, {
				title = props.title or "",
				LayoutOrder = 1
			}),
			ItemCardFooterInfo = 0,
			BundleParts = 0
		}
		local v18

		if props.itemSubType or props.creatorName then
			local createElement4 = React.createElement
			local view4 = Foundation.View

			local v21 = if props.itemSubType then React.createElement(text, {
				textStyle = v5.Color.Content.Default,
				fontStyle = v5.Typography.BodyMedium,
				LayoutOrder = 1,
				Text = props.itemSubType,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextTruncate = Enum.TextTruncate.SplitWord
			}) else nil

			local v22 = if props.itemSubType and not fFlagAXMISSmallUIChanges then React.createElement(icon, {
				name = "icons/controls/keys/period",
				size = iconSize.Small,
				LayoutOrder = 2
			}) else nil

			local v23 = if props.creatorName and fFlagAXMISSmallUIChanges then React.createElement(icon, {
				name = "icons/controls/keys/period",
				size = iconSize.Small,
				LayoutOrder = 2
			}) else nil
			local v24

			if props.creatorName then
				local createElement5 = React.createElement
				local v26 = {
					tag = "fill self-stretch",
					textStyle = v5.Color.Content.Default,
					fontStyle = v5.Typography.BodyMedium,
					LayoutOrder = 3,
					Text = 0,
					TextXAlignment = 0,
					AutomaticSize = 0,
					TextTruncate = 0
				}

				local v27 = if props.creatorHasVerifiedBadge then `{props.creatorName}{module3.emoji.verified}` else props.creatorName
				v26.Text = v27

				v26.TextXAlignment = Enum.TextXAlignment.Left
				v26.AutomaticSize = Enum.AutomaticSize.XY
				v26.TextTruncate = Enum.TextTruncate.SplitWord
				v24 = createElement5(text, v26)
			end

			v18 = createElement4(
				view4,
				{
					tag = "row align-x-left gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 2
				},
				{ ItemSubType = v21, Spacer = v22, Divider = v23, CreatorName = v24 }
			)
		end

		v17.ItemCardFooterInfo = v18

		local v19 = if props.bundlePartsText and not props.timedOptions then React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-xsmall radius-small bg-surface-100",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(text, {
					textStyle = v5.Color.Content.Default,
					fontStyle = v5.Typography.BodySmall,
					Text = props.bundlePartsText,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			}
		) else nil
		v17.BundleParts = v19
		local v15 = {
			Left = createElement3(
				view3,
				{
					tag = "col align-x-left fill gap-xsmall size-full-0 auto-y",
					LayoutOrder = 1
				},
				v17
			),
			Right = 0
		}
		local v20

		if props.onRemove or fFlagAXGifting and props.giftButton then
			local createElement4 = React.createElement
			local view4 = Foundation.View
			local v21 = {
				tag = fFlagAXGifting and {
					["auto-xy"] = true,
					["row gap-small"] = props.giftButton ~= nil
				} or "auto-xy",
				LayoutOrder = 2
			}
			local v22

			if fFlagAXGifting then
				v22 = { GiftButton = 0, RemoveButton = 0 }
				local v23 = if props.giftButton ~= nil then React.createElement(
					Foundation.View,
					{
						tag = "auto-xy",
						LayoutOrder = 1,
						testId = "catalogRowItemCardGiftButton"
					},
					props.giftButton
				) else nil
				v22.GiftButton = v23

				local v24 = if props.onRemove then React.createElement(Foundation.IconButton, {
					icon = "x",
					isCircular = true,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = props.onRemove,
					testId = "catalogRowItemCardRemoveButton",
					LayoutOrder = 2
				}) else nil
				v22.RemoveButton = v24
			elseif props.onRemove then
				v22 = React.createElement(Foundation.IconButton, {
					icon = "x",
					isCircular = true,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = props.onRemove,
					testId = "catalogRowItemCardRemoveButton"
				})
			end

			v20 = createElement4(view4, v21, v22)
		end

		v15.Right = v20
		v13 = createElement2(view2, { tag = "row size-full-0 auto-y" }, v15)
	else
		local createElement2 = React.createElement
		local v15 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v16 = {
			TopLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v5.Gap.XSmall)
			}),
			ItemCardFooterTitle = React.createElement(itemCardTitle, {
				title = props.title or "",
				LayoutOrder = 1
			}),
			ItemCardFooterInfo = 0,
			BundleParts = 0
		}
		local v17

		if props.itemSubType or props.creatorName then
			local createElement3 = React.createElement
			local v19 = {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2
			}

			local v20 = {
				ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v5.Gap.XXSmall)
				}),
				ItemSubType = 0,
				Spacer = 0,
				Divider = 0,
				CreatorName = 0
			}

			local v21 = if props.itemSubType then React.createElement(text, {
				textStyle = v5.Color.Content.Default,
				fontStyle = v5.Typography.BodyMedium,
				LayoutOrder = 1,
				Text = props.itemSubType,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextTruncate = Enum.TextTruncate.SplitWord
			}) else nil
			v20.ItemSubType = v21

			local v22 = if props.itemSubType and not fFlagAXMISSmallUIChanges then React.createElement(icon, {
				name = "icons/controls/keys/period",
				size = iconSize.Small,
				LayoutOrder = 2
			}) else nil
			v20.Spacer = v22

			local v23 = if props.creatorName and fFlagAXMISSmallUIChanges then React.createElement(icon, {
				name = "icons/controls/keys/period",
				size = iconSize.Small,
				LayoutOrder = 2
			}) else nil
			v20.Divider = v23
			local v24

			if props.creatorName then
				local createElement4 = React.createElement
				local v26 = {
					tag = "fill self-stretch",
					textStyle = v5.Color.Content.Default,
					fontStyle = v5.Typography.BodyMedium,
					LayoutOrder = 3,
					Text = 0,
					TextXAlignment = 0,
					AutomaticSize = 0,
					TextTruncate = 0
				}

				local v27 = if props.creatorHasVerifiedBadge then `{props.creatorName}{module3.emoji.verified}` else props.creatorName
				v26.Text = v27

				v26.TextXAlignment = Enum.TextXAlignment.Left
				v26.AutomaticSize = Enum.AutomaticSize.XY
				v26.TextTruncate = Enum.TextTruncate.SplitWord
				v24 = createElement4(text, v26)
			end

			v20.CreatorName = v24
			v17 = createElement3("Frame", v19, v20)
		end

		v16.ItemCardFooterInfo = v17

		local v18 = if props.bundlePartsText then React.createElement(
			"Frame",
			{
				LayoutOrder = 3,
				BackgroundColor3 = v5.Color.Surface.Surface_100.Color3,
				BackgroundTransparency = v5.Color.Surface.Surface_100.Transparency,
				AutomaticSize = Enum.AutomaticSize.XY
			},
			{
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Small)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v5.Padding.XSmall),
					PaddingLeft = UDim.new(0, v5.Padding.XSmall),
					PaddingRight = UDim.new(0, v5.Padding.XSmall),
					PaddingBottom = UDim.new(0, v5.Padding.XSmall)
				}),
				Text = React.createElement(text, {
					textStyle = v5.Color.Content.Default,
					fontStyle = v5.Typography.BodySmall,
					Text = props.bundlePartsText,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			}
		) else nil
		v16.BundleParts = v18
		v13 = createElement2("Frame", v15, v16)
	end

	local v14 = if not (fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard or not (props.priceLineContent and #props.priceLineContent > 0)) then React.createElement(
		Foundation.View,
		{ tag = "auto-xy row gap-xsmall position-bottom-left anchor-bottom-left" },
		v9
	) else nil
	local v15

	if (fFlagAXDurablesForMIS or fFlagAXEnableTimedOptionsForCatalogRowCard) and v10 then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v16 = {
			tag = fFlagAXDurables2Option and props.hideTimedOptionSelections and "auto-x row gap-xsmall align-y-center position-bottom-left anchor-bottom-left" or "auto-xy row gap-xsmall align-y-center position-bottom-left anchor-bottom-left",
			Size = 0
		}

		local v17 = if fFlagAXMISOffersChip then UDim2.fromOffset(0, v5.Size.Size_800) else nil
		v16.Size = v17

		local join = Cryo.Dictionary.join

		local v18 = fFlagAXDurables2Option
			and props.hideTimedOptionSelections
			and props.timedOptions
			and (not props.isOwned or props.expirationTime)
			and props.itemStatusInCheckout == nil
			and {}
			or v9
		local v20

		if not (fFlagAXDurables2Option and props.hideTimedOptionSelections or not props.timedOptions or props.isOwned and not props.expirationTime) then
			local createElement3 = React.createElement
			local view3 = Foundation.View
			local v23

			if props.wearTimeSelectedOptionInList then
				local createElement4 = React.createElement
				local wearTimeSelectedOptionInList = props.wearTimeSelectedOptionInList
				local v24 = {
					options = props.timedOptions,
					selectedTimedOptionIndexInReducer = 0,
					onOptionActivated = 0
				}

				local v25 = if fFlagAXDurablesForMIS then props.selectedTimedOptionIndexInReducer else nil
				v24.selectedTimedOptionIndexInReducer = v25

				function v24.onOptionActivated(p2)
					local timedOption = props.timedOptions[p2]

					if timedOption then
						if setSelectedTimedOptionPrice then
							setSelectedTimedOptionPrice(timedOption.price)
						end

						if props.onTimedOptionPriceChanged then
							local v26 = if timedOption.days ~= 0 then timedOption.days else nil
							props.onTimedOptionPriceChanged(timedOption.price, v26)
						end
					end
				end

				v23 = createElement4(wearTimeSelectedOptionInList, v24)
			end

			v20 = createElement3(view3, {
				tag = "auto-xy padding-left-small",
				LayoutOrder = 100
			}, {
				WearTimeSelectedOptionInList = v23
			})
		end

		local v21 = if fFlagAXDurables2Option and props.offerApplied then React.createElement(Foundation.Popover.Root, {
			isOpen = props.showOfferPillTooltip or false
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, { LayoutOrder = 101 }, {
				Badge = React.createElement(Foundation.Badge, {
					icon = {
						name = Foundation.Enums.IconName.TagSparkle,
						position = Foundation.Enums.IconPosition.Left
					},
					text = props.offersLocalized and props.offersLocalized.OfferApplied,
					variant = Foundation.Enums.BadgeVariant.Neutral,
					shape = Foundation.Enums.BadgeShape.Pill,
					size = Foundation.Enums.BadgeSize.XSmall
				})
			}),
			Content = React.createElement(
				Foundation.Popover.Content,
				{
					align = Foundation.Enums.PopoverAlign.Center,
					side = Foundation.Enums.PopoverSide.Top,
					radius = Foundation.Enums.Radius.Medium,
					backgroundStyle = v5.Color.System.Contrast
				},
				{
					TooltipContent = React.createElement(
						Foundation.View,
						{
							tag = "col gap-xsmall auto-xy padding-x-medium padding-y-small"
						},
						{
							TooltipText = React.createElement(text, {
								Text = props.offersLocalized and props.offersLocalized.OfferAppliedTooltip,
								tag = "auto-xy text-title-medium text-truncate-end content-inverse-emphasis"
							})
						}
					)
				}
			)
		}) else nil

		local v22 = if fFlagAXMISOffersChip and not fFlagAXDurables2Option and props.offerApplied and (not props.timedOptions or props.isOwned and not props.expirationTime) then React.createElement(Foundation.Badge, {
			icon = {
				name = Foundation.Enums.IconName.TagSparkle,
				position = Foundation.Enums.IconPosition.Left
			},
			text = props.offersLocalized and props.offersLocalized.OfferApplied,
			variant = Foundation.Enums.BadgeVariant.Neutral,
			shape = Foundation.Enums.BadgeShape.Pill,
			size = Foundation.Enums.BadgeSize.XSmall,
			LayoutOrder = 101
		}) else nil
		v15 = createElement2(
			view2,
			v16,
			join(v18, { WearTimeOptions = v20, Badge = v21, OfferAppliedBadge = v22 })
		)
	end

	return createElement(view, v11, {
		TopSection = v13,
		BottomPrice = v14,
		BottomContent = v15
	})
end

return CatalogRowItemCardFooter
