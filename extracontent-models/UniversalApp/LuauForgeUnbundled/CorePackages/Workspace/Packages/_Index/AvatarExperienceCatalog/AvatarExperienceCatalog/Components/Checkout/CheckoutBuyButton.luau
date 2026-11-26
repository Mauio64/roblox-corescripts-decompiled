local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/ReactOtter")
local fFlagAXMISWithBlackbird = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagAXMISWithBlackbird
local v5 = game:DefineFastInt("AXBuyDelayMilliseconds", 1000) / 1000

local function CheckoutBuyButton(props)
	local v6 = Foundation.Hooks.useTokens()

	local state, setState = React.useState(false)
	local v7 = React.useCallback(function()
		setState(true)
	end, { state })
	local v8, v9 = ReactOtter.useAnimatedBinding(1, v7)

	React.useEffect(function()
		if not state then
			v9(ReactOtter.ease(0, { duration = v5, easingStyle = Enum.EasingStyle.Linear }))
		end
	end, { state })

	local createElement = React.createElement
	local view = Foundation.View

	local v11 = if fFlagAXMISWithBlackbird then props.LayoutOrder else nil
	return createElement(view, { tag = "size-full-0 auto-y fill", LayoutOrder = v11 }, {
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
			backgroundStyle = {
				Color3 = v6.Color.Surface.Surface_0.Color3,
				Transparency = 0.5
			},
			Position = UDim2.fromScale(1, 0),
			Size = v8:map(function(p2)
				return UDim2.fromScale(-p2, 1)
			end)
		})
	})
end

return React.memo(CheckoutBuyButton, tutils.deepEqual)
