local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId

local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local enums = Foundation.Enums
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local module = require("@luauforge/bundled/fXv")
local module2 = require("@luauforge/bundled/dCh")
local module3 = require("@luauforge/bundled/dyA")
local module4 = require("@luauforge/deferred/gaN")
local module5 = require("@luauforge/bundled/dwB")
local module6 = require("@luauforge/bundled/eeH")
local module7 = require("@luauforge/deferred/gaO")

local module8 = require("@luauforge/deferred/gaP")
local module9 = require("@luauforge/bundled/eda")

local module10 = require("@luauforge/deferred/fXN")
local constants = module10.Constants
local module11 = require("@luauforge/deferred/fXQ")

local module12 = require("@luauforge/deferred/gaQ")

local fFlagHideDevSubsPriceIfSubscribed = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagHideDevSubsPriceIfSubscribed

local module13 = require("@luauforge/deferred/fvm")
local module14 = require("@luauforge/bundled/fvl")
local productPurchaseSurface = require("@luauforge/deferred/fvp").Enums.ProductPurchaseSurface

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagIntegrateDiscountsWithEDP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagIntegrateDiscountsWithEDP

require("@luauforge/bundled/fXM")

local function SubscriptionTile(props)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local v5 = useDesignTokens()
	local titleLarge = v5.Typography.TitleLarge
	local bodySmall = v5.Typography.BodySmall
	local color = v5.Color
	local medium = v5.Radius.Medium
	local size_2400 = v5.Size.Size_2400
	local size_900 = v5.Size.Size_900

	local size_600 = v5.Size.Size_600
	local size_600_2 = v5.Size.Size_600
	local size_300 = v5.Size.Size_300
	local size_300_2 = v5.Size.Size_300

	local lineHeight = titleLarge.LineHeight
	local lineHeight2 = bodySmall.LineHeight
	local fontSize = titleLarge.FontSize
	local fontSize2 = bodySmall.FontSize

	local v6 = lineHeight * fontSize
	local v7 = v6 * 2
	local v8 = lineHeight2 * fontSize2

	local subscriptionProduct = props.subscriptionProduct
	local thumbnailString = props.thumbnailString
	local isSubscribed = props.isSubscribed

	local v9 = useDispatch()

	local v10 = useLocalization({
		subscribed = "Feature.Subscription.Text.Subscribed",
		pricePerMonth = {
			"Feature.Subscription.Email.PricePerMonthLabel",
			purchasePrice = subscriptionProduct.displayPrice
		},
		pricePerMonthRobux = module12() and subscriptionProduct.priceInRobux ~= nil and {
			"Feature.Subscription.Email.PricePerMonthLabel",
			purchasePrice = tostring(subscriptionProduct.priceInRobux)
		} or nil,
		seeMore = "Feature.Subscription.Action.SeeMore",
		reportSubscription = "Feature.Subscription.Action.ReportSubscription",
		reportSubscriptionSubmitted = "Feature.Subscription.Message.ReportSubmitted",
		somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
		subscribe = "Feature.Subscription.Action.Subscribe"
	})

	local v11 = if isSubscribed then v10.subscribed else v10.pricePerMonth

	local v12 = if isSubscribed then v10.subscribed else v10.subscribe
	local v13 = module12()

	if v13 then
		v13 = not (subscriptionProduct.priceInRobux == nil) and subscriptionProduct.priceInRobux > 0
	end

	local state3, setState3 = React.useState(false)
	local v14 = useLocalUserId()
	local v15 = module6(module9)

	local v16 = {
		{
			text = v10.reportSubscription,
			onActivated = function()
				module7(v15, subscriptionProduct.subscriptionTargetKey, v14):andThen(function(p2)
					v9(module2({
						toastMessage = v10.reportSubscriptionSubmitted,
						isLocalized = true,
						toastType = module5.SuccessConfirmation
					}))
				end, function(p2)
					v9(module2({
						toastMessage = v10.somethingIsWrong,
						isLocalized = true,
						toastType = module5.NetworkingError
					}))
				end)

				setState3(false)
			end,
			fontStyle = {
				Font = bodySmall.Font,
				RelativeSize = 0.625,
				RelativeMinSize = 0.625
			},
			textOnlyPadding = size_300
		}
	}

	local v17 = React.useCallback(function()
		local v21 = {
			kind = "DeveloperSubscription",
			subscriptionId = subscriptionProduct.subscriptionTargetKey,
			name = subscriptionProduct.name,
			expectedPrice = subscriptionProduct.priceInRobux or 0,
			iconImageAssetId = subscriptionProduct.iconImageAssetId,
			isSubscriptionInRobux = v13,
			displayPrice = 0
		}

		local v22 = if not v13 then subscriptionProduct.displayPrice else nil
		v21.displayPrice = v22
		v9(module13({
			productPayload = v21,
			purchaseCallbacks = {
				onFlowComplete = function()
					v9(module14())
				end,
				onPurchaseSuccess = function()
					v9(module3({
						[subscriptionProduct.subscriptionTargetKey] = {
							isSubscribed = true,
							isRenewing = true
						}
					}))
				end,
				onRobloxSubscriptionUpsellSuccess = fFlagIntegrateDiscountsWithEDP and function()
					v9(module(v15, subscriptionProduct.subscriptionProviderId))
				end or nil
			},
			purchaseAnalyticsMetadata = {
				surface = productPurchaseSurface.EDP,
				productUniverseId = subscriptionProduct.subscriptionProviderId
			}
		}))
	end, { subscriptionProduct, v13 })

	local v18 = React.useCallback(function()
		if module11() then
			module10.EdpStoreAnalyticsLogger.logEvent(
				constants.StoreEnums.ActionType.PurchaseAttemptClick,
				constants.StoreEnums.ProductType.Subscriptions,
				constants.StoreEnums.LocationType.Store,
				tonumber(subscriptionProduct.subscriptionProviderId),
				nil,
				(tostring(subscriptionProduct.subscriptionTargetKey))
			)
		end

		v9(module8(
			subscriptionProduct,
			thumbnailString,
			isSubscribed,
			props.creatorName,
			props.creatorVerified
		))
	end, { subscriptionProduct, thumbnailString, isSubscribed })

	local v19 = React.useCallback(function()
		if fFlagEnableUnifiedPurchaseFlowForDevSubs then
			v17()
		else
			v18()
		end
	end, { v18, v17 })

	if module12() then
		local v20 = if v13 then v10.pricePerMonthRobux else v10.pricePerMonth
		local createElement = React.createElement
		local v22 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = color.Surface.Surface_300.Color3,
			BackgroundTransparency = color.Surface.Surface_300.Transparency
		}
		local v23 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 0),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12)
			}),
			UICorners = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			TileContent = 0
		}

		local createElement2 = React.createElement
		local v25 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 12)
			}),
			TopSection = 0,
			SubscribeButton = 0
		}

		local createElement3 = React.createElement
		local v27 = {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = 0,
			[React.Event.Activated] = v18
		}
		local v28 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 12),
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Thumbnail = React.createElement(
				"ImageLabel",
				{
					Size = UDim2.fromOffset(72, 72),
					BackgroundTransparency = 1,
					Image = thumbnailString,
					LayoutOrder = 0
				},
				{
					UICorners = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}
			),
			TextContent = 0
		}

		local createElement4 = React.createElement
		local v30 = {
			Size = UDim2.new(1, -84, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[React.Change.AbsoluteSize] = function(p2)
				setState(p2.AbsoluteSize.X)
			end
		}
		local v31 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 6)
			}),
			SubscriptionTitle = React.createElement(styledTextLabel, {
				maxSize = Vector2.new(state, v6),
				fontStyle = titleLarge,
				colorStyle = color.Content.Emphasis,
				fluidSizing = false,
				richText = false,
				textWrapped = false,
				lineHeight = titleLarge.LineHeight,
				textTruncate = Enum.TextTruncate.AtEnd,
				text = subscriptionProduct.name,
				layoutOrder = 0,
				onAbsoluteSizeChange = function(p2)
					setState2(p2.AbsoluteSize.Y / v6)
				end
			}),
			Description = 0,
			PriceText = 0
		}

		local createElement5 = React.createElement
		local newVector2 = Vector2.new

		if isSubscribed and fFlagHideDevSubsPriceIfSubscribed then
			v8 *= 2
		end

		v31.Description = createElement5(styledTextLabel, {
			maxSize = newVector2(state, v8),
			fontStyle = bodySmall,
			colorStyle = color.Content.Muted,
			fluidSizing = false,
			richText = false,
			textWrapped = true,
			textTruncate = Enum.TextTruncate.AtEnd,
			lineHeight = bodySmall.LineHeight,
			text = subscriptionProduct.description,
			layoutOrder = 1
		})
		local v34

		if not (isSubscribed and fFlagHideDevSubsPriceIfSubscribed) then
			local createElement6 = React.createElement

			if v13 then
				v20 = getIconRichText(enums.IconName.Robux) .. " " .. v20
			end

			v34 = createElement6(text, {
				Text = v20,
				RichText = v13,
				tag = "auto-xy content-emphasis text-body-medium",
				LayoutOrder = 2
			})
		end

		v31.PriceText = v34
		v28.TextContent = createElement4("Frame", v30, v31)
		children.TopSection = createElement3("TextButton", v27, v28)

		children.SubscribeButton = React.createElement(button, {
			size = UDim2.new(1, 0, 0, 32),
			text = v12,
			isDisabled = isSubscribed,
			onActivated = v19,
			layoutOrder = 1
		})
		v23.TileContent = createElement2("Frame", v25, children)
		return createElement("Frame", v22, v23)
	else
		local createElement = React.createElement
		local v21 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = color.Surface.Surface_300.Color3,
			BackgroundTransparency = color.Surface.Surface_300.Transparency
		}
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, size_600_2),
				PaddingBottom = UDim.new(0, size_600_2),
				PaddingLeft = UDim.new(0, size_600_2),
				PaddingRight = UDim.new(0, size_600_2)
			}),
			UICorners = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, medium)
			}),
			TileContent = 0,
			MoreMenuButton = 0
		}

		local createElement2 = React.createElement
		local v23 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local children2 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, size_300_2)
			}),
			SubscriptionInfoFrame = 0,
			PurchaseButton = 0
		}

		local createElement3 = React.createElement
		local v25 = {
			Size = UDim2.new(1, 0, 0, 128),
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}

		local v26 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, size_600)
			}),
			Thumbnail = React.createElement(
				"ImageLabel",
				{
					Size = UDim2.fromOffset(size_2400, size_2400),
					BackgroundTransparency = 1,
					Image = thumbnailString
				},
				{
					UICorners = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, medium)
					})
				}
			),
			TextContent = 0
		}

		local createElement4 = React.createElement
		local v28 = {
			Size = UDim2.new(1, -size_2400 - size_600, 0, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = function(p2)
				setState(p2.AbsoluteSize.X)
			end
		}
		local v29 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, size_300)
			}),
			SubscriptionTitle = React.createElement(styledTextLabel, {
				maxSize = Vector2.new(state, v7),
				fontStyle = titleLarge,
				colorStyle = color.Content.Emphasis,
				fluidSizing = false,
				richText = false,
				textWrapped = true,
				lineHeight = titleLarge.LineHeight,
				textTruncate = Enum.TextTruncate.AtEnd,
				text = subscriptionProduct.name,
				layoutOrder = 0,
				onAbsoluteSizeChange = function(p2)
					setState2(p2.AbsoluteSize.Y / v6)
				end
			}),
			Description = React.createElement(styledTextLabel, {
				maxSize = Vector2.new(state, v8 * (5 - state2)),
				fontStyle = bodySmall,
				colorStyle = color.Content.Emphasis,
				fluidSizing = false,
				richText = false,
				textWrapped = true,
				textTruncate = Enum.TextTruncate.AtEnd,
				lineHeight = bodySmall.LineHeight,
				text = subscriptionProduct.description,
				layoutOrder = 1
			}),
			SeeMore = 0
		}

		local createElement5 = React.createElement
		local v31 = {}
		v31.Size = UDim2.new(1, 0, 0, 0)
		v31.Text = v10.seeMore
		v31.AutomaticSize = Enum.AutomaticSize.Y
		v31.TextXAlignment = Enum.TextXAlignment.Left
		v31.BackgroundTransparency = 1
		v31.TextColor3 = color.Content.Emphasis.Color3
		v31.TextSize = bodySmall.FontSize
		local v32 = if not foundationFontFaceMigration then bodySmall.Font else nil
		v31.Font = v32

		local v33 = if foundationFontFaceMigration then normalizeFontFace(bodySmall.Font) else nil
		v31.FontFace = v33

		v31.LayoutOrder = 2
		v31[React.Event.Activated] = v18
		v29.SeeMore = createElement5("TextButton", v31)
		v26.TextContent = createElement4("Frame", v28, v29)
		children2.SubscriptionInfoFrame = createElement3("Frame", v25, v26)

		children2.PurchaseButton = React.createElement(button, {
			size = UDim2.new(1, 0, 0, size_900),
			text = v11,
			isDisabled = isSubscribed,
			onActivated = v19,
			layoutOrder = 1
		})
		children.TileContent = createElement2("Frame", v23, children2)

		children.MoreMenuButton = React.createElement(module4, {
			screenSize = props.screenSize,
			buttonProps = v16,
			showMenu = state3,
			onDismiss = function()
				setState3(false)
			end,
			onActivated = function()
				setState3(not state3)
			end
		})
		return createElement("Frame", v21, children)
	end
end

return SubscriptionTile
