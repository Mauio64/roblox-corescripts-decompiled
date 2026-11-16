local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent

require(parent.Chrome)
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local StatusIndicator = Foundation.StatusIndicator
local View = Foundation.View

local useNotificationCount = require(InExperienceSideSheet.Hooks.useNotificationCount)

local function IconHost(props)
	local v = useTokens()

	local v2, v3 = useNotificationCount(props.notification)

	local createElement = React.createElement
	local v4 = {
		tag = {
			["size-1000"] = true,
			["position-center-center anchor-center-center"] = props.centerPosition
		}
	}

	local v5 = {
		IconContainer = React.createElement(View, {
			tag = "size-full align-x-center align-y-center",
			ZIndex = 1
		}, {
			Icon = React.createElement(props.icon)
		}),
		NotificationBadge = 0
	}
	local notificationBadge

	if v2 then
		notificationBadge = React.createElement(StatusIndicator, {
			value = v3,
			variant = StatusIndicatorVariant.Emphasis,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, v.Gap.XXLarge, 0, v.Gap.Small),
			ZIndex = 2
		})
	end

	v5.NotificationBadge = notificationBadge
	return createElement(View, v4, v5)
end

return IconHost
