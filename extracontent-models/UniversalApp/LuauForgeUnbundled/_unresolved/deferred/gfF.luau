local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/deferred/gfG")
local module3 = require("@luauforge/deferred/gfc")

local module4 = require("@luauforge/deferred/gfJ")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module5 = require("@luauforge/bundled/dTM")
local module6 = require("@luauforge/deferred/fvp")
local getTTIEventName = module6.getTTIEventName

local timeToInteractiveTracker = require("@luauforge/bundled/fvo").TimeToInteractiveTracker
local productPurchaseSurface = module6.Enums.ProductPurchaseSurface
local module7 = require("@luauforge/bundled/ftl")

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal

local fIntTTIUnifiedPurchaseSamplingRate = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntTTIUnifiedPurchaseSamplingRate

local tenFootInterface = isTenFootInterface()

local extended = Roact.PureComponent:extend("InsufficientRobuxPrompt")

function extended:init()
	function self.closePrompt()
		module5.closeOverlay(self.props.navigation)
	end

	function self.buyRobux()
		self.closePrompt()

		if tenFootInterface then
			self.props.openXboxUpsell(self.props.networking)
		else
			self.props.openPurchaseRobuxPage(nil, self.props.networking)
		end
	end
end

function extended.didMount(p2)
	if fFlagAddPerformanceMetricsToUnifiedPurchaseModal then
		local ttiEventName = getTTIEventName(productPurchaseSurface.Catalog)
		timeToInteractiveTracker.trackEnd(ttiEventName, {
			samplingRateOverride = fIntTTIUnifiedPurchaseSamplingRate
		})
	end
end

function extended:renderMiddle(p3)
	local userRobux = self.props.userRobux

	return withStyle(function(p4)
		local font = p4.Font
		local theme = p4.Theme
		local v5 = font.BaseSize * font.Body.RelativeSize

		return Roact.createElement(fitFrameVertical, {
			BackgroundTransparency = 1,
			margin = roactFitComponents.Rect.quad(10, 0, 10, 0),
			contentPadding = UDim.new(0, 30),
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}, {
			CurrentBalanceLabel = Roact.createElement(fitTextLabel, {
				width = fitTextLabel.Width.FitToText,
				BackgroundTransparency = 1,
				Font = font.Body.Font,
				Text = p3.currentBalanceLabel,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.Transparency,
				TextSize = v5,
				LayoutOrder = 0
			}),
			RobuxContainer = Roact.createElement(module4, {
				robuxAmountText = tostring(userRobux),
				iconSize = v5,
				textSize = v5,
				padding = 10
			})
		})
	end)
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.titleText,
		bodyText = props2.messageText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = self.closePrompt,
						text = props2.cancelButtonText
					},
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = self.buyRobux,
						text = props2.confirmButtonText
					}
				}
			}
		},
		middleContent = function()
			return self:renderMiddle(props2)
		end,
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		titleText = "Feature.Catalog.Heading.InsufficientFunds",
		currentBalanceLabel = "Feature.Catalog.Label.CurrentBalance",
		messageText = "Feature.Catalog.Label.InsufficientFunds",
		confirmButtonText = "Feature.GameDetails.Action.BuyRobux",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	local localUserId = data.LocalUserId
	return { userRobux = data.UserRobux[localUserId], screenSize = data.ScreenSize }
end, function(callback, p2)
	return {
		openPurchaseRobuxPage = function()
			return callback(module7(nil, p2))
		end,
		openXboxUpsell = function(p3)
			callback(module2(p3))
		end
	}
end)(extended)

return (module3((roactServices.connect({ networking = module })(v5))))
