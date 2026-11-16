local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(ChatUIPrimitives.Components.ExpressionTray.ExpressionTrayView)
local useExpressionTrayController = require(ChatUIPrimitives.Hooks.useExpressionTrayController)
local useInExperienceLocalization = require(ChatUIPrimitives.Hooks.useInExperienceLocalization)
local useLayoutMode = require(ChatUIPrimitives.Hooks.useLayoutMode)
local withPresetDisclaimer = require(ChatUIPrimitives.PresetChat.withPresetDisclaimer)
local getExpressionCooldownStore = require(ChatUIPrimitives.getExpressionCooldownStore)
local getExpressionCooldownStore2 = getExpressionCooldownStore.getExpressionCooldownStore
local getDefaultCooldownKey = require(ChatUIPrimitives.getDefaultCooldownKey)
local expressionCatalogStore = require(ChatUIPrimitives.expressionCatalogStore)
require(ChatUIPrimitives.createExpressionCatalogResource)
require(ChatUIPrimitives.UniversalMessage.Types)
local FFlagExpChatPresetGroupFooter = require(ChatUIPrimitives.Flags.FFlagExpChatPresetGroupFooter)

local FFlagExpChatExpressionTrayRecoverFromSendError = require(ChatUIPrimitives.Flags.FFlagExpChatExpressionTrayRecoverFromSendError)

local v = game:DefineFastInt("PresetChatCooldownLuaMs", 10000) / 1000

local signal = Signals.createSignal("disabled")
local signal2 = Signals.createSignal({})
local signal3 = Signals.createSignal(nil)
local v2 = {}

local function useExpressionTray(data)
	local layoutMode = useLayoutMode()
	local catalogResource

	if data then
		catalogResource = data.catalogResource
	else
		catalogResource = nil
	end

	local v3

	if data == nil or catalogResource ~= nil then
		v3 = nil
	else
		v3 = expressionCatalogStore
	end

	local useSignalState = SignalsReact.useSignalState
	local v4 = if v3 == nil then signal else v3.getStatus
	local v5 = useSignalState(v4)

	local useSignalState2 = SignalsReact.useSignalState
	local v6 = if v3 == nil then signal2 else v3.getCategoryGroups
	local categoryGroups = useSignalState2(v6)

	local useSignalState3 = SignalsReact.useSignalState
	local v7

	if catalogResource == nil then
		v7 = signal3
	else
		v7 = catalogResource.getCatalog
	end

	local v8 = useSignalState3(v7)

	if catalogResource ~= nil then
		v5 = v8 == nil and "disabled" or v8.status

		categoryGroups = if v8 ~= nil then v8.categoryGroups else nil

		if categoryGroups == nil then
			categoryGroups = v2
		end
	end

	if FFlagExpChatPresetGroupFooter then
		local v9 = useInExperienceLocalization()

		categoryGroups = React.useMemo(function()
			return withPresetDisclaimer(categoryGroups, v9)
		end, { categoryGroups, v9 })
	end

	local v9

	if data then
		v9 = data.cooldownScope
	end

	local expressionCooldownStore = getExpressionCooldownStore2(v9)
	local cooldownEndsAtByKey = SignalsReact.useSignalState(expressionCooldownStore.getCooldownEndsAtByKey)

	local v10 = useExpressionTrayController({ categoryGroups = categoryGroups })

	local close = v10.close
	local ref = React.useRef(false)
	local v11

	if data then
		v11 = data.canSend
	else
		v11 = false
	end

	React.useEffect(function()
		local v12 = catalogResource

		if v12 == nil then
			if v11 and v3 ~= nil then
				v3.acquire()
				return function()
					v3.release()
				end
			end

			close()
		elseif v11 then
			v12.acquire()
			return function()
				v12.release()
			end
		else
			close()
		end
	end, { v11, catalogResource, v3, close })
	local onKeyboardActivated

	if data then
		onKeyboardActivated = data.onKeyboardActivated
	else
		onKeyboardActivated = nil
	end

	local onKeyboardActivated2 = React.useCallback(function()
		close()

		if onKeyboardActivated then
			onKeyboardActivated()
		end
	end, { close, onKeyboardActivated })
	local sendExpression

	if data then
		sendExpression = data.sendExpression
	else
		sendExpression = nil
	end

	local cooldownDurationSeconds

	if data and data.cooldownDurationSeconds ~= nil then
		cooldownDurationSeconds = data.cooldownDurationSeconds
	else
		cooldownDurationSeconds = v
	end

	local onExpressionActivated = React.useCallback(function(p)
		if sendExpression == nil then
			return
		end

		local defaultCooldownKey = getDefaultCooldownKey(p)

		if defaultCooldownKey ~= nil then
			local cooldownEndsAt = expressionCooldownStore.getCooldownEndsAt(defaultCooldownKey)

			if cooldownEndsAt ~= nil and os.clock() < cooldownEndsAt then
				return
			end
		end

		if ref.current then
			return
		end

		ref.current = true

		if defaultCooldownKey ~= nil then
			expressionCooldownStore.startCooldown(defaultCooldownKey, os.clock() + cooldownDurationSeconds)
		end

		close()
		task.spawn(function()
			if FFlagExpChatExpressionTrayRecoverFromSendError then
				local success, result = pcall(sendExpression, p)
				ref.current = false

				if success and not result and defaultCooldownKey ~= nil then
					expressionCooldownStore.clearCooldown(defaultCooldownKey)
				end

				if not success then
					error(result, 0)
				end
			else
				local v12 = sendExpression(p)
				ref.current = false

				if not v12 and defaultCooldownKey ~= nil then
					expressionCooldownStore.clearCooldown(defaultCooldownKey)
				end
			end
		end)
	end, { sendExpression, cooldownDurationSeconds, close, expressionCooldownStore })
	local onOpenChanged

	if data then
		onOpenChanged = data.onOpenChanged
	else
		onOpenChanged = nil
	end

	local isVisible

	if v11 then
		if v5 == "enabled" then
			isVisible = #categoryGroups > 0
		else
			isVisible = false
		end
	else
		isVisible = v11
	end

	local v12 = v10.isOpen and isVisible
	React.useEffect(function()
		if onOpenChanged then
			onOpenChanged(v12)
		end
	end, { v12, onOpenChanged })

	if data == nil then
		return nil
	end

	return {
		isVisible = isVisible,
		isOpen = v10.isOpen,
		layoutMode = layoutMode,
		focusNavEnabled = data.focusNavEnabled,
		canLocalUserChat = data.canLocalUserChat,
		footerText = data.footerText,
		categoryGroups = categoryGroups,
		activeGroupId = v10.activeGroupId,
		cooldownDurationSeconds = cooldownDurationSeconds,
		cooldownEndsAtByKey = cooldownEndsAtByKey,
		onEntryActivated = v10.onEntryActivated,
		onPressedOutside = close,
		onGroupActivated = v10.onGroupActivated,
		onExpressionActivated = onExpressionActivated,
		onKeyboardActivated = onKeyboardActivated2
	}
end

return useExpressionTray
