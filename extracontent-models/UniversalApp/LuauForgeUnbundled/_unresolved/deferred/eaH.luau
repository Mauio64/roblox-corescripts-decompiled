local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/dZm")

local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local module4 = require("@luauforge/deferred/eaj")

local icon = module4.Icon
local view = module4.View

local module5 = require("@luauforge/deferred/eam")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useTokens = module4.Hooks.useTokens

local module7 = require("@luauforge/deferred/eaI")

local udim = UDim2.fromOffset(1, 1)

return function(props)
	local v5 = useAnalytics()
	local v6 = useDispatch()
	local v7 = useTokens()

	local v8 = React.useContext(CapturesContext)

	return React.createElement(view, {
		isDisabled = v8.isZooming,
		LayoutOrder = props.layoutOrder,
		onActivated = function()
			v5.fireEvent(module5.ContentFeedInspectCtaPressed, { postId = props.postId })

			v6(module7(props.avatarItemIds))
		end,
		tag = "radius-medium auto-xy padding-small bg-action-subtle"
	}, {
		InspectIcon = React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = "icons/menu/shopOn",
			Position = UDim2.fromScale(0.5, 0.5),
			style = v7.Color.ActionEmphasis.Foreground,
			ZIndex = 2
		}),
		InspectIconShadow = React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = "icons/menu/shopOn",
			Position = UDim2.fromScale(0.5, 0.5) + udim,
			style = v7.Color.Common.Shadow,
			ZIndex = 1
		})
	})
end
