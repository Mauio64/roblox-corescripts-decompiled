local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)

local function useDismissOnEscapeOrMenu(flag: boolean, callback, p, p2)
	local v = p or UserInputService
	local v2 = p2 or GuiService
	React.useEffect(function()
		if not flag then
			return
		end

		local flag2 = false
		local function dismissOnce() -- 1 equivalent call inferred from this helper
			if flag2 then
				return
			end

			flag2 = true
			callback()
		end
		local inputBeganConnection = v.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
				dismissOnce() -- inferred equivalent call
			end
		end)
		local menuOpenedConnection = v2.MenuOpened:Connect(dismissOnce)
		return function()
			inputBeganConnection:Disconnect()
			menuOpenedConnection:Disconnect()
		end
	end, { flag, callback, v, v2 })
end

return useDismissOnEscapeOrMenu
