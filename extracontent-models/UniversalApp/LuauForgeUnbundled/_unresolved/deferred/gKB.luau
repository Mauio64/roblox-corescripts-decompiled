local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/egY")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameHorizontal = roactFitComponents.FitFrameHorizontal
local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel

local module3 = require("@luauforge/deferred/gKC")
local module4 = require("@luauforge/deferred/gKD")

local module5 = require("@luauforge/deferred/gJH")
local module6 = require("@luauforge/bundled/dXh")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module7 = require("@luauforge/deferred/gJI")
local module8 = require("@luauforge/bundled/dVl")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData

local module9 = require("@luauforge/bundled/fCe")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module10 = require("@luauforge/bundled/dPU")

local AlertViewTextbox = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewTextbox")

local module12 = require("@luauforge/deferred/gKp")

local UIBlox = require(CorePackages.Packages.UIBlox)
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus

local iconscommonrobux = images["icons/common/robux"]

local extended = Roact.PureComponent:extend("SellItemPrompt")

function extended:init()
	self.isMounted = false
	self.state = { isKeyboardRepositioned = false, priceInRobux = 0 }

	function self.changeText(p2)
		if not self.isMounted then
			return
		end

		local priceInRobux = self.state.priceInRobux
		local text = p2.Text
		local v5 = priceInRobux == 0 and "" or priceInRobux

		if string.len(text) > 10 then
			p2.Text = v5
		elseif priceInRobux ~= 0 and (text == nil or text == "") then
			self:setState({ priceInRobux = 0 })
		elseif string.match(text, "^[0-9]+$") then
			self:setState({ priceInRobux = text })
		else
			p2.Text = v5
		end
	end

	function self.sellItem()
		local priceInRobux = self.state.priceInRobux

		if not priceInRobux or tonumber(priceInRobux) <= 0 then
			return
		end

		local networking = self.props.networking

		local itemId = self.props.itemId
		local userAssetId = self.props.userAssetId

		local v5 = tonumber(priceInRobux)
		self.props.sellAsset(networking, itemId, userAssetId, v5)
	end

	function self.getMarketplaceFee()
		local networking = self.props.networking
		return self.props.getMarketplaceFee(networking)
	end

	self.keyboardConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
		if not self.isMounted then
			return
		end

		if not self.state.isKeyboardRepositioned and UserInputService.OnScreenKeyboardVisible then
			self:setState({ isKeyboardRepositioned = true })
		end
	end)

	function self.getMiddleContent(p2)
		return function()
			local function fn()
				return withStyle(function(p3)
					return self:renderOnLoaded(p2, p3)
				end)
			end

			return Roact.createElement(loadingStateContainer, {
				dataStatus = retrievalStatus2.fromRawValue(self.props.marketPlaceFeeFetchingState),
				onRetry = self.getMarketplaceFee,
				renderOnLoaded = fn
			})
		end
	end

	function self.closePrompt()
		module6.closeOverlay(self.props.navigation)
	end
end

function extended:didMount()
	self.isMounted = true

	if self.props.marketPlaceFeeFetchingState ~= retrievalStatus.Fetching then
		self.getMarketplaceFee()
	end
end

function extended.willUpdate(p2, p3, p4)
	if module9.isFetchingDoneOrFailed(p2.props.sellFetchingState, p3.sellFetchingState) then
		p2.closePrompt()
	end
end

function extended.renderOnLoaded(props, props2, p2)
	local marketplaceFee = props.props.marketplaceFee
	local averagePrice = props.props.averagePrice
	local localization = props.props.localization
	local priceInRobux = props.state.priceInRobux

	local taxRate = marketplaceFee.taxRate
	local v5 = marketplaceFee.minimumFee

	local v6 = averagePrice and numberLocalization.localize(averagePrice, localization:GetLocale()) or ""

	local v7 = tonumber(priceInRobux)
	local v8, v9

	if v7 and v7 > 0 then
		v8 = false
		local rounded = module8.Round(taxRate * v7)
		v5 = v5 < rounded and rounded or v5
		local v10 = string.format("%.0f", module8.Round(v7 - v5))
		v9 = numberLocalization.localize(v10, localization:GetLocale())
	else
		v5 = 0
		v8 = true
		v9 = 0
	end

	local v10 = props2.robloxFeeText:gsub("({feePercentage})", taxRate * 100)

	local v11 = string.format("%.0f", v5)
	local localize = numberLocalization.localize(v11, localization:GetLocale())

	local font = p2.Font
	local theme = p2.Theme
	local v12 = font.BaseSize * font.Body.RelativeSize
	local v13 = v12 + 2

	return Roact.createElement(
		fitFrameVertical,
		{
			contentPadding = UDim.new(0, 6),
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		},
		{
			PriceTextBox = Roact.createElement(focusable[AlertViewTextbox], {
				LayoutOrder = 1,
				PlaceholderText = props2.placeholderText,
				Image = iconscommonrobux,
				TextInputType = Enum.TextInputType.Number,
				[Roact.Change.Text] = props.changeText
			}),
			WarningText = v8 and Roact.createElement(fitTextLabel, {
				width = UDim.new(1, 0),
				BackgroundTransparency = 1,
				Text = props2.minimumWarningText,
				LayoutOrder = 2,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 20),
				TextColor3 = theme.Alert.Color,
				TextWrapped = true,
				Font = font.Body.Font,
				TextSize = font.Body.RelativeSize * font.BaseSize
			}),
			RobuxFeeContainer = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v13)
				},
				{
					RobloxFeeLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = v10,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextSize = v12,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1,
						Size = UDim2.new(0, 0, 1, 0)
					}),
					RobuxContainer = Roact.createElement(fitFrameHorizontal, {
						height = UDim.new(1, 0),
						contentPadding = UDim.new(0, 6),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Position = UDim2.new(1, 0, 0, 0)
					}, {
						MinusText = Roact.createElement(fitTextLabel, {
							width = fitTextLabel.Width.FitToText,
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = "-",
							Font = font.Body.Font,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextSize = v12
						}),
						Image = Roact.createElement(imageSetLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(0, v12, 0, v12),
							Image = iconscommonrobux,
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(fitTextLabel, {
							width = fitTextLabel.Width.FitToText,
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = localize,
							Font = font.Body.Font,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextSize = v12
						})
					})
				}
			),
			YouEarnContainer = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v13)
				},
				{
					YouEarnLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = props2.sellCutText,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextEmphasis.Transparency,
						TextSize = v12,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1,
						Size = UDim2.new(0, 0, 1, 0)
					}),
					RobuxContainer = Roact.createElement(fitFrameHorizontal, {
						height = UDim.new(1, 0),
						contentPadding = UDim.new(0, 6),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Position = UDim2.new(1, 0, 0, 0)
					}, {
						Image = Roact.createElement(imageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(0, v12, 0, v12),
							Image = iconscommonrobux,
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(fitTextLabel, {
							width = fitTextLabel.Width.FitToText,
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = tostring(v9),
							Font = font.Body.Font,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextEmphasis.Transparency,
							TextSize = v12
						})
					})
				}
			),
			AverageSellPriceContainer = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, v13)
				},
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 12),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					AverageSellPriceLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = props2.averageSellPriceText,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextSize = v12,
						LayoutOrder = 0
					}),
					RobuxContainer = Roact.createElement(module12, {
						robuxAmountText = v6,
						iconSize = v12,
						textSize = v12,
						padding = 6
					})
				}
			)
		}
	)
end

function extended.render(data)
	return withLocalization({
		titleText = "Feature.Catalog.Heading.SellItem",
		robloxFeeText = "Feature.Catalog.Label.RobuxFee",
		sellCutText = "Feature.Catalog.Label.SellCut",
		averageSellPriceText = "Feature.Catalog.Label.AveragePrice",
		placeholderText = "Feature.Catalog.Label.Price",
		minimumWarningText = "Feature.Catalog.Label.MinimumAmount",
		minimumWarningTextWithPrice = "Feature.Catalog.Label.MinimumAmountCustom",
		confirmButtonText = "Feature.Catalog.Action.Sell",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(props)
		local screenSize = data.props.screenSize
		local priceInRobux = tonumber(data.state.priceInRobux)
		local v5 = not priceInRobux or priceInRobux == 0
		local udim = UDim2.new(0.5, 0, 0.5, 0)

		if data.state.isKeyboardRepositioned then
			udim = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
		end

		return Roact.createElement(
			focusable.Frame,
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
			{
				InteractiveAlert = Roact.createElement(interactiveAlert, {
					title = props.titleText,
					buttonStackInfo = {
						buttons = {
							{
								props = {
									onActivated = data.closePrompt,
									text = props.cancelButtonText
								},
								isDefaultChild = true
							},
							{
								buttonType = buttonType.PrimarySystem,
								props = {
									isDisabled = v5,
									isLoading = data.props.sellFetchingState == retrievalStatus.Fetching or data.props.marketPlaceFeeFetchingState == retrievalStatus.Fetching,
									onActivated = data.sellItem,
									text = props.confirmButtonText
								}
							}
						}
					},
					middleContent = data.getMiddleContent(props),
					isMiddleContentFocusable = true,
					position = udim,
					screenSize = data.props.screenSize,
					defaultChildRef = data.props.defaultChildRef
				})
			}
		)
	end)
end

function extended:willUnmount()
	self.keyboardConnection:disconnect()
	self.keyboardConnection = nil
	self.isMounted = false
end

local v5 = RoactRodux.connect(function(p2, data)
	local itemId = data.itemId
	local itemType = data.itemType
	local userAssetId = data.userAssetId
	local v6 = itemData(p2.AvatarExperience.Common, itemId, itemType)
	local averagePrice = v6 and v6.averagePrice
	local collectibleItemId = v6 and v6.collectibleItemId
	local priceFloor = p2.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters
		and p2.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters[collectibleItemId]
		and p2.AvatarExperience.Catalog.CollectibleMarketplaceResaleParameters[collectibleItemId].priceFloor
		or 0

	return {
		screenSize = p2.ScreenSize,
		averagePrice = averagePrice,
		sellFetchingState = performFetch.GetStatus(
			p2,
			module10.RemoveAvailableToSellAssetKey .. tostring(userAssetId)
		),
		marketPlaceFeeFetchingState = performFetch.GetStatus(p2, module10.GetMarketplaceFeeKey),
		marketplaceFee = p2.AvatarExperience.Catalog.MarketplaceFee,
		collectibleItemId = collectibleItemId,
		priceFloor = priceFloor
	}
end, function(callback)
	return {
		getMarketplaceFee = function(p2)
			return callback(module4(p2))
		end,
		sellAsset = function(p2, p3, p4, p5)
			return callback(module3(p2, p3, p4, p5))
		end
	}
end)(extended)

return (module5((module7((roactServices.connect({
	networking = module,
	localization = module2
})(v5))))))
