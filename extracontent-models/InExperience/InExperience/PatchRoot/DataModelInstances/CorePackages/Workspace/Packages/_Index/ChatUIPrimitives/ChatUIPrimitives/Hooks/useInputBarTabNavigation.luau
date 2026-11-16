local UserInputService = game:GetService("UserInputService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)

local chatTabNavigationSignal = require(ChatUIPrimitives.chatTabNavigationSignal)

local function withoutTabs(text: string) -- 2 equivalent calls inferred from this helper
	return (string.gsub(text, "\t", ""))
end

local function stripTabs(state) -- 2 equivalent calls inferred from this helper
	local text = state.Text
	local text2 = withoutTabs(text) -- inferred equivalent call

	if text2 == text then
		return
	end

	local cursorPosition = state.CursorPosition
	state.Text = text2

	if cursorPosition > 0 then
		local _, v = string.gsub(string.sub(text, 1, cursorPosition - 1), "\t", "")
		state.CursorPosition = cursorPosition - v
	end
end

local function useInputBarTabNavigation(p, p2)
	local v = p2 or UserInputService
	React.useEffect(function()
		local v2 = nil
		local textChangedConnection = nil

		local function watch(current) -- 1 equivalent call inferred from this helper
			if v2 == current then
				return
			end

			if textChangedConnection then
				textChangedConnection:Disconnect()
			end

			v2 = current
			textChangedConnection = current:GetPropertyChangedSignal("Text"):Connect(function()
				stripTabs(current) -- inferred equivalent call
			end)
		end

		local inputBeganConnection = v.InputBegan:connect(function(object)
			if not (object.UserInputType == Enum.UserInputType.Keyboard and object.KeyCode == Enum.KeyCode.Tab) then
				return
			end

			local current = p.current

			if current == nil or not current:IsFocused() then
				return
			end

			watch(current) -- inferred equivalent call
			local v3 = withoutTabs(current.Text) == "" -- inferred equivalent call
			stripTabs(current) -- inferred equivalent call

			if v3 then
				chatTabNavigationSignal:fire(object:IsModifierKeyDown(Enum.ModifierKey.Shift) and -1 or 1)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()

			if textChangedConnection then
				textChangedConnection:Disconnect()
			end
		end
	end, { p, v })
end

return useInputBarTabNavigation
