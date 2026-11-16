local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local TextKeys = require(FriendsLanding.Common.TextKeys)

local iconButton = uiBlox.App.Button.IconButton
local images = uiBlox.App.ImageSet.Images
local badge = uiBlox.App.Indicator.Badge
local tooltip = uiBlox.App.Dialog.Tooltip

local dash = dependencies.Dash
local useState = react.useState
local useLocalization = dependencies.Hooks.useLocalization
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local v = { layoutOrder = 0, friendRequestCount = 0, onActivated = dash.noop, showTooltip = false }

return function(p)
	local joined = dash.join(v, p)

	local state, setState = useState(240)
	local function fn(instance)
		if instance and instance:FindFirstChild("CallToActionTooltip", true) then
			setState(getDeepValue(instance, "CallToActionTooltip.TooltipContainer.AbsoluteSize.X") or 240)
		end
	end
	local v2 = useLocalization({ tooltipMessage = TextKeys.NO_FRIENDS_TOOLTIP })

	return react.createElement(iconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = images["icons/actions/friends/friendAdd"],
		position = joined.position,
		anchorPoint = Vector2.new(1, 0.5),
		layoutOrder = joined.layoutOrder,
		onActivated = joined.onActivated
	}, {
		ImagesContainer = react.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				[react.Change.AbsoluteSize] = fn
			},
			{
				FriendRequestsBadge = joined.friendRequestCount > 0 and react.createElement(badge, {
					position = UDim2.new(0.5, 0, 0.5, 0),
					anchorPoint = Vector2.new(0, 1),
					value = joined.friendRequestCount
				}),
				CallToActionTooltip = joined.showTooltip and react.createElement(tooltip, {
					position = UDim2.new(0, 42.5 - state, 0, 36),
					triggerPosition = Vector2.new(0, 0),
					triggerSize = Vector2.new(36, 0),
					bodyText = v2.tooltipMessage,
					forceClickTriggerPoint = true,
					isDirectChild = true
				})
			}
		)
	})
end
