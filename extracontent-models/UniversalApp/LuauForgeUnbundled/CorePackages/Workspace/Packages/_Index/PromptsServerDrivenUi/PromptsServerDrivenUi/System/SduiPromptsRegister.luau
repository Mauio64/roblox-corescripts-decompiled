local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/React")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags")
local fFlagLuaAppSduiMovePromptsActions = SharedFlags.FFlagLuaAppSduiMovePromptsActions

local fFlagSduiRequestPushNotificationPermissionActionHandler = SharedFlags.FFlagSduiRequestPushNotificationPermissionActionHandler
local fFlagSduiMilestoneCountActions = SharedFlags.FFlagSduiMilestoneCountActions
local registerPromptsActions = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/registerPromptsActions")
local registerPromptsImpressions = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Impressions/registerPromptsImpressions")

local function SduiPromptsRegister(): nil
	React.useEffect(function()
		if
			fFlagLuaAppSduiMovePromptsActions
			or fFlagSduiRequestPushNotificationPermissionActionHandler
			or fFlagSduiMilestoneCountActions
		then
			registerPromptsActions()
		end

		registerPromptsImpressions()
	end, {})
	return nil
end

return React.memo(SduiPromptsRegister)
