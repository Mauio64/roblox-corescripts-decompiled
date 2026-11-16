local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiMovePromptsActions = SharedFlags2.FFlagLuaAppSduiMovePromptsActions

local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiRequestPushNotificationPermissionActionHandler = SharedFlags3.FFlagSduiRequestPushNotificationPermissionActionHandler
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiMilestoneCountActions = SharedFlags4.FFlagSduiMilestoneCountActions

local function registerPromptsActions()
	local v = {
		[SduiActionType.DismissPrompt] = FFlagLuaAppSduiMovePromptsActions and FFlagSduiDismissPromptAction and {
			lazyHandler = function()
				return require(PromptsServerDrivenUi.Actions.SduiDismissPromptAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.RequestPushNotificationPermission] = FFlagSduiRequestPushNotificationPermissionActionHandler and {
			lazyHandler = function()
				return require(PromptsServerDrivenUi.Actions.SduiRequestPushNotificationPermissionAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.IncrementMilestoneCount] = FFlagSduiMilestoneCountActions and {
			lazyHandler = function()
				return require(PromptsServerDrivenUi.Actions.SduiIncrementMilestoneCountAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.SetMilestoneCount] = FFlagSduiMilestoneCountActions and {
			lazyHandler = function()
				return require(PromptsServerDrivenUi.Actions.SduiSetMilestoneCountAction)
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerPromptsActions
