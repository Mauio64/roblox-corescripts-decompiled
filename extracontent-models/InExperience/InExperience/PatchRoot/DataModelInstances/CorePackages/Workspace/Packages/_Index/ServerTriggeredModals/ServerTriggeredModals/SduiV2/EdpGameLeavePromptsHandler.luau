local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local PromptsHandler = require(script.Parent.PromptsHandler)
local promptsHandler = PromptsHandler.PromptsHandler
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)
local isPinShortcutAvailable = require(script.Parent.isPinShortcutAvailable)
local isCustomAppEntryPointAutoJoinAvailable = require(script.Parent.isCustomAppEntryPointAutoJoinAvailable)
local isRecentInstall = require(script.Parent.isRecentInstall)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local SharedFlags = require(parent.SharedFlags)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEdpGameLeavePromptsPassPinShortcutAvailable = SharedFlags2.FFlagEdpGameLeavePromptsPassPinShortcutAvailable

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin = SharedFlags3.FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin
local FFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy

local defineFastFlag = game:DefineFastFlag("AvoidShowingMobileUpsellDialogOnDesktopHackyLuaFix", false)

local defineFastFlag2 = game:DefineFastFlag("PassInPinShortcutTargetDestinationToUpsellResolver", false)
local FFlagEdpGameLeavePromptsPassIsRecentInstall = SharedFlags.FFlagEdpGameLeavePromptsPassIsRecentInstall

local function EdpGameLeavePromptsHandler(p)
	local state, setState = React.useState(0)
	local v = React.useMemo(isPinShortcutAvailable, {})
	local v2 = React.useMemo(function()
		return FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin and isCustomAppEntryPointAutoJoinAvailable()
	end, {})
	local v3

	if FFlagEdpGameLeavePromptsPassIsRecentInstall then
		v3 = useLocalUserId()
	else
		v3 = nil
	end

	local v4 = not FFlagAddPinExperienceTargetDestinationGUACPolicy and "HomeScreen"
		or getAppFeaturePolicies().getPinExperienceTargetDestination()

	local clientAttributes = React.useMemo(function()
		if p.universeId == nil then
			return nil
		end

		local v5 = { universeId = p.universeId }

		if FFlagEdpGameLeavePromptsPassPinShortcutAvailable then
			if defineFastFlag and FFlagAddPinExperienceTargetDestinationGUACPolicy then
				if v4 == "Desktop" then
					v5.isPinnedShortcutAvailableDesktop = tostring(v)

					v5.isPinnedShortcutAvailable = "false"
				else
					v5.isPinnedShortcutAvailable = tostring(v)
				end
			else
				v5.isPinnedShortcutAvailable = tostring(v)
			end
		end

		if FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin then
			v5.isCustomAppEntryPointAutoJoinAvailable = tostring(v2)
		end

		if FFlagEdpGameLeavePromptsPassIsRecentInstall and state > 0 then
			v5.isRecentInstall = tostring(isRecentInstall(v3))
		end

		if defineFastFlag2 and FFlagAddPinExperienceTargetDestinationGUACPolicy then
			v5.pinnedShortcutTargetDestination = getAppFeaturePolicies().getPinExperienceTargetDestination()
		end

		return v5
	end, { p.universeId, v, v2, v4, v3, state })

	React.useEffect(function()
		if not (p.universeId ~= nil and (FFlagEdpGameLeavePromptsPassPinShortcutAvailable or v)) then
			return
		end

		local subscriber = messageBus.Subscriber.new()
		local messageId = messageBus.getMessageId("Game", "onGameLeave")
		subscriber:subscribe({ mid = messageId, validateParams = t.table }, function()
			setState(function(p2: number)
				return p2 + 1
			end)
		end)

		return function()
			subscriber:unsubscribeWithMsgId(messageId)
		end
	end, { v, p.universeId })

	if state == 0 or clientAttributes == nil then
		return nil
	end

	if FFlagEdpGameLeavePromptsPassPinShortcutAvailable or v then
		return React.createElement(promptsHandler, {
			key = "EdpPrompts" .. tostring(state),
			entryPoint = PromptsEntryPoint.ExperienceDetailsPageSessionEnd,
			clientAttributes = clientAttributes
		})
	end

	return nil
end

return EdpGameLeavePromptsHandler
