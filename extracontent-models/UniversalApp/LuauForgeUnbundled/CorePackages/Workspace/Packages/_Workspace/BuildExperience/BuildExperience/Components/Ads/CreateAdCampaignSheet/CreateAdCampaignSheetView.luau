local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local InlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InlineLayout")

local button = Foundation.Button
local chip = Foundation.Chip
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local optionSelectorGroup = Foundation.OptionSelectorGroup
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local inlineLayout = InlineLayout.Components.InlineLayout
local linkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local textElement = InlineLayout.Components.InlineLayoutElements.TextElement

local CreateAdCampaignSheetConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetConfig")
local FFlagBuildAdsUiPolish = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsUiPolish")

local buttonVariant = Foundation.Enums.ButtonVariant
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local optionSelectorGroupSize = Foundation.Enums.OptionSelectorGroupSize
local useTokens = Foundation.Hooks.useTokens

local v5 = { 1 }
local v6 = { name = "u", attributes = {} }

local function createLegalTextElement(p2, p3, p4)
	return textElement.new({ Text = p2, fontStyle = p3, textStyle = p4 })
end

local function createLegalElements(text2, bodyMedium, default, onActivated, onActivated2)
	local v7 = {
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
	local v8 = 1
	local legalElements = {}

	while v8 <= #text2 do
		local v9 = nil
		local v10 = nil
		local v11 = nil

		for k, v12 in v7 do
			local v13, v14 = string.find(text2, v12.startMarker, v8, true)

			if not (v13 ~= nil and (v9 == nil or v13 < v9)) then
				continue
			end

			v11 = v14
			v10 = v12
			v9 = v13
		end

		if v10 == nil or v9 == nil or v11 == nil then
			table.insert(legalElements, createLegalTextElement(string.sub(text2, v8), bodyMedium, default))
			return legalElements
		end

		if v8 < v9 then
			table.insert(
				legalElements,
				createLegalTextElement(string.sub(text2, v8, v9 - 1), bodyMedium, default)
			)
		end

		local v12, v13 = string.find(text2, v10.endMarker, v11 + 1, true)

		if v12 == nil or v13 == nil then
			table.insert(legalElements, createLegalTextElement(string.sub(text2, v9), bodyMedium, default))
			return legalElements
		end

		local v14 = string.sub(text2, v11 + 1, v12 - 1)
		local onActivated3 = v10.onActivated
		table.insert(legalElements, linkElement.new({ textElement.new({
				Text = v14,
				EngineTags = { v6 },
				fontStyle = bodyMedium,
				textStyle = default
			}) }, {
			onActivated = function()
				onActivated3(v14)
			end
		}))

		v8 = v13 + 1
	end

	return legalElements
end

local function AdCampaignLegalText(props)
	local v7 = useTokens()
	local bodyMedium = v7.Typography.BodyMedium
	local legalElements = createLegalElements(
		props.text,
		bodyMedium,
		v7.Color.Content.Default,
		props.onAdvertisingTerms,
		props.onAdvertisingStandards
	)

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = "size-full-0 auto-y"
	}, {
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
			view,
			{
				LayoutOrder = k,
				tag = "row align-y-center gap-xxlarge size-full-0 auto-y padding-y-xsmall"
			},
			{
				Icon = React.createElement(icon, {
					LayoutOrder = 1,
					name = item.icon,
					size = iconSize.Large,
					tag = "content-emphasis"
				}),
				Label = React.createElement(text, {
					LayoutOrder = 2,
					Text = item.text,
					tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		)
	end

	return children
end

local function CampaignPrice(p2)
	local v7 = useTokens()

	if p2.option.originalPriceText == nil then
		return React.createElement(
			view,
			{
				LayoutOrder = 1,
				testId = p2.testId,
				tag = "row align-y-center gap-xxsmall auto-xy"
			},
			{
				Icon = React.createElement(icon, {
					LayoutOrder = 1,
					name = Foundation.Enums.IconName.Robux,
					size = iconSize.Small,
					tag = "content-default",
					testId = `{p2.testId}-robux-icon`
				}),
				Amount = React.createElement(text, {
					LayoutOrder = 2,
					Text = p2.option.priceText,
					tag = "auto-xy text-body-medium content-default"
				})
			}
		)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = 1,
			testId = p2.testId,
			tag = "row align-y-center gap-small auto-xy"
		},
		{
			OriginalPrice = React.createElement(view, {
				LayoutOrder = 1,
				tag = "auto-xy"
			}, {
				Content = React.createElement(
					view,
					{ ZIndex = 1, tag = "row align-y-center gap-xxsmall auto-xy" },
					{
						Icon = React.createElement(icon, {
							LayoutOrder = 1,
							name = Foundation.Enums.IconName.Robux,
							size = iconSize.Small,
							tag = "content-default",
							testId = `{p2.testId}-robux-icon`
						}),
						Amount = React.createElement(text, {
							LayoutOrder = 2,
							Text = p2.option.originalPriceText,
							tag = "auto-xy text-body-medium content-default"
						})
					}
				),
				Strikethrough = React.createElement(view, {
					ZIndex = 2,
					tag = "position-center-left anchor-center-left",
					Size = UDim2.new(1, 0, 0, 1),
					backgroundStyle = v7.Color.Content.Default,
					testId = `{p2.testId}-strikethrough`
				})
			}),
			Free = React.createElement(text, {
				LayoutOrder = 2,
				Text = p2.option.priceText,
				tag = "auto-xy text-title-medium content-emphasis",
				testId = `{p2.testId}-free`
			})
		}
	)
end

local function CampaignOptionItem(props)
	local v7 = useTokens()
	local ref = React.useRef(nil)

	React.useImperativeHandle(props.optionRef, function()
		return ref.current
	end)

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = "size-full-0 auto-y"
	}, {
		Selector = React.createElement(optionSelectorGroup.Item, {
			value = props.option.value,
			label = props.option.title,
			metadata = props.option.runDates,
			description = props.option.description,
			isDisabled = props.isInteractionDisabled,
			ref = ref
		}),
		Price = React.createElement(view, {
			Position = UDim2.new(1, -v7.Padding.XLarge, 0, v7.Padding.XLarge),
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
	local v7 = useTokens()
	local v8 = props.variant == "twoOptions"

	local v9 = math.ceil(v7.Typography.CaptionSmall.FontSize * v7.Typography.CaptionSmall.LineHeight * 2)

	local v10 = math.ceil(v7.Typography.CaptionMedium.FontSize * v7.Typography.CaptionMedium.LineHeight * 2)
	local v11 = v8 and "two-options-ad-campaign" or "create-ad-campaign"
	local createElement = React.createElement
	local root = sheet.Root
	local v12 = {
		isOpen = props.isOpen,
		ref = 0,
		preferCenterSheet = true,
		snapPoints = 0,
		onClose = 0,
		testId = 0
	}
	local v13 = if v8 then props.sheetRootRef else nil
	v12.ref = v13

	v12.snapPoints = v5
	v12.onClose = props.onClose
	v12.testId = v8 and "TwoOptionsAdCampaignSheet" or nil

	local createElement2 = React.createElement
	local header = sheet.Header

	local createElement3 = React.createElement
	local v17 = {
		LayoutOrder = 1,
		tag = {
			["row align-y-center size-full-0 auto-y"] = true,
			["flex-between"] = not v8 or props.showCloseButton,
			["align-x-right"] = v8 and not props.showCloseButton
		}
	}
	local v19

	if not (v8 and not props.showCloseButton) then
		local createElement4 = React.createElement
		local v21 = {
			LayoutOrder = 1,
			icon = Foundation.Enums.IconName.X,
			size = inputSize.Large,
			variant = buttonVariant.Utility,
			isDisabled = props.isCreatePending,
			onActivated = props.onClose,
			testId = 0
		}
		local v22 = if v8 then `{v11}-close` else nil
		v21.testId = v22
		v19 = createElement4(iconButton, v21)
	end

	local v20

	if FFlagBuildAdsUiPolish then
		v20 = React.createElement(chip, {
			LayoutOrder = 2,
			text = props.balanceText,
			leading = Foundation.Enums.IconName.Robux,
			variant = chipVariant.Standard,
			size = chipSize.Medium,
			onActivated = not v8 and function() end or props.onOpenBuyRobux,
			isDisabled = not v8 or props.isCreatePending,
			testId = v8 and "two-options-ad-campaign-balance" or nil
		})
	else
		local createElement4 = React.createElement

		local v23 = if v8 and not props.isCreatePending then props.onOpenBuyRobux else nil
		v20 = createElement4(view, {
			LayoutOrder = 2,
			onActivated = v23,
			tag = "row align-y-center gap-small auto-xy padding-right-small",
			testId = v8 and "two-options-ad-campaign-balance" or nil
		}, {
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = Foundation.Enums.IconName.Robux,
				size = iconSize.Medium,
				tag = {
					["content-emphasis"] = props.balanceState == "ready",
					["content-muted"] = props.balanceState ~= "ready"
				}
			}),
			Amount = React.createElement(text, {
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
			HeaderRow = createElement3(view, v17, { Close = v19, Balance = v20 })
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = sheet.Content
	local createElement5 = React.createElement

	local v25 = {
		Introduction = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "col gap-xxsmall size-full-0 auto-y" },
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.title,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"
				}),
				Description = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.description,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis"
				})
			}
		),
		Campaign = 0,
		Disclaimer = 0,
		Included = 0,
		Legal = 0
	}
	local v26

	if v8 then
		local createElement6 = React.createElement

		local v29 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.startCampaignTitle,
				tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
			}),
			Options = 0
		}

		local createElement7 = React.createElement
		local root2 = optionSelectorGroup.Root
		local v30 = {
			LayoutOrder = 2,
			value = props.selectedOption,
			onValueChanged = props.onOptionChanged,
			size = optionSelectorGroupSize.Medium,
			Selectable = not props.isCreatePending,
			testId = "two-options-ad-campaign-options"
		}
		local v32

		if props.feedbackOption ~= nil then
			local createElement8 = React.createElement
			local v34 = {
				LayoutOrder = 1,
				option = props.feedbackOption,
				optionRef = 0,
				isInteractionDisabled = 0,
				testId = "two-options-ad-campaign-feedback-option"
			}
			local v35 = if props.selectedOption == props.feedbackOption.value then props.defaultOptionRef else nil
			v34.optionRef = v35

			v34.isInteractionDisabled = props.isCreatePending
			v32 = createElement8(CampaignOptionItem, v34)
		end

		local v33

		if props.playsOption ~= nil then
			local createElement8 = React.createElement
			local v35 = {
				LayoutOrder = 2,
				option = props.playsOption,
				optionRef = 0,
				isInteractionDisabled = 0,
				testId = "two-options-ad-campaign-plays-option"
			}
			local v36 = if props.selectedOption == props.playsOption.value then props.defaultOptionRef else nil
			v35.optionRef = v36

			v35.isInteractionDisabled = props.isCreatePending
			v33 = createElement8(CampaignOptionItem, v35)
		end

		v29.Options = createElement7(root2, v30, { Feedback = v32, Plays = v33 })
		v26 = createElement6(view, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, v29)
	else
		v26 = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-small size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-0"
			},
			{
				Name = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.campaignTitle,
					tag = "fill auto-y text-label-large text-wrap text-align-x-left content-emphasis"
				}),
				Price = React.createElement(
					view,
					{ LayoutOrder = 2, tag = "row align-y-center gap-small auto-xy" },
					{
						Estimated = React.createElement(view, {
							LayoutOrder = 1,
							tag = "auto-xy"
						}, {
							Content = React.createElement(
								view,
								{
									ZIndex = 1,
									tag = "row align-y-center gap-xxsmall auto-xy"
								},
								{
									Icon = React.createElement(icon, {
										LayoutOrder = 1,
										name = Foundation.Enums.IconName.Robux,
										size = iconSize.Small,
										tag = "content-default"
									}),
									Amount = React.createElement(text, {
										LayoutOrder = 2,
										Text = props.estimatedPriceText,
										tag = "auto-xy text-body-large content-default"
									})
								}
							),
							Strikethrough = React.createElement(view, {
								ZIndex = 2,
								tag = "position-center-left anchor-center-left",
								Size = UDim2.new(1, 0, 0, v7.Stroke.Standard),
								backgroundStyle = v7.Color.Content.Default,
								testId = "create-ad-campaign-strikethrough"
							})
						}),
						Free = React.createElement(text, {
							LayoutOrder = 2,
							Text = props.freeText,
							tag = "auto-xy text-title-large content-emphasis"
						})
					}
				)
			}
		)
	end

	v25.Campaign = v26

	local v27 = if not v8 then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.earnedRobuxDisclaimer,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
	}) else nil
	v25.Disclaimer = v27

	local v28 = if not v8 then React.createElement(
		view,
		{
			LayoutOrder = 4,
			tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge stroke-standard stroke-default radius-medium bg-surface-0"
		},
		{
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.includedTitle,
				tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
			}),
			Benefits = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col gap-xxlarge size-full-0 auto-y padding-bottom-small padding-left-medium"
				},
				createBenefitRows(props.benefits)
			)
		}
	) else nil
	v25.Included = v28

	v25.Legal = React.createElement(AdCampaignLegalText, {
		LayoutOrder = 5,
		text = props.legalText,
		onAdvertisingTerms = props.onAdvertisingTerms,
		onAdvertisingStandards = props.onAdvertisingStandards
	})
	children.Content = createElement4(content, nil, {
		Body = createElement5(view, {
			tag = {
				["col size-full-0 auto-y"] = true,
				["gap-large"] = not v8,
				["gap-xlarge"] = v8
			}
		}, v25)
	})

	local createElement6 = React.createElement
	local actions = sheet.Actions
	local createElement7 = React.createElement
	local v33

	if props.hasCreateError then
		local createElement8 = React.createElement
		local v35 = {
			LayoutOrder = 0,
			Text = props.createErrorText,
			Size = 0,
			tag = 0,
			testId = 0
		}
		local v36 = if v8 then UDim2.new(1, 0, 0, v10) else nil
		v35.Size = v36
		v35.tag = {
			["auto-y text-caption-medium text-wrap text-align-x-left text-align-y-bottom content-system-alert"] = v8,
			["size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert"] = not v8
		}

		v35.testId = `{v11}-create-error`
		v33 = createElement8(text, v35)
	end

	local v34 = if v8 and props.showAdCreditsCallout then React.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "size-full-0 auto-y padding-bottom-small",
			testId = "two-options-ad-campaign-ad-credits"
		},
		{
			Link = React.createElement(
				view,
				{
					onActivated = props.onOpenAdsManager,
					tag = "row align-y-center size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium",
					testId = "two-options-ad-campaign-ad-credits-link"
				},
				{
					Copy = React.createElement(
						view,
						{ LayoutOrder = 1, tag = "col fill gap-xxsmall auto-y" },
						{
							Title = React.createElement(text, {
								LayoutOrder = 1,
								Text = props.adCreditsTitle,
								tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-left content-emphasis"
							}),
							Description = React.createElement(text, {
								LayoutOrder = 2,
								Text = props.adCreditsAction,
								tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
							})
						}
					),
					ExternalLink = React.createElement(icon, {
						LayoutOrder = 2,
						name = Foundation.Enums.IconName.ArrowUpRightFromSquare,
						size = iconSize.Small,
						tag = "auto-xy content-emphasis",
						testId = "two-options-ad-campaign-ad-credits-icon"
					})
				}
			)
		}
	) else nil

	local createElement8 = React.createElement
	local v36 = {
		LayoutOrder = 2,
		text = props.createText,
		size = inputSize.Medium,
		variant = buttonVariant.Emphasis,
		width = UDim.new(1, 0),
		isDisabled = 0,
		isLoading = 0,
		onActivated = 0,
		testId = 0
	}
	local v37 = if v8 then props.isCreateDisabled else nil
	v36.isDisabled = v37
	v36.isLoading = props.isCreatePending or v8 and props.isFundingCheckPending
	v36.onActivated = props.onCreate
	v36.testId = `{v11}-create-button`
	children.Actions = createElement6(actions, nil, {
		Footer = createElement7(view, { tag = "col gap-medium size-full-0 auto-y" }, {
			Error = v33,
			AdCredits = v34,
			Create = createElement8(button, v36),
			Moderation = React.createElement(text, {
				LayoutOrder = 3,
				Text = props.moderationNotice,
				Size = UDim2.new(1, 0, 0, v9),
				tag = "auto-y text-caption-small text-wrap text-align-x-left content-default",
				testId = `{v11}-moderation-notice`
			})
		})
	})
	return createElement(root, v12, children)
end

return CreateAdCampaignSheetView
