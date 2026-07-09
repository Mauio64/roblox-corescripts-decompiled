local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local PerformXboxUpsell = require(Modules.AvatarExperience.Catalog.Thunks.PerformXboxUpsell)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local RobuxAmountDisplay = require(Modules.AvatarExperience.Common.Components.ItemDetails.RobuxAmountDisplay)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FIntTTIUnifiedPurchaseSamplingRate = require(CorePackages.Workspace.Packages.SharedFlags).FIntTTIUnifiedPurchaseSamplingRate
local v27 = GuiService:IsTenFootInterface()
local v28 = Roact.PureComponent:extend("InsufficientRobuxPrompt")

function v28.init(p1) -- line: 47
	-- upvalues: NavigationUtils (copy), v27 (copy)
	function p1.closePrompt() -- line: 48
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
	function p1.buyRobux() -- line: 52
		-- upvalues: p1 (copy), v27 (copy)
		p1.closePrompt()

		if v27 then
			p1.props.openXboxUpsell(p1.props.networking)

			return
		end

		p1.props.openPurchaseRobuxPage(nil, p1.props.networking)
	end
end
function v28.didMount(_) -- line: 62
	-- upvalues: FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), FIntTTIUnifiedPurchaseSamplingRate (copy)
	if FFlagAddPerformanceMetricsToUnifiedPurchaseModal then
		local v32 = getTTIEventName(ProductPurchaseSurface.Catalog)

		TimeToInteractiveTracker.trackEnd(v32, {
			samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
		})
	end
end
function v28.renderMiddle(p3, p4) -- line: 71
	-- upvalues: withStyle (copy), Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), RobuxAmountDisplay (copy)
	local userRobux = p3.props.userRobux

	return withStyle(function(p5) -- line: 74
		-- upvalues: Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), p4 (copy), RobuxAmountDisplay (copy), userRobux (copy)
		local p5Font = p5.Font
		local Theme = p5.Theme
		local v47 = p5Font.BaseSize * p5Font.Body.RelativeSize

		return Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			margin = RoactFitComponents.Rect.quad(10, 0, 10, 0),
			contentPadding = UDim.new(0, 30),
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}, {
			CurrentBalanceLabel = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				width = FitTextLabel.Width.FitToText,
				Font = p5Font.Body.Font,
				Text = p4.currentBalanceLabel,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextSize = v47
			}),
			RobuxContainer = Roact.createElement(RobuxAmountDisplay, {
				padding = 10,
				robuxAmountText = tostring(userRobux),
				iconSize = v47,
				textSize = v47
			})
		})
	end)
end
function v28.renderAlertLocalized(p6, p7) -- line: 110
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p7.titleText,
		bodyText = p7.messageText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p6.closePrompt,
						text = p7.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p6.buyRobux,
						text = p7.confirmButtonText
					}
				}
			}
		},
		middleContent = function() -- line: 132
			-- upvalues: p6 (copy), p7 (copy)
			return p6:renderMiddle(p7)
		end,
		screenSize = p6.props.screenSize,
		defaultChildRef = p6.props.defaultChildRef
	})
end
function v28.render(p8) -- line: 140
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Catalog.Heading.InsufficientFunds",
		currentBalanceLabel = "Feature.Catalog.Label.CurrentBalance",
		messageText = "Feature.Catalog.Label.InsufficientFunds",
		confirmButtonText = "Feature.GameDetails.Action.BuyRobux",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p9) -- line: 147
		-- upvalues: p8 (copy)
		return p8:renderAlertLocalized(p9)
	end)
end

local v29 = RoactRodux.connect(function(p10, _) -- line: 152
	local LocalUserId = p10.LocalUserId

	return {
		userRobux = p10.UserRobux[LocalUserId],
		screenSize = p10.ScreenSize
	}
end, function(p12, p13) -- line: 158
	-- upvalues: OpenPurchaseRobuxPage (copy), PerformXboxUpsell (copy)
	return {
		openPurchaseRobuxPage = function() -- line: 160
			-- upvalues: p12 (copy), OpenPurchaseRobuxPage (copy), p13 (copy)
			return p12(OpenPurchaseRobuxPage(nil, p13))
		end,
		openXboxUpsell = function(p14) -- line: 163
			-- upvalues: p12 (copy), PerformXboxUpsell (copy)
			p12(PerformXboxUpsell(p14))
		end
	}
end)(v28)

return (withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking
})(v29))))
