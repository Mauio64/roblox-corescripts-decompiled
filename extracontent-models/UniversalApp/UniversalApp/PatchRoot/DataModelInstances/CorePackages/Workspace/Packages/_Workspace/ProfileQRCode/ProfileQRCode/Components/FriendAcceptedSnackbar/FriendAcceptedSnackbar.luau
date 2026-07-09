local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local Localization = require(ProfileQRCodeParent.Localization)
local Foundation = require(ProfileQRCodeParent.Foundation)
local View = Foundation.View
local Snackbar = Foundation.Snackbar
local useTokens = Foundation.Hooks.useTokens
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)

local function FriendAcceptedSnackbar(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalUserInfo (copy), useTokens (copy), useLocalization (copy), TextKeys (copy), React (copy), View (copy), Snackbar (copy)
	local v14 = useLocalUserInfo(t1.acceptedFriendUserId)
	local v15 = useTokens()
	local v16 = if not v14 then nil else v14.displayName or v14.username
	local v17 = useLocalization({
		nowTrusted = {
			TextKeys.NowTrusted,
			username = v16
		},
		friendAdded = TextKeys.QRFriendAdded
	})

	React.useEffect(function() -- line: 36
		-- upvalues: t1 (copy)
		local thread = task.delay(5, function() -- line: 37
			-- upvalues: t1 (copy)
			if t1.onDismissed then
				t1.onDismissed()
			end
		end)

		return function() -- line: 42
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		t1.onDismissed,
		t1.acceptedFriendUserId
	})

	return React.createElement(View, {
		tag = "size-full",
		ZIndex = 101
	}, {
		Message = React.createElement(Snackbar, {
			title = if not t1.newFriendIsTrusted then v17.friendAdded else v17.nowTrusted,
			Position = UDim2.new(0.5, 0, 1, -v15.Size.Size_500),
			AnchorPoint = Vector2.new(0.5, 1)
		})
	})
end

return FriendAcceptedSnackbar
