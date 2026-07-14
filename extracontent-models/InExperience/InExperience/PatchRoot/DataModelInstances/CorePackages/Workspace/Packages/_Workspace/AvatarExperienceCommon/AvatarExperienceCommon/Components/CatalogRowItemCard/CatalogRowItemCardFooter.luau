local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local VerifiedBadges = require(AvatarExperienceCommonParent.VerifiedBadges)
local AvatarExperienceUIKit = require(AvatarExperienceCommonParent.AvatarExperienceUIKit)
local ItemCardPriceLine = AvatarExperienceUIKit.ItemCardComponents.ItemCardPriceLine
local ItemCardTitle = AvatarExperienceUIKit.ItemCardComponents.ItemCardTitle
local Cryo = require(AvatarExperienceCommonParent.Cryo)

require(AvatarExperienceCommon.Types.TimedOptionType)

local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXEnableTimedOptionsForCatalogRowCard = AvatarExperienceFlags.FFlagAXEnableTimedOptionsForCatalogRowCard
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function CatalogRowItemCardFooter(t1: {[any]: any}) -- line: 76
	-- upvalues: useTokens (copy), FFlagAXDurablesForMIS (copy), FFlagAXEnableTimedOptionsForCatalogRowCard (copy), React (copy), Cryo (copy), FFlagAXMISWithOffers (copy), IconSize (copy), Foundation (copy), ItemCardPriceLine (copy), FFlagAXMISSmallUIChanges (copy), FFlagAXDurables2Option (copy), ItemCardTitle (copy), FoundationText (copy), Icon (copy), VerifiedBadges (copy)
	local v22 = useTokens()
	local selectedTimedOptionPrice = nil
	local setSelectedTimedOptionPrice = nil

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		selectedTimedOptionPrice = t1.selectedTimedOptionPrice
		setSelectedTimedOptionPrice = t1.setSelectedTimedOptionPrice
	end

	local v25 = React.useMemo(function() -- line: 87
		-- upvalues: t1 (copy), Cryo (copy), FFlagAXDurablesForMIS (copy), FFlagAXEnableTimedOptionsForCatalogRowCard (copy), selectedTimedOptionPrice (ref), FFlagAXMISWithOffers (copy), v22 (copy), IconSize (copy), React (copy), Foundation (copy), ItemCardPriceLine (copy), FFlagAXMISSmallUIChanges (copy)
		local t2 = {}

		if t1.priceLineContent and #t1.priceLineContent > 0 then
			for v28, v29 in t1.priceLineContent do
				local v30 = Cryo.Dictionary.omit(v29, { "strikethrough" })

				if (FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard) and selectedTimedOptionPrice and v29.type == "price" then
					if v29.isOriginalPrice and t1.timedOptions then
						local v31 = selectedTimedOptionPrice

						for _, v33 in t1.timedOptions do
							if v33.price == selectedTimedOptionPrice and v33.discountInformation then
								v31 = v33.discountInformation.originalPrice

								break
							end
						end

						v30 = Cryo.Dictionary.join(v30, {
							price = v31
						})

						if v31 == selectedTimedOptionPrice and (not FFlagAXMISWithOffers or FFlagAXMISWithOffers and not v29.shouldShowOriginalPrice) then
							continue
						end
					else
						v30 = Cryo.Dictionary.join(v30, {
							price = selectedTimedOptionPrice
						})
					end
				end

				if FFlagAXMISWithOffers and v29.priceInRobuxDiscountedByOffers then
					v30 = Cryo.Dictionary.join(v30, {
						price = v29.priceInRobuxDiscountedByOffers
					})
				end

				if (FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard) and v29.strikethrough then
					v30 = Cryo.Dictionary.join(v30, {
						colorStyle = v22.Color.Content.Muted,
						iconSize = IconSize.XSmall,
						fontStyle = v22.Typography.BodySmall
					})
				end

				t2[`PriceLine{ v28 }`] = React.createElement(Foundation.View, {
					tag = "auto-xy",
					LayoutOrder = v28
				}, {
					ItemCardPriceLine = React.createElement(ItemCardPriceLine, {
						content = v30
					}),
					Strikethrough = if not v29.strikethrough then nil else React.createElement(Foundation.View, {
						tag = "bg-system-neutral anchor-center-center position-center-center size-full-50",
						Size = if not FFlagAXMISSmallUIChanges then nil else UDim2.new(1, 0, 0, 1)
					})
				})
			end
		end

		return t2
	end, {
		t1.priceLineContent,
		if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else selectedTimedOptionPrice,
		if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else t1.timedOptions,
		if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard then nil else v22
	})
	local v26 = nil

	if FFlagAXDurablesForMIS or FFlagAXEnableTimedOptionsForCatalogRowCard then
		v26 = t1.priceLineContent and #t1.priceLineContent > 0 or t1.timedOptions
	end

	return React.createElement(Foundation.View, {
		tag = "fill self-stretch",
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize,
		LayoutOrder = t1.LayoutOrder
	}, {
		TopSection = if not FFlagAXDurables2Option or not t1.onRemove then React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			TopLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v22.Gap.XSmall)
			}),
			ItemCardFooterTitle = React.createElement(ItemCardTitle, {
				LayoutOrder = 1,
				title = t1.title or ""
			}),
			ItemCardFooterInfo = if not t1.itemSubType and not t1.creatorName then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v22.Gap.XXSmall)
				}),
				ItemSubType = if not t1.itemSubType then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					textStyle = v22.Color.Content.Default,
					fontStyle = v22.Typography.BodyMedium,
					Text = t1.itemSubType,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				}),
				Spacer = if not t1.itemSubType or FFlagAXMISSmallUIChanges then nil else React.createElement(Icon, {
					name = "icons/controls/keys/period",
					LayoutOrder = 2,
					size = IconSize.Small
				}),
				Divider = if not t1.creatorName or not FFlagAXMISSmallUIChanges then nil else React.createElement(Icon, {
					name = "icons/controls/keys/period",
					LayoutOrder = 2,
					size = IconSize.Small
				}),
				CreatorName = if not t1.creatorName then nil else React.createElement(FoundationText, {
					tag = "fill self-stretch",
					LayoutOrder = 3,
					textStyle = v22.Color.Content.Default,
					fontStyle = v22.Typography.BodyMedium,
					Text = if not t1.creatorHasVerifiedBadge then t1.creatorName else `{ t1.creatorName }{ VerifiedBadges.emoji.verified }`,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			}),
			BundleParts = if not t1.bundlePartsText then nil else React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundColor3 = v22.Color.Surface.Surface_100.Color3,
				BackgroundTransparency = v22.Color.Surface.Surface_100.Transparency,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v22.Radius.Small)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v22.Padding.XSmall),
					PaddingLeft = UDim.new(0, v22.Padding.XSmall),
					PaddingRight = UDim.new(0, v22.Padding.XSmall),
					PaddingBottom = UDim.new(0, v22.Padding.XSmall)
				}),
				Text = React.createElement(FoundationText, {
					textStyle = v22.Color.Content.Default,
					fontStyle = v22.Typography.BodySmall,
					Text = t1.bundlePartsText,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			})
		}) else React.createElement(Foundation.View, {
			tag = "row size-full-0 auto-y"
		}, {
			Left = React.createElement(Foundation.View, {
				tag = "col align-x-left fill gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				ItemCardFooterTitle = React.createElement(ItemCardTitle, {
					LayoutOrder = 1,
					title = t1.title or ""
				}),
				ItemCardFooterInfo = if not t1.itemSubType and not t1.creatorName then nil else React.createElement(Foundation.View, {
					tag = "row align-x-left gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					ItemSubType = if not t1.itemSubType then nil else React.createElement(FoundationText, {
						LayoutOrder = 1,
						textStyle = v22.Color.Content.Default,
						fontStyle = v22.Typography.BodyMedium,
						Text = t1.itemSubType,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.SplitWord
					}),
					Spacer = if not t1.itemSubType or FFlagAXMISSmallUIChanges then nil else React.createElement(Icon, {
						name = "icons/controls/keys/period",
						LayoutOrder = 2,
						size = IconSize.Small
					}),
					Divider = if not t1.creatorName or not FFlagAXMISSmallUIChanges then nil else React.createElement(Icon, {
						name = "icons/controls/keys/period",
						LayoutOrder = 2,
						size = IconSize.Small
					}),
					CreatorName = if not t1.creatorName then nil else React.createElement(FoundationText, {
						tag = "fill self-stretch",
						LayoutOrder = 3,
						textStyle = v22.Color.Content.Default,
						fontStyle = v22.Typography.BodyMedium,
						Text = if not t1.creatorHasVerifiedBadge then t1.creatorName else `{ t1.creatorName }{ VerifiedBadges.emoji.verified }`,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}),
				BundleParts = if not t1.bundlePartsText or t1.timedOptions then nil else React.createElement(Foundation.View, {
					tag = "auto-xy padding-xsmall radius-small bg-surface-100",
					LayoutOrder = 3
				}, {
					Text = React.createElement(FoundationText, {
						textStyle = v22.Color.Content.Default,
						fontStyle = v22.Typography.BodySmall,
						Text = t1.bundlePartsText,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				})
			}),
			Right = if not t1.onRemove then nil else React.createElement(Foundation.View, {
				tag = "auto-xy",
				LayoutOrder = 2
			}, React.createElement(Foundation.IconButton, {
				icon = "x",
				isCircular = true,
				testId = "catalogRowItemCardRemoveButton",
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = t1.onRemove
			}))
		}),
		BottomPrice = if FFlagAXDurablesForMIS or (FFlagAXEnableTimedOptionsForCatalogRowCard or (not t1.priceLineContent or not (#t1.priceLineContent > 0))) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy row gap-xsmall position-bottom-left anchor-bottom-left"
		}, v25),
		BottomContent = if not FFlagAXDurablesForMIS and not FFlagAXEnableTimedOptionsForCatalogRowCard or not v26 then nil else React.createElement(Foundation.View, {
			tag = (not FFlagAXDurables2Option or not t1.hideTimedOptionSelections) and "auto-xy row gap-xsmall align-y-center position-bottom-left anchor-bottom-left" or "auto-x row gap-xsmall align-y-center position-bottom-left anchor-bottom-left",
			Size = if not FFlagAXDurables2Option or not t1.hideTimedOptionSelections then nil else UDim2.fromOffset(0, v22.Size.Size_1200)
		}, Cryo.Dictionary.join(if not FFlagAXDurables2Option or (not t1.hideTimedOptionSelections or (not t1.timedOptions or (t1.isOwned and not t1.expirationTime or t1.itemStatusInCheckout ~= nil))) then v25 else {}, {
			WearTimeOptions = if FFlagAXDurables2Option and t1.hideTimedOptionSelections or (not t1.timedOptions or not not t1.isOwned and not t1.expirationTime) then nil else React.createElement(Foundation.View, {
				tag = "auto-xy padding-left-small",
				LayoutOrder = 100
			}, {
				WearTimeSelectedOptionInList = if not t1.wearTimeSelectedOptionInList then nil else React.createElement(t1.wearTimeSelectedOptionInList, {
					options = t1.timedOptions,
					selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS then nil else t1.selectedTimedOptionIndexInReducer,
					onOptionActivated = function(p1) -- line: 415
						-- upvalues: t1 (copy), setSelectedTimedOptionPrice (ref)
						local v35 = t1.timedOptions[p1]

						if v35 then
							if setSelectedTimedOptionPrice then
								setSelectedTimedOptionPrice(v35.price)
							end

							if t1.onTimedOptionPriceChanged then
								local v36 = if v35.days ~= 0 then v35.days else nil

								t1.onTimedOptionPriceChanged(v35.price, v36)
							end
						end
					end
				})
			}),
			Badge = if not FFlagAXDurables2Option or not t1.offerApplied then nil else React.createElement(Foundation.Popover.Root, {
				isOpen = t1.showOfferPillTooltip or false
			}, {
				Anchor = React.createElement(Foundation.Popover.Anchor, {
					LayoutOrder = 101
				}, {
					Badge = React.createElement(Foundation.Badge, {
						icon = {
							name = Foundation.Enums.IconName.TagSparkle,
							position = Foundation.Enums.IconPosition.Left
						},
						text = t1.offersLocalized and t1.offersLocalized.OfferApplied,
						variant = Foundation.Enums.BadgeVariant.Neutral,
						shape = Foundation.Enums.BadgeShape.Pill,
						size = Foundation.Enums.BadgeSize.XSmall
					})
				}),
				Content = React.createElement(Foundation.Popover.Content, {
					align = Foundation.Enums.PopoverAlign.Center,
					side = Foundation.Enums.PopoverSide.Top,
					radius = Foundation.Enums.Radius.Medium,
					backgroundStyle = v22.Color.System.Contrast
				}, {
					TooltipContent = React.createElement(Foundation.View, {
						tag = "col gap-xsmall auto-xy padding-x-medium padding-y-small"
					}, {
						TooltipText = React.createElement(FoundationText, {
							tag = "auto-xy text-title-medium text-truncate-end content-inverse-emphasis",
							Text = t1.offersLocalized and t1.offersLocalized.OfferAppliedTooltip
						})
					})
				})
			})
		}))
	})
end

return CatalogRowItemCardFooter
