local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FoundationCloudAssets")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local OverflowMenuPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/OverflowMenuPageShell")
local ChatActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatActions")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceMonetizationMultiKind = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationMultiKind")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceDeveloperProductContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDeveloperProductContext")
local FFlagBuildExperienceMonetizationPageFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationPageFixes")

local badge = Foundation.Badge
local button = Foundation.Button
local dialog = Foundation.Dialog
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local image = Foundation.Image
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local textArea = Foundation.TextArea
local textInput = Foundation.TextInput
local toggle = Foundation.Toggle
local view = Foundation.View
local menu = Foundation.Menu
local skeleton = Foundation.Skeleton

local badgeShape = Foundation.Enums.BadgeShape
local badgeSize = Foundation.Enums.BadgeSize
local badgeVariant = Foundation.Enums.BadgeVariant
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local assetId = if FFlagBuildExperienceMonetizationNativeUI then FoundationCloudAssets.Assets["pictograms/robux"].assetId else nil

local udim = UDim2.new(1 / 3, -8, 0, 0)

local function ProductActionsMenu(props)
	local state, setState = React.useState(false)
	local v5 = React.useCallback(function()
		setState(false)
	end, {})
	local v6 = useLocalization({ archive = LocalizationStrings.ARCHIVE_GAME_ARCHIVE })
	local v7 = React.useMemo(function()
		return {
			{
				id = "edit",
				text = props.editLabel,
				icon = iconName.Pencil,
				isDisabled = props.isDisabled
			},
			{
				id = "archive",
				text = v6.archive,
				icon = iconName.TrashCan,
				isDisabled = true
			}
		}
	end, { v6.archive, props.editLabel, props.isDisabled })
	return React.createElement(menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = state,
		items = v7,
		onActivated = function(p2)
			v5()

			if p2 == "edit" and not props.isDisabled then
				props.onEdit()
			end
		end,
		onPressedOutside = v5,
		side = Foundation.Enums.PopoverSide.Bottom,
		testId = "monetization-product-actions-menu"
	}, {
		Trigger = React.createElement(iconButton, {
			icon = iconName.ThreeDotsHorizontal,
			isCircular = true,
			isDisabled = props.isDisabled,
			onActivated = function()
				setState(not state)
			end,
			size = inputSize.Medium,
			testId = "monetization-product-actions",
			variant = buttonVariant.Utility
		})
	})
end

local function ProductCard(props)
	local product = props.product
	local v5 = useTokens()
	local v6 = product.image

	if not v6 then
		v6 = if FFlagBuildExperienceMonetizationNativeUI then assetId else nil
	end

	local identity = product.identity or product.id

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		selection = { Selectable = true },
		Size = 0,
		stateLayer = 0,
		tag = "col auto-y radius-medium",
		testId = 0
	}
	local v9 = if props.tileWidth == nil then udim else UDim2.new(0, props.tileWidth, 0, 0)
	v8.Size = v9
	v8.stateLayer = { affordance = stateLayerAffordance.None }

	v8.testId = `monetization-product-{identity}`

	local createElement2 = React.createElement
	local udim2

	if props.tileWidth == nil then
		if FFlagBuildExperienceMonetizationNativeUI and not FFlagBuildExperienceMonetizationMultiKind then
			udim2 = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_2800)
		else
			udim2 = if FFlagBuildExperienceMonetizationMultiKind then UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, 109)
		end
	else
		udim2 = UDim2.fromOffset(props.tileWidth, props.tileWidth)
	end

	local v11 = {
		LayoutOrder = 1,
		Size = udim2,
		aspectRatio = 1,
		tag = props.tileWidth == nil and "radius-medium clip bg-surface-200" or "radius-medium clip bg-shift-200"
	}

	local v13 = if product.saleStatus ~= nil and (not (not FFlagBuildExperienceMonetizationMultiKind and FFlagBuildExperienceMonetizationNativeUI) or product.isForSale == true) then React.createElement(badge, {
		Position = UDim2.fromOffset(v5.Gap.Small, v5.Gap.Small),
		shape = badgeShape.Pill,
		size = badgeSize.Small,
		text = product.saleStatus,
		testId = `monetization-product-sale-status-{identity}`,
		variant = badgeVariant.OverMedia,
		ZIndex = 2
	}) else nil
	local v14

	if v6 ~= nil then
		local createElement3 = React.createElement

		local v17 = if FFlagBuildExperienceMonetizationNativeUI and product.image == nil then v5.Color.Content.Emphasis else nil
		v14 = createElement3(image, {
			Image = v6,
			imageStyle = v17,
			ScaleType = Enum.ScaleType.Fit,
			tag = FFlagBuildExperienceMonetizationNativeUI and "size-full radius-medium" or "size-full",
			testId = `monetization-product-image-{identity}`
		})
	end

	local children = {
		Media = createElement2(view, v11, { SaleStatus = v13, Image = v14 }),
		Title = 0,
		Kind = 0,
		Metadata = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		LayoutOrder = 2,
		Text = product.name,
		sizeConstraint = FFlagBuildExperienceMonetizationNativeUI and {
			MaxSize = Vector2.new(v5.Size.Size_2800, v5.Size.Size_1000 + v5.Gap.Small)
		} or nil,
		tag = {
			["size-full-0 auto-y padding-top-small text-title-medium text-align-x-left text-truncate-end content-emphasis"] = true,
			["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
		},
		testId = 0
	}

	local v17 = if FFlagBuildExperienceMonetizationNativeUI then `monetization-product-title-{identity}` else nil
	v16.testId = v17
	children.Title = createElement3(text, v16)

	local v18 = if FFlagBuildExperienceMonetizationMultiKind and product.kind ~= nil and props.tileWidth == nil then React.createElement(text, {
		LayoutOrder = 3,
		Text = product.kind,
		tag = "size-full-0 auto-y padding-top-xsmall text-body-small text-wrap text-align-x-left content-muted",
		testId = `monetization-product-kind-{identity}`
	}) else nil
	children.Kind = v18

	local createElement4 = React.createElement
	local v20 = {
		LayoutOrder = 4,
		sizeConstraint = FFlagBuildExperienceMonetizationNativeUI and {
			MaxSize = Vector2.new(v5.Size.Size_2800, 1e999)
		} or nil,
		tag = {
			["row align-y-center gap-xsmall size-full-0 auto-y"] = true,
			["padding-top-xsmall"] = FFlagBuildExperienceMonetizationNativeUI
		}
	}

	local v22 = if not FFlagBuildExperienceMonetizationNativeUI and product.kind ~= nil then React.createElement(text, {
		LayoutOrder = 1,
		Text = product.kind,
		tag = "auto-xy text-body-medium content-default"
	}) else nil

	local v23 = if not FFlagBuildExperienceMonetizationMultiKind or product.showRobuxIcon ~= false then React.createElement(icon, {
		LayoutOrder = 2,
		name = iconName.Robux,
		size = iconSize.Small
	}) else nil
	local v21 = {
		Kind = v22,
		PriceIcon = v23,
		Price = React.createElement(text, {
			LayoutOrder = 3,
			Text = product.price,
			tag = FFlagBuildExperienceMonetizationNativeUI and "fill auto-y text-body-medium text-wrap text-align-x-left content-default" or "auto-xy text-body-medium content-default"
		}),
		Spacer = 0,
		Age = 0
	}

	local v24 = if not FFlagBuildExperienceMonetizationNativeUI then React.createElement(view, {
		LayoutOrder = 4,
		tag = "fill"
	}) else nil
	v21.Spacer = v24

	local v25 = if not FFlagBuildExperienceMonetizationNativeUI and product.age ~= nil then React.createElement(text, {
		LayoutOrder = 5,
		Text = product.age,
		tag = "auto-xy text-body-medium content-default"
	}) else nil
	v21.Age = v25
	children.Metadata = createElement4(view, v20, v21)
	return createElement(view, v8, children)
end

local function ProductRow(props)
	local children = {}

	for i = props.startIndex, math.min(props.startIndex + 2, #props.products) do
		local product = props.products[i]
		local identity = product.identity or product.id
		children[identity] = React.createElement(ProductCard, {
			LayoutOrder = i - props.startIndex + 1,
			product = product,
			onActivated = function()
				props.onProductActivated(identity)
			end
		})
	end

	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "row gap-medium size-full-0 auto-y" },
		children
	)
end

local function OptionRow(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-large size-full-0 auto-y padding-x-large padding-y-medium"
	}

	local createElement2 = React.createElement

	local v9 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = {
				["size-full-0 auto-y text-title-medium text-align-x-left content-emphasis"] = true,
				["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}),
		Description = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Supporting = 0
	}

	local v10 = if props.supportingText ~= nil then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.supportingText,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted"
	}) else nil
	v9.Supporting = v10
	return createElement(view, v6, {
		Copy = createElement2(view, {
			LayoutOrder = 1,
			tag = FFlagBuildExperienceMonetizationNativeUI and "col fill gap-xsmall auto-y" or "col fill gap-xxsmall auto-y"
		}, v9),
		Toggle = React.createElement(toggle, {
			LayoutOrder = 2,
			isChecked = props.isChecked,
			isDisabled = props.isDisabled,
			label = "",
			onActivated = props.onActivated,
			size = inputSize.Medium,
			testId = props.testId
		})
	})
end

local function OptionsStatusContent(props)
	if props.optionsLoadStatus == "NotReady" then
		return React.createElement(text, {
			Text = props.labels.loading,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted",
			testId = "monetization-options-loading"
		})
	end

	if props.optionsLoadStatus == "Failed" then
		return React.createElement(
			view,
			{
				tag = "col align-x-center gap-medium size-full-0 auto-y padding-large",
				testId = "monetization-options-error"
			},
			{
				Message = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.labels.optionsLoadError,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				}),
				Retry = React.createElement(button, {
					LayoutOrder = 2,
					onActivated = props.onRetryOptions,
					size = inputSize.Medium,
					text = props.labels.retry,
					variant = buttonVariant.Standard
				})
			}
		)
	end

	return nil
end

local function OptionsContent(props)
	local v5 = OptionsStatusContent(props)

	if v5 ~= nil then
		return v5
	end

	local v6 = props.managedPricingSupportingText

	if not v6 then
		if props.managedPricingState == "Mixed" then
			v6 = props.labels.mixed
		else
			v6 = if props.managedPricingState == "Unavailable" then props.labels.unavailable else nil
		end
	end

	local v7 = {
		actions = {
			{
				text = props.labels.agree,
				variant = buttonVariant.Emphasis,
				onActivated = props.onConfirmManagedPricing,
				isDisabled = false,
				isLoading = props.isOptionsManagedPricingPending
			},
			{
				text = props.labels.cancel,
				variant = buttonVariant.Standard,
				onActivated = props.onCancelManagedPricing,
				isDisabled = props.isOptionsManagedPricingPending,
				isLoading = false
			}
		}
	}

	local createElement = React.createElement

	local v10 = if not props.canMonetize then React.createElement(text, {
		LayoutOrder = 1,
		Text = props.labels.permissionDenied,
		tag = "size-full-0 auto-y padding-medium text-body-medium text-wrap radius-medium bg-surface-100 content-default"
	}) else nil

	local createElement2 = React.createElement

	local v13 = {
		Header = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "col gap-xsmall size-full-0 auto-y" },
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.labels.pricingOptions,
					tag = {
						["size-full-0 auto-y text-title-large text-align-x-left content-emphasis"] = true,
						["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
					}
				}),
				Description = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.labels.pricingOptionsDescription,
					tag = {
						["size-full-0 auto-y text-body-small text-align-x-left content-default"] = true,
						["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
					}
				})
			}
		),
		Rows = 0
	}

	local createElement3 = React.createElement

	local v16 = {
		ManagedPricing = React.createElement(OptionRow, {
			LayoutOrder = 1,
			description = props.labels.managedPricingDescription,
			isChecked = props.managedPricingState == "AllOn",
			isDisabled = not props.canChangeManagedPricing or props.isOptionsManagedPricingPending,
			onActivated = props.onManagedPricingChanged,
			supportingText = v6,
			testId = "monetization-managed-pricing",
			title = props.labels.managedPricing
		}),
		Error = 0
	}

	local v17 = if props.managedPricingError ~= nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.managedPricingError,
		tag = "size-full-0 auto-y padding-x-large padding-bottom-medium text-body-small text-wrap content-alert"
	}) else nil
	v16.Error = v17
	v13.Rows = createElement3(
		view,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
		},
		v16
	)
	local children = {
		Permission = v10,
		Pricing = createElement2(view, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, v13),
		Shop = 0,
		Acknowledgement = 0
	}

	local createElement4 = React.createElement

	local v20 = {
		Header = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.labels.shopUI,
			tag = {
				["size-full-0 auto-y text-title-large text-align-x-left content-emphasis"] = true,
				["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}),
		Rows = 0
	}

	local createElement5 = React.createElement

	local v23 = {
		ShopButton = React.createElement(OptionRow, {
			LayoutOrder = 1,
			description = props.labels.shopButtonDescription,
			isChecked = props.shopButtonEnabled,
			isDisabled = not props.canMonetize or props.isShopButtonPending,
			onActivated = props.onShopButtonChanged,
			testId = "monetization-shop-button",
			title = props.labels.shopButton
		}),
		Error = 0
	}

	local v24 = if props.shopButtonError ~= nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.shopButtonError,
		tag = "size-full-0 auto-y padding-x-large padding-bottom-medium text-body-small text-wrap content-alert"
	}) else nil
	v23.Error = v24
	v20.Rows = createElement5(
		view,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
		},
		v23
	)
	children.Shop = createElement4(view, {
		LayoutOrder = 3,
		tag = "col gap-large size-full-0 auto-y"
	}, v20)

	local v25 = if props.showManagedPricingAcknowledgement then React.createElement(dialog.Root, {
		disablePortal = props.disableDialogPortal == true,
		hasBackdrop = props.disableDialogPortal ~= true,
		size = dialogSize.Small
	}, {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = props.labels.acknowledgementTitle
		}),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(dialog.Text, {
				Text = props.labels.acknowledgementDescription
			})
		}),
		Actions = React.createElement(dialog.Actions, v7)
	}) else nil
	children.Acknowledgement = v25
	return createElement(
		view,
		{
			tag = "col gap-xxlarge size-full-0 auto-y padding-y-medium",
			testId = "monetization-options"
		},
		children
	)
end

local function ProductCarousel(props)
	local size_2800 = useTokens().Size.Size_2800

	local children = {}

	for k, product in props.products do
		local identity = product.identity or product.id
		children[identity] = React.createElement(ProductCard, {
			LayoutOrder = k,
			product = product,
			tileWidth = size_2800,
			onActivated = function()
				props.onProductActivated(identity)
			end
		})
	end

	return React.createElement(scrollView, {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		testId = props.testId,
		scroll = {
			AutomaticSize = Enum.AutomaticSize.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = Foundation.Enums.Visibility.None
		}
	}, {
		Row = React.createElement(view, { tag = "row gap-medium auto-xy" }, children)
	})
end

local v5 = {
	GamePass = {
		icon = iconName.Tag,
		title = LocalizationStrings.MONETIZATION_EMPTY_PASSES_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_PASSES_DESCRIPTION
	},
	DeveloperProduct = {
		icon = iconName.ShoppingCart,
		title = LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_DESCRIPTION
	},
	Subscription = {
		icon = iconName.CircleStar,
		title = LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_DESCRIPTION
	}
}

local function EmptyKindCard(p2)
	local v6 = v5[p2.kind]
	local v7 = useLocalization({ title = v6.title, description = v6.description })

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col align-x-center gap-small size-full-0 auto-y padding-large bg-surface-0 stroke-standard stroke-default radius-large",
			testId = `monetization-empty-{p2.kind}`
		},
		{
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = v6.icon,
				size = iconSize.XLarge
			}),
			Title = React.createElement(text, {
				LayoutOrder = 2,
				Text = v7.title,
				tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-center content-emphasis"
			}),
			Description = React.createElement(text, {
				LayoutOrder = 3,
				Text = v7.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-default"
			})
		}
	)
end

local function KindLoadingTiles(p2)
	local v6 = useTokens()
	local size_2800 = v6.Size.Size_2800
	local children = {}

	for i = 1, 3 do
		children[`tile-{i}`] = React.createElement(
			view,
			{
				LayoutOrder = i,
				Size = UDim2.fromOffset(size_2800, 0),
				tag = "col gap-small auto-y"
			},
			{
				Media = React.createElement(skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(size_2800, size_2800),
					radius = radius.Medium
				}),
				Title = React.createElement(skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.7, 0, 0, v6.Size.Size_400),
					radius = radius.Small
				}),
				Price = React.createElement(skeleton, {
					LayoutOrder = 3,
					Size = UDim2.new(0.4, 0, 0, v6.Size.Size_300),
					radius = radius.Small
				})
			}
		)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "row gap-medium size-full-0 auto-y clip",
			testId = `monetization-section-loading-{p2.kind}`
		},
		children
	)
end

local function getKindProducts(products, kind)
	local kindProducts = {}

	for k, item in products do
		if item.productKind == kind then
			table.insert(kindProducts, item)
		end
	end

	return kindProducts
end

local function EmptyKindSection(props)
	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = `monetization-empty-section-{props.kind}`
		},
		{
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.label,
				tag = "size-full-0 auto-y text-title-large text-align-x-left content-emphasis",
				testId = `monetization-section-title-{props.kind}`
			}),
			Card = React.createElement(EmptyKindCard, {
				kind = props.kind,
				LayoutOrder = 2
			})
		}
	)
end

local function KindLoadFailure(props)
	local onRetryCatalogSource = props.page.onRetryCatalogSource
	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-small size-full-0 auto-y padding-medium radius-medium bg-surface-100",
		testId = `monetization-catalog-source-{props.kind}`
	}
	local v8 = {
		Message = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.page.labels.loadErrorDescription,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Retry = 0
	}
	local v9

	if onRetryCatalogSource ~= nil then
		v9 = React.createElement(button, {
			LayoutOrder = 2,
			onActivated = function()
				onRetryCatalogSource(props.kind)
			end,
			size = inputSize.Medium,
			text = props.page.labels.retry,
			variant = buttonVariant.Standard,
			testId = `monetization-button-retry-{props.kind}`
		})
	end

	v8.Retry = v9
	return createElement(view, v7, v8)
end

local function hasLoadingSource(items): boolean
	for k, item in items do
		if item.status == "NotReady" then
			return true
		end
	end

	return false
end

local function createEmptyKindSection(p2, p3, p4)
	return React.createElement(EmptyKindSection, {
		kind = p3.kind,
		label = p3.label,
		LayoutOrder = p4
	})
end

local function GroupedCatalogContent(props)
	local children = {}
	local count = 0
	local catalogSources = {}

	if props.catalogSources ~= nil then
		local v6 = FFlagBuildExperienceMonetizationPageFixes

		if v6 then
			local flag = true

			for k, catalogSource in props.catalogSources do
				if catalogSource.status == "NotReady" then
					v6 = true
					flag = false
					break
				end
			end

			if flag then
				v6 = false
			end
		end

		for k, catalogSource in props.catalogSources do
			local kind = catalogSource.kind
			local kindProducts = getKindProducts(props.products, kind)

			local v7 = FFlagBuildExperienceMonetizationPageFixes

			if v7 then
				v7 = #kindProducts == 0 and catalogSource.status == "NotReady"
			end

			local v8 = FFlagBuildExperienceMonetizationPageFixes and catalogSource.status == "Failed"

			if #kindProducts == 0 and not (v7 or v8) then
				if catalogSource.status == "Ready" and not catalogSource.isIncomplete then
					if v6 then
						children[`empty-section-{kind}`] = React.createElement(EmptyKindSection, {
							kind = catalogSource.kind,
							label = catalogSource.label,
							LayoutOrder = k
						})
					else
						table.insert(catalogSources, catalogSource)
					end
				end
			else
				count += 1
				local v9 = {}
				v9.Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = catalogSource.label,
					tag = "size-full-0 auto-y text-title-large text-align-x-left content-emphasis",
					testId = `monetization-section-title-{kind}`
				})
				local v10

				if FFlagBuildExperienceMonetizationPageFixes and #kindProducts == 0 then
					if v7 then
						v10 = React.createElement(KindLoadingTiles, {
							kind = kind,
							LayoutOrder = 2
						})
					end
				else
					v10 = React.createElement(ProductCarousel, {
						LayoutOrder = 2,
						onProductActivated = props.onProductActivated,
						products = kindProducts,
						testId = `monetization-section-products-{kind}`
					})
				end

				v9.Products = v10

				local v11 = if v8 then React.createElement(KindLoadFailure, {
					page = props,
					kind = kind,
					LayoutOrder = 3
				}) else nil
				v9.Failure = v11

				local formatted = `section-{kind}`
				local createElement = React.createElement

				if not v6 then
					k = count
				end

				children[formatted] = createElement(
					view,
					{
						LayoutOrder = k,
						tag = "col gap-medium size-full-0 auto-y",
						testId = `monetization-section-{kind}`
					},
					v9
				)
			end
		end

		for k, v7 in catalogSources do
			count += 1
			children[`empty-section-{v7.kind}`] = React.createElement(EmptyKindSection, {
				kind = v7.kind,
				label = v7.label,
				LayoutOrder = count
			})
		end
	end

	return React.createElement(
		view,
		{
			tag = "col gap-large size-full-0 auto-y padding-top-medium",
			testId = "MonetizationPageView"
		},
		children
	)
end

local function CatalogContent(props)
	if FFlagBuildExperienceMonetizationMultiKind and props.catalogSources ~= nil and #props.catalogSources > 0 then
		return React.createElement(GroupedCatalogContent, props)
	end

	local count = 0
	local children = {}

	for i = 1, #props.products, 3 do
		count += 1
		children[`row-{count}`] = React.createElement(ProductRow, {
			LayoutOrder = count,
			onProductActivated = props.onProductActivated,
			products = props.products,
			startIndex = i
		})
	end

	return React.createElement(view, {
		tag = FFlagBuildExperienceMonetizationNativeUI and "col gap-large size-full-0 auto-y padding-top-medium" or "col gap-large size-full-0 auto-y padding-y-medium",
		testId = "MonetizationPageView"
	}, children)
end

local function EmptyContent(p2)
	local v6 = if FFlagBuildExperienceMonetizationNativeUI then useTokens() else nil
	local emphasis = if FFlagBuildExperienceMonetizationNativeUI then v6.Color.Content.Emphasis else nil
	local v7 = not FFlagBuildExperienceMonetizationNativeUI and 1 or v6.Config.UI.Scale
	local createElement = React.createElement

	local createElement2 = React.createElement
	local v11 = {
		Image = not FFlagBuildExperienceMonetizationNativeUI and "rbxasset://textures/ui/LuaApp/graphic/BuildExperience/NativeMonetization/EmptyCatalog.png" or assetId,
		imageStyle = emphasis,
		LayoutOrder = 1,
		ScaleType = Enum.ScaleType.Fit,
		Size = 0,
		testId = "monetization-empty-illustration"
	}

	local v12 = if FFlagBuildExperienceMonetizationNativeUI then UDim2.fromOffset(320 * v7, 180 * v7) else UDim2.fromOffset(298, 168)
	v11.Size = v12
	local element = createElement(view, {
		tag = FFlagBuildExperienceMonetizationNativeUI and "col align-x-center align-y-center size-full auto-y" or "col align-x-center gap-xxlarge size-full-0 auto-y padding-y-medium",
		testId = "MonetizationPageView"
	}, {
		Illustration = createElement2(image, v11),
		Copy = React.createElement(view, {
			LayoutOrder = 2,
			tag = FFlagBuildExperienceMonetizationNativeUI and "col align-x-center size-full-0 auto-y padding-large" or "col align-x-center size-full-0 auto-y"
		}, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = p2.emptyTitle,
				tag = FFlagBuildExperienceMonetizationNativeUI and "size-full-0 auto-y text-heading-medium text-wrap text-align-x-center content-emphasis" or "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis"
			}),
			Description = React.createElement(text, {
				LayoutOrder = 2,
				Text = p2.emptyDescription,
				tag = FFlagBuildExperienceMonetizationNativeUI and "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default" or "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
			})
		})
	})

	if FFlagBuildExperienceMonetizationNativeUI then
		return React.createElement(scrollView, {
			tag = "size-full",
			testId = "monetization-empty-scroll",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, { Content = element })
	end

	return element
end

local function CatalogStatusContent(props)
	if props.catalogStatus == "NotReady" then
		return React.createElement(text, {
			Text = props.labels.loading,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted",
			testId = "monetization-catalog-loading"
		})
	end

	return React.createElement(
		view,
		{
			tag = "col align-x-center gap-large size-full-0 auto-y padding-large",
			testId = "monetization-catalog-error"
		},
		{
			Copy = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col align-x-center gap-small size-full-0 auto-y"
				},
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.labels.loadErrorTitle,
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis"
					}),
					Description = React.createElement(text, {
						LayoutOrder = 2,
						Text = props.labels.loadErrorDescription,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
					})
				}
			),
			Retry = React.createElement(button, {
				LayoutOrder = 2,
				onActivated = props.onRetryCatalog,
				size = inputSize.Medium,
				text = props.labels.retry,
				variant = buttonVariant.Standard
			})
		}
	)
end

local function CatalogRefreshWarning(p2)
	return React.createElement(
		view,
		{
			tag = "col align-x-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-100",
			testId = "monetization-catalog-refresh-error"
		},
		{
			Message = React.createElement(text, {
				LayoutOrder = 1,
				Text = p2.labels.loadErrorDescription,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
			}),
			Retry = React.createElement(button, {
				LayoutOrder = 2,
				onActivated = p2.onRetryCatalog,
				size = inputSize.Medium,
				text = p2.labels.retry,
				variant = buttonVariant.Standard
			})
		}
	)
end

local function CatalogSourcesStatus(props)
	local children = {}
	local catalogSources = props.catalogSources

	if catalogSources == nil then
		return nil
	end

	for k, catalogSource in catalogSources do
		if catalogSource.status == "Ready" then
			continue
		end

		local kind = catalogSource.kind
		local createElement = React.createElement
		local v7 = {
			LayoutOrder = k,
			tag = "col gap-small size-full-0 auto-y padding-medium radius-medium bg-surface-100",
			testId = `monetization-catalog-source-{catalogSource.kind}`
		}
		local children2 = {
			Label = React.createElement(text, {
				LayoutOrder = 1,
				Text = catalogSource.label,
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			Message = 0,
			Retry = 0
		}

		local createElement2 = React.createElement

		local v10 = if catalogSource.status == "Failed" then props.labels.loadErrorDescription else props.labels.loading
		children2.Message = createElement2(text, {
			LayoutOrder = 2,
			Text = v10,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
		local v11

		if catalogSource.status == "Failed" and props.onRetryCatalogSource ~= nil then
			v11 = React.createElement(button, {
				LayoutOrder = 3,
				onActivated = function()
					props.onRetryCatalogSource(catalogSource.kind)
				end,
				size = inputSize.Medium,
				text = props.labels.retry,
				variant = buttonVariant.Standard
			})
		end

		children2.Retry = v11
		children[kind] = createElement(view, v7, children2)
	end

	return React.createElement(
		view,
		{
			tag = "col gap-medium size-full-0 auto-y",
			testId = "monetization-catalog-sources-status"
		},
		children
	)
end

local function DetailContent(props)
	local emphasis = if FFlagBuildExperienceMonetizationNativeUI then useTokens().Color.Content.Emphasis else nil
	local selectedProduct = props.selectedProduct

	if selectedProduct == nil then
		return React.createElement(view, {
			tag = "size-full",
			testId = "MonetizationPageView"
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v11

	if not (selectedProduct.image == nil and not FFlagBuildExperienceMonetizationNativeUI) then
		local createElement3 = React.createElement
		local v13 = {
			Image = selectedProduct.image or assetId,
			imageStyle = 0,
			ScaleType = 0,
			Size = 0,
			testId = "monetization-detail-image"
		}

		if selectedProduct.image ~= nil then
			emphasis = nil
		end

		v13.imageStyle = emphasis
		v13.ScaleType = Enum.ScaleType.Fit
		v13.Size = UDim2.fromOffset(195, 196)
		v11 = createElement3(image, v13)
	end

	local children = {
		Media = createElement2(view, {
			LayoutOrder = 1,
			tag = FFlagBuildExperienceMonetizationNativeUI and "row align-x-center size-full-0 auto-y padding-y-xlarge radius-medium bg-surface-200" or "row align-x-center size-full-0 auto-y padding-y-medium"
		}, { Image = v11 }),
		Summary = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v16 = {
		Name = React.createElement(text, {
			LayoutOrder = 1,
			Text = selectedProduct.name,
			tag = {
				["size-full-0 auto-y text-heading-small text-align-x-left content-emphasis"] = true,
				["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}),
		Kind = 0,
		Price = 0,
		Status = 0
	}

	local v17 = if FFlagBuildExperienceMonetizationMultiKind and selectedProduct.kind ~= nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = selectedProduct.kind,
		tag = "size-full-0 auto-y padding-top-xsmall text-body-medium text-wrap text-align-x-left content-muted",
		testId = "monetization-detail-kind"
	}) else nil
	v16.Kind = v17

	local createElement5 = React.createElement

	local v21 = if not FFlagBuildExperienceMonetizationMultiKind or selectedProduct.showRobuxIcon ~= false then React.createElement(icon, {
		LayoutOrder = 1,
		name = iconName.Robux,
		size = iconSize.Small
	}) else nil
	v16.Price = createElement5(
		view,
		{ LayoutOrder = 3, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
		{
			Icon = v21,
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = selectedProduct.price,
				tag = "auto-xy text-body-medium content-default"
			})
		}
	)

	local v22 = if selectedProduct.canManage == false and selectedProduct.saleStatus ~= nil and props.canChangeSaleStatus ~= true then React.createElement(text, {
		LayoutOrder = 4,
		Text = selectedProduct.saleStatus,
		tag = "size-full-0 auto-y padding-top-xsmall text-body-medium text-wrap text-align-x-left content-muted",
		testId = "monetization-detail-sale-status"
	}) else nil
	v16.Status = v22
	local children2 = {
		Title = createElement4(view, { LayoutOrder = 1, tag = "col size-full-0 auto-y" }, v16),
		Description = React.createElement(text, {
			LayoutOrder = 2,
			Text = selectedProduct.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		SaleStatus = 0,
		Pricing = 0
	}
	local v23

	if props.canManageProduct or props.canChangeSaleStatus == true then
		local createElement6 = React.createElement

		local v26 = {
			Row = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-large size-full-0 auto-y padding-y-large"
				},
				{
					Label = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.labels.availableForPurchase,
						tag = "fill auto-y text-body-medium text-align-x-left content-default"
					}),
					Toggle = React.createElement(toggle, {
						LayoutOrder = 2,
						isChecked = selectedProduct.isForSale == true,
						isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
						label = "",
						onActivated = props.onProductSaleStatusChanged,
						size = inputSize.Medium,
						testId = "monetization-detail-sale-status"
					})
				}
			),
			Error = 0
		}
		local v27

		if props.productSaleStatusError then
			local createElement7 = React.createElement

			local v30 = props.productSaleStatusErrorLabel

			if not v30 then
				if selectedProduct.priceInRobux == nil then
					v30 = props.labels.priceRequiredForSale
				else
					v30 = props.labels.updateError
				end
			end

			v27 = createElement7(text, {
				LayoutOrder = 2,
				Text = v30,
				tag = "size-full-0 auto-y text-body-small content-alert",
				testId = "monetization-sale-status-error"
			})
		end

		v26.Error = v27
		v23 = createElement6(view, {
			LayoutOrder = 3,
			tag = "col gap-small size-full-0 auto-y"
		}, v26)
	end

	children2.SaleStatus = v23
	local v24

	if
		selectedProduct.productKind == nil
		or selectedProduct.productKind == "DeveloperProduct"
		or props.canChangeKindManagedPricing == true
	then
		local createElement6 = React.createElement

		local v27 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.labels.pricing,
				tag = "size-full-0 auto-y padding-bottom-small text-heading-small text-align-x-left content-emphasis"
			}),
			Regional = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "row align-y-center gap-large size-full-0 auto-y padding-y-large"
				},
				{
					Label = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.labels.regionalPricing,
						tag = "fill auto-y text-body-medium text-align-x-left content-default"
					}),
					Toggle = React.createElement(toggle, {
						LayoutOrder = 2,
						isChecked = selectedProduct.isManagedPricingEnabled == true,
						isDisabled = props.isProductDisabled or props.isProductManagedPricingPending or props.isProductSaleStatusPending or not props.canUpdateProductManagedPricing,
						label = "",
						onActivated = props.onProductManagedPricingChanged,
						size = inputSize.Medium,
						testId = "monetization-detail-managed-pricing"
					})
				}
			),
			UpdateError = 0
		}
		local v28

		if props.productManagedPricingError then
			local createElement7 = React.createElement

			local v31 = props.productManagedPricingErrorLabel

			if not v31 then
				if selectedProduct.priceInRobux == nil then
					v31 = props.labels.priceRequiredForSale
				else
					v31 = props.labels.updateError
				end
			end

			v28 = createElement7(text, {
				LayoutOrder = 3,
				Text = v31,
				tag = "size-full-0 auto-y text-body-small content-alert",
				testId = "monetization-managed-pricing-error"
			})
		end

		v27.UpdateError = v28
		v24 = createElement6(view, { LayoutOrder = 4, tag = "col size-full-0 auto-y" }, v27)
	end

	children2.Pricing = v24
	children.Summary = createElement3(
		view,
		{ LayoutOrder = 2, tag = "col gap-xxlarge size-full-0 auto-y" },
		children2
	)
	return createElement(
		view,
		{
			tag = "col gap-xxlarge size-full-0 auto-y padding-y-large",
			testId = "MonetizationPageView"
		},
		children
	)
end

local function EditContent(props)
	local v6 = if FFlagBuildExperienceMonetizationNativeUI then useTokens() else nil
	local selectedProduct = props.selectedProduct
	local createElement = React.createElement
	local v10

	if FFlagBuildExperienceMonetizationNativeUI and selectedProduct ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v15 = {
			Image = selectedProduct.image or assetId,
			imageStyle = 0,
			ScaleType = 0,
			Size = 0,
			testId = "monetization-edit-image"
		}
		local v16 = if selectedProduct.image == nil then v6.Color.Content.Emphasis else nil
		v15.imageStyle = v16
		v15.ScaleType = Enum.ScaleType.Fit
		v15.Size = UDim2.fromOffset(v6.Size.Size_3000, v6.Size.Size_3000)
		v10 = createElement2(
			view,
			{
				LayoutOrder = 0,
				tag = "row align-x-center size-full-0 auto-y padding-y-xlarge radius-medium bg-surface-200"
			},
			{ Image = createElement3(image, v15) }
		)
	end

	local v11 = if props.canEditName ~= false then React.createElement(textInput, {
		LayoutOrder = 1,
		isDisabled = props.isProductEditPending,
		label = props.labels.name,
		onChanged = props.onEditNameChanged,
		text = props.editName,
		testId = "monetization-edit-name",
		width = UDim.new(1, 0)
	}) else nil
	local v9 = {
		Media = v10,
		Name = v11,
		Description = React.createElement(textArea, {
			LayoutOrder = 2,
			isDisabled = props.isProductEditPending,
			label = props.labels.description,
			numLines = 4,
			onChanged = props.onEditDescriptionChanged,
			text = props.editDescription,
			testId = "monetization-edit-description",
			width = UDim.new(1, 0)
		}),
		Price = 0,
		Error = 0
	}

	local v12 = if props.canEditPrice ~= false then React.createElement(textInput, {
		LayoutOrder = 3,
		isDisabled = props.isProductEditPending,
		label = props.labels.price,
		onChanged = props.onEditPriceChanged,
		text = props.editPrice,
		textInputType = Enum.TextInputType.Number,
		testId = "monetization-edit-price",
		width = UDim.new(1, 0)
	}) else nil
	v9.Price = v12

	local v13 = if props.productEditError ~= nil then React.createElement(text, {
		LayoutOrder = 4,
		Text = props.productEditError,
		tag = "size-full-0 auto-y text-body-small text-wrap content-alert",
		testId = "monetization-product-edit-error"
	}) else nil
	v9.Error = v13
	return createElement(
		view,
		{
			tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
			testId = "monetization-product-edit"
		},
		v9
	)
end

local function showsPageCreate(p2, p3): boolean
	return not p3 and (p2.mode == "empty" or p2.mode == "catalog")
end

local function MonetizationPageView(props)
	local v6 = props.mode == "detail"
	local v7 = props.mode == "edit"
	local v8 = props.mode == "options"
	local v9 = #props.products > 0
	local v10 = props.catalogSources ~= nil
	local v11 = true

	if v10 then
		for k, catalogSource in props.catalogSources do
			if catalogSource.status ~= "Ready" then
				v11 = false
				break
			end
		end
	end

	local v12 = not (v6 or v7 or v8)

	if v12 then
		if v10 then
			v12 = not (v11 or v9)
		else
			v12 = not (props.catalogStatus == "Ready") and (props.catalogStatus ~= "Failed" or not v9)
		end
	end

	local v13 = props.mode == "empty" and not v12

	local v14 = FFlagBuildExperienceMonetizationPageFixes and FFlagBuildExperienceMonetizationMultiKind and v10 and #props.catalogSources > 0

	local v15 = not (v10 or v6 or v7 or v8)

	if v15 then
		v15 = props.catalogStatus == "Failed" and v9
	end

	local v16

	if v6 and (props.canManageProduct or props.canEditKindProduct == true) then
		if FFlagBuildExperienceMonetizationNativeUI then
			v16 = React.createElement(ProductActionsMenu, {
				isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
				editLabel = props.labels.edit,
				onEdit = props.onOpenProductEdit
			})
		else
			v16 = React.createElement(button, {
				isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
				onActivated = props.onOpenProductEdit,
				size = inputSize.Medium,
				testId = "monetization-edit-product",
				text = props.labels.edit,
				variant = buttonVariant.Standard
			})
		end
	elseif not (v6 or v7 or v8 or v12 or not props.showOptions) then
		local createElement = React.createElement

		local v19 = if FFlagBuildExperienceMonetizationNativeUI then iconName.TwoSwitchesHorizontal else iconName.ThreeSlidersHorizontal
		v16 = createElement(iconButton, {
			icon = v19,
			isCircular = true,
			onActivated = props.onOpenOptions,
			size = inputSize.Medium,
			testId = "monetization-open-options",
			variant = buttonVariant.Utility
		})
	end

	local v17

	if props.isProductDisabled then
		v17 = React.createElement("CanvasGroup", {
			[React.Tag] = "data-testid=monetization-disabled-detail",
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = 0.55,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Content = React.createElement(DetailContent, props)
		})
	else
		v17 = React.createElement(DetailContent, props)
	end

	if v12 then
		if v14 then
			v17 = React.createElement(GroupedCatalogContent, props)
		elseif v10 then
			v17 = React.createElement(CatalogSourcesStatus, props)
		else
			v17 = React.createElement(CatalogStatusContent, props)
		end
	elseif not v6 then
		if v7 then
			v17 = React.createElement(EditContent, props)
		elseif v8 then
			v17 = React.createElement(OptionsContent, props)
		elseif props.mode == "empty" then
			v17 = React.createElement(EmptyContent, props)
		else
			v17 = React.createElement(CatalogContent, props)
		end
	end

	if v10 and not v14 and not v11 and v9 and not (v6 or v7 or v8) then
		v17 = React.createElement(view, { tag = "col gap-large size-full-0 auto-y" }, {
			Status = React.createElement(CatalogSourcesStatus, props),
			Content = v17
		})
	end

	if v15 then
		v17 = React.createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
			Warning = React.createElement(CatalogRefreshWarning, props),
			Content = v17
		})
	end

	local v18 = not v12 and (props.mode == "empty" or props.mode == "catalog")
	local v19

	if v7 then
		v19 = React.createElement(view, {
			tag = {
				["row gap-medium size-full-0 auto-y"] = true,
				["padding-y-medium"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}, {
			Cancel = React.createElement(button, {
				LayoutOrder = 1,
				fillBehavior = fillBehavior.Fill,
				isDisabled = props.isProductEditPending,
				onActivated = props.onCancelProductEdit,
				size = inputSize.Large,
				testId = "monetization-cancel-product-edit",
				text = props.labels.cancel,
				variant = buttonVariant.Standard,
				width = UDim.new(0.5, -6)
			}),
			Save = React.createElement(button, {
				LayoutOrder = 2,
				fillBehavior = fillBehavior.Fill,
				isLoading = props.isProductEditPending,
				onActivated = props.onSaveProductEdit,
				size = inputSize.Large,
				testId = "monetization-save-product-edit",
				text = props.labels.save,
				variant = buttonVariant.Emphasis,
				width = UDim.new(0.5, -6)
			})
		})
	elseif v18 then
		local createElement = React.createElement

		local createElement2 = React.createElement

		local v25 = if FFlagBuildExperienceMonetizationMultiKind or FFlagBuildCheckGamePermissions then not props.canCreateProduct else nil
		local v24 = {
			isDisabled = v25,
			onActivated = props.onOpenCreate,
			size = 0,
			testId = "monetization-create",
			text = 0,
			variant = 0,
			width = 0
		}
		local v26 = if FFlagBuildExperienceMonetizationNativeUI then inputSize.Large else inputSize.Medium
		v24.size = v26

		v24.text = props.labels.emptyCreateProduct
		v24.variant = buttonVariant.Emphasis
		local v27 = if FFlagBuildExperienceMonetizationNativeUI then UDim.new(1, 0) else UDim.new(0, 240)
		v24.width = v27
		v19 = createElement(view, {
			tag = {
				["row align-x-center size-full-0 auto-y"] = true,
				["padding-y-medium"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}, { Create = createElement2(button, v24) })
	end

	if FFlagBuildExperienceDeveloperProductContext and v6 and props.chatActions ~= nil then
		v19 = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y padding-y-medium",
				testId = "monetization-detail-composer"
			},
			{
				Composer = React.createElement(ChatActions, props.chatActions)
			}
		)
	end

	local createElement = React.createElement
	local v21 = {
		closeIcon = iconName.ChevronLargeLeft,
		content = v17,
		footer = v19,
		footerDivider = false,
		disableScrolling = FFlagBuildExperienceMonetizationNativeUI and v13,
		headerTrailing = v16,
		onClose = props.onClose,
		testId = "MonetizationPage",
		title = 0
	}
	local v22

	if v6 then
		v22 = if props.selectedProduct == nil then props.labels.title else props.selectedProduct.name
	elseif v7 then
		v22 = props.labels.editProduct
	else
		v22 = if v8 then props.labels.options else props.labels.title
	end

	v21.title = v22
	local element = createElement(OverflowMenuPageShell, v21)

	if FFlagBuildExperienceDeveloperProductContext then
		return React.createElement(view, {
			tag = "size-full",
			padding = {
				bottom = UDim.new(0, props.keyboardHeight or 0)
			}
		}, { Page = element })
	end

	return element
end

return MonetizationPageView
