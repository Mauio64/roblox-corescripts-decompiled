local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.React)
require(BuildExperience.Chat.chatTypes)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)

local function createLibraryStore()
	local signal, setIsOpen = Signals.createSignal(false)
	local signal2, setWorldViewportRect = Signals.createSignal(nil)
	local signal3, setWorldChatTop = Signals.createSignal(nil)
	local signal4, setWorldChatLeft = Signals.createSignal(nil)

	local signal5, v = Signals.createSignal(nil)

	local signal6, v2 = Signals.createSignal(nil)

	local signal7, setChatComposerState = Signals.createSignal(nil)

	local signal8, v3 = Signals.createSignal(nil)

	local signal9, v4 = Signals.createSignal(nil)
	local count = 0

	local function requestFocus(position: Vector3, radius: number, model)
		count += 1
		v({ token = count, position = position, radius = radius, model = model })
	end

	local function requestAddToChat(resource, replacePath: string?, focusComposer: boolean?)
		count += 1
		v2({
			token = count,
			action = "Add",
			resource = resource,
			replacePath = replacePath,
			focusComposer = focusComposer
		})
	end

	local function requestRemoveFromChat(resource)
		count += 1
		v2({ token = count, action = "Remove", resource = resource })
	end

	return {
		getIsOpen = signal,
		getIsChatOpen = GetPlayButtonStore(false).getIsActive,
		useIsOpen = function()
			return SignalsReact.useSignalState(signal)
		end,
		setIsOpen = setIsOpen,
		getFocusRequest = signal5,
		requestFocus = requestFocus,
		clearFocus = function()
			v(nil)
		end,
		getWorldViewportRect = signal2,
		setWorldViewportRect = setWorldViewportRect,
		getWorldChatTop = signal3,
		setWorldChatTop = setWorldChatTop,
		getWorldChatLeft = signal4,
		setWorldChatLeft = setWorldChatLeft,
		getChatResourceRequest = signal6,
		consumeChatResourceRequest = function(p)
			local v5 = signal6(false)

			if v5 ~= nil and v5.token == p then
				v2(nil)
			end
		end,
		requestAddToChat = requestAddToChat,
		requestRemoveFromChat = requestRemoveFromChat,
		getChatComposerState = signal7,
		setChatComposerState = setChatComposerState,
		getPromptFailure = signal8,
		reportPromptFailure = function(errorCode: number?)
			count += 1
			v3({ token = count, errorCode = errorCode })
		end,
		getChipEvent = signal9,
		reportChipEvent = function(kind: string, uris)
			count += 1
			v4({ token = count, kind = kind, uris = uris })
		end
	}
end

return createLibraryStore
