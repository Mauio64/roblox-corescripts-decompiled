local TweenService = game:GetService("TweenService")
local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local React = require(Parent.React)
local withLocalization = require(Parent.Localization).withLocalization
local PasskeyUpsellHeaderContainer = require(script.Parent.PasskeyUpsellHeaderContainer)
local PasskeyUpsellButtonContainer = require(script.Parent.PasskeyUpsellButtonContainer)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local AuthAnalytics = require(Parent.AuthAnalytics)
local authPageload = AuthAnalytics.Events.authPageload
local EventStreamConstants = AuthAnalytics.EventStreamConstants

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), authPageload (copy), EventStreamConstants (copy), PasskeyUpsellHeaderContainer (copy), FoundationText (copy), View (copy), TweenService (copy), withLocalization (copy), PasskeyUpsellButtonContainer (copy)
	local v14 = React.useRef(nil)

	authPageload(EventStreamConstants.Context.PasskeyUpsellSuccessScreen)

	local function createContent(p1) -- line: 35
		-- upvalues: React (copy), PasskeyUpsellHeaderContainer (copy), t1 (copy), EventStreamConstants (copy), v14 (copy), FoundationText (copy), View (copy)
		local v18 = React.createElement(PasskeyUpsellHeaderContainer, {
			localizedTitleText = p1.titleText,
			onCancelButtonPressed = function() -- line: 38
				-- upvalues: t1 (copy), EventStreamConstants (copy)
				t1.onCancelButtonPressed(EventStreamConstants.Context.PasskeyUpsellSuccessScreen, EventStreamConstants.Button.DismissCornerX)
			end,
			shouldRenderGraphic = t1.shouldRenderGraphic
		})
		local t2 = {
			tag = "text-body-large text-align-x-left auto-xy text-wrap",
			LayoutOrder = 2,
			ref = v14,
			Text = p1.successDescription
		}

		if not t1.shouldRenderGraphic then
			t2.Position = UDim2.new(0.75, 0, 0, 0)
			t2.Size = UDim2.new(1, 0, 1, 0)
		end

		local v20 = React.createElement(FoundationText, t2)

		if t1.shouldRenderGraphic then
			return React.createElement(View, {
				tag = "auto-xy col"
			}, {
				PasskeyUpsellHeaderContainer = v18,
				BodyText = v20
			})
		end

		return React.createElement(React.Fragment, {}, {
			PasskeyUpsellHeaderContainer = v18,
			BodyText = v20
		})
	end
	local function animateSlideIn(p2) -- line: 77
		-- upvalues: TweenService (copy)
		if not p2 then
			return
		end

		local uDim2 = UDim2.new(0, 0, 0, 0)
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

		TweenService:Create(p2, tweenInfo, {
			Position = uDim2
		}):Play()
	end

	React.useEffect(function() -- line: 96
		-- upvalues: v14 (copy), animateSlideIn (copy)
		if v14.current then
			animateSlideIn(v14.current)
		end
	end, {})

	return withLocalization({
		titleText = "Authentication.Passkey.Label.UpsellToastPageTitle",
		successDescription = "Authentication.Passkey.Description.UpsellRegistrationSuccess",
		continueText = "Authentication.Passkey.Action.Continue"
	})(function(p3) -- line: 106
		-- upvalues: React (copy), createContent (copy), PasskeyUpsellButtonContainer (copy), t1 (copy), EventStreamConstants (copy)
		return React.createElement(React.Fragment, {}, {
			ContentContainer = createContent(p3),
			PasskeyUpsellButtonContainer = React.createElement(PasskeyUpsellButtonContainer, {
				layoutOrder = 3,
				localizedContinueText = p3.continueText,
				onContinueButtonPressed = function() -- line: 111
					-- upvalues: t1 (copy), EventStreamConstants (copy)
					t1.onCancelButtonPressed(EventStreamConstants.Context.PasskeyUpsellSuccessScreen, EventStreamConstants.Button.Continue)
				end
			})
		})
	end)
end
