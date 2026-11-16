local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local InputType = require(parent.InputType)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav
local FFlagExpChatTabShortcutNav = SharedFlags.FFlagExpChatTabShortcutNav

local v = FFlagFriendsChatConversationListFocusNav or FFlagExpChatTabShortcutNav

local function useFocusInputBar(p)
	local v2

	if v then
		v2 = React.useContext(FocusNavigationContext)
	else
		v2 = nil
	end

	local ref = React.useRef(nil)
	local ref3 = p or ref

	local ref2 = React.useRef(false)

	local focus = React.useCallback(function()
		task.delay(0, function()
			local current = ref3.current

			if current == nil then
				return
			end

			if v then
				if InputType.getInputGroup(UserInputService:GetLastInputType()) == InputType.InputTypeConstants.Gamepad then
					if v2 ~= nil then
						v2:focusGuiObject(current, false)
					end
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			if not current:IsFocused() then
				ref2.current = true
				current:CaptureFocus()
			end
		end)
	end, { ref3, v2 })

	React.useEffect(function()
		return function()
			if not ref2.current then
				return
			end

			local localPlayer = Players.LocalPlayer

			if localPlayer then
				local textBox = Instance.new("TextBox")
				textBox.Visible = false
				textBox.Parent = localPlayer:FindFirstChildOfClass("PlayerGui")
				textBox:CaptureFocus()
				textBox:ReleaseFocus()
				textBox:Destroy()
			end
		end
	end, {})

	return { ref = ref3, focus = focus }
end

return useFocusInputBar
