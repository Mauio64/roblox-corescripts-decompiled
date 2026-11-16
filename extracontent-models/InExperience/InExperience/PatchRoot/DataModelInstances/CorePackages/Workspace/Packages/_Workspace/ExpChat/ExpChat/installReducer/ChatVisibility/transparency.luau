local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local UserInteraction = require(ExpChat.Actions.UserInteraction)
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)

local v = {
	textDurationUntilFadeout = 30,
	backgroundDurationUntilFadeout = 3.5,
	lastGeneralActivityTimestamp = 0,
	lastMessageActivityTimestamp = 0,
	isTextBoxFocused = false
}

local function reset(p) -- 2 equivalent calls inferred from this helper
	local now = os.clock()

	return dictionary.join(v, {
		isTextBoxFocused = p.isTextBoxFocused,
		lastGeneralActivityTimestamp = now,
		lastMessageActivityTimestamp = now
	})
end

local function resetTextOnly(p)
	local now = os.clock()

	return dictionary.join(p, {
		isTextBoxFocused = p.isTextBoxFocused,
		lastMessageActivityTimestamp = now
	})
end

return Rodux.createReducer(v, {
	[ChatInputBarConfigurationEnabled.name] = function(p, p2)
		if p2.enabled then
			return reset(p)
		end

		return p
	end,
	[ChatTopBarButtonActivated.name] = function(p, p2)
		if p2.isVisible then
			return reset(p)
		end

		return p
	end,
	[SetCoreGuiEnabledChanged.name] = function(p, p2)
		if p2.enabled then
			return reset(p)
		end

		return p
	end,
	[ClientAppLoaded.name] = function(p, _)
		return reset(p)
	end,
	[UserInteraction.name] = function(p, p2)
		if p2.interaction == "focus" then
			return dictionary.join(reset(p), { isTextBoxFocused = true }) -- inferred equivalent call
		end

		if p2.interaction ~= "unfocus" then
			return reset(p)
		end

		return dictionary.join(reset(p), { isTextBoxFocused = false }) -- inferred equivalent call
	end,
	[IncomingMessageReceived.name] = function(p, _)
		return resetTextOnly(p)
	end
})
