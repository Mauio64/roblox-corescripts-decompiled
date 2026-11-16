local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local shouldFocusBackButtonOnKey = require(script.Parent.shouldFocusBackButtonOnKey)

local function useFocusBackButtonOnUp(p, p2, p3)
	local v = useFocusGuiObject()
	local v2 = p3 or UserInputService
	React.useEffect(function()
		if p2 == nil then
			return
		end

		local inputBeganConnection = v2.InputBegan:Connect(function(input)
			local current = p.current
			local v3

			if current == nil then
				v3 = false
			else
				v3 = v2:GetFocusedTextBox() == current
			end

			local v4

			if current ~= nil then
				v4 = current.Text
			end

			if not shouldFocusBackButtonOnKey(input.KeyCode, v3, v4) then
				return
			end

			local current2 = p2.current

			if current2 == nil then
				return
			end

			if current ~= nil then
				current:ReleaseFocus()
			end

			v(current2)
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { p2, v2 })
end

return useFocusBackButtonOnUp
