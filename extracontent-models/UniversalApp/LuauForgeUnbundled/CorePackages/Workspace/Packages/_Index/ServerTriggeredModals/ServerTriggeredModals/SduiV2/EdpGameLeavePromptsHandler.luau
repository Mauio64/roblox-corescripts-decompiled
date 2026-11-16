local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/t")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UniversalAppPolicy")

local promptsHandler = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler").PromptsHandler
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
local isPinShortcutAvailable = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/isPinShortcutAvailable")
local isCustomAppEntryPointAutoJoinAvailable = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/isCustomAppEntryPointAutoJoinAvailable")
local isRecentInstall = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/isRecentInstall")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppHooks").useLocalUserId
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local fFlagEdpGameLeavePromptsPassPinShortcutAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagEdpGameLeavePromptsPassPinShortcutAvailable

local fFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin
local fFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy

local defineFastFlag = game:DefineFastFlag("AvoidShowingMobileUpsellDialogOnDesktopHackyLuaFix", false)

local defineFastFlag2 = game:DefineFastFlag("PassInPinShortcutTargetDestinationToUpsellResolver", false)
local fFlagEdpGameLeavePromptsPassIsRecentInstall = SharedFlags.FFlagEdpGameLeavePromptsPassIsRecentInstall

local function EdpGameLeavePromptsHandler(p2)
	local state, setState = React.useState(0)
	local v5 = React.useMemo(isPinShortcutAvailable, {})
	local v6 = React.useMemo(function()
		return fFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin and isCustomAppEntryPointAutoJoinAvailable()
	end, {})
	local v7 = if fFlagEdpGameLeavePromptsPassIsRecentInstall then useLocalUserId() else nil

	local v8 = not fFlagAddPinExperienceTargetDestinationGUACPolicy and "HomeScreen"
		or getAppFeaturePolicies().getPinExperienceTargetDestination()

	local v9 = React.useMemo(function()
		if p2.universeId == nil then
			return nil
		end

		local v10 = { universeId = p2.universeId }

		if fFlagEdpGameLeavePromptsPassPinShortcutAvailable then
			if defineFastFlag and fFlagAddPinExperienceTargetDestinationGUACPolicy then
				if v8 == "Desktop" then
					v10.isPinnedShortcutAvailableDesktop = tostring(v5)

					v10.isPinnedShortcutAvailable = "false"
				else
					v10.isPinnedShortcutAvailable = tostring(v5)
				end
			else
				v10.isPinnedShortcutAvailable = tostring(v5)
			end
		end

		if fFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin then
			v10.isCustomAppEntryPointAutoJoinAvailable = tostring(v6)
		end

		if fFlagEdpGameLeavePromptsPassIsRecentInstall and state > 0 then
			v10.isRecentInstall = tostring(isRecentInstall(v7))
		end

		if defineFastFlag2 and fFlagAddPinExperienceTargetDestinationGUACPolicy then
			v10.pinnedShortcutTargetDestination = getAppFeaturePolicies().getPinExperienceTargetDestination()
		end

		return v10
	end, { p2.universeId, v5, v6, v8, v7, state })

	React.useEffect(function()
		if not (p2.universeId ~= nil and (fFlagEdpGameLeavePromptsPassPinShortcutAvailable or v5)) then
			return
		end

		local subscriber = messageBus.Subscriber.new()
		local messageId = messageBus.getMessageId("Game", "onGameLeave")
		subscriber:subscribe({ mid = messageId, validateParams = t.table }, function()
			setState(function(p3)
				return p3 + 1
			end)
		end)

		return function()
			subscriber:unsubscribeWithMsgId(messageId)
		end
	end, { v5, p2.universeId })

	if state == 0 or v9 == nil then
		return nil
	end

	if fFlagEdpGameLeavePromptsPassPinShortcutAvailable or v5 then
		return React.createElement(promptsHandler, {
			key = "EdpPrompts" .. tostring(state),
			entryPoint = PromptsEntryPoint.ExperienceDetailsPageSessionEnd,
			clientAttributes = v9
		})
	end

	return nil
end

return EdpGameLeavePromptsHandler
