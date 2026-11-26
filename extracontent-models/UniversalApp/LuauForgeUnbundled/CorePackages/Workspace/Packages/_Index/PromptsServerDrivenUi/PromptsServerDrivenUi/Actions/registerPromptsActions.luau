local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local fFlagSduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagSduiDismissPromptAction
local fFlagLuaAppSduiMovePromptsActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagLuaAppSduiMovePromptsActions

local fFlagSduiRequestPushNotificationPermissionActionHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagSduiRequestPushNotificationPermissionActionHandler
local fFlagSduiMilestoneCountActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagSduiMilestoneCountActions

local function registerPromptsActions()
	local v5 = {
		[sduiActionType.DismissPrompt] = fFlagLuaAppSduiMovePromptsActions and fFlagSduiDismissPromptAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/SduiDismissPromptAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.RequestPushNotificationPermission] = fFlagSduiRequestPushNotificationPermissionActionHandler and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/SduiRequestPushNotificationPermissionAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.IncrementMilestoneCount] = fFlagSduiMilestoneCountActions and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/SduiIncrementMilestoneCountAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.SetMilestoneCount] = fFlagSduiMilestoneCountActions and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/SduiSetMilestoneCountAction")
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerPromptsActions
