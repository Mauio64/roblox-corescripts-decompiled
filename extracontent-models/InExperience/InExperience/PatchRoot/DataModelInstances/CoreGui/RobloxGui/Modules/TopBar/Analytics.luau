local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
game:GetService("UserInputService")
game:GetService("Players")

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent
local Constants = require(parent.Constants)
local GetFFlagEnableTopBarAnalytics = require(parent.Flags.GetFFlagEnableTopBarAnalytics)
GetFFlagEnableTopBarAnalytics()

local Analytics = {}
Analytics.__index = Analytics

function Analytics.new()
	local object = setmetatable({
		_target = "client",
		_context = "topbar",
		_defaultProps = {
			universeid = tostring(game.GameId),
			placeid = tostring(game.PlaceId),
			sessionid = RbxAnalyticsService:GetSessionId()
		}
	}, Analytics)

	if engineFeature then
		object._defaultProps.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function object._sendEvent(p: string, options): nil
		local joined = Cryo.Dictionary.join(object._defaultProps, options or {})
		RbxAnalyticsService:SendEventDeferred(object._target, object._context, p, joined)
		return nil
	end

	function object._onButtonActivated(button: string, flag: boolean)
		local sendEvent = object._sendEvent
		local eventNameTopBarButtonActivated = Constants.Analytics.EventNameTopBarButtonActivated
		local status

		if flag then
			status = Constants.Analytics.StatusActive
		else
			status = Constants.Analytics.StatusInactive
		end

		return sendEvent(eventNameTopBarButtonActivated, { button = button, status = status })
	end

	return object
end

function Analytics:onChatButtonActivated(flag: boolean)
	return self._onButtonActivated(Constants.Analytics.ChatButtonName, flag)
end

function Analytics:onMoreMenuActivated()
	return self._onButtonActivated(Constants.Analytics.MoreMenuButtonName, true)
end

function Analytics:onInventoryActivated(flag: boolean)
	return self._onButtonActivated(Constants.Analytics.InventoryButtonName, flag)
end

function Analytics:onLeaderboardActivated(flag: boolean)
	return self._onButtonActivated(Constants.Analytics.LeaderboardButtonName, flag)
end

function Analytics:onEmotesActivated(flag: boolean)
	return self._onButtonActivated(Constants.Analytics.EmotesButtonName, flag)
end

function Analytics:onShowGamepadNavigationDialog()
	return self._sendEvent(Constants.Analytics.ShowGamepadNavigationDialog)
end

function Analytics:onDismissGamepadNavigationDialog()
	return self._sendEvent(Constants.Analytics.DismissGamepadNavigationDialog)
end

Analytics.default = Analytics.new()
return Analytics
