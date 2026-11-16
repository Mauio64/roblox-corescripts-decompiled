local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiMovePromptsActions = SharedFlags2.FFlagLuaAppSduiMovePromptsActions
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiShowToastAction = SharedFlags3.FFlagSduiShowToastAction
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiActionSequence = SharedFlags4.FFlagSduiActionSequence
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiNavigate = SharedFlags5.FFlagSduiNavigate
local FFlagSduiSetPageScopeFieldAction = require(SduiSharedContent.Flags.FFlagSduiSetPageScopeFieldAction)
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiReactionsComponent = SharedFlags6.FFlagSduiReactionsComponent

local function registerSharedActions()
	local v = {
		[SduiActionType.CustomAnalyticsEvent] = {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiAnalyticsEventAction)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.LoadMoreFromApi] = {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiLoadMoreFromApi)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.RefreshFromApi] = {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiRefreshFromApi)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.Share] = {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiShareAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenSocialProofUserListSheet] = {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiOpenSocialProofUserListSheetAction)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.DismissPrompt] = FFlagSduiDismissPromptAction and not FFlagLuaAppSduiMovePromptsActions and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiDismissPromptAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.ShowToast] = FFlagSduiShowToastAction and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiShowToastAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.ActionSequence] = FFlagSduiActionSequence and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiActionSequenceAction)
			end,
			skipUnifiedLogging = true
		} or nil,
		[SduiActionType.Navigate] = FFlagSduiNavigate and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiNavigateAction)
			end
		} or nil,
		[SduiActionType.SetPageScopeField] = FFlagSduiSetPageScopeFieldAction and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiSetPageScopeFieldAction)
			end
		} or nil,
		[SduiActionType.ToggleContentReaction] = FFlagSduiReactionsComponent and {
			lazyHandler = function()
				return require(SduiSharedContent.Actions.SduiToggleContentReactionAction)
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerSharedActions
