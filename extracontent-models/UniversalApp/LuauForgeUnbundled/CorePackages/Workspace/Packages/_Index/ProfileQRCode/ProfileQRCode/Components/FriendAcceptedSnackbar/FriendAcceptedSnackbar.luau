local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Foundation")

local view = Foundation.View
local snackbar = Foundation.Snackbar
local useTokens = Foundation.Hooks.useTokens

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Utils/useLocalUserInfo")

local function FriendAcceptedSnackbar(props)
	local v5 = useLocalUserInfo(props.acceptedFriendUserId)
	local v6 = useTokens()

	local v7 = if v5 then v5.displayName or v5.username else nil

	local v8 = useLocalization({
		nowTrusted = {
			TextKeys.NowTrusted,
			username = v7
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
	local v14 = if props.newFriendIsTrusted then v8.nowTrusted else v8.friendAdded
	return createElement(view, { tag = "size-full", ZIndex = 101 }, {
		Message = createElement2(snackbar, {
			title = v14,
			Position = UDim2.new(0.5, 0, 1, -v6.Size.Size_500),
			AnchorPoint = Vector2.new(0.5, 1)
		})
	})
end

return FriendAcceptedSnackbar
