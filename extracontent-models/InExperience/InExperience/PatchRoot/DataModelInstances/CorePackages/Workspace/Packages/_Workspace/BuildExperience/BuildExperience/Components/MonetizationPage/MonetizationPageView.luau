local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local OverflowMenuPageShell = require(BuildExperience.Components.BuildPillMenu.OverflowMenuPageShell)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceMonetizationMultiKind = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationMultiKind)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceDeveloperProductContext = require(BuildExperience.Flags.FFlagBuildExperienceDeveloperProductContext)
local FFlagBuildExperienceMonetizationPageFixes = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationPageFixes)

local Badge = Foundation.Badge
local Button = Foundation.Button
local Dialog = Foundation.Dialog
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Image = Foundation.Image
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local Toggle = Foundation.Toggle
local View = Foundation.View
local Menu = Foundation.Menu
local Skeleton = Foundation.Skeleton

local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local assetId

if FFlagBuildExperienceMonetizationNativeUI then
	assetId = FoundationCloudAssets.Assets["pictograms/robux"].assetId
else
	assetId = nil
end

local udim = UDim2.new(1 / 3, -8, 0, 0)

local function ProductActionsMenu(props)
	local state, setState = React.useState(false)
	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})
	local v = useLocalization({ archive = LocalizationStrings.ARCHIVE_GAME_ARCHIVE })
	local items = React.useMemo(function()
		return {
			{
				id = "edit",
				text = props.editLabel,
				icon = IconName.Pencil,
				isDisabled = props.isDisabled
			},
			{ id = "archive", text = v.archive, icon = IconName.TrashCan, isDisabled = true }
		}
	end, { v.archive, props.editLabel, props.isDisabled })
	return React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = state,
		items = items,
		onActivated = function(p)
			onPressedOutside()

			if p == "edit" and not props.isDisabled then
				props.onEdit()
			end
		end,
		onPressedOutside = onPressedOutside,
		side = Foundation.Enums.PopoverSide.Bottom,
		testId = "monetization-product-actions-menu"
	}, {
		Trigger = React.createElement(IconButton, {
			icon = IconName.ThreeDotsHorizontal,
			isCircular = true,
			isDisabled = props.isDisabled,
			onActivated = function()
				setState(not state)
			end,
			size = InputSize.Medium,
			testId = "monetization-product-actions",
			variant = ButtonVariant.Utility
		})
	})
end

local function ProductCard(props)
	local product = props.product
	local v = useTokens()
	local image = product.image

	if not image then
		if FFlagBuildExperienceMonetizationNativeUI then
			image = assetId
		else
			image = nil
		end
	end

	local identity = product.identity or product.id

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		selection = { Selectable = true },
		Size = 0,
		stateLayer = 0,
		tag = "col auto-y radius-medium",
		testId = 0
	}
	local size

	if props.tileWidth == nil then
		size = udim
	else
		size = UDim2.new(0, props.tileWidth, 0, 0)
	end

	v2.Size = size
	v2.stateLayer = { affordance = StateLayerAffordance.None }

	v2.testId = `monetization-product-{identity}`

	local createElement2 = React.createElement
	local udim2

	if props.tileWidth == nil then
		if FFlagBuildExperienceMonetizationNativeUI and not FFlagBuildExperienceMonetizationMultiKind then
			udim2 = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_2800)
		elseif FFlagBuildExperienceMonetizationMultiKind then
			udim2 = UDim2.fromScale(1, 0)
		else
			udim2 = UDim2.new(1, 0, 0, 109)
		end
	else
		udim2 = UDim2.fromOffset(props.tileWidth, props.tileWidth)
	end

	local v3 = {
		LayoutOrder = 1,
		Size = udim2,
		aspectRatio = 1,
		tag = props.tileWidth == nil and "radius-medium clip bg-surface-200" or "radius-medium clip bg-shift-200"
	}
	local saleStatus

	if not (product.saleStatus == nil or not FFlagBuildExperienceMonetizationMultiKind and FFlagBuildExperienceMonetizationNativeUI and product.isForSale ~= true) then
		saleStatus = React.createElement(Badge, {
			Position = UDim2.fromOffset(v.Gap.Small, v.Gap.Small),
			shape = BadgeShape.Pill,
			size = BadgeSize.Small,
			text = product.saleStatus,
			testId = `monetization-product-sale-status-{identity}`,
			variant = BadgeVariant.OverMedia,
			ZIndex = 2
		})
	end

	local image2

	if image ~= nil then
		local createElement3 = React.createElement
		local imageStyle

		if FFlagBuildExperienceMonetizationNativeUI and product.image == nil then
			imageStyle = v.Color.Content.Emphasis
		end

		image2 = createElement3(Image, {
			Image = image,
			imageStyle = imageStyle,
			ScaleType = Enum.ScaleType.Fit,
			tag = FFlagBuildExperienceMonetizationNativeUI and "size-full radius-medium" or "size-full",
			testId = `monetization-product-image-{identity}`
		})
	end

	local children = {
		Media = createElement2(View, v3, { SaleStatus = saleStatus, Image = image2 }),
		Title = 0,
		Kind = 0,
		Metadata = 0
	}

	local createElement3 = React.createElement
	local v4 = {
		LayoutOrder = 2,
		Text = product.name,
		sizeConstraint = FFlagBuildExperienceMonetizationNativeUI and {
			MaxSize = Vector2.new(v.Size.Size_2800, v.Size.Size_1000 + v.Gap.Small)
		} or nil,
		tag = {
			["size-full-0 auto-y padding-top-small text-title-medium text-align-x-left text-truncate-end content-emphasis"] = true,
			["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
		},
		testId = 0
	}
	local testId

	if FFlagBuildExperienceMonetizationNativeUI then
		testId = `monetization-product-title-{identity}`
	end

	v4.testId = testId
	children.Title = createElement3(Text, v4)
	local kind

	if FFlagBuildExperienceMonetizationMultiKind and product.kind ~= nil and props.tileWidth == nil then
		kind = React.createElement(Text, {
			LayoutOrder = 3,
			Text = product.kind,
			tag = "size-full-0 auto-y padding-top-xsmall text-body-small text-wrap text-align-x-left content-muted",
			testId = `monetization-product-kind-{identity}`
		})
	end

	children.Kind = kind

	local createElement4 = React.createElement
	local v5 = {
		LayoutOrder = 4,
		sizeConstraint = FFlagBuildExperienceMonetizationNativeUI and {
			MaxSize = Vector2.new(v.Size.Size_2800, 1e999)
		} or nil,
		tag = {
			["row align-y-center gap-xsmall size-full-0 auto-y"] = true,
			["padding-top-xsmall"] = FFlagBuildExperienceMonetizationNativeUI
		}
	}
	local kind2

	if not (FFlagBuildExperienceMonetizationNativeUI or product.kind == nil) then
		kind2 = React.createElement(Text, {
			LayoutOrder = 1,
			Text = product.kind,
			tag = "auto-xy text-body-medium content-default"
		})
	end

	local priceIcon

	if not (FFlagBuildExperienceMonetizationMultiKind and product.showRobuxIcon == false) then
		priceIcon = React.createElement(Icon, {
			LayoutOrder = 2,
			name = IconName.Robux,
			size = IconSize.Small
		})
	end

	local v6 = {
		Kind = kind2,
		PriceIcon = priceIcon,
		Price = React.createElement(Text, {
			LayoutOrder = 3,
			Text = product.price,
			tag = FFlagBuildExperienceMonetizationNativeUI and "fill auto-y text-body-medium text-wrap text-align-x-left content-default" or "auto-xy text-body-medium content-default"
		}),
		Spacer = 0,
		Age = 0
	}
	local spacer

	if not FFlagBuildExperienceMonetizationNativeUI then
		spacer = React.createElement(View, { LayoutOrder = 4, tag = "fill" })
	end

	v6.Spacer = spacer
	local age

	if not (FFlagBuildExperienceMonetizationNativeUI or product.age == nil) then
		age = React.createElement(Text, {
			LayoutOrder = 5,
			Text = product.age,
			tag = "auto-xy text-body-medium content-default"
		})
	end

	v6.Age = age
	children.Metadata = createElement4(View, v5, v6)
	return createElement(View, v2, children)
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
		View,
		{ LayoutOrder = props.LayoutOrder, tag = "row gap-medium size-full-0 auto-y" },
		children
	)
end

local function OptionRow(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-large size-full-0 auto-y padding-x-large padding-y-medium"
	}

	local createElement2 = React.createElement

	local v2 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = {
				["size-full-0 auto-y text-title-medium text-align-x-left content-emphasis"] = true,
				["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}),
		Description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Supporting = 0
	}
	local supporting

	if props.supportingText ~= nil then
		supporting = React.createElement(Text, {
			LayoutOrder = 3,
			Text = props.supportingText,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted"
		})
	end

	v2.Supporting = supporting
	return createElement(View, v, {
		Copy = createElement2(View, {
			LayoutOrder = 1,
			tag = FFlagBuildExperienceMonetizationNativeUI and "col fill gap-xsmall auto-y" or "col fill gap-xxsmall auto-y"
		}, v2),
		Toggle = React.createElement(Toggle, {
			LayoutOrder = 2,
			isChecked = props.isChecked,
			isDisabled = props.isDisabled,
			label = "",
			onActivated = props.onActivated,
			size = InputSize.Medium,
			testId = props.testId
		})
	})
end

local function OptionsStatusContent(props)
	if props.optionsLoadStatus == "NotReady" then
		return React.createElement(Text, {
			Text = props.labels.loading,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted",
			testId = "monetization-options-loading"
		})
	end

	if props.optionsLoadStatus == "Failed" then
		return React.createElement(
			View,
			{
				tag = "col align-x-center gap-medium size-full-0 auto-y padding-large",
				testId = "monetization-options-error"
			},
			{
				Message = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.labels.optionsLoadError,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				}),
				Retry = React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = props.onRetryOptions,
					size = InputSize.Medium,
					text = props.labels.retry,
					variant = ButtonVariant.Standard
				})
			}
		)
	end

	return nil
end

local function OptionsContent(props)
	local optionsStatusContent = OptionsStatusContent(props)

	if optionsStatusContent ~= nil then
		return optionsStatusContent
	end

	local supportingText = props.managedPricingSupportingText

	if not supportingText then
		if props.managedPricingState == "Mixed" then
			supportingText = props.labels.mixed
		elseif props.managedPricingState == "Unavailable" then
			supportingText = props.labels.unavailable
		else
			supportingText = nil
		end
	end

	local v = {
		actions = {
			{
				text = props.labels.agree,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onConfirmManagedPricing,
				isDisabled = false,
				isLoading = props.isOptionsManagedPricingPending
			},
			{
				text = props.labels.cancel,
				variant = ButtonVariant.Standard,
				onActivated = props.onCancelManagedPricing,
				isDisabled = props.isOptionsManagedPricingPending,
				isLoading = false
			}
		}
	}

	local createElement = React.createElement
	local permission

	if not props.canMonetize then
		permission = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.labels.permissionDenied,
			tag = "size-full-0 auto-y padding-medium text-body-medium text-wrap radius-medium bg-surface-100 content-default"
		})
	end

	local createElement2 = React.createElement

	local v2 = {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.labels.pricingOptions,
				tag = {
					["size-full-0 auto-y text-title-large text-align-x-left content-emphasis"] = true,
					["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
				}
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.labels.pricingOptionsDescription,
				tag = {
					["size-full-0 auto-y text-body-small text-align-x-left content-default"] = true,
					["text-wrap"] = FFlagBuildExperienceMonetizationNativeUI
				}
			})
		}),
		Rows = 0
	}

	local createElement3 = React.createElement

	local v3 = {
		ManagedPricing = React.createElement(OptionRow, {
			LayoutOrder = 1,
			description = props.labels.managedPricingDescription,
			isChecked = props.managedPricingState == "AllOn",
			isDisabled = not props.canChangeManagedPricing or props.isOptionsManagedPricingPending,
			onActivated = props.onManagedPricingChanged,
			supportingText = supportingText,
			testId = "monetization-managed-pricing",
			title = props.labels.managedPricing
		}),
		Error = 0
	}
	local err

	if props.managedPricingError ~= nil then
		err = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.managedPricingError,
			tag = "size-full-0 auto-y padding-x-large padding-bottom-medium text-body-small text-wrap content-alert"
		})
	end

	v3.Error = err
	v2.Rows = createElement3(
		View,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
		},
		v3
	)
	local children = {
		Permission = permission,
		Pricing = createElement2(View, { LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" }, v2),
		Shop = 0,
		Acknowledgement = 0
	}

	local createElement4 = React.createElement

	local v4 = {
		Header = React.createElement(Text, {
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

	local v5 = {
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
	local err2

	if props.shopButtonError ~= nil then
		err2 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.shopButtonError,
			tag = "size-full-0 auto-y padding-x-large padding-bottom-medium text-body-small text-wrap content-alert"
		})
	end

	v5.Error = err2
	v4.Rows = createElement5(
		View,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip"
		},
		v5
	)
	children.Shop = createElement4(View, {
		LayoutOrder = 3,
		tag = "col gap-large size-full-0 auto-y"
	}, v4)
	local acknowledgement

	if props.showManagedPricingAcknowledgement then
		acknowledgement = React.createElement(Dialog.Root, {
			disablePortal = props.disableDialogPortal == true,
			hasBackdrop = props.disableDialogPortal ~= true,
			size = DialogSize.Small
		}, {
			Title = React.createElement(Dialog.Title, {
				LayoutOrder = 1,
				text = props.labels.acknowledgementTitle
			}),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Description = React.createElement(Dialog.Text, {
					Text = props.labels.acknowledgementDescription
				})
			}),
			Actions = React.createElement(Dialog.Actions, v)
		})
	end

	children.Acknowledgement = acknowledgement
	return createElement(
		View,
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

	return React.createElement(ScrollView, {
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
		Row = React.createElement(View, { tag = "row gap-medium auto-xy" }, children)
	})
end

local v = {
	GamePass = {
		icon = IconName.Tag,
		title = LocalizationStrings.MONETIZATION_EMPTY_PASSES_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_PASSES_DESCRIPTION
	},
	DeveloperProduct = {
		icon = IconName.ShoppingCart,
		title = LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_DESCRIPTION
	},
	Subscription = {
		icon = IconName.CircleStar,
		title = LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_TITLE,
		description = LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_DESCRIPTION
	}
}

local function EmptyKindCard(p)
	local v2 = v[p.kind]
	local v3 = useLocalization({ title = v2.title, description = v2.description })

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col align-x-center gap-small size-full-0 auto-y padding-large bg-surface-0 stroke-standard stroke-default radius-large",
			testId = `monetization-empty-{p.kind}`
		},
		{
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = v2.icon,
				size = IconSize.XLarge
			}),
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v3.title,
				tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-center content-emphasis"
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 3,
				Text = v3.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-default"
			})
		}
	)
end

local function KindLoadingTiles(p)
	local v2 = useTokens()
	local size_2800 = v2.Size.Size_2800
	local children = {}

	for i = 1, 3 do
		children[`tile-{i}`] = React.createElement(
			View,
			{ LayoutOrder = i, Size = UDim2.fromOffset(size_2800, 0), tag = "col gap-small auto-y" },
			{
				Media = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(size_2800, size_2800),
					radius = Radius.Medium
				}),
				Title = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.7, 0, 0, v2.Size.Size_400),
					radius = Radius.Small
				}),
				Price = React.createElement(Skeleton, {
					LayoutOrder = 3,
					Size = UDim2.new(0.4, 0, 0, v2.Size.Size_300),
					radius = Radius.Small
				})
			}
		)
	end

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "row gap-medium size-full-0 auto-y clip",
			testId = `monetization-section-loading-{p.kind}`
		},
		children
	)
end

local function getKindProducts(products, kind: string)
	local kindProducts = {}

	for _, item in products do
		if item.productKind == kind then
			table.insert(kindProducts, item)
		end
	end

	return kindProducts
end

local function EmptyKindSection(props)
	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = `monetization-empty-section-{props.kind}`
		},
		{
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.label,
				tag = "size-full-0 auto-y text-title-large text-align-x-left content-emphasis",
				testId = `monetization-section-title-{props.kind}`
			}),
			Card = React.createElement(EmptyKindCard, { kind = props.kind, LayoutOrder = 2 })
		}
	)
end

local function KindLoadFailure(props)
	local onRetryCatalogSource = props.page.onRetryCatalogSource
	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-small size-full-0 auto-y padding-medium radius-medium bg-surface-100",
		testId = `monetization-catalog-source-{props.kind}`
	}
	local v3 = {
		Message = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.page.labels.loadErrorDescription,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		Retry = 0
	}
	local retry

	if onRetryCatalogSource ~= nil then
		retry = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = function()
				onRetryCatalogSource(props.kind)
			end,
			size = InputSize.Medium,
			text = props.page.labels.retry,
			variant = ButtonVariant.Standard,
			testId = `monetization-button-retry-{props.kind}`
		})
	end

	v3.Retry = retry
	return createElement(View, v2, v3)
end

local function hasLoadingSource(items): boolean
	for _, item in items do
		if item.status == "NotReady" then
			return true
		end
	end

	return false
end

local function createEmptyKindSection(_, p, layoutOrder: number) -- 2 equivalent calls inferred from this helper
	return React.createElement(EmptyKindSection, {
		kind = p.kind,
		label = p.label,
		LayoutOrder = layoutOrder
	})
end

local function GroupedCatalogContent(props)
	local children = {}
	local count = 0
	local catalogSources = {}

	if props.catalogSources ~= nil then
		local v2 = FFlagBuildExperienceMonetizationPageFixes

		if v2 then
			local flag = true

			for _, catalogSource in props.catalogSources do
				if catalogSource.status == "NotReady" then
					v2 = true
					flag = false
					break
				end
			end

			if flag then
				v2 = false
			end
		end

		for k, catalogSource in props.catalogSources do
			local kind = catalogSource.kind
			local kindProducts = getKindProducts(props.products, kind)

			local v3 = FFlagBuildExperienceMonetizationPageFixes

			if v3 then
				if #kindProducts == 0 then
					v3 = catalogSource.status == "NotReady"
				else
					v3 = false
				end
			end

			local v4 = FFlagBuildExperienceMonetizationPageFixes and catalogSource.status == "Failed"

			if #kindProducts == 0 and not (v3 or v4) then
				if catalogSource.status == "Ready" and not catalogSource.isIncomplete then
					if v2 then
						children[`empty-section-{kind}`] = createEmptyKindSection(nil, catalogSource, k) -- inferred equivalent call
					else
						table.insert(catalogSources, catalogSource)
					end
				end
			else
				count += 1
				local v5 = {}
				v5.Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = catalogSource.label,
					tag = "size-full-0 auto-y text-title-large text-align-x-left content-emphasis",
					testId = `monetization-section-title-{kind}`
				})
				local products

				if FFlagBuildExperienceMonetizationPageFixes and #kindProducts == 0 then
					if v3 then
						products = React.createElement(KindLoadingTiles, {
							kind = kind,
							LayoutOrder = 2
						})
					end
				else
					products = React.createElement(ProductCarousel, {
						LayoutOrder = 2,
						onProductActivated = props.onProductActivated,
						products = kindProducts,
						testId = `monetization-section-products-{kind}`
					})
				end

				v5.Products = products
				local failure

				if v4 then
					failure = React.createElement(KindLoadFailure, {
						page = props,
						kind = kind,
						LayoutOrder = 3
					})
				end

				v5.Failure = failure

				local formatted = `section-{kind}`
				local createElement = React.createElement

				if not v2 then
					k = count
				end

				children[formatted] = createElement(
					View,
					{
						LayoutOrder = k,
						tag = "col gap-medium size-full-0 auto-y",
						testId = `monetization-section-{kind}`
					},
					v5
				)
			end
		end

		for _, v3 in catalogSources do
			count += 1
			children[`empty-section-{v3.kind}`] = createEmptyKindSection(nil, v3, count) -- inferred equivalent call
		end
	end

	return React.createElement(
		View,
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

	return React.createElement(View, {
		tag = FFlagBuildExperienceMonetizationNativeUI and "col gap-large size-full-0 auto-y padding-top-medium" or "col gap-large size-full-0 auto-y padding-y-medium",
		testId = "MonetizationPageView"
	}, children)
end

local function EmptyContent(p)
	local v2

	if FFlagBuildExperienceMonetizationNativeUI then
		v2 = useTokens()
	end

	local emphasis

	if FFlagBuildExperienceMonetizationNativeUI then
		emphasis = v2.Color.Content.Emphasis
	end

	local v3 = not FFlagBuildExperienceMonetizationNativeUI and 1 or v2.Config.UI.Scale
	local createElement = React.createElement

	local createElement2 = React.createElement
	local v4 = {
		Image = not FFlagBuildExperienceMonetizationNativeUI and "rbxasset://textures/ui/LuaApp/graphic/BuildExperience/NativeMonetization/EmptyCatalog.png" or assetId,
		imageStyle = emphasis,
		LayoutOrder = 1,
		ScaleType = Enum.ScaleType.Fit,
		Size = 0,
		testId = "monetization-empty-illustration"
	}
	local size

	if FFlagBuildExperienceMonetizationNativeUI then
		size = UDim2.fromOffset(320 * v3, 180 * v3)
	else
		size = UDim2.fromOffset(298, 168)
	end

	v4.Size = size
	local element = createElement(View, {
		tag = FFlagBuildExperienceMonetizationNativeUI and "col align-x-center align-y-center size-full auto-y" or "col align-x-center gap-xxlarge size-full-0 auto-y padding-y-medium",
		testId = "MonetizationPageView"
	}, {
		Illustration = createElement2(Image, v4),
		Copy = React.createElement(View, {
			LayoutOrder = 2,
			tag = FFlagBuildExperienceMonetizationNativeUI and "col align-x-center size-full-0 auto-y padding-large" or "col align-x-center size-full-0 auto-y"
		}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = p.emptyTitle,
				tag = FFlagBuildExperienceMonetizationNativeUI and "size-full-0 auto-y text-heading-medium text-wrap text-align-x-center content-emphasis" or "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis"
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = p.emptyDescription,
				tag = FFlagBuildExperienceMonetizationNativeUI and "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default" or "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
			})
		})
	})

	if FFlagBuildExperienceMonetizationNativeUI then
		return React.createElement(ScrollView, {
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
		return React.createElement(Text, {
			Text = props.labels.loading,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted",
			testId = "monetization-catalog-loading"
		})
	end

	return React.createElement(
		View,
		{
			tag = "col align-x-center gap-large size-full-0 auto-y padding-large",
			testId = "monetization-catalog-error"
		},
		{
			Copy = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "col align-x-center gap-small size-full-0 auto-y" },
				{
					Title = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.labels.loadErrorTitle,
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis"
					}),
					Description = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.labels.loadErrorDescription,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
					})
				}
			),
			Retry = React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = props.onRetryCatalog,
				size = InputSize.Medium,
				text = props.labels.retry,
				variant = ButtonVariant.Standard
			})
		}
	)
end

local function CatalogRefreshWarning(p)
	return React.createElement(
		View,
		{
			tag = "col align-x-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-100",
			testId = "monetization-catalog-refresh-error"
		},
		{
			Message = React.createElement(Text, {
				LayoutOrder = 1,
				Text = p.labels.loadErrorDescription,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
			}),
			Retry = React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = p.onRetryCatalog,
				size = InputSize.Medium,
				text = p.labels.retry,
				variant = ButtonVariant.Standard
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
		local v2 = {
			LayoutOrder = k,
			tag = "col gap-small size-full-0 auto-y padding-medium radius-medium bg-surface-100",
			testId = `monetization-catalog-source-{catalogSource.kind}`
		}
		local children2 = {
			Label = React.createElement(Text, {
				LayoutOrder = 1,
				Text = catalogSource.label,
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			Message = 0,
			Retry = 0
		}

		local createElement2 = React.createElement
		local text

		if catalogSource.status == "Failed" then
			text = props.labels.loadErrorDescription
		else
			text = props.labels.loading
		end

		children2.Message = createElement2(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
		local retry

		if catalogSource.status == "Failed" and props.onRetryCatalogSource ~= nil then
			retry = React.createElement(Button, {
				LayoutOrder = 3,
				onActivated = function()
					props.onRetryCatalogSource(catalogSource.kind)
				end,
				size = InputSize.Medium,
				text = props.labels.retry,
				variant = ButtonVariant.Standard
			})
		end

		children2.Retry = retry
		children[kind] = createElement(View, v2, children2)
	end

	return React.createElement(
		View,
		{
			tag = "col gap-medium size-full-0 auto-y",
			testId = "monetization-catalog-sources-status"
		},
		children
	)
end

local function DetailContent(props)
	local emphasis

	if FFlagBuildExperienceMonetizationNativeUI then
		emphasis = useTokens().Color.Content.Emphasis
	end

	local selectedProduct = props.selectedProduct

	if selectedProduct == nil then
		return React.createElement(View, { tag = "size-full", testId = "MonetizationPageView" })
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local image

	if not (selectedProduct.image == nil and not FFlagBuildExperienceMonetizationNativeUI) then
		local createElement3 = React.createElement
		local v2 = {
			Image = selectedProduct.image or assetId,
			imageStyle = 0,
			ScaleType = 0,
			Size = 0,
			testId = "monetization-detail-image"
		}

		if selectedProduct.image ~= nil then
			emphasis = nil
		end

		v2.imageStyle = emphasis
		v2.ScaleType = Enum.ScaleType.Fit
		v2.Size = UDim2.fromOffset(195, 196)
		image = createElement3(Image, v2)
	end

	local children = {
		Media = createElement2(View, {
			LayoutOrder = 1,
			tag = FFlagBuildExperienceMonetizationNativeUI and "row align-x-center size-full-0 auto-y padding-y-xlarge radius-medium bg-surface-200" or "row align-x-center size-full-0 auto-y padding-y-medium"
		}, { Image = image }),
		Summary = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v2 = {
		Name = React.createElement(Text, {
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
	local kind

	if FFlagBuildExperienceMonetizationMultiKind and selectedProduct.kind ~= nil then
		kind = React.createElement(Text, {
			LayoutOrder = 2,
			Text = selectedProduct.kind,
			tag = "size-full-0 auto-y padding-top-xsmall text-body-medium text-wrap text-align-x-left content-muted",
			testId = "monetization-detail-kind"
		})
	end

	v2.Kind = kind

	local createElement5 = React.createElement
	local icon

	if not (FFlagBuildExperienceMonetizationMultiKind and selectedProduct.showRobuxIcon == false) then
		icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Robux,
			size = IconSize.Small
		})
	end

	v2.Price = createElement5(View, {
		LayoutOrder = 3,
		tag = "row align-y-center gap-xsmall size-full-0 auto-y"
	}, {
		Icon = icon,
		Value = React.createElement(Text, {
			LayoutOrder = 2,
			Text = selectedProduct.price,
			tag = "auto-xy text-body-medium content-default"
		})
	})
	local status

	if
		selectedProduct.canManage == false
		and selectedProduct.saleStatus ~= nil
		and props.canChangeSaleStatus ~= true
	then
		status = React.createElement(Text, {
			LayoutOrder = 4,
			Text = selectedProduct.saleStatus,
			tag = "size-full-0 auto-y padding-top-xsmall text-body-medium text-wrap text-align-x-left content-muted",
			testId = "monetization-detail-sale-status"
		})
	end

	v2.Status = status
	local children2 = {
		Title = createElement4(View, { LayoutOrder = 1, tag = "col size-full-0 auto-y" }, v2),
		Description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = selectedProduct.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		SaleStatus = 0,
		Pricing = 0
	}
	local saleStatus

	if props.canManageProduct or props.canChangeSaleStatus == true then
		local createElement6 = React.createElement

		local v3 = {
			Row = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-large size-full-0 auto-y padding-y-large"
				},
				{
					Label = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.labels.availableForPurchase,
						tag = "fill auto-y text-body-medium text-align-x-left content-default"
					}),
					Toggle = React.createElement(Toggle, {
						LayoutOrder = 2,
						isChecked = selectedProduct.isForSale == true,
						isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
						label = "",
						onActivated = props.onProductSaleStatusChanged,
						size = InputSize.Medium,
						testId = "monetization-detail-sale-status"
					})
				}
			),
			Error = 0
		}
		local err

		if props.productSaleStatusError then
			local createElement7 = React.createElement

			local text = props.productSaleStatusErrorLabel

			if not text then
				if selectedProduct.priceInRobux == nil then
					text = props.labels.priceRequiredForSale
				else
					text = props.labels.updateError
				end
			end

			err = createElement7(Text, {
				LayoutOrder = 2,
				Text = text,
				tag = "size-full-0 auto-y text-body-small content-alert",
				testId = "monetization-sale-status-error"
			})
		end

		v3.Error = err
		saleStatus = createElement6(View, {
			LayoutOrder = 3,
			tag = "col gap-small size-full-0 auto-y"
		}, v3)
	end

	children2.SaleStatus = saleStatus
	local pricing

	if
		selectedProduct.productKind == nil
		or selectedProduct.productKind == "DeveloperProduct"
		or props.canChangeKindManagedPricing == true
	then
		local createElement6 = React.createElement

		local v3 = {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.labels.pricing,
				tag = "size-full-0 auto-y padding-bottom-small text-heading-small text-align-x-left content-emphasis"
			}),
			Regional = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "row align-y-center gap-large size-full-0 auto-y padding-y-large"
				},
				{
					Label = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.labels.regionalPricing,
						tag = "fill auto-y text-body-medium text-align-x-left content-default"
					}),
					Toggle = React.createElement(Toggle, {
						LayoutOrder = 2,
						isChecked = selectedProduct.isManagedPricingEnabled == true,
						isDisabled = props.isProductDisabled or props.isProductManagedPricingPending or props.isProductSaleStatusPending or not props.canUpdateProductManagedPricing,
						label = "",
						onActivated = props.onProductManagedPricingChanged,
						size = InputSize.Medium,
						testId = "monetization-detail-managed-pricing"
					})
				}
			),
			UpdateError = 0
		}
		local updateError

		if props.productManagedPricingError then
			local createElement7 = React.createElement

			local text = props.productManagedPricingErrorLabel

			if not text then
				if selectedProduct.priceInRobux == nil then
					text = props.labels.priceRequiredForSale
				else
					text = props.labels.updateError
				end
			end

			updateError = createElement7(Text, {
				LayoutOrder = 3,
				Text = text,
				tag = "size-full-0 auto-y text-body-small content-alert",
				testId = "monetization-managed-pricing-error"
			})
		end

		v3.UpdateError = updateError
		pricing = createElement6(View, { LayoutOrder = 4, tag = "col size-full-0 auto-y" }, v3)
	end

	children2.Pricing = pricing
	children.Summary = createElement3(View, {
		LayoutOrder = 2,
		tag = "col gap-xxlarge size-full-0 auto-y"
	}, children2)
	return createElement(
		View,
		{
			tag = "col gap-xxlarge size-full-0 auto-y padding-y-large",
			testId = "MonetizationPageView"
		},
		children
	)
end

local function EditContent(props)
	local v2

	if FFlagBuildExperienceMonetizationNativeUI then
		v2 = useTokens()
	end

	local selectedProduct = props.selectedProduct
	local createElement = React.createElement
	local media

	if FFlagBuildExperienceMonetizationNativeUI and selectedProduct ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v3 = {
			Image = selectedProduct.image or assetId,
			imageStyle = 0,
			ScaleType = 0,
			Size = 0,
			testId = "monetization-edit-image"
		}
		local imageStyle

		if selectedProduct.image == nil then
			imageStyle = v2.Color.Content.Emphasis
		end

		v3.imageStyle = imageStyle
		v3.ScaleType = Enum.ScaleType.Fit
		v3.Size = UDim2.fromOffset(v2.Size.Size_3000, v2.Size.Size_3000)
		media = createElement2(
			View,
			{
				LayoutOrder = 0,
				tag = "row align-x-center size-full-0 auto-y padding-y-xlarge radius-medium bg-surface-200"
			},
			{ Image = createElement3(Image, v3) }
		)
	end

	local name

	if props.canEditName ~= false then
		name = React.createElement(TextInput, {
			LayoutOrder = 1,
			isDisabled = props.isProductEditPending,
			label = props.labels.name,
			onChanged = props.onEditNameChanged,
			text = props.editName,
			testId = "monetization-edit-name",
			width = UDim.new(1, 0)
		})
	end

	local v3 = {
		Media = media,
		Name = name,
		Description = React.createElement(TextArea, {
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
	local price

	if props.canEditPrice ~= false then
		price = React.createElement(TextInput, {
			LayoutOrder = 3,
			isDisabled = props.isProductEditPending,
			label = props.labels.price,
			onChanged = props.onEditPriceChanged,
			text = props.editPrice,
			textInputType = Enum.TextInputType.Number,
			testId = "monetization-edit-price",
			width = UDim.new(1, 0)
		})
	end

	v3.Price = price
	local err

	if props.productEditError ~= nil then
		err = React.createElement(Text, {
			LayoutOrder = 4,
			Text = props.productEditError,
			tag = "size-full-0 auto-y text-body-small text-wrap content-alert",
			testId = "monetization-product-edit-error"
		})
	end

	v3.Error = err
	return createElement(
		View,
		{
			tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
			testId = "monetization-product-edit"
		},
		v3
	)
end

local function showsPageCreate(props, flag: boolean): boolean -- 1 equivalent call inferred from this helper
	return not flag and (props.mode == "empty" or props.mode == "catalog")
end

local function MonetizationPageView(props)
	local v2 = props.mode == "detail"
	local v3 = props.mode == "edit"
	local v4 = props.mode == "options"
	local v5 = #props.products > 0
	local v6 = props.catalogSources ~= nil
	local v7 = true

	if v6 then
		for _, catalogSource in props.catalogSources do
			if catalogSource.status ~= "Ready" then
				v7 = false
				break
			end
		end
	end

	local v8 = not (v2 or v3 or v4)

	if v8 then
		if v6 then
			v8 = not (v7 or v5)
		elseif props.catalogStatus == "Ready" then
			v8 = false
		else
			v8 = props.catalogStatus ~= "Failed" or not v5
		end
	end

	local v9

	if props.mode == "empty" then
		v9 = not v8
	else
		v9 = false
	end

	local v10 = FFlagBuildExperienceMonetizationPageFixes
		and FFlagBuildExperienceMonetizationMultiKind
		and v6
		and #props.catalogSources > 0

	local v11 = not (v6 or v2 or v3 or v4)

	if v11 then
		v11 = props.catalogStatus == "Failed" and v5
	end

	local headerTrailing

	if v2 and (props.canManageProduct or props.canEditKindProduct == true) then
		if FFlagBuildExperienceMonetizationNativeUI then
			headerTrailing = React.createElement(ProductActionsMenu, {
				isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
				editLabel = props.labels.edit,
				onEdit = props.onOpenProductEdit
			})
		else
			headerTrailing = React.createElement(Button, {
				isDisabled = props.isProductDisabled or props.isProductSaleStatusPending or props.isProductManagedPricingPending,
				onActivated = props.onOpenProductEdit,
				size = InputSize.Medium,
				testId = "monetization-edit-product",
				text = props.labels.edit,
				variant = ButtonVariant.Standard
			})
		end
	elseif not (v2 or v3 or v4 or v8 or not props.showOptions) then
		local createElement = React.createElement
		local icon

		if FFlagBuildExperienceMonetizationNativeUI then
			icon = IconName.TwoSwitchesHorizontal
		else
			icon = IconName.ThreeSlidersHorizontal
		end

		headerTrailing = createElement(IconButton, {
			icon = icon,
			isCircular = true,
			onActivated = props.onOpenOptions,
			size = InputSize.Medium,
			testId = "monetization-open-options",
			variant = ButtonVariant.Utility
		})
	end

	local content

	if props.isProductDisabled then
		content = React.createElement("CanvasGroup", {
			[React.Tag] = "data-testid=monetization-disabled-detail",
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = 0.55,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Content = React.createElement(DetailContent, props)
		})
	else
		content = React.createElement(DetailContent, props)
	end

	if v8 then
		if v10 then
			content = React.createElement(GroupedCatalogContent, props)
		elseif v6 then
			content = React.createElement(CatalogSourcesStatus, props)
		else
			content = React.createElement(CatalogStatusContent, props)
		end
	elseif not v2 then
		if v3 then
			content = React.createElement(EditContent, props)
		elseif v4 then
			content = React.createElement(OptionsContent, props)
		elseif props.mode == "empty" then
			content = React.createElement(EmptyContent, props)
		else
			content = React.createElement(CatalogContent, props)
		end
	end

	if v6 and not v10 and not v7 and v5 and not (v2 or v3 or v4) then
		content = React.createElement(View, { tag = "col gap-large size-full-0 auto-y" }, {
			Status = React.createElement(CatalogSourcesStatus, props),
			Content = content
		})
	end

	if v11 then
		content = React.createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
			Warning = React.createElement(CatalogRefreshWarning, props),
			Content = content
		})
	end

	local v12 = showsPageCreate(props, v8) -- inferred equivalent call
	local footer

	if v3 then
		footer = React.createElement(View, {
			tag = {
				["row gap-medium size-full-0 auto-y"] = true,
				["padding-y-medium"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}, {
			Cancel = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = FillBehavior.Fill,
				isDisabled = props.isProductEditPending,
				onActivated = props.onCancelProductEdit,
				size = InputSize.Large,
				testId = "monetization-cancel-product-edit",
				text = props.labels.cancel,
				variant = ButtonVariant.Standard,
				width = UDim.new(0.5, -6)
			}),
			Save = React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = FillBehavior.Fill,
				isLoading = props.isProductEditPending,
				onActivated = props.onSaveProductEdit,
				size = InputSize.Large,
				testId = "monetization-save-product-edit",
				text = props.labels.save,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(0.5, -6)
			})
		})
	elseif v12 then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local isDisabled

		if FFlagBuildExperienceMonetizationMultiKind or FFlagBuildCheckGamePermissions then
			isDisabled = not props.canCreateProduct
		end

		local v13 = {
			isDisabled = isDisabled,
			onActivated = props.onOpenCreate,
			size = 0,
			testId = "monetization-create",
			text = 0,
			variant = 0,
			width = 0
		}
		local size

		if FFlagBuildExperienceMonetizationNativeUI then
			size = InputSize.Large
		else
			size = InputSize.Medium
		end

		v13.size = size

		v13.text = props.labels.emptyCreateProduct
		v13.variant = ButtonVariant.Emphasis
		local width

		if FFlagBuildExperienceMonetizationNativeUI then
			width = UDim.new(1, 0)
		else
			width = UDim.new(0, 240)
		end

		v13.width = width
		footer = createElement(View, {
			tag = {
				["row align-x-center size-full-0 auto-y"] = true,
				["padding-y-medium"] = FFlagBuildExperienceMonetizationNativeUI
			}
		}, { Create = createElement2(Button, v13) })
	end

	if FFlagBuildExperienceDeveloperProductContext and v2 and props.chatActions ~= nil then
		footer = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-y-medium", testId = "monetization-detail-composer" },
			{
				Composer = React.createElement(ChatActions, props.chatActions)
			}
		)
	end

	local createElement = React.createElement
	local v13 = {
		closeIcon = IconName.ChevronLargeLeft,
		content = content,
		footer = footer,
		footerDivider = false,
		disableScrolling = FFlagBuildExperienceMonetizationNativeUI and v9,
		headerTrailing = headerTrailing,
		onClose = props.onClose,
		testId = "MonetizationPage",
		title = 0
	}
	local title

	if v2 then
		if props.selectedProduct == nil then
			title = props.labels.title
		else
			title = props.selectedProduct.name
		end
	elseif v3 then
		title = props.labels.editProduct
	elseif v4 then
		title = props.labels.options
	else
		title = props.labels.title
	end

	v13.title = title
	local element = createElement(OverflowMenuPageShell, v13)

	if FFlagBuildExperienceDeveloperProductContext then
		return React.createElement(View, {
			tag = "size-full",
			padding = {
				bottom = UDim.new(0, props.keyboardHeight or 0)
			}
		}, { Page = element })
	end

	return element
end

return MonetizationPageView
