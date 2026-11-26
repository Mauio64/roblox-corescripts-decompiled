local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")

local function createLibraryStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal(nil)
	local signal4, v8 = Signals.createSignal(nil)

	local signal5, v9 = Signals.createSignal(nil)

	local signal6, v10 = Signals.createSignal(nil)

	local signal7, v11 = Signals.createSignal(nil)

	local signal8, v12 = Signals.createSignal(nil)

	local signal9, v13 = Signals.createSignal(nil)
	local count = 0

	local function requestFocus(p2, p3, p4)
		count += 1
		v9({ token = count, position = p2, radius = p3, model = p4 })
	end

	local function requestAddAllToChat(list, p2, p3)
		if #list == 0 then
			return
		end

		count += 1
		v10({
			token = count,
			action = "Add",
			resources = list,
			replacePaths = p2,
			focusComposer = p3
		})
	end

	local function requestRemoveAllFromChat(list)
		if #list == 0 then
			return
		end

		count += 1
		v10({ token = count, action = "Remove", resources = list, replacePaths = {} })
	end

	local function requestAddToChat(p2, p3, p4)
		local v14 = { p2 }
		local v15 = p3 == nil and {} or { p3 }

		if #v14 == 0 then
			return
		end

		count += 1
		v10({
			token = count,
			action = "Add",
			resources = v14,
			replacePaths = v15,
			focusComposer = p4
		})
	end

	return {
		getIsOpen = signal,
		getIsChatOpen = GetPlayButtonStore(false).getIsActive,
		useIsOpen = function()
			return SignalsReact.useSignalState(signal)
		end,
		setIsOpen = v5,
		getFocusRequest = signal5,
		requestFocus = requestFocus,
		clearFocus = function()
			v9(nil)
		end,
		getWorldViewportRect = signal2,
		setWorldViewportRect = v6,
		getWorldChatTop = signal3,
		setWorldChatTop = v7,
		getWorldChatLeft = signal4,
		setWorldChatLeft = v8,
		getChatResourceRequest = signal6,
		consumeChatResourceRequest = function(p2)
			local v14 = signal6(false)

			if v14 ~= nil and v14.token == p2 then
				v10(nil)
			end
		end,
		requestAddToChat = requestAddToChat,
		requestRemoveFromChat = function(p2)
			requestRemoveAllFromChat({ p2 })
		end,
		requestAddAllToChat = requestAddAllToChat,
		requestRemoveAllFromChat = requestRemoveAllFromChat,
		getChatComposerState = signal7,
		setChatComposerState = v11,
		getPromptFailure = signal8,
		reportPromptFailure = function(p2)
			count += 1
			v12({ token = count, errorCode = p2 })
		end,
		getChipEvent = signal9,
		reportChipEvent = function(p2, p3)
			count += 1
			v13({ token = count, kind = p2, uris = p3 })
		end
	}
end

return createLibraryStore
