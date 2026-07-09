local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local Enums = Foundation.Enums
local FetchExperienceStoreProducts = require(Modules.LuaApp.Thunks.Economy.FetchExperienceStoreProducts)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetSubscriptionStatuses = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionStatuses)
local MoreMenu = require(Modules.LuaApp.Components.Subscription.MoreMenu)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local PostReportSubscription = require(Modules.LuaApp.Http.Requests.EconomyAPI.PostReportSubscription)
local NavigateDownToSubscriptionPurchase = require(Modules.LuaApp.Thunks.Subscription.NavigateDownToSubscriptionPurchase)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableDevSubsInRobux = require(Modules.LuaApp.Flags.GetFFlagEnableDevSubsInRobux)
local FFlagHideDevSubsPriceIfSubscribed = require(CorePackages.Workspace.Packages.SharedFlags).FFlagHideDevSubsPriceIfSubscribed
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ProductPurchaseSurface = require(CorePackages.Workspace.Packages.PurchasePromptLite).Enums.ProductPurchaseSurface
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagIntegrateDiscountsWithEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIntegrateDiscountsWithEDP

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)

local function SubscriptionTile(t1: {[any]: any}) -- line: 72
	-- upvalues: React (copy), useDesignTokens (copy), useDispatch (copy), useLocalization (copy), GetFFlagEnableDevSubsInRobux (copy), useLocalUserId (copy), useRoactService (copy), RoactNetworking (copy), PostReportSubscription (copy), SetCurrentToastMessage (copy), ToastType (copy), CloseCentralOverlay (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), SetSubscriptionStatuses (copy), FFlagIntegrateDiscountsWithEDP (copy), FetchExperienceStoreProducts (copy), ProductPurchaseSurface (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), NavigateDownToSubscriptionPurchase (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), StyledTextLabel (copy), FFlagHideDevSubsPriceIfSubscribed (copy), FoundationText (copy), getIconRichText (copy), Enums (copy), Button (copy), MoreMenu (copy)
	local v36, v37 = React.useState(0)
	local v38, v39 = React.useState(0)
	local v40 = useDesignTokens()
	local Semantic = v40.Semantic
	local Subheader = Semantic.Typography.Subheader
	local CaptionBody = Semantic.Typography.CaptionBody
	local SemanticColor = Semantic.Color
	local Medium = Semantic.Radius.Medium
	local XLarge = Semantic.Icon.Size.XLarge
	local Global = v40.Global
	local Size_450 = Global.Size_450
	local Space_300 = Global.Space_300
	local Space_300_2 = Global.Space_300
	local Space_150 = Global.Space_150
	local Space_150_2 = Global.Space_150
	local LineHeight = Subheader.LineHeight
	local LineHeight2 = CaptionBody.LineHeight
	local FontSize = Subheader.FontSize
	local FontSize2 = CaptionBody.FontSize
	local v57 = LineHeight * FontSize
	local v58 = v57 * 2
	local v59 = LineHeight2 * FontSize2
	local subscriptionProduct = t1.subscriptionProduct
	local thumbnailString = t1.thumbnailString
	local isSubscribed = t1.isSubscribed
	local v63 = useDispatch()
	local v64 = useLocalization({
		subscribed = "Feature.Subscription.Text.Subscribed",
		seeMore = "Feature.Subscription.Action.SeeMore",
		reportSubscription = "Feature.Subscription.Action.ReportSubscription",
		reportSubscriptionSubmitted = "Feature.Subscription.Message.ReportSubmitted",
		somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
		subscribe = "Feature.Subscription.Action.Subscribe",
		pricePerMonth = {
			"Feature.Subscription.Email.PricePerMonthLabel",
			purchasePrice = subscriptionProduct.displayPrice
		},
		pricePerMonthRobux = if not GetFFlagEnableDevSubsInRobux() or subscriptionProduct.priceInRobux == nil then nil else {
			"Feature.Subscription.Email.PricePerMonthLabel",
			purchasePrice = tostring(subscriptionProduct.priceInRobux)
		}
	})
	local v65 = if not isSubscribed then v64.pricePerMonth else v64.subscribed
	local v66 = if not isSubscribed then v64.subscribe else v64.subscribed
	local v67 = GetFFlagEnableDevSubsInRobux() and (subscriptionProduct.priceInRobux ~= nil and subscriptionProduct.priceInRobux > 0)
	local v68, v69 = React.useState(false)
	local v70 = useLocalUserId()
	local v71 = useRoactService(RoactNetworking)
	local t2 = {{
		text = v64.reportSubscription,
		onActivated = function() -- line: 141
			-- upvalues: PostReportSubscription (copy), v71 (copy), subscriptionProduct (copy), v70 (copy), v63 (copy), SetCurrentToastMessage (copy), v64 (copy), ToastType (copy), v69 (copy)
			PostReportSubscription(v71, subscriptionProduct.subscriptionTargetKey, v70):andThen(function(_) -- line: 143
				-- upvalues: v63 (copy), SetCurrentToastMessage (copy), v64 (copy), ToastType (copy)
				v63(SetCurrentToastMessage({
					isLocalized = true,
					toastMessage = v64.reportSubscriptionSubmitted,
					toastType = ToastType.SuccessConfirmation
				}))
			end, function(_) -- line: 150
				-- upvalues: v63 (copy), SetCurrentToastMessage (copy), v64 (copy), ToastType (copy)
				v63(SetCurrentToastMessage({
					isLocalized = true,
					toastMessage = v64.somethingIsWrong,
					toastType = ToastType.NetworkingError
				}))
			end)
			v69(false)
		end,
		fontStyle = {
			RelativeSize = 0.625,
			RelativeMinSize = 0.625,
			Font = CaptionBody.Font
		},
		textOnlyPadding = Space_150
	}}
	local v73 = React.useCallback(function() -- line: 165
		-- upvalues: v63 (copy), CloseCentralOverlay (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), subscriptionProduct (copy), v67 (copy), SetSubscriptionStatuses (copy), FFlagIntegrateDiscountsWithEDP (copy), FetchExperienceStoreProducts (copy), v71 (copy), ProductPurchaseSurface (copy)
		v63(OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = {
				kind = "DeveloperSubscription",
				subscriptionId = subscriptionProduct.subscriptionTargetKey,
				name = subscriptionProduct.name,
				expectedPrice = subscriptionProduct.priceInRobux or 0,
				iconImageAssetId = subscriptionProduct.iconImageAssetId,
				isSubscriptionInRobux = v67,
				displayPrice = if v67 then nil else subscriptionProduct.displayPrice
			},
			purchaseCallbacks = {
				onFlowComplete = function() -- line: 166
					-- upvalues: v63 (copy), CloseCentralOverlay (copy)
					v63(CloseCentralOverlay())
				end,
				onPurchaseSuccess = function() -- line: 182
					-- upvalues: v63 (copy), SetSubscriptionStatuses (copy), subscriptionProduct (copy)
					v63(SetSubscriptionStatuses({
						[subscriptionProduct.subscriptionTargetKey] = {
							isSubscribed = true,
							isRenewing = true
						}
					}))
				end,
				onRobloxSubscriptionUpsellSuccess = if not FFlagIntegrateDiscountsWithEDP then nil else function() -- line: 191
					-- upvalues: v63 (copy), FetchExperienceStoreProducts (copy), v71 (copy), subscriptionProduct (copy)
					v63(FetchExperienceStoreProducts(v71, subscriptionProduct.subscriptionProviderId))
				end
			},
			purchaseAnalyticsMetadata = {
				surface = ProductPurchaseSurface.EDP,
				productUniverseId = subscriptionProduct.subscriptionProviderId
			}
		}))
	end, {
		subscriptionProduct,
		v67
	})
	local v74 = React.useCallback(function() -- line: 203
		-- upvalues: GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), subscriptionProduct (copy), v63 (copy), NavigateDownToSubscriptionPurchase (copy), thumbnailString (copy), isSubscribed (copy), t1 (copy)
		if GetFFlagEnableEdpStoreClickLogging() then
			EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants.StoreEnums.ActionType.PurchaseAttemptClick, Constants.StoreEnums.ProductType.Subscriptions, Constants.StoreEnums.LocationType.Store, tonumber(subscriptionProduct.subscriptionProviderId), nil, (tostring(subscriptionProduct.subscriptionTargetKey)))
		end

		v63(NavigateDownToSubscriptionPurchase(subscriptionProduct, thumbnailString, isSubscribed, t1.creatorName, t1.creatorVerified))
	end, {
		subscriptionProduct,
		thumbnailString,
		isSubscribed
	})
	local v75 = React.useCallback(function() -- line: 225
		-- upvalues: FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), v73 (copy), v74 (copy)
		if FFlagEnableUnifiedPurchaseFlowForDevSubs then
			v73()

			return
		end

		v74()
	end, {
		v74,
		v73
	})

	if GetFFlagEnableDevSubsInRobux() then
		local v76 = if not v67 then v64.pricePerMonth else v64.pricePerMonthRobux

		return React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = SemanticColor.BackgroundUi.Default.Color3,
			BackgroundTransparency = SemanticColor.BackgroundUi.Default.Transparency
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 0),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12)
			}),
			UICorners = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			TileContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 12)
				}),
				TopSection = React.createElement("TextButton", {
					Size = UDim2.new(1, 0, 0, 72),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = 0,
					[React.Event.Activated] = v74
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 12),
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					Thumbnail = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						Size = UDim2.fromOffset(72, 72),
						Image = thumbnailString
					}, {
						UICorners = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}),
					TextContent = React.createElement("Frame", {
						Size = UDim2.new(1, -84, 1, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						[React.Change.AbsoluteSize] = function(p3) -- line: 291
							-- upvalues: v37 (copy)
							v37(p3.AbsoluteSize.X)
						end
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 6)
						}),
						SubscriptionTitle = React.createElement(StyledTextLabel, {
							fluidSizing = false,
							richText = false,
							textWrapped = false,
							layoutOrder = 0,
							maxSize = Vector2.new(v36, v57),
							fontStyle = Subheader,
							colorStyle = SemanticColor.Text.Emphasis,
							lineHeight = Subheader.LineHeight,
							textTruncate = Enum.TextTruncate.AtEnd,
							text = subscriptionProduct.name,
							onAbsoluteSizeChange = function(p4) -- line: 311
								-- upvalues: v39 (copy), v57 (copy)
								v39(p4.AbsoluteSize.Y / v57)
							end
						}),
						Description = React.createElement(StyledTextLabel, {
							fluidSizing = false,
							richText = false,
							textWrapped = true,
							layoutOrder = 1,
							maxSize = Vector2.new(v36, if not isSubscribed or not FFlagHideDevSubsPriceIfSubscribed then v59 else v59 * 2),
							fontStyle = CaptionBody,
							colorStyle = SemanticColor.Text.Muted,
							textTruncate = Enum.TextTruncate.AtEnd,
							lineHeight = CaptionBody.LineHeight,
							text = subscriptionProduct.description
						}),
						PriceText = if not not isSubscribed and FFlagHideDevSubsPriceIfSubscribed then nil else React.createElement(FoundationText, {
							tag = "auto-xy content-emphasis text-body-medium",
							LayoutOrder = 2,
							Text = if not v67 then v76 else getIconRichText(Enums.IconName.Robux) .. " " .. v76,
							RichText = v67
						})
					})
				}),
				SubscribeButton = React.createElement(Button, {
					layoutOrder = 1,
					size = UDim2.new(1, 0, 0, 32),
					text = v66,
					isDisabled = isSubscribed,
					onActivated = v75
				})
			})
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = SemanticColor.BackgroundUi.Default.Color3,
		BackgroundTransparency = SemanticColor.BackgroundUi.Default.Transparency
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Space_300_2),
			PaddingBottom = UDim.new(0, Space_300_2),
			PaddingLeft = UDim.new(0, Space_300_2),
			PaddingRight = UDim.new(0, Space_300_2)
		}),
		UICorners = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, Medium)
		}),
		TileContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, Space_150_2)
			}),
			SubscriptionInfoFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, 128)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, Space_300)
				}),
				Thumbnail = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(XLarge, XLarge),
					Image = thumbnailString
				}, {
					UICorners = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, Medium)
					})
				}),
				TextContent = React.createElement("Frame", {
					Size = UDim2.new(1, -XLarge - Space_300, 0, 0),
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = function(p5) -- line: 402
						-- upvalues: v37 (copy)
						v37(p5.AbsoluteSize.X)
					end
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, Space_150)
					}),
					SubscriptionTitle = React.createElement(StyledTextLabel, {
						fluidSizing = false,
						richText = false,
						textWrapped = true,
						layoutOrder = 0,
						maxSize = Vector2.new(v36, v58),
						fontStyle = Subheader,
						colorStyle = SemanticColor.Text.Emphasis,
						lineHeight = Subheader.LineHeight,
						textTruncate = Enum.TextTruncate.AtEnd,
						text = subscriptionProduct.name,
						onAbsoluteSizeChange = function(p6) -- line: 423
							-- upvalues: v39 (copy), v57 (copy)
							v39(p6.AbsoluteSize.Y / v57)
						end
					}),
					Description = React.createElement(StyledTextLabel, {
						fluidSizing = false,
						richText = false,
						textWrapped = true,
						layoutOrder = 1,
						maxSize = Vector2.new(v36, v59 * (5 - v38)),
						fontStyle = CaptionBody,
						colorStyle = SemanticColor.Text.Emphasis,
						textTruncate = Enum.TextTruncate.AtEnd,
						lineHeight = CaptionBody.LineHeight,
						text = subscriptionProduct.description
					}),
					SeeMore = React.createElement("TextButton", {
						Size = UDim2.new(1, 0, 0, 0),
						Text = v64.seeMore,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
						TextColor3 = SemanticColor.Text.Emphasis.Color,
						TextSize = CaptionBody.FontSize,
						Font = CaptionBody.Font,
						LayoutOrder = 2,
						[React.Event.Activated] = v74
					})
				})
			}),
			PurchaseButton = React.createElement(Button, {
				layoutOrder = 1,
				size = UDim2.new(1, 0, 0, Size_450),
				text = v65,
				isDisabled = isSubscribed,
				onActivated = v75
			})
		}),
		MoreMenuButton = React.createElement(MoreMenu, {
			screenSize = t1.screenSize,
			buttonProps = t2,
			showMenu = v68,
			onDismiss = function() -- line: 470
				-- upvalues: v69 (copy)
				v69(false)
			end,
			onActivated = function() -- line: 473
				-- upvalues: v69 (copy), v68 (copy)
				v69(not v68)
			end
		})
	})
end

return SubscriptionTile
