local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Foundation = require(CorePackages.Packages.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Button = Foundation.Button

local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)

local function AddConnectionButton(p)
	local v = useLocalization({
		isFriend = "CommonUI.Features.Label.Connection",
		addPerson = "CommonUI.Features.Label.Add",
		requestSent = "CommonUI.Features.Label.Sent"
	})

	local v2 = React.useMemo(function()
		return PeopleService.getService("Constants")
	end, {})

	local v3 = React.useMemo(function()
		return PeopleService.getService("PeopleAnalyticsManager")
	end, {})

	local v4 = React.useMemo(function()
		return PeopleService.getService("FriendStatusStore")
	end, {})

	local v5 = React.useMemo(function()
		if p.userId then
			return (Players:GetPlayerByUserId(p.userId))
		end

		return nil
	end, { p.userId })

	local text = SignalsReact.useSignalState(v4.getFriendButtonText(p.userId, v))
	local isDisabled = SignalsReact.useSignalState(v4.getIsFriendButtonDisabled(p.userId))

	local createElement = React.createElement
	local variant

	if isDisabled then
		variant = ButtonVariant.Subtle
	else
		variant = ButtonVariant.Emphasis
	end

	return createElement(Button, {
		text = text,
		variant = variant,
		fillBehavior = FillBehavior.Fill,
		isDisabled = isDisabled,
		LayoutOrder = p.layoutOrder,
		onActivated = function()
			v3:trackRequestFriendship(v2.ANALYTICS.ENTRY_POINT.PLAYER_PROFILE)
			v4.sendFriendRequest(v5)
		end
	})
end

return React.memo(AddConnectionButton)
