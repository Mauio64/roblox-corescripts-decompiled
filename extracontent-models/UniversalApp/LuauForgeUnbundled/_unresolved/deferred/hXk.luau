local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local t = require(CorePackages.Packages.t)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local UIBlox = require(CorePackages.Packages.UIBlox)
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module2 = require("@luauforge/deferred/fGi")
local module3 = require("@luauforge/bundled/ehB")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module5 = require("@luauforge/bundled/dFu")
local module6 = require("@luauforge/deferred/hXl")
local module7 = require("@luauforge/bundled/fBF")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType

local ageRecommendationDetails = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationDetails
local module8 = require("@luauforge/deferred/hXm")

local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum

local getFFlagUseExternalBrowserForAgeGuidelines10ft = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseExternalBrowserForAgeGuidelines10ft

local extended = Roact.PureComponent:extend("ExperienceGuidelinesExplainedModal")

extended.validateProps = t.strictInterface({
	ageRecommendations = t.optional(ageRecommendationDetails.validateModel),
	ageRecommendationHeader = t.optional(t.string),
	hideCloseButton = t.optional(t.boolean),
	universeId = t.string,
	localization = t.table,
	navigateDown = t.callback,
	navigateBack = t.callback,
	closeModal = t.optional(t.callback),
	screenSize = t.Vector2,
	webViewSupport = t.boolean,
	linking = t.table,
	useExternalBrowserForAgeGuidelines = t.optional(t.boolean)
})

function extended:init()
	local fStringExperienceGuidelinesExplainedPageUrl = module8.FStringExperienceGuidelinesExplainedPageUrl

	function self.onLearnMoreActivated()
		if self.props.useExternalBrowserForAgeGuidelines then
			module2(self.props.linking, fStringExperienceGuidelinesExplainedPageUrl)
			return
		end

		local localization = self.props.localization
		local navigateDown = self.props.navigateDown
		local v5 = {
			name = module5.GenericWebPage,
			detail = fStringExperienceGuidelinesExplainedPageUrl,
			extraProps = 0
		}

		local v7 = if self.props.ageRecommendationHeader then self.props.ageRecommendationHeader else localization:Format("Feature.GameDetails.Label.ContentMaturity")
		v5.extraProps = { title = v7, transitionAnimation = module7.SlideInFromRight }
		navigateDown(v5)
	end

	function self.closeModal()
		if self.props.closeModal then
			self.props.closeModal()
		else
			self.props.navigateBack()
		end
	end

	self.focusEventHandlers = {
		[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				if not self.props.hideCloseButton then
					self.closeModal()
					object:cancel()
				end
			end)
		}
	}
end

function extended.render(props)
	local localization = props.props.localization
	local ageRecommendations = props.props.ageRecommendations

	local screenSize = props.props.screenSize

	local createElement = Roact.createElement
	local v7 = if props.props.ageRecommendationHeader then props.props.ageRecommendationHeader else localization:Format("Feature.GameDetails.Label.ContentMaturity")

	local v8 = if not props.props.hideCloseButton then props.closeModal else nil
	local element = createElement(partialPageModal, {
		title = v7,
		screenSize = screenSize,
		onCloseClicked = v8,
		buttonStackProps = props.props.webViewSupport and {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttonHeight = 48,
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = props.onLearnMoreActivated,
						text = localization:Format("Feature.GameDetails.Label.LearnMore")
					}
				}
			}
		} or nil
	}, {
		ViewFrame = Roact.createElement(
			"Frame",
			{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
			{
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				}),
				DescriptorList = ageRecommendations and Roact.createElement(module6, {
					ageRecommendations = ageRecommendations
				})
			}
		)
	})

	return Roact.createElement("ImageButton", {
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = props.props.hideCloseButton
	}, { Content = element })
end

local v5 = RoactRodux.connect(function(data, p2)
	return {
		screenSize = data.ScreenSize,
		ageRecommendations = data.AgeRecommendations[p2.universeId],
		ageRecommendationHeader = data.AgeRecommendationHeaders.headerDisplayName
	}
end, function(callback)
	return {
		navigateDown = function(p2)
			return callback(module3(p2))
		end,
		navigateBack = function()
			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended)

local v6 = roactServices.connect({ localization = module, linking = appLinking })(v5)

return (roactAppPolicy.connect(function(p2)
	local webViewSupport = p2.getWebViewSupport()
	local v7 = if getFFlagUseExternalBrowserForAgeGuidelines10ft() then p2.getUseExternalBrowserForAgeGuidelines() else nil

	return { webViewSupport = webViewSupport, useExternalBrowserForAgeGuidelines = v7 }
end)(v6))
