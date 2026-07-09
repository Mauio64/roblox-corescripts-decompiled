local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local tutils = require(Parent.tutils)
local Foundation = require(Parent.Foundation)
local ReactOtter = require(Parent.ReactOtter)
local FFlagAXMISWithBlackbird = require(Parent.SharedFlags).FFlagAXMISWithBlackbird
local v7 = game:DefineFastInt("AXBuyDelayMilliseconds", 1000) / 1000

local function CheckoutBuyButton(t1: {[any]: any}) -- line: 22
	-- upvalues: Foundation (copy), React (copy), ReactOtter (copy), v7 (copy), FFlagAXMISWithBlackbird (copy)
	local v10 = Foundation.Hooks.useTokens()
	local v11, v12 = React.useState(false)
	local v13 = React.useCallback(function() -- line: 26
		-- upvalues: v12 (copy)
		v12(true)
	end, { v11 })
	local v14, v15 = ReactOtter.useAnimatedBinding(1, v13)

	React.useEffect(function() -- line: 31
		-- upvalues: v11 (copy), v15 (copy), ReactOtter (copy), v7 (copy)
		if not v11 then
			v15(ReactOtter.ease(0, {
				duration = v7,
				easingStyle = Enum.EasingStyle.Linear
			}))
		end
	end, { v11 })

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y fill",
		LayoutOrder = if not FFlagAXMISWithBlackbird then nil else t1.LayoutOrder
	}, {
		BuyButton = React.createElement(Foundation.Button, {
			testId = "CheckoutBuyButton_BuyButton",
			text = t1.label,
			onActivated = t1.onCheckoutButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isDisabled = not v11 or t1.isPurchasing,
			isLoading = t1.isPurchasing
		}),
		CooldownBar = React.createElement(Foundation.View, {
			isDisabled = true,
			backgroundStyle = {
				Transparency = 0.5,
				Color3 = v10.Color.Surface.Surface_0.Color3
			},
			Position = UDim2.fromScale(1, 0),
			Size = v14:map(function(p1) -- line: 61
				return UDim2.fromScale(-p1, 1)
			end)
		})
	})
end

return React.memo(CheckoutBuyButton, tutils.deepEqual)
