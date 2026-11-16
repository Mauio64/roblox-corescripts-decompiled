local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local Constants = require(Foundation.Constants)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local mapBindable = require(Foundation.Utility.mapBindable)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { transparency = 0, Size = UDim2.fromScale(2, 2), testId = "--foundation-backdrop" }

local function Backdrop(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	return React.createElement(View, withCommonProps(v2, {
		Size = v2.Size,
		backgroundStyle = mapBindable(v2.transparency, function(p2: number)
			return {
				Color3 = v3.Color.Common.Backdrop.Color3,
				Transparency = math.lerp(v3.Color.Common.Backdrop.Transparency, 1, p2)
			}
		end),
		onActivated = v2.onActivated or Dash.noop,
		selection = Constants.MODAL.DISABLE_SELECTION,
		stateLayer = { affordance = StateLayerAffordance.None },
		tag = {
			["position-center-center"] = v2.Position == nil,
			["anchor-center-center"] = v2.AnchorPoint == nil
		},
		ref = ref
	}))
end

return React.memo(React.forwardRef(Backdrop))
