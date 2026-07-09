local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local FFlagConnectionsToFriendsRename = require(FriendsLandingParent.SharedFlags).FFlagConnectionsToFriendsRename
local dependencies = require(FriendsLanding.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local TextKeys = require(FriendsLanding.Common.TextKeys)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local Badge = UIBlox.App.Indicator.Badge
local Tooltip = UIBlox.App.Dialog.Tooltip
local Dash = dependencies.Dash
local useState = React.useState
local useLocalization = dependencies.Hooks.useLocalization
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local t1 = {
	layoutOrder = 0,
	friendRequestCount = 0,
	showTooltip = false,
	onActivated = Dash.noop
}

return function(t2: {[any]: any}) -- line: 36
	-- upvalues: Dash (copy), t1 (copy), useState (copy), getDeepValue (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), React (copy), IconButton (copy), Images (copy), Badge (copy), Tooltip (copy)
	local v18 = Dash.join(t1, t2)
	local v19, v20 = useState(240)
	local v21 = useLocalization({
		tooltipMessage = if not FFlagConnectionsToFriendsRename then TextKeys.NO_CONNECTIONS_TOOLTIP else TextKeys.NO_FRIENDS_TOOLTIP
	})

	return React.createElement(IconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = Images["icons/actions/friends/friendAdd"],
		position = v18.position,
		anchorPoint = Vector2.new(1, 0.5),
		layoutOrder = v18.layoutOrder,
		onActivated = v18.onActivated
	}, {
		ImagesContainer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = function(p1) -- line: 40
				-- upvalues: v20 (copy), getDeepValue (copy)
				if p1 and p1:FindFirstChild("CallToActionTooltip", true) then
					v20(getDeepValue(p1, "CallToActionTooltip.TooltipContainer.AbsoluteSize.X") or 240)
				end
			end
		}, {
			FriendRequestsBadge = v18.friendRequestCount > 0 and React.createElement(Badge, {
				position = UDim2.new(0.5, 0, 0.5, 0),
				anchorPoint = Vector2.new(0, 1),
				value = v18.friendRequestCount
			}),
			CallToActionTooltip = v18.showTooltip and React.createElement(Tooltip, {
				forceClickTriggerPoint = true,
				isDirectChild = true,
				position = UDim2.new(0, 42.5 - v19, 0, 36),
				triggerPosition = Vector2.new(0, 0),
				triggerSize = Vector2.new(36, 0),
				bodyText = v21.tooltipMessage
			})
		})
	})
end
