local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hcT")

local fFlagAXBackgroundGenerationAnalytics = require("@luauforge/deferred/hcQ").FFlagAXBackgroundGenerationAnalytics

local useTokens = module2.Hooks.useTokens

local function PlusCreateTile(props)
	local v5 = useTokens()
	local isDisabled = props.isDisabled == true

	local createElement = module.createElement
	local view = module2.View
	local v6 = {
		tag = "col align-x-center align-y-center size-full radius-medium clip",
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = props.onActivated,
		backgroundStyle = 0,
		LayoutOrder = 0,
		testId = "PlusCreateTile",
		ref = 0
	}
	local v7 = if isDisabled then v5.Color.Shift.Shift_200 else v5.Color.Common.Shimmer
	v6.backgroundStyle = v7
	v6.LayoutOrder = props.LayoutOrder

	local v8 = if fFlagAXBackgroundGenerationAnalytics then props.impressionRef else nil
	v6.ref = v8
	return createElement(view, v6, {
		Icon = module.createElement(module2.Icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			name = module2.Enums.IconName.PlusLarge,
			style = v5.Color.Content.Muted,
			size = module2.Enums.IconSize.Large
		})
	})
end

return PlusCreateTile
