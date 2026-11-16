local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local tutils = require(parent.tutils)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)
local SharedFlags = require(parent.SharedFlags)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local duration = game:DefineFastInt("AXBuyDelayMilliseconds", 1000) / 1000

local function CheckoutBuyButton(props)
	local v = Foundation.Hooks.useTokens()

	local state, setState = React.useState(false)
	local v2 = React.useCallback(function()
		setState(true)
	end, { state })
	local v3, v4 = ReactOtter.useAnimatedBinding(1, v2)

	React.useEffect(function()
		if not state then
			v4(ReactOtter.ease(0, { duration = duration, easingStyle = Enum.EasingStyle.Linear }))
		end
	end, { state })

	local createElement = React.createElement
	local view = Foundation.View
	local layoutOrder

	if FFlagAXMISWithBlackbird then
		layoutOrder = props.LayoutOrder
	end

	return createElement(view, { tag = "size-full-0 auto-y fill", LayoutOrder = layoutOrder }, {
		BuyButton = React.createElement(Foundation.Button, {
			text = props.label,
			onActivated = props.onCheckoutButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isDisabled = not state or props.isPurchasing,
			isLoading = props.isPurchasing,
			testId = "CheckoutBuyButton_BuyButton"
		}),
		CooldownBar = React.createElement(Foundation.View, {
			isDisabled = true,
			backgroundStyle = { Color3 = v.Color.Surface.Surface_0.Color3, Transparency = 0.5 },
			Position = UDim2.fromScale(1, 0),
			Size = v3:map(function(p)
				return UDim2.fromScale(-p, 1)
			end)
		})
	})
end

return React.memo(CheckoutBuyButton, tutils.deepEqual)
