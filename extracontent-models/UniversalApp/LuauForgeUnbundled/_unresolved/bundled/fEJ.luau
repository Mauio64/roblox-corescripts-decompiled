local TweenService = game:GetService("TweenService")

local module = require("@luauforge/bundled/fEA")
local withLocalization = require("@luauforge/bundled/fEG").withLocalization
local module2 = require("@luauforge/bundled/fEK")
local module3 = require("@luauforge/bundled/fEM")
local module4 = require("@luauforge/bundled/fEL")
local text = module4.Text
local view = module4.View
local module5 = require("@luauforge/bundled/fEI")
local authPageload = module5.Events.authPageload
local eventStreamConstants = module5.EventStreamConstants

return function(p2)
	local ref = module.useRef(nil)
	authPageload(eventStreamConstants.Context.PasskeyUpsellSuccessScreen)

	local function createContent(p3)
		local element = module.createElement(module2, {
			localizedTitleText = p3.titleText,
			onCancelButtonPressed = function()
				p2.onCancelButtonPressed(
					eventStreamConstants.Context.PasskeyUpsellSuccessScreen,
					eventStreamConstants.Button.DismissCornerX
				)
			end,
			shouldRenderGraphic = p2.shouldRenderGraphic
		})

		local v5 = {
			ref = ref,
			Text = p3.successDescription,
			tag = "text-body-large text-align-x-left auto-xy text-wrap",
			LayoutOrder = 2
		}

		if not p2.shouldRenderGraphic then
			v5.Position = UDim2.new(0.75, 0, 0, 0)
			v5.Size = UDim2.new(1, 0, 1, 0)
		end

		local element2 = module.createElement(text, v5)

		if p2.shouldRenderGraphic then
			return module.createElement(view, { tag = "auto-xy col" }, {
				PasskeyUpsellHeaderContainer = element,
				BodyText = element2
			})
		end

		return module.createElement(module.Fragment, {}, {
			PasskeyUpsellHeaderContainer = element,
			BodyText = element2
		})
	end

	local function animateSlideIn(current)
		if not current then
			return
		end

		local udim = UDim2.new(0, 0, 0, 0)

		TweenService:Create(current, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = udim
		}):Play()
	end

	module.useEffect(function()
		if ref.current then
			animateSlideIn(ref.current)
		end
	end, {})

	return withLocalization({
		titleText = "Authentication.Passkey.Label.UpsellToastPageTitle",
		successDescription = "Authentication.Passkey.Description.UpsellRegistrationSuccess",
		continueText = "Authentication.Passkey.Action.Continue"
	})(function(p3)
		return module.createElement(module.Fragment, {}, {
			ContentContainer = createContent(p3),
			PasskeyUpsellButtonContainer = module.createElement(module3, {
				localizedContinueText = p3.continueText,
				onContinueButtonPressed = function()
					p2.onCancelButtonPressed(
						eventStreamConstants.Context.PasskeyUpsellSuccessScreen,
						eventStreamConstants.Button.Continue
					)
				end,
				layoutOrder = 3
			})
		})
	end)
end
