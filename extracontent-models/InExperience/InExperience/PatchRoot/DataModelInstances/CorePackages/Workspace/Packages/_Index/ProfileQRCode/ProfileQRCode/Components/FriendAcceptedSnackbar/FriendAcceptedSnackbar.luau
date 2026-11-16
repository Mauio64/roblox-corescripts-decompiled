local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Snackbar = Foundation.Snackbar
local useTokens = Foundation.Hooks.useTokens

local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)

local function FriendAcceptedSnackbar(props)
	local v = useLocalUserInfo(props.acceptedFriendUserId)
	local v2 = useTokens()
	local username

	if v then
		username = v.displayName or v.username
	end

	local v3 = useLocalization({
		nowTrusted = {
			TextKeys.NowTrusted,
			username = username
		},
		friendAdded = TextKeys.QRFriendAdded
	})

	React.useEffect(function()
		local thread = task.delay(5, function()
			if props.onDismissed then
				props.onDismissed()
			end
		end)
		return function()
			task.cancel(thread)
		end
	end, { props.onDismissed, props.acceptedFriendUserId })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local title

	if props.newFriendIsTrusted then
		title = v3.nowTrusted
	else
		title = v3.friendAdded
	end

	return createElement(View, { tag = "size-full", ZIndex = 101 }, {
		Message = createElement2(Snackbar, {
			title = title,
			Position = UDim2.new(0.5, 0, 1, -v2.Size.Size_500),
			AnchorPoint = Vector2.new(0.5, 1)
		})
	})
end

return FriendAcceptedSnackbar
