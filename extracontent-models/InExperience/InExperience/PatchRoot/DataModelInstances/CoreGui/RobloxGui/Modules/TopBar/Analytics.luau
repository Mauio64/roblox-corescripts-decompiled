local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

game:GetService("GuiService")
game:GetService("CoreGui"):WaitForChild("RobloxGui")
game:GetService("UserInputService")
game:GetService("Players")

local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local Cryo = require(CorePackages.Packages.Cryo)
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)

require(scriptParent.Flags.GetFFlagEnableTopBarAnalytics)()

local t1 = {}

t1.__index = t1

function t1.new() -- line: 42
	-- upvalues: RbxAnalyticsService (copy), t1 (copy), EngineFeature (copy), Cryo (copy), Constants (copy)
	local v8 = setmetatable({
		_target = "client",
		_context = "topbar",
		_defaultProps = {
			universeid = tostring(game.GameId),
			placeid = tostring(game.PlaceId),
			sessionid = RbxAnalyticsService:GetSessionId()
		}
	}, t1)

	if EngineFeature then
		v8._defaultProps.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v8._sendEvent(s1: string, p1) -- line: 59
		-- upvalues: Cryo (copy), v8 (copy), RbxAnalyticsService (copy)
		local v22 = Cryo.Dictionary.join(v8._defaultProps, p1 or {})

		RbxAnalyticsService:SendEventDeferred(v8._target, v8._context, s1, v22)

		return nil
	end
	function v8._onButtonActivated(s2: string, b1: boolean) -- line: 65
		-- upvalues: v8 (copy), Constants (copy)
		return v8._sendEvent(Constants.Analytics.EventNameTopBarButtonActivated, {
			button = s2,
			status = if not b1 then Constants.Analytics.StatusInactive else Constants.Analytics.StatusActive
		})
	end

	return v8
end
function t1.onChatButtonActivated(t2: {[any]: any}, b2: boolean) -- line: 75
	-- upvalues: Constants (copy)
	return t2._onButtonActivated(Constants.Analytics.ChatButtonName, b2)
end
function t1.onMoreMenuActivated(p2) -- line: 79
	-- upvalues: Constants (copy)
	return p2._onButtonActivated(Constants.Analytics.MoreMenuButtonName, true)
end
function t1.onInventoryActivated(t3: {[any]: any}, b3: boolean) -- line: 84
	-- upvalues: Constants (copy)
	return t3._onButtonActivated(Constants.Analytics.InventoryButtonName, b3)
end
function t1.onLeaderboardActivated(t4: {[any]: any}, b4: boolean) -- line: 88
	-- upvalues: Constants (copy)
	return t4._onButtonActivated(Constants.Analytics.LeaderboardButtonName, b4)
end
function t1.onEmotesActivated(t5: {[any]: any}, b5: boolean) -- line: 92
	-- upvalues: Constants (copy)
	return t5._onButtonActivated(Constants.Analytics.EmotesButtonName, b5)
end
function t1.onShowGamepadNavigationDialog(p3) -- line: 96
	-- upvalues: Constants (copy)
	return p3._sendEvent(Constants.Analytics.ShowGamepadNavigationDialog)
end
function t1.onDismissGamepadNavigationDialog(p4) -- line: 100
	-- upvalues: Constants (copy)
	return p4._sendEvent(Constants.Analytics.DismissGamepadNavigationDialog)
end

t1.default = t1.new()

return t1
