local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local SetCoreGuiEnabledChanged = require(Actions.SetCoreGuiEnabledChanged)
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local UserInteraction = require(ExpChat.Actions.UserInteraction)
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)
local t1 = {
	textDurationUntilFadeout = 30,
	backgroundDurationUntilFadeout = 3.5,
	lastGeneralActivityTimestamp = 0,
	lastMessageActivityTimestamp = 0,
	isTextBoxFocused = false
}

local function reset(p1) -- line: 31
	-- upvalues: Dictionary (copy), t1 (copy)
	local elapsed = os.clock()

	return Dictionary.join(t1, {
		isTextBoxFocused = p1.isTextBoxFocused,
		lastGeneralActivityTimestamp = elapsed,
		lastMessageActivityTimestamp = elapsed
	})
end
local function resetTextOnly(p2) -- line: 41
	-- upvalues: Dictionary (copy)
	local elapsed = os.clock()

	return Dictionary.join(p2, {
		isTextBoxFocused = p2.isTextBoxFocused,
		lastMessageActivityTimestamp = elapsed
	})
end

return Rodux.createReducer(t1, {
	[ChatInputBarConfigurationEnabled.name] = function(t2: {[any]: any}, p3) -- line: 51
		-- upvalues: reset (copy)
		if p3.enabled then
			return reset(t2)
		end

		return t2
	end,
	[ChatTopBarButtonActivated.name] = function(t3: {[any]: any}, p4) -- line: 59
		-- upvalues: reset (copy)
		if p4.isVisible then
			return reset(t3)
		end

		return t3
	end,
	[SetCoreGuiEnabledChanged.name] = function(t4: {[any]: any}, p5) -- line: 67
		-- upvalues: reset (copy)
		if p5.enabled then
			return reset(t4)
		end

		return t4
	end,
	[ClientAppLoaded.name] = function(t5: {[any]: any}, _) -- line: 75
		-- upvalues: reset (copy)
		return reset(t5)
	end,
	[UserInteraction.name] = function(t6: {[any]: any}, p7) -- line: 79
		-- upvalues: Dictionary (copy), t1 (copy), reset (copy)
		if p7.interaction == "focus" then
			local join = Dictionary.join
			local elapsed = os.clock()

			return join(Dictionary.join(t1, {
				isTextBoxFocused = t6.isTextBoxFocused,
				lastGeneralActivityTimestamp = elapsed,
				lastMessageActivityTimestamp = elapsed
			}), {
				isTextBoxFocused = true
			})
		end

		if p7.interaction == "unfocus" then
			local join = Dictionary.join
			local elapsed = os.clock()

			return join(Dictionary.join(t1, {
				isTextBoxFocused = t6.isTextBoxFocused,
				lastGeneralActivityTimestamp = elapsed,
				lastMessageActivityTimestamp = elapsed
			}), {
				isTextBoxFocused = false
			})
		end

		return reset(t6)
	end,
	[IncomingMessageReceived.name] = function(t7: {[any]: any}, _) -- line: 93
		-- upvalues: resetTextOnly (copy)
		return resetTextOnly(t7)
	end
})
