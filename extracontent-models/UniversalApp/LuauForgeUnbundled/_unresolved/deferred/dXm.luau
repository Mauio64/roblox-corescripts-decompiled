local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/dVP")

local module3 = require("@luauforge/deferred/dWM")

local icon = module3.Icon
local view = module3.View

local module4 = require("@luauforge/deferred/dWP")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local module6 = require("@luauforge/deferred/dXn")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useTokens = module3.Hooks.useTokens

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
			v5.fireEvent(module4.ContentFeedShareCtaPressed, { postId = props.postId })

			v6(module6(props.creatorUserId, props.postId))
		end,
		tag = "radius-medium auto-xy padding-small bg-action-subtle"
	}, {
		ShareIcon = React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = "icons/actions/shareArrowOn",
			Position = UDim2.fromScale(0.5, 0.5),
			style = v7.Color.ActionEmphasis.Foreground,
			ZIndex = 2
		}),
		ShareIconShadow = React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = "icons/actions/shareArrowOn",
			Position = UDim2.fromScale(0.5, 0.5) + udim,
			style = v7.Color.Common.Shadow,
			ZIndex = 1
		})
	})
end
