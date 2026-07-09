local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local useSignalState = require(ExpChatParent.SignalsReact).useSignalState
local React = require(ExpChatParent.React)
local SharedFlags = require(ExpChatParent.SharedFlags)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local GetCharacterStore = require(ExpChat.Stores.GetCharacterStore)

require(ExpChat.Stores.GetCharacterStore.createCharacterStore)

local GetVoiceStore = require(ExpChat.Stores.GetVoiceStore)

require(ExpChat.Stores.GetVoiceStore.createVoiceStore)

local v12 = if not getFFlagUseCharacterStore() then nil else GetCharacterStore(false)
local v13 = if not GetFFlagExpChatUseVoiceParticipantsStore() then nil else GetVoiceStore(false)

local function withSignalsData(p1) -- line: 29
	-- upvalues: getFFlagUseCharacterStore (copy), v12 (copy), useSignalState (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), v13 (copy), FFlagExpChatUseMessagesStore (copy), ExpChatShared (copy), React (copy)
	return function(t1: {[any]: any}) -- line: 30
		-- upvalues: getFFlagUseCharacterStore (copy), v12 (copy), useSignalState (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), v13 (copy), FFlagExpChatUseMessagesStore (copy), ExpChatShared (copy), React (copy), p1 (copy)
		local v17 = nil

		if getFFlagUseCharacterStore() and v12 then
			local getCharacters = v12.getCharacters

			v17 = useSignalState(getCharacters)
		end

		local v19 = nil

		if GetFFlagExpChatUseVoiceParticipantsStore() and v13 then
			local getVoiceParticipants = v13.getVoiceParticipants

			v19 = useSignalState(getVoiceParticipants)
		end

		local v21 = nil

		if FFlagExpChatUseMessagesStore then
			local context = ExpChatShared.context
			local v23 = context and context.messagesStore

			if v23 then
				local getMockUserIdToPartOrModel = v23.getMockUserIdToPartOrModel

				v21 = useSignalState(getMockUserIdToPartOrModel)
			end
		end

		local v25 = table.clone(t1)

		if getFFlagUseCharacterStore() then
			v25.characters = v17
		end

		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v25.voiceParticipants = v19
		end

		if FFlagExpChatUseMessagesStore and v21 then
			v25.mockUserIdToPartOrModel = v21
		end

		return React.createElement(p1, v25)
	end
end

return withSignalsData
