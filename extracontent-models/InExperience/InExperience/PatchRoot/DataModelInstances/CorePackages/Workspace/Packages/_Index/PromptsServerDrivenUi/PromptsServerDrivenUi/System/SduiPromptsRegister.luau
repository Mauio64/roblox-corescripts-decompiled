local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiMovePromptsActions = SharedFlags.FFlagLuaAppSduiMovePromptsActions

local FFlagSduiRequestPushNotificationPermissionActionHandler = SharedFlags.FFlagSduiRequestPushNotificationPermissionActionHandler
local FFlagSduiMilestoneCountActions = SharedFlags.FFlagSduiMilestoneCountActions
local registerPromptsActions = require(PromptsServerDrivenUi.Actions.registerPromptsActions)
local registerPromptsImpressions = require(PromptsServerDrivenUi.Impressions.registerPromptsImpressions)

local function SduiPromptsRegister(): nil
	React.useEffect(function()
		if
			FFlagLuaAppSduiMovePromptsActions
			or FFlagSduiRequestPushNotificationPermissionActionHandler
			or FFlagSduiMilestoneCountActions
		then
			registerPromptsActions()
		end

		registerPromptsImpressions()
	end, {})
	return nil
end

return React.memo(SduiPromptsRegister)
