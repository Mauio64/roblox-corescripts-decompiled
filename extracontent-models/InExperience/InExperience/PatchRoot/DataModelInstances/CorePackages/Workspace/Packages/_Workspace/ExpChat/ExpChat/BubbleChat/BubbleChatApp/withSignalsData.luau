local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local ExpChatShared = require(parent.ExpChatShared)

local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local GetCharacterStore = require(ExpChat.Stores.GetCharacterStore)
require(ExpChat.Stores.GetCharacterStore.createCharacterStore)
local GetVoiceStore = require(ExpChat.Stores.GetVoiceStore)
require(ExpChat.Stores.GetVoiceStore.createVoiceStore)
local v

if getFFlagUseCharacterStore() then
	v = GetCharacterStore(false)
else
	v = nil
end

local v2

if GetFFlagExpChatUseVoiceParticipantsStore() then
	v2 = GetVoiceStore(false)
else
	v2 = nil
end

local function withSignalsData(p)
	return function(p2)
		local characters

		if getFFlagUseCharacterStore() and v then
			characters = useSignalState(v.getCharacters)
		end

		local voiceParticipants

		if GetFFlagExpChatUseVoiceParticipantsStore() and v2 then
			voiceParticipants = useSignalState(v2.getVoiceParticipants)
		end

		local context = ExpChatShared.context
		local messagesStore = context and context.messagesStore
		local mockUserIdToPartOrModel

		if messagesStore then
			mockUserIdToPartOrModel = useSignalState(messagesStore.getMockUserIdToPartOrModel)
		end

		local clone = table.clone(p2)

		if getFFlagUseCharacterStore() then
			clone.characters = characters
		end

		if GetFFlagExpChatUseVoiceParticipantsStore() then
			clone.voiceParticipants = voiceParticipants
		end

		if mockUserIdToPartOrModel then
			clone.mockUserIdToPartOrModel = mockUserIdToPartOrModel
		end

		return React.createElement(p, clone)
	end
end

return withSignalsData
