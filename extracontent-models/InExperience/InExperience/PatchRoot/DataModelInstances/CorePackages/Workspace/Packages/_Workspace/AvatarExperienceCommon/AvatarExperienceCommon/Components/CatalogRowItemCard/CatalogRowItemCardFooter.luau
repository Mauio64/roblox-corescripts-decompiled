local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local VerifiedBadges = require(parent.VerifiedBadges)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardPriceLine = AvatarExperienceUIKit.ItemCardComponents.ItemCardPriceLine
local ItemCardTitle = AvatarExperienceUIKit.ItemCardComponents.ItemCardTitle
local Cryo = require(parent.Cryo)
require(AvatarExperienceCommon.Types.TimedOptionType)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local FFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip

local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function CatalogRowItemCardFooter(props)
	local v = useTokens()
	local selectedTimedOptionPrice, setSelectedTimedOptionPrice

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
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

		for k, v2 in props.priceLineContent do
			local joined = Cryo.Dictionary.omit(v2, { "strikethrough" })

			if
				(FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard)
				and selectedTimedOptionPrice
				and v2.type == "price"
			then
				if v2.isOriginalPrice and props.timedOptions then
					local price = selectedTimedOptionPrice

					for _, timedOption in props.timedOptions do
						if timedOption.price == selectedTimedOptionPrice and timedOption.discountInformation then
							price = timedOption.discountInformation.originalPrice
							break
						end
					end

					joined = Cryo.Dictionary.join(joined, { price = price })

					if
						price == selectedTimedOptionPrice
						and (not FFlagAXMISWithOffers or FFlagAXMISWithOffers and not v2.shouldShowOriginalPrice)
					then
						continue
					end
				else
					joined = Cryo.Dictionary.join(joined, { price = selectedTimedOptionPrice })
				end
			end

			if FFlagAXMISWithOffers and v2.priceInRobuxDiscountedByOffers then
				joined = Cryo.Dictionary.join(joined, { price = v2.priceInRobuxDiscountedByOffers })
			end

			if (FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard) and v2.strikethrough then
				joined = Cryo.Dictionary.join(joined, {
					colorStyle = v.Color.Content.Muted,
					iconSize = IconSize.XSmall,
					fontStyle = v.Typography.BodySmall
				})
			end

			local formatted = `PriceLine{k}`
			local createElement = React.createElement
			local view = Foundation.View

			local v3 = {
				ItemCardPriceLine = React.createElement(ItemCardPriceLine, { content = joined }),
				Strikethrough = 0
			}
			local strikethrough

			if v2.strikethrough then
				local createElement2 = React.createElement
				local view2 = Foundation.View
				local size

				if FFlagAXMISSmallUIChanges then
					size = UDim2.new(1, 0, 0, 1)
				end

				strikethrough = createElement2(view2, {
					tag = "bg-system-neutral anchor-center-center position-center-center size-full-50",
					Size = size
				})
			end

			v3.Strikethrough = strikethrough
			children[formatted] = createElement(view, { tag = "auto-xy", LayoutOrder = k }, v3)
		end

		return children
	end

	local priceLineContent = props.priceLineContent
	local v2

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		v2 = selectedTimedOptionPrice
	end

	local timedOptions

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		timedOptions = props.timedOptions
	end

	local v3

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		v3 = v
	end

	local v4 = useMemo(fn, { priceLineContent, v2, timedOptions, v3 })
	local v5

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		v5 = props.priceLineContent and #props.priceLineContent > 0 and true or props.timedOptions
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		LayoutOrder = props.LayoutOrder,
		tag = "fill self-stretch"
	}
	local onRemove

	if FFlagAXGifting then
		onRemove = props.onRemove or props.giftButton
	else
		onRemove = FFlagAXDurables2Option and props.onRemove
	end

	local topSection

	if onRemove then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local view3 = Foundation.View

		local v7 = {
			ItemCardFooterTitle = React.createElement(ItemCardTitle, {
				title = props.title or "",
				LayoutOrder = 1
			}),
			ItemCardFooterInfo = 0,
			BundleParts = 0
		}
		local itemCardFooterInfo

		if props.itemSubType or props.creatorName then
			local createElement4 = React.createElement
			local view4 = Foundation.View
			local itemSubType

			if props.itemSubType then
				itemSubType = React.createElement(Text, {
					textStyle = v.Color.Content.Default,
					fontStyle = v.Typography.BodyMedium,
					LayoutOrder = 1,
					Text = props.itemSubType,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			end

			local spacer

			if props.itemSubType and not FFlagAXMISSmallUIChanges then
				spacer = React.createElement(Icon, {
					name = "icons/controls/keys/period",
					size = IconSize.Small,
					LayoutOrder = 2
				})
			end

			local divider

			if props.creatorName and FFlagAXMISSmallUIChanges then
				divider = React.createElement(Icon, {
					name = "icons/controls/keys/period",
					size = IconSize.Small,
					LayoutOrder = 2
				})
			end

			local creatorName

			if props.creatorName then
				local createElement5 = React.createElement
				local v8 = {
					tag = "fill self-stretch",
					textStyle = v.Color.Content.Default,
					fontStyle = v.Typography.BodyMedium,
					LayoutOrder = 3,
					Text = 0,
					TextXAlignment = 0,
					AutomaticSize = 0,
					TextTruncate = 0
				}
				local text

				if props.creatorHasVerifiedBadge then
					text = `{props.creatorName}{VerifiedBadges.emoji.verified}`
				else
					text = props.creatorName
				end

				v8.Text = text

				v8.TextXAlignment = Enum.TextXAlignment.Left
				v8.AutomaticSize = Enum.AutomaticSize.XY
				v8.TextTruncate = Enum.TextTruncate.SplitWord
				creatorName = createElement5(Text, v8)
			end

			itemCardFooterInfo = createElement4(
				view4,
				{ tag = "row align-x-left gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
				{
					ItemSubType = itemSubType,
					Spacer = spacer,
					Divider = divider,
					CreatorName = creatorName
				}
			)
		end

		v7.ItemCardFooterInfo = itemCardFooterInfo
		local bundleParts

		if props.bundlePartsText and not props.timedOptions then
			bundleParts = React.createElement(
				Foundation.View,
				{ tag = "auto-xy padding-xsmall radius-small bg-surface-100", LayoutOrder = 3 },
				{
					Text = React.createElement(Text, {
						textStyle = v.Color.Content.Default,
						fontStyle = v.Typography.BodySmall,
						Text = props.bundlePartsText,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}
			)
		end

		v7.BundleParts = bundleParts
		local v8 = {
			Left = createElement3(
				view3,
				{ tag = "col align-x-left fill gap-xsmall size-full-0 auto-y", LayoutOrder = 1 },
				v7
			),
			Right = 0
		}
		local right

		if props.onRemove or FFlagAXGifting and props.giftButton then
			local createElement4 = React.createElement
			local view4 = Foundation.View
			local v9 = {
				tag = FFlagAXGifting and {
					["auto-xy"] = true,
					["row gap-small"] = props.giftButton ~= nil
				} or "auto-xy",
				LayoutOrder = 2
			}
			local v10

			if FFlagAXGifting then
				v10 = { GiftButton = 0, RemoveButton = 0 }
				local giftButton

				if props.giftButton ~= nil then
					giftButton = React.createElement(
						Foundation.View,
						{
							tag = "auto-xy",
							LayoutOrder = 1,
							testId = "catalogRowItemCardGiftButton"
						},
						props.giftButton
					)
				end

				v10.GiftButton = giftButton
				local removeButton

				if props.onRemove then
					removeButton = React.createElement(Foundation.IconButton, {
						icon = "x",
						isCircular = true,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onRemove,
						testId = "catalogRowItemCardRemoveButton",
						LayoutOrder = 2
					})
				end

				v10.RemoveButton = removeButton
			elseif props.onRemove then
				v10 = React.createElement(Foundation.IconButton, {
					icon = "x",
					isCircular = true,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = props.onRemove,
					testId = "catalogRowItemCardRemoveButton"
				})
			end

			right = createElement4(view4, v9, v10)
		end

		v8.Right = right
		topSection = createElement2(view2, { tag = "row size-full-0 auto-y" }, v8)
	else
		local createElement2 = React.createElement
		local v7 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v8 = {
			TopLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v.Gap.XSmall)
			}),
			ItemCardFooterTitle = React.createElement(ItemCardTitle, {
				title = props.title or "",
				LayoutOrder = 1
			}),
			ItemCardFooterInfo = 0,
			BundleParts = 0
		}
		local itemCardFooterInfo

		if props.itemSubType or props.creatorName then
			local createElement3 = React.createElement
			local v9 = {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2
			}

			local v10 = {
				ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v.Gap.XXSmall)
				}),
				ItemSubType = 0,
				Spacer = 0,
				Divider = 0,
				CreatorName = 0
			}
			local itemSubType

			if props.itemSubType then
				itemSubType = React.createElement(Text, {
					textStyle = v.Color.Content.Default,
					fontStyle = v.Typography.BodyMedium,
					LayoutOrder = 1,
					Text = props.itemSubType,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			end

			v10.ItemSubType = itemSubType
			local spacer

			if props.itemSubType and not FFlagAXMISSmallUIChanges then
				spacer = React.createElement(Icon, {
					name = "icons/controls/keys/period",
					size = IconSize.Small,
					LayoutOrder = 2
				})
			end

			v10.Spacer = spacer
			local divider

			if props.creatorName and FFlagAXMISSmallUIChanges then
				divider = React.createElement(Icon, {
					name = "icons/controls/keys/period",
					size = IconSize.Small,
					LayoutOrder = 2
				})
			end

			v10.Divider = divider
			local creatorName

			if props.creatorName then
				local createElement4 = React.createElement
				local v11 = {
					tag = "fill self-stretch",
					textStyle = v.Color.Content.Default,
					fontStyle = v.Typography.BodyMedium,
					LayoutOrder = 3,
					Text = 0,
					TextXAlignment = 0,
					AutomaticSize = 0,
					TextTruncate = 0
				}
				local text

				if props.creatorHasVerifiedBadge then
					text = `{props.creatorName}{VerifiedBadges.emoji.verified}`
				else
					text = props.creatorName
				end

				v11.Text = text

				v11.TextXAlignment = Enum.TextXAlignment.Left
				v11.AutomaticSize = Enum.AutomaticSize.XY
				v11.TextTruncate = Enum.TextTruncate.SplitWord
				creatorName = createElement4(Text, v11)
			end

			v10.CreatorName = creatorName
			itemCardFooterInfo = createElement3("Frame", v9, v10)
		end

		v8.ItemCardFooterInfo = itemCardFooterInfo
		local bundleParts

		if props.bundlePartsText then
			bundleParts = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					BackgroundColor3 = v.Color.Surface.Surface_100.Color3,
					BackgroundTransparency = v.Color.Surface.Surface_100.Transparency,
					AutomaticSize = Enum.AutomaticSize.XY
				},
				{
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v.Radius.Small)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v.Padding.XSmall),
						PaddingLeft = UDim.new(0, v.Padding.XSmall),
						PaddingRight = UDim.new(0, v.Padding.XSmall),
						PaddingBottom = UDim.new(0, v.Padding.XSmall)
					}),
					Text = React.createElement(Text, {
						textStyle = v.Color.Content.Default,
						fontStyle = v.Typography.BodySmall,
						Text = props.bundlePartsText,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}
			)
		end

		v8.BundleParts = bundleParts
		topSection = createElement2("Frame", v7, v8)
	end

	local bottomPrice

	if not (FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard or not (props.priceLineContent and #props.priceLineContent > 0)) then
		bottomPrice = React.createElement(
			Foundation.View,
			{ tag = "auto-xy row gap-xsmall position-bottom-left anchor-bottom-left" },
			v4
		)
	end

	local bottomContent

	if (FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard) and v5 then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v7 = {
			tag = FFlagAXDurables2Option and props.hideTimedOptionSelections and "auto-x row gap-xsmall align-y-center position-bottom-left anchor-bottom-left" or "auto-xy row gap-xsmall align-y-center position-bottom-left anchor-bottom-left",
			Size = 0
		}
		local size

		if FFlagAXMISOffersChip then
			size = UDim2.fromOffset(0, v.Size.Size_800)
		end

		v7.Size = size

		local join = Cryo.Dictionary.join

		local v8 = FFlagAXDurables2Option
			and props.hideTimedOptionSelections
			and props.timedOptions
			and (not props.isOwned or props.expirationTime)
			and props.itemStatusInCheckout == nil
			and {}
			or v4
		local wearTimeOptions

		if not (FFlagAXDurables2Option and props.hideTimedOptionSelections or not props.timedOptions or props.isOwned and not props.expirationTime) then
			local createElement3 = React.createElement
			local view3 = Foundation.View
			local wearTimeSelectedOptionInList2

			if props.wearTimeSelectedOptionInList then
				local createElement4 = React.createElement
				local wearTimeSelectedOptionInList = props.wearTimeSelectedOptionInList
				local v9 = {
					options = props.timedOptions,
					selectedTimedOptionIndexInReducer = 0,
					onOptionActivated = 0
				}
				local selectedTimedOptionIndexInReducer

				if FFlagAXDurablesForMIS then
					selectedTimedOptionIndexInReducer = props.selectedTimedOptionIndexInReducer
				end

				v9.selectedTimedOptionIndexInReducer = selectedTimedOptionIndexInReducer

				function v9.onOptionActivated(p)
					local timedOption = props.timedOptions[p]

					if timedOption then
						if setSelectedTimedOptionPrice then
							setSelectedTimedOptionPrice(timedOption.price)
						end

						if props.onTimedOptionPriceChanged then
							local v10

							if timedOption.days ~= 0 then
								v10 = timedOption.days
							end

							props.onTimedOptionPriceChanged(timedOption.price, v10)
						end
					end
				end

				wearTimeSelectedOptionInList2 = createElement4(wearTimeSelectedOptionInList, v9)
			end

			wearTimeOptions = createElement3(view3, {
				tag = "auto-xy padding-left-small",
				LayoutOrder = 100
			}, {
				WearTimeSelectedOptionInList = wearTimeSelectedOptionInList2
			})
		end

		local badge

		if FFlagAXDurables2Option and props.offerApplied then
			badge = React.createElement(Foundation.Popover.Root, {
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
						backgroundStyle = v.Color.System.Contrast
					},
					{
						TooltipContent = React.createElement(
							Foundation.View,
							{ tag = "col gap-xsmall auto-xy padding-x-medium padding-y-small" },
							{
								TooltipText = React.createElement(Text, {
									Text = props.offersLocalized and props.offersLocalized.OfferAppliedTooltip,
									tag = "auto-xy text-title-medium text-truncate-end content-inverse-emphasis"
								})
							}
						)
					}
				)
			})
		end

		local offerAppliedBadge

		if
			FFlagAXMISOffersChip
			and not FFlagAXDurables2Option
			and props.offerApplied
			and (not props.timedOptions or props.isOwned and not props.expirationTime)
		then
			offerAppliedBadge = React.createElement(Foundation.Badge, {
				icon = {
					name = Foundation.Enums.IconName.TagSparkle,
					position = Foundation.Enums.IconPosition.Left
				},
				text = props.offersLocalized and props.offersLocalized.OfferApplied,
				variant = Foundation.Enums.BadgeVariant.Neutral,
				shape = Foundation.Enums.BadgeShape.Pill,
				size = Foundation.Enums.BadgeSize.XSmall,
				LayoutOrder = 101
			})
		end

		bottomContent = createElement2(
			view2,
			v7,
			join(v8, {
				WearTimeOptions = wearTimeOptions,
				Badge = badge,
				OfferAppliedBadge = offerAppliedBadge
			})
		)
	end

	return createElement(view, v6, {
		TopSection = topSection,
		BottomPrice = bottomPrice,
		BottomContent = bottomContent
	})
end

return CatalogRowItemCardFooter
