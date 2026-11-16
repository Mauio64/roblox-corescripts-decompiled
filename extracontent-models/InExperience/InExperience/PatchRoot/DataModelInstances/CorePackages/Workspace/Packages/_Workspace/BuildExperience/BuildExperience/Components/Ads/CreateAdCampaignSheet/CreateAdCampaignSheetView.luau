local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local InlineLayout = require(parent.InlineLayout)

local Button = Foundation.Button
local Chip = Foundation.Chip
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local OptionSelectorGroup = Foundation.OptionSelectorGroup
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local inlineLayout = InlineLayout.Components.InlineLayout
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement

local CreateAdCampaignSheetConfig = require(script.Parent.CreateAdCampaignSheetConfig)
local FFlagBuildAdsUiPolish = require(BuildExperience.Flags.FFlagBuildAdsUiPolish)

local ButtonVariant = Foundation.Enums.ButtonVariant
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local OptionSelectorGroupSize = Foundation.Enums.OptionSelectorGroupSize
local useTokens = Foundation.Hooks.useTokens

local snapPoints = { 1 }
local v = { name = "u", attributes = {} }

local function createLegalTextElement(text: string, fontStyle, textStyle)
	return TextElement.new({ Text = text, fontStyle = fontStyle, textStyle = textStyle })
end

local function createLegalElements(text: string, bodyMedium, default, onActivated, onActivated2)
	local v2 = {
		{
			startMarker = CreateAdCampaignSheetConfig.ADVERTISING_TERMS_START_MARKER,
			endMarker = CreateAdCampaignSheetConfig.ADVERTISING_TERMS_END_MARKER,
			onActivated = onActivated
		},
		{
			startMarker = CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_START_MARKER,
			endMarker = CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_END_MARKER,
			onActivated = onActivated2
		}
	}
	local v3 = 1
	local legalElements = {}

	while v3 <= #text do
		local v4 = nil
		local v5 = nil
		local v6 = nil

		for _, v7 in v2 do
			local v8, v9 = string.find(text, v7.startMarker, v3, true)

			if not (v8 ~= nil and (v4 == nil or v8 < v4)) then
				continue
			end

			v6 = v9
			v5 = v7
			v4 = v8
		end

		if v5 == nil or v4 == nil or v6 == nil then
			table.insert(legalElements, createLegalTextElement(string.sub(text, v3), bodyMedium, default))
			return legalElements
		end

		if v3 < v4 then
			table.insert(legalElements, createLegalTextElement(string.sub(text, v3, v4 - 1), bodyMedium, default))
		end

		local v7, v8 = string.find(text, v5.endMarker, v6 + 1, true)

		if v7 == nil or v8 == nil then
			table.insert(legalElements, createLegalTextElement(string.sub(text, v4), bodyMedium, default))
			return legalElements
		end

		local text2 = string.sub(text, v6 + 1, v7 - 1)
		local onActivated3 = v5.onActivated
		table.insert(legalElements, LinkElement.new({ TextElement.new({
				Text = text2,
				EngineTags = { v },
				fontStyle = bodyMedium,
				textStyle = default
			}) }, {
			onActivated = function()
				onActivated3(text2)
			end
		}))

		v3 = v8 + 1
	end

	return legalElements
end

local function AdCampaignLegalText(props)
	local v2 = useTokens()
	local bodyMedium = v2.Typography.BodyMedium
	local legalElements = createLegalElements(
		props.text,
		bodyMedium,
		v2.Color.Content.Default,
		props.onAdvertisingTerms,
		props.onAdvertisingStandards
	)

	return React.createElement(View, { LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y" }, {
		Layout = React.createElement(inlineLayout, {
			Elements = legalElements,
			VerticalPadding = UDim.new(0, bodyMedium.FontSize * (bodyMedium.LineHeight - 1) / 2)
		})
	})
end

local function createBenefitRows(benefits)
	local children = {}

	for k, item in benefits do
		children[`Benefit{k}`] = React.createElement(
			View,
			{
				LayoutOrder = k,
				tag = "row align-y-center gap-xxlarge size-full-0 auto-y padding-y-xsmall"
			},
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = item.icon,
					size = IconSize.Large,
					tag = "content-emphasis"
				}),
				Label = React.createElement(Text, {
					LayoutOrder = 2,
					Text = item.text,
					tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		)
	end

	return children
end

local function CampaignPrice(p)
	local v2 = useTokens()

	if p.option.originalPriceText == nil then
		return React.createElement(
			View,
			{ LayoutOrder = 1, testId = p.testId, tag = "row align-y-center gap-xxsmall auto-xy" },
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = Foundation.Enums.IconName.Robux,
					size = IconSize.Small,
					tag = "content-default",
					testId = `{p.testId}-robux-icon`
				}),
				Amount = React.createElement(Text, {
					LayoutOrder = 2,
					Text = p.option.priceText,
					tag = "auto-xy text-body-medium content-default"
				})
			}
		)
	end

	return React.createElement(
		View,
		{ LayoutOrder = 1, testId = p.testId, tag = "row align-y-center gap-small auto-xy" },
		{
			OriginalPrice = React.createElement(View, { LayoutOrder = 1, tag = "auto-xy" }, {
				Content = React.createElement(View, {
					ZIndex = 1,
					tag = "row align-y-center gap-xxsmall auto-xy"
				}, {
					Icon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = Foundation.Enums.IconName.Robux,
						size = IconSize.Small,
						tag = "content-default",
						testId = `{p.testId}-robux-icon`
					}),
					Amount = React.createElement(Text, {
						LayoutOrder = 2,
						Text = p.option.originalPriceText,
						tag = "auto-xy text-body-medium content-default"
					})
				}),
				Strikethrough = React.createElement(View, {
					ZIndex = 2,
					tag = "position-center-left anchor-center-left",
					Size = UDim2.new(1, 0, 0, 1),
					backgroundStyle = v2.Color.Content.Default,
					testId = `{p.testId}-strikethrough`
				})
			}),
			Free = React.createElement(Text, {
				LayoutOrder = 2,
				Text = p.option.priceText,
				tag = "auto-xy text-title-medium content-emphasis",
				testId = `{p.testId}-free`
			})
		}
	)
end

local function CampaignOptionItem(props)
	local v2 = useTokens()
	local ref = React.useRef(nil)

	React.useImperativeHandle(props.optionRef, function()
		return ref.current
	end)

	return React.createElement(View, { LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y" }, {
		Selector = React.createElement(OptionSelectorGroup.Item, {
			value = props.option.value,
			label = props.option.title,
			metadata = props.option.runDates,
			description = props.option.description,
			isDisabled = props.isInteractionDisabled,
			ref = ref
		}),
		Price = React.createElement(View, {
			Position = UDim2.new(1, -v2.Padding.XLarge, 0, v2.Padding.XLarge),
			ZIndex = 2,
			tag = "anchor-top-right auto-xy"
		}, {
			Content = React.createElement(CampaignPrice, {
				option = props.option,
				testId = `{props.testId}-price`
			})
		})
	})
end

local function CreateAdCampaignSheetView(props)
	local v2 = useTokens()
	local gapxlarge = props.variant == "twoOptions"

	local v3 = math.ceil(v2.Typography.CaptionSmall.FontSize * v2.Typography.CaptionSmall.LineHeight * 2)

	local v4 = math.ceil(v2.Typography.CaptionMedium.FontSize * v2.Typography.CaptionMedium.LineHeight * 2)
	local v5 = gapxlarge and "two-options-ad-campaign" or "create-ad-campaign"
	local createElement = React.createElement
	local root = Sheet.Root
	local v6 = {
		isOpen = props.isOpen,
		ref = 0,
		preferCenterSheet = true,
		snapPoints = 0,
		onClose = 0,
		testId = 0
	}
	local ref

	if gapxlarge then
		ref = props.sheetRootRef
	end

	v6.ref = ref

	v6.snapPoints = snapPoints
	v6.onClose = props.onClose
	v6.testId = gapxlarge and "TwoOptionsAdCampaignSheet" or nil

	local createElement2 = React.createElement
	local header = Sheet.Header

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 1,
		tag = {
			["row align-y-center size-full-0 auto-y"] = true,
			["flex-between"] = not gapxlarge or props.showCloseButton,
			["align-x-right"] = gapxlarge and not props.showCloseButton
		}
	}
	local close

	if not (gapxlarge and not props.showCloseButton) then
		local createElement4 = React.createElement
		local v8 = {
			LayoutOrder = 1,
			icon = Foundation.Enums.IconName.X,
			size = InputSize.Large,
			variant = ButtonVariant.Utility,
			isDisabled = props.isCreatePending,
			onActivated = props.onClose,
			testId = 0
		}
		local testId

		if gapxlarge then
			testId = `{v5}-close`
		end

		v8.testId = testId
		close = createElement4(IconButton, v8)
	end

	local balance

	if FFlagBuildAdsUiPolish then
		balance = React.createElement(Chip, {
			LayoutOrder = 2,
			text = props.balanceText,
			leading = Foundation.Enums.IconName.Robux,
			variant = ChipVariant.Standard,
			size = ChipSize.Medium,
			onActivated = not gapxlarge and function() end or props.onOpenBuyRobux,
			isDisabled = not gapxlarge or props.isCreatePending,
			testId = gapxlarge and "two-options-ad-campaign-balance" or nil
		})
	else
		local createElement4 = React.createElement
		local onActivated

		if gapxlarge and not props.isCreatePending then
			onActivated = props.onOpenBuyRobux
		end

		balance = createElement4(View, {
			LayoutOrder = 2,
			onActivated = onActivated,
			tag = "row align-y-center gap-small auto-xy padding-right-small",
			testId = gapxlarge and "two-options-ad-campaign-balance" or nil
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = Foundation.Enums.IconName.Robux,
				size = IconSize.Medium,
				tag = {
					["content-emphasis"] = props.balanceState == "ready",
					["content-muted"] = props.balanceState ~= "ready"
				}
			}),
			Amount = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.balanceText,
				tag = {
					["auto-xy text-label-medium"] = true,
					["content-emphasis"] = props.balanceState == "ready",
					["content-muted"] = props.balanceState ~= "ready"
				}
			})
		})
	end

	local children = {
		Header = createElement2(header, { hasCloseAffordance = false }, {
			HeaderRow = createElement3(View, v7, { Close = close, Balance = balance })
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = Sheet.Content
	local createElement5 = React.createElement

	local v8 = {
		Introduction = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.description,
				tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis"
			})
		}),
		Campaign = 0,
		Disclaimer = 0,
		Included = 0,
		Legal = 0
	}
	local campaign

	if gapxlarge then
		local createElement6 = React.createElement

		local v9 = {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.startCampaignTitle,
				tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
			}),
			Options = 0
		}

		local createElement7 = React.createElement
		local root2 = OptionSelectorGroup.Root
		local v10 = {
			LayoutOrder = 2,
			value = props.selectedOption,
			onValueChanged = props.onOptionChanged,
			size = OptionSelectorGroupSize.Medium,
			Selectable = not props.isCreatePending,
			testId = "two-options-ad-campaign-options"
		}
		local feedback

		if props.feedbackOption ~= nil then
			local createElement8 = React.createElement
			local v11 = {
				LayoutOrder = 1,
				option = props.feedbackOption,
				optionRef = 0,
				isInteractionDisabled = 0,
				testId = "two-options-ad-campaign-feedback-option"
			}
			local optionRef

			if props.selectedOption == props.feedbackOption.value then
				optionRef = props.defaultOptionRef
			end

			v11.optionRef = optionRef

			v11.isInteractionDisabled = props.isCreatePending
			feedback = createElement8(CampaignOptionItem, v11)
		end

		local plays

		if props.playsOption ~= nil then
			local createElement8 = React.createElement
			local v11 = {
				LayoutOrder = 2,
				option = props.playsOption,
				optionRef = 0,
				isInteractionDisabled = 0,
				testId = "two-options-ad-campaign-plays-option"
			}
			local optionRef

			if props.selectedOption == props.playsOption.value then
				optionRef = props.defaultOptionRef
			end

			v11.optionRef = optionRef

			v11.isInteractionDisabled = props.isCreatePending
			plays = createElement8(CampaignOptionItem, v11)
		end

		v9.Options = createElement7(root2, v10, { Feedback = feedback, Plays = plays })
		campaign = createElement6(View, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, v9)
	else
		campaign = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-small size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-0"
			},
			{
				Name = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.campaignTitle,
					tag = "fill auto-y text-label-large text-wrap text-align-x-left content-emphasis"
				}),
				Price = React.createElement(View, {
					LayoutOrder = 2,
					tag = "row align-y-center gap-small auto-xy"
				}, {
					Estimated = React.createElement(View, { LayoutOrder = 1, tag = "auto-xy" }, {
						Content = React.createElement(
							View,
							{ ZIndex = 1, tag = "row align-y-center gap-xxsmall auto-xy" },
							{
								Icon = React.createElement(Icon, {
									LayoutOrder = 1,
									name = Foundation.Enums.IconName.Robux,
									size = IconSize.Small,
									tag = "content-default"
								}),
								Amount = React.createElement(Text, {
									LayoutOrder = 2,
									Text = props.estimatedPriceText,
									tag = "auto-xy text-body-large content-default"
								})
							}
						),
						Strikethrough = React.createElement(View, {
							ZIndex = 2,
							tag = "position-center-left anchor-center-left",
							Size = UDim2.new(1, 0, 0, v2.Stroke.Standard),
							backgroundStyle = v2.Color.Content.Default,
							testId = "create-ad-campaign-strikethrough"
						})
					}),
					Free = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.freeText,
						tag = "auto-xy text-title-large content-emphasis"
					})
				})
			}
		)
	end

	v8.Campaign = campaign
	local disclaimer

	if not gapxlarge then
		disclaimer = React.createElement(Text, {
			LayoutOrder = 3,
			Text = props.earnedRobuxDisclaimer,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	v8.Disclaimer = disclaimer
	local included

	if not gapxlarge then
		included = React.createElement(
			View,
			{
				LayoutOrder = 4,
				tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge stroke-standard stroke-default radius-medium bg-surface-0"
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.includedTitle,
					tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
				}),
				Benefits = React.createElement(
					View,
					{
						LayoutOrder = 2,
						tag = "col gap-xxlarge size-full-0 auto-y padding-bottom-small padding-left-medium"
					},
					createBenefitRows(props.benefits)
				)
			}
		)
	end

	v8.Included = included

	v8.Legal = React.createElement(AdCampaignLegalText, {
		LayoutOrder = 5,
		text = props.legalText,
		onAdvertisingTerms = props.onAdvertisingTerms,
		onAdvertisingStandards = props.onAdvertisingStandards
	})
	children.Content = createElement4(content, nil, {
		Body = createElement5(View, {
			tag = {
				["col size-full-0 auto-y"] = true,
				["gap-large"] = not gapxlarge,
				["gap-xlarge"] = gapxlarge
			}
		}, v8)
	})

	local createElement6 = React.createElement
	local actions = Sheet.Actions
	local createElement7 = React.createElement
	local err

	if props.hasCreateError then
		local createElement8 = React.createElement
		local v9 = {
			LayoutOrder = 0,
			Text = props.createErrorText,
			Size = 0,
			tag = 0,
			testId = 0
		}
		local size

		if gapxlarge then
			size = UDim2.new(1, 0, 0, v4)
		end

		v9.Size = size
		v9.tag = {
			["auto-y text-caption-medium text-wrap text-align-x-left text-align-y-bottom content-system-alert"] = gapxlarge,
			["size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert"] = not gapxlarge
		}

		v9.testId = `{v5}-create-error`
		err = createElement8(Text, v9)
	end

	local adCredits

	if gapxlarge and props.showAdCreditsCallout then
		adCredits = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "size-full-0 auto-y padding-bottom-small",
				testId = "two-options-ad-campaign-ad-credits"
			},
			{
				Link = React.createElement(
					View,
					{
						onActivated = props.onOpenAdsManager,
						tag = "row align-y-center size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium",
						testId = "two-options-ad-campaign-ad-credits-link"
					},
					{
						Copy = React.createElement(View, {
							LayoutOrder = 1,
							tag = "col fill gap-xxsmall auto-y"
						}, {
							Title = React.createElement(Text, {
								LayoutOrder = 1,
								Text = props.adCreditsTitle,
								tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-left content-emphasis"
							}),
							Description = React.createElement(Text, {
								LayoutOrder = 2,
								Text = props.adCreditsAction,
								tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
							})
						}),
						ExternalLink = React.createElement(Icon, {
							LayoutOrder = 2,
							name = Foundation.Enums.IconName.ArrowUpRightFromSquare,
							size = IconSize.Small,
							tag = "auto-xy content-emphasis",
							testId = "two-options-ad-campaign-ad-credits-icon"
						})
					}
				)
			}
		)
	end

	local createElement8 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		text = props.createText,
		size = InputSize.Medium,
		variant = ButtonVariant.Emphasis,
		width = UDim.new(1, 0),
		isDisabled = 0,
		isLoading = 0,
		onActivated = 0,
		testId = 0
	}
	local isDisabled

	if gapxlarge then
		isDisabled = props.isCreateDisabled
	end

	v9.isDisabled = isDisabled
	v9.isLoading = props.isCreatePending or gapxlarge and props.isFundingCheckPending
	v9.onActivated = props.onCreate
	v9.testId = `{v5}-create-button`
	children.Actions = createElement6(actions, nil, {
		Footer = createElement7(View, { tag = "col gap-medium size-full-0 auto-y" }, {
			Error = err,
			AdCredits = adCredits,
			Create = createElement8(Button, v9),
			Moderation = React.createElement(Text, {
				LayoutOrder = 3,
				Text = props.moderationNotice,
				Size = UDim2.new(1, 0, 0, v3),
				tag = "auto-y text-caption-small text-wrap text-align-x-left content-default",
				testId = `{v5}-moderation-notice`
			})
		})
	})
	return createElement(root, v6, children)
end

return CreateAdCampaignSheetView
