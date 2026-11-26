local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/dKT")

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameOnAxis = roactFitComponents.FitFrameOnAxis
local fitFrameVertical = roactFitComponents.FitFrameVertical

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local module3 = require("@luauforge/bundled/dFu")
local module4 = require("@luauforge/bundled/dzD")
local fitTextLabel = roactFitComponents.FitTextLabel
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed

local module5 = require("@luauforge/bundled/ehB")
local module6 = require("@luauforge/bundled/fzK")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization

local module7 = require("@luauforge/bundled/ciE")
local constants = module7.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module7.Utils.getRbxthumbWithTypeSizeAndOptions
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagFontFaceAX = SharedFlags.FFlagFontFaceAX
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local defineFastFlag = game:DefineFastFlag("AXResellersCardShouldRespectWebViewAvailability", false)
local fFlagAXFixResellersList = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixResellersList
local withStyle = UIBlox.Style.withStyle

local AVATAR_PLACEHOLDER_IMAGE = module4.AVATAR_PLACEHOLDER_IMAGE
local component_assetscircle_17 = images["component_assets/circle_17"]

local imageRectSize = component_assetscircle_17.ImageRectSize
local v5 = 8 * images.ImagesResolutionScale
local v6 = 8 * images.ImagesResolutionScale

local rect = Rect.new(v5, v6, imageRectSize.x - v5, imageRectSize.y - v6)

local iconsstatusitemlimited = images["icons/status/item/limited"]
local iconscommonrobux = images["icons/common/robux"]

local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local extended = Roact.PureComponent:extend("ResellerCard")

function extended:init()
	function self.viewProfile()
		self.props.navigateDown({
			name = module3.GenericWebPage,
			detail = module6.user.profile({ userId = self.props.sellerId }),
			extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
		})
	end

	function self.openPurchasePrompt()
		local userRobux = self.props.userRobux
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local productId = self.props.productId
		local itemPrice = self.props.itemPrice
		local sellerId = self.props.sellerId
		local sellerName = self.props.sellerName
		local userAssetId = self.props.userAssetId
		local collectibleInstanceId = self.props.collectibleInstanceId
		local navigation = self.props.navigation
		local v7 = self.onOverlayClosed()
		local param = navigation.getParam("fromContentFeed")
		local param2 = navigation.getParam("fromProfile")

		if itemPrice and userRobux and itemPrice <= userRobux then
			navigation.navigate(avatarScreen.PurchaseCatalogItem, {
				itemId = itemId,
				itemType = itemType,
				productId = productId,
				priceInRobux = itemPrice,
				sellerId = sellerId,
				sellerName = sellerName,
				userAssetId = userAssetId,
				collectibleInstanceId = collectibleInstanceId,
				onOverlayClosed = v7,
				fromProfile = param2,
				fromContentFeed = param
			})
		else
			navigation.navigate(avatarScreen.InsufficientRobuxPrompt, {
				onOverlayClosed = v7
			})
		end
	end

	function self.onOverlayClosed()
		return function()
			logOnOverlayClosed("ResellerCard")
		end
	end
end

function extended.render(data)
	local serialNumber = data.props.serialNumber
	local sellerId = data.props.sellerId
	local sellerName = data.props.sellerName
	local itemPrice = data.props.itemPrice
	local layoutOrder = data.props.LayoutOrder
	local localization = data.props.localization

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(sellerId, avatarHeadShot, 48)

	return withStyle(function(data2)
		local theme = data2.Theme
		local font = data2.Font

		local color = theme.BackgroundDefault.Color

		local footer = font.Footer
		local v7 = footer.RelativeSize * font.BaseSize

		local v8 = string.format("%.0f", itemPrice)
		local localize = numberLocalization.localize(v8, localization:GetLocale())

		return withSelectionCursorProvider(function(callback)
			local createElement = Roact.createElement
			local v10 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				margin = roactFitComponents.Rect.rectangle(24, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				LayoutOrder = layoutOrder,
				BorderSizePixel = 0,
				BackgroundColor3 = theme.BackgroundDefault.Color
			}

			local createElement2 = Roact.createElement
			local v12 = {
				width = UDim.new(1, 0),
				onActivated = 0,
				Selectable = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}
			local viewProfile

			if defineFastFlag then
				if data.props.isWebViewSupported then
					viewProfile = data.viewProfile
				end
			else
				viewProfile = data.viewProfile
			end

			v12.onActivated = viewProfile

			local v13 = if defineFastFlag then data.props.isWebViewSupported else nil
			v12.Selectable = v13

			local createElement3 = Roact.createElement
			local v16 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = serialNumber and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Center,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				BackgroundTransparency = 1
			}

			local v17 = {
				UserThumbnail = Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, 48, 0, 48),
					BackgroundTransparency = 1,
					Image = rbxthumbWithTypeSizeAndOptions or AVATAR_PLACEHOLDER_IMAGE,
					LayoutOrder = 1
				}, {
					MaskFrame = Roact.createElement(imageSetLabel, {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxasset://textures/ui/LuaApp/graphic/profilemask.png",
						ImageColor3 = color
					})
				}),
				SerialAndUsernameFrame = 0
			}

			local createElement4 = Roact.createElement
			local v19 = {
				axis = fitFrameOnAxis.Axis.Both,
				contentPadding = UDim.new(0, 3),
				FillDirection = Enum.FillDirection.Vertical,
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}

			local v20 = {
				Username = Roact.createElement(VerifiedBadges.EmojiWrapper, {
					emoji = not data.props.sellerHasVerifiedBadge and "" or VerifiedBadges.emoji.verified
				}, {
					UsernameLabel = Roact.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font),
						TextColor3 = theme.TextEmphasis.Color,
						TextSize = font.Header2.RelativeSize * font.BaseSize,
						Text = sellerName,
						LayoutOrder = 1
					})
				}),
				SerialNumberLabel = 0
			}

			local v21 = serialNumber

			if v21 then
				local createElement5 = Roact.createElement
				local v23 = {
					axis = fitFrameOnAxis.Axis.Both,
					contentPadding = UDim.new(0, 1),
					margin = roactFitComponents.Rect.square(4),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					ImageSet = component_assetscircle_17,
					BackgroundTransparency = 1,
					ImageColor3 = theme.UIDefault.Color,
					ImageTransparency = theme.UIDefault.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = rect,
					LayoutOrder = 2
				}

				local v24 = {
					LimitedIcon = Roact.createElement(imageSetLabel, {
						Size = UDim2.new(0, v7, 0, v7),
						BackgroundTransparency = 1,
						Image = iconsstatusitemlimited,
						ImageColor3 = theme.TextEmphasis.Color,
						LayoutOrder = 1
					}),
					SerialNumberText = 0
				}

				local createElement6 = Roact.createElement
				local v26 = {
					width = fitTextLabel.Width.FitToText,
					Size = UDim2.new(0, 0, 0, v7),
					BackgroundTransparency = 1,
					Font = 0,
					TextColor3 = 0,
					TextSize = 0,
					Text = 0,
					LayoutOrder = 2
				}

				local v27 = if fFlagFontFaceAX then normalizeFontFace(data2.Tokens.Typography.CaptionSmall.Font) else footer.Font
				v26.Font = v27

				v26.TextColor3 = theme.TextEmphasis.Color
				v26.TextSize = v7
				v26.Text = "#" .. serialNumber
				v24.SerialNumberText = createElement6(fitTextLabel, v26)
				v21 = createElement5(fitFrameOnAxis, v23, v24)
			end

			v20.SerialNumberLabel = v21
			v17.SerialAndUsernameFrame = createElement4(fitFrameOnAxis, v19, v20)
			local children = {
				ProfileButton = createElement2(fitFrameVertical, v12, {
					UserAndStatsFrame = createElement3(fitFrameVertical, v16, v17)
				}),
				BuyButton = 0
			}

			local createElement5 = Roact.createElement
			local openPurchasePromptsByActivated = {
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundTransparency = 1,
				Image = component_assetscircle_17,
				ImageColor3 = theme.ContextualPrimaryDefault.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				LayoutOrder = 2,
				SelectionImageObject = callback(cursorKind.RoundedRectNoInset),
				[Roact.Event.Activated] = data.openPurchasePrompt
			}

			local createElement6 = Roact.createElement
			local v25 = {
				axis = fitFrameOnAxis.Axis.Both,
				contentPadding = UDim.new(0, 4),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1
			}

			local v26 = {
				RobuxIcon = Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, 25, 0, 25),
					BackgroundTransparency = 1,
					Image = iconscommonrobux,
					ImageColor3 = theme.ContextualPrimaryContent.Color,
					ImageTransparency = theme.ContextualPrimaryContent.Transparency,
					LayoutOrder = 1
				}),
				Price = 0
			}

			local createElement7 = Roact.createElement
			local v28 = {
				width = fitTextLabel.Width.FitToText,
				BackgroundTransparency = 1,
				Font = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextSize = 0,
				Text = 0,
				LayoutOrder = 2
			}

			local v29 = if fFlagFontFaceAX then normalizeFontFace(data2.Tokens.Typography.TitleLarge.Font) else font.Header2.Font
			v28.Font = v29

			v28.TextColor3 = theme.ContextualPrimaryContent.Color
			v28.TextTransparency = theme.ContextualPrimaryContent.Transparency
			v28.TextSize = font.Header2.RelativeSize * font.BaseSize
			v28.Text = localize
			v26.Price = createElement7(fitTextLabel, v28)
			children.BuyButton = createElement5(imageSetButton, openPurchasePromptsByActivated, {
				PriceFrame = createElement6(fitFrameOnAxis, v25, v26)
			})
			return createElement(fitFrameVertical, v10, children)
		end)
	end)
end

local function mapStateToProps(data, p2)
	local user = data.Users[p2.sellerId]
	local localUserId = data.LocalUserId

	return {
		userRobux = data.UserRobux[localUserId],
		userName = user and user.name
	}
end

local v7 = RoactRodux.connect(mapStateToProps, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module5(p2))
			end
		end
	}
end or nil)(extended)

local v8 = withNavigation((roactServices.connect({ localization = module })(v7)))

if defineFastFlag then
	return function(p2)
		local v9 = useAppPolicy(function(p3)
			return p3.getWebViewSupport()
		end)

		local clone = table.clone(p2)

		if fFlagAXFixResellersList then
			clone.isWebViewSupported = v9
		else
			p2.isWebViewSupported = v9
		end

		return React.createElement(v8, clone)
	end
end

return v8
