local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local fFlagSduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiDismissPromptAction
local fFlagLuaAppSduiMovePromptsActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppSduiMovePromptsActions
local fFlagSduiShowToastAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiShowToastAction
local fFlagSduiActionSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiActionSequence
local fFlagSduiNavigate = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiNavigate
local FFlagSduiSetPageScopeFieldAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiSetPageScopeFieldAction")
local fFlagSduiReactionsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiReactionsComponent

local function registerSharedActions()
	local v5 = {
		[sduiActionType.CustomAnalyticsEvent] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiAnalyticsEventAction")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.LoadMoreFromApi] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiLoadMoreFromApi")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.RefreshFromApi] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiRefreshFromApi")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.Share] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiShareAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenSocialProofUserListSheet] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiOpenSocialProofUserListSheetAction")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.DismissPrompt] = fFlagSduiDismissPromptAction and not fFlagLuaAppSduiMovePromptsActions and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiDismissPromptAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.ShowToast] = fFlagSduiShowToastAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiShowToastAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.ActionSequence] = fFlagSduiActionSequence and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiActionSequenceAction")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.Navigate] = fFlagSduiNavigate and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiNavigateAction")
			end
		} or nil,
		[sduiActionType.SetPageScopeField] = FFlagSduiSetPageScopeFieldAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiSetPageScopeFieldAction")
			end
		} or nil,
		[sduiActionType.ToggleContentReaction] = fFlagSduiReactionsComponent and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiToggleContentReactionAction")
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerSharedActions
