local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local isSelectionWithinVisible = require(script.Parent.isSelectionWithinVisible)
local chatFocusRequestSignal = require(ExpChat.ShortcutNav.chatFocusRequestSignal)
local FFlagExpChatGenericChatFocus = require(ExpChat.Flags.FFlagExpChatGenericChatFocus)

return function()
	local signal, v = createSignal(false)
	local signal2, setTabBarVisible = createSignal(false)

	local signal3, v2 = createSignal(nil)

	local signal4, v3 = createSignal(nil)

	local signal5, v4 = createSignal(nil)

	local v5 = nil
	local v6 = nil
	return {
		getChatInputBarFocused = signal,
		getIsChatFocused = function()
			return isSelectionWithinVisible(GuiService.SelectedCoreObject, v5)
		end,
		getIsTabBarFocused = function()
			return isSelectionWithinVisible(GuiService.SelectedCoreObject, v6)
		end,
		getIsTabBarVisible = signal2,
		getTabNavFocusRequestTime = signal3,
		getTabNavFocusTabName = signal4,
		getChatInputBarFocusRequestTime = signal5,
		focusChatInputBar = function()
			v(true)

			if FFlagExpChatGenericChatFocus then
				chatFocusRequestSignal:fire()
			end
		end,
		unfocusChatInputBar = function()
			v(false)

			if FFlagExpChatGenericChatFocus then
				local focusedTextBox = UserInputService:GetFocusedTextBox()

				if focusedTextBox ~= nil and v5 ~= nil and focusedTextBox:IsDescendantOf(v5) then
					focusedTextBox:ReleaseFocus()
				end

				if GuiService.MenuIsOpen then
					GuiService:SetMenuIsOpen(false, "ExperienceChat")
				end
			end
		end,
		setChatRoot = function(p)
			v5 = p
		end,
		setTabBarRoot = function(p)
			v6 = p
		end,
		setTabBarVisible = setTabBarVisible,
		requestTabNavFocus = function(p: string, p2: number?)
			v3(p)
			v2(p2 or os.clock())
		end,
		clearTabNavFocusRequest = function()
			v3(nil)
			v2(nil)
		end,
		requestChatInputBarFocus = function(p: number?)
			v4(p or os.clock())
		end,
		clearChatInputBarFocusRequest = function()
			v4(nil)
		end
	}
end
