local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Foundation = require(CorePackages.Packages.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Button = Foundation.Button
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)

local function AddConnectionButton(t1: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), React (copy), PeopleService (copy), Players (copy), SignalsReact (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v13 = useLocalization({
		isFriend = "CommonUI.Features.Label.Connection",
		addPerson = "CommonUI.Features.Label.Add",
		requestSent = "CommonUI.Features.Label.Sent"
	})
	local v14 = React.useMemo(function() -- line: 29
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("Constants")
	end, {})
	local v15 = React.useMemo(function() -- line: 33
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleAnalyticsManager")
	end, {})
	local v16 = React.useMemo(function() -- line: 37
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FriendStatusStore")
	end, {})
	local v17 = React.useMemo(function() -- line: 41
		-- upvalues: t1 (copy), Players (copy)
		if t1.userId then
			return (Players:GetPlayerByUserId(t1.userId))
		end

		return nil
	end, { t1.userId })
	local v18 = SignalsReact.useSignalState(v16.getFriendButtonText(t1.userId, v13))
	local v19 = SignalsReact.useSignalState(v16.getIsFriendButtonDisabled(t1.userId))

	return React.createElement(Button, {
		text = v18,
		variant = if not v19 then ButtonVariant.Emphasis else ButtonVariant.Subtle,
		fillBehavior = FillBehavior.Fill,
		isDisabled = v19,
		LayoutOrder = t1.layoutOrder,
		onActivated = function() -- line: 54
			-- upvalues: v15 (copy), v14 (copy), v16 (copy), v17 (copy)
			v15:trackRequestFriendship(v14.ANALYTICS.ENTRY_POINT.PLAYER_PROFILE)
			v16.sendFriendRequest(v17)
		end
	})
end

return React.memo(AddConnectionButton)
