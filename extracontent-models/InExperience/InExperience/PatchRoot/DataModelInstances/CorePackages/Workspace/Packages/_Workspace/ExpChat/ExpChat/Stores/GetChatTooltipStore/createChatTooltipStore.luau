local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Display = require(parent.Display)
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local createEffect = Signals.createEffect

local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)
local GetPresetChatStore = require(script.Parent.Parent.GetPresetChatStore)
local promptsApi = require(script.Parent.promptsApi)

local v = { "GlobalChatTooltip", "PresetChatTooltip" }

local v2 = { isEligible = false, isDismissed = false, shouldShow = false }

return function()
	local signal, setIsChatWindowOpen = createSignal(false)
	local signal2, setIsChatInputBarVisible = createSignal(false)
	local signal3, setIsGlobalChatAvailable = createSignal(false)

	local getIsScreenWideEnough = createComputed(function(p): boolean
		return Display.GetDisplayStore(p).getViewportSize(p).X >= 720
	end)

	local chatStatusStore = GetChatStatusStore(false)
	local presetChatStore = GetPresetChatStore(false)

	local v3 = {
		GlobalChatTooltip = function(p)
			return isUserChatEnabled(chatStatusStore.getChatStatus(p)) and signal3(p)
		end,
		PresetChatTooltip = function(p)
			return presetChatStore.getIsEnabled(p) and presetChatStore.getAccessLevel(p) == "Enabled"
		end
	}

	local v4 = {}

	local function ensureTooltip(p: string)
		local v5 = v4[p]

		if v5 then
			return v5
		end

		local signal4, setEntry = createSignal(v2)

		local v6 = {
			getEntry = signal4,
			setEntry = setEntry,
			getIsEligible = createComputed(function(p2)
				return signal4(p2).isEligible
			end),
			getIsDismissed = createComputed(function(p2)
				return signal4(p2).isDismissed
			end),
			getShouldShow = createComputed(function(p2)
				return signal4(p2).shouldShow
			end)
		}

		v4[p] = v6
		return v6
	end

	for _, v5 in v do
		ensureTooltip(v5)
	end

	local function setField(p: string, p2: string, p3) -- 3 equivalent calls inferred from this helper
		ensureTooltip(p).setEntry(function(p4)
			if p4[p2] == p3 then
				return p4
			end

			local clone = table.clone(p4)
			clone[p2] = p3
			return clone
		end)
	end

	local function isTooltipValid(p, p2: string) -- 2 equivalent calls inferred from this helper
		local v5 = v3[p2]

		if v5 ~= nil and not v5(p) then
			return false
		end

		local v6 = v4[p2]

		if v6 == nil then
			return false
		end

		local entry = v6.getEntry(p)
		return entry.isEligible and not entry.isDismissed
	end

	local signal4, v5 = createSignal(nil)

	return {
		getIsChatWindowOpen = signal,
		setIsChatWindowOpen = setIsChatWindowOpen,
		getIsChatInputBarVisible = signal2,
		setIsChatInputBarVisible = setIsChatInputBarVisible,
		getIsScreenWideEnough = getIsScreenWideEnough,
		setIsGlobalChatAvailable = setIsGlobalChatAvailable,
		getActiveTooltipKey = signal4,
		getIsEligible = function(p: string)
			return ensureTooltip(p).getIsEligible
		end,
		setIsEligible = function(p: string, flag: boolean)
			setField(p, "isEligible", flag) -- inferred equivalent call
		end,
		getIsDismissed = function(p: string)
			return ensureTooltip(p).getIsDismissed
		end,
		setIsDismissed = function(p: string, flag: boolean)
			setField(p, "isDismissed", flag) -- inferred equivalent call
		end,
		getShouldShow = function(p: string)
			return ensureTooltip(p).getShouldShow
		end,
		setShouldShow = function(p: string, flag: boolean)
			setField(p, "shouldShow", flag) -- inferred equivalent call
		end,
		reportImpression = function(p: string)
			promptsApi.reportImpression(p)
		end,
		activeTooltipKeyEffect = createEffect(function(p)
			local v6 = signal4(false)

			if v6 ~= nil and isTooltipValid(p, v6) then -- inferred equivalent call
				return
			end

			for _, v7 in v do
				if isTooltipValid(p, v7) then -- inferred equivalent call
					if v6 ~= v7 then
						v5(v7)
					end

					return
				end
			end

			if v6 ~= nil then
				v5(nil)
			end
		end)
	}
end
