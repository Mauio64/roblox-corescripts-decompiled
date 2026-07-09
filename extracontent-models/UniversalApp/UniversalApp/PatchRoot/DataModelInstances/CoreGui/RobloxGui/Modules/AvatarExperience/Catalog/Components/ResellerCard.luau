local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameOnAxis = RoactFitComponents.FitFrameOnAxis
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local AppPage = require(Modules.LuaApp.AppPage)
local Constants = require(Modules.LuaApp.Constants)
local FitTextLabel = RoactFitComponents.FitTextLabel
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v36 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v37 = SharedFlags.FFlagAXMigrateAXToGlobalAutofocus and game:DefineFastFlag("AXMigrateResellersCardToAutofocus", false)
local v38 = game:DefineFastFlag("AXResellersCardShouldRespectWebViewAvailability", false)
local withStyle = UIBlox.Style.withStyle
local AVATAR_PLACEHOLDER_IMAGE = Constants.AVATAR_PLACEHOLDER_IMAGE
local v41 = Images["component_assets/circle_17"]
local ImageRectSize = v41.ImageRectSize
local v43 = 8 * Images.ImagesResolutionScale
local v44 = 8 * Images.ImagesResolutionScale
local rect = Rect.new(v43, v44, ImageRectSize.x - v43, ImageRectSize.y - v44)
local v46 = Images["icons/status/item/limited"]
local v47 = Images["icons/common/robux"]
local AvatarHeadShot = Constants2.RbxthumbTypes.AvatarHeadShot
local v49 = Roact.PureComponent:extend("ResellerCard")

function v49.init(p1) -- line: 99
	-- upvalues: AppPage (copy), UrlBuilder (copy), AvatarScreen (copy), logOnOverlayClosed (copy), v37 (copy)
	function p1.viewProfile() -- line: 100
		-- upvalues: p1 (copy), AppPage (copy), UrlBuilder (copy)
		p1.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = UrlBuilder.user.profile({
				userId = p1.props.sellerId
			}),
			extraProps = {
				titleKey = "CommonUI.Features.Label.Profile"
			}
		})
	end
	function p1.openPurchasePrompt() -- line: 112
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local userRobux = p1.props.userRobux
		local itemId = p1.props.itemId
		local itemType = p1.props.itemType
		local productId = p1.props.productId
		local itemPrice = p1.props.itemPrice
		local sellerId = p1.props.sellerId
		local sellerName = p1.props.sellerName
		local userAssetId = p1.props.userAssetId
		local collectibleInstanceId = p1.props.collectibleInstanceId
		local navigation = p1.props.navigation
		local v81 = p1.onOverlayClosed()
		local v82 = navigation.getParam("fromContentFeed")
		local v83 = navigation.getParam("fromProfile")

		if itemPrice and (userRobux and itemPrice <= userRobux) then
			navigation.navigate(AvatarScreen.PurchaseCatalogItem, {
				itemId = itemId,
				itemType = itemType,
				productId = productId,
				priceInRobux = itemPrice,
				sellerId = sellerId,
				sellerName = sellerName,
				userAssetId = userAssetId,
				collectibleInstanceId = collectibleInstanceId,
				onOverlayClosed = v81,
				fromProfile = v83,
				fromContentFeed = v82
			})

			return
		end

		navigation.navigate(AvatarScreen.InsufficientRobuxPrompt, {
			onOverlayClosed = v81
		})
	end
	function p1.onOverlayClosed() -- line: 148
		-- upvalues: logOnOverlayClosed (copy), v37 (copy), p1 (copy)
		return function() -- line: 149
			-- upvalues: logOnOverlayClosed (copy), v37 (copy), p1 (copy)
			logOnOverlayClosed("ResellerCard")

			if not v37 then
				p1.props.focusController.captureFocus()
			end
		end
	end
end
function v49.render(p2) -- line: 158
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), NumberLocalization (copy), withSelectionCursorProvider (copy), Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), v38 (copy), ImageSetLabel (copy), AVATAR_PLACEHOLDER_IMAGE (copy), FitFrameOnAxis (copy), VerifiedBadges (copy), v41 (copy), rect (ref), v46 (copy), FitTextLabel (copy), v37 (copy), ImageSetButton (copy), Focusable (copy), CursorKind (copy), v47 (copy), withStyle (copy)
	local serialNumber = p2.props.serialNumber
	local sellerId = p2.props.sellerId
	local sellerName = p2.props.sellerName
	local itemPrice = p2.props.itemPrice
	local propsLayoutOrder = p2.props.LayoutOrder
	local localization = p2.props.localization
	local v62 = getRbxthumbWithTypeSizeAndOptions(sellerId, AvatarHeadShot, 48)

	return withStyle(function(p3) -- line: 168
		-- upvalues: itemPrice (copy), NumberLocalization (copy), localization (copy), withSelectionCursorProvider (copy), Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), propsLayoutOrder (copy), v38 (copy), p2 (copy), serialNumber (copy), ImageSetLabel (copy), v62 (copy), AVATAR_PLACEHOLDER_IMAGE (copy), FitFrameOnAxis (copy), VerifiedBadges (copy), sellerName (copy), v41 (copy), rect (ref), v46 (copy), FitTextLabel (copy), v37 (copy), ImageSetButton (copy), Focusable (copy), CursorKind (copy), v47 (copy)
		local Theme = p3.Theme
		local p3Font = p3.Font
		local BackgroundDefaultColor = Theme.BackgroundDefault.Color
		local Footer = p3Font.Footer
		local v89 = Footer.RelativeSize * p3Font.BaseSize
		local v90 = string.format("%.0f", itemPrice)
		local v91 = NumberLocalization.localize(v90, localization:GetLocale())

		return withSelectionCursorProvider(function(p4) -- line: 180
			-- upvalues: Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), propsLayoutOrder (copy), Theme (copy), v38 (copy), p2 (copy), serialNumber (copy), ImageSetLabel (copy), v62 (copy), AVATAR_PLACEHOLDER_IMAGE (copy), BackgroundDefaultColor (copy), FitFrameOnAxis (copy), VerifiedBadges (copy), p3Font (copy), sellerName (copy), v41 (copy), rect (ref), v89 (copy), v46 (copy), FitTextLabel (copy), Footer (copy), v37 (copy), ImageSetButton (copy), Focusable (copy), CursorKind (copy), v47 (copy), v91 (copy)
			return Roact.createElement(FitFrameVertical, {
				BorderSizePixel = 0,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				margin = RoactFitComponents.Rect.rectangle(24, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				LayoutOrder = propsLayoutOrder,
				BackgroundColor3 = Theme.BackgroundDefault.Color
			}, {
				ProfileButton = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					width = UDim.new(1, 0),
					onActivated = if not v38 then p2.viewProfile else if not p2.props.isWebViewSupported then nil else p2.viewProfile,
					Selectable = if not v38 then nil else p2.props.isWebViewSupported
				}, {
					UserAndStatsFrame = Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						contentPadding = UDim.new(0, 12),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = serialNumber and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Center,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 0, 0)
					}, {
						UserThumbnail = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(0, 48, 0, 48),
							Image = v62 or AVATAR_PLACEHOLDER_IMAGE
						}, {
							MaskFrame = Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								Image = "rbxasset://textures/ui/LuaApp/graphic/profilemask.png",
								Size = UDim2.new(1, 0, 1, 0),
								ImageColor3 = BackgroundDefaultColor
							})
						}),
						SerialAndUsernameFrame = Roact.createElement(FitFrameOnAxis, {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							axis = FitFrameOnAxis.Axis.Both,
							contentPadding = UDim.new(0, 3),
							FillDirection = Enum.FillDirection.Vertical
						}, {
							Username = Roact.createElement(VerifiedBadges.EmojiWrapper, {
								emoji = not p2.props.sellerHasVerifiedBadge and "" or VerifiedBadges.emoji.verified
							}, {
								UsernameLabel = Roact.createElement("TextLabel", {
									BackgroundTransparency = 1,
									LayoutOrder = 1,
									AutomaticSize = Enum.AutomaticSize.XY,
									Font = p3Font.Header2.Font,
									TextColor3 = Theme.TextEmphasis.Color,
									TextSize = p3Font.Header2.RelativeSize * p3Font.BaseSize,
									Text = sellerName
								})
							}),
							SerialNumberLabel = serialNumber and Roact.createElement(FitFrameOnAxis, {
								BackgroundTransparency = 1,
								LayoutOrder = 2,
								axis = FitFrameOnAxis.Axis.Both,
								contentPadding = UDim.new(0, 1),
								margin = RoactFitComponents.Rect.square(4),
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								ImageSet = v41,
								ImageColor3 = Theme.UIDefault.Color,
								ImageTransparency = Theme.UIDefault.Transparency,
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = rect
							}, {
								LimitedIcon = Roact.createElement(ImageSetLabel, {
									BackgroundTransparency = 1,
									LayoutOrder = 1,
									Size = UDim2.new(0, v89, 0, v89),
									Image = v46,
									ImageColor3 = Theme.TextEmphasis.Color
								}),
								SerialNumberText = Roact.createElement(FitTextLabel, {
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									width = FitTextLabel.Width.FitToText,
									Size = UDim2.new(0, 0, 0, v89),
									Font = Footer.Font,
									TextColor3 = Theme.TextEmphasis.Color,
									TextSize = v89,
									Text = "#" .. serialNumber
								})
							})
						})
					})
				}),
				BuyButton = Roact.createElement(if not v37 then Focusable[ImageSetButton] else ImageSetButton, {
					Size = UDim2.new(1, 0, 0, 44),
					BackgroundTransparency = 1,
					Image = v41,
					ImageColor3 = Theme.ContextualPrimaryDefault.Color,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9),
					LayoutOrder = 2,
					SelectionImageObject = p4(CursorKind.RoundedRectNoInset),
					[Roact.Event.Activated] = p2.openPurchasePrompt
				}, {
					PriceFrame = Roact.createElement(FitFrameOnAxis, {
						BackgroundTransparency = 1,
						axis = FitFrameOnAxis.Axis.Both,
						contentPadding = UDim.new(0, 4),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					}, {
						RobuxIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(0, 25, 0, 25),
							Image = v47,
							ImageColor3 = Theme.ContextualPrimaryContent.Color,
							ImageTransparency = Theme.ContextualPrimaryContent.Transparency
						}),
						Price = Roact.createElement(FitTextLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							width = FitTextLabel.Width.FitToText,
							Font = p3Font.Header2.Font,
							TextColor3 = Theme.ContextualPrimaryContent.Color,
							TextTransparency = Theme.ContextualPrimaryContent.Transparency,
							TextSize = p3Font.Header2.RelativeSize * p3Font.BaseSize,
							Text = v91
						})
					})
				})
			})
		end)
	end)
end

local v50 = function(p5) -- line: 345
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v36 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p6) -- line: 347
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v36 (copy), p5 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v36.down(v36.fromLegacyPage(p6))

				return
			end

			p5(NavigateDown(p6))
		end
	}
end or nil

local function mapStateToProps(p7, p8) -- line: 357
	local v66 = p7.Users[p8.sellerId]
	local LocalUserId = p7.LocalUserId

	return {
		userRobux = p7.UserRobux[LocalUserId],
		userName = v66 and v66.name
	}
end

local v52 = RoactRodux.connect(mapStateToProps, v50)(v49)
local u53 = withNavigation((RoactServices.connect({
	localization = RoactLocalization
})(v52)))

if v38 then
	return function(p9) -- line: 376
		-- upvalues: useAppPolicy (copy), React (copy), u53 (ref)
		local v69 = useAppPolicy(function(p10) -- line: 377
			return p10.getWebViewSupport()
		end)
		local v70 = table.clone(p9)

		p9.isWebViewSupported = v69

		return React.createElement(u53, v70)
	end
end

return u53
