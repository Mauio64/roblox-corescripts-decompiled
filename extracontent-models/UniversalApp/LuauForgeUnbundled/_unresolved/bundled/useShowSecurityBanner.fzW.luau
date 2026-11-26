local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/fyY").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local module = require("@luauforge/bundled/fzv")

local module2 = require("@luauforge/bundled/fzw")

local module3 = require("@luauforge/bundled/fzx")

local function useShowSecurityBanner()
	local v5 = React.useCallback(function(p2)
		return p2.AccountSecurityPrompt and p2.AccountSecurityPrompt.promptType
	end, {})

	local v7 = (if fFlagUseSignalsForAccountSecurityPrompt then useSignalState(getAccountSecurityPromptStore(false).getPromptType) else useSelector(v5)) ~= nil

	local v8 = useLocalUserId()
	return module2() and module3(v8) and v7 or module()
end

return useShowSecurityBanner
