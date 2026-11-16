local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)

local function useAutocompleteKeyboardNavigation(flag: boolean, callback, p)
	local v = "AutocompleteSourcesSink_" .. tostring((React.useRef({})))
	local inputBegan

	if p == nil then
		inputBegan = UserInputService.InputBegan
	else
		inputBegan = p.InputBegan
	end

	React.useEffect(function()
		if callback == nil then
			return
		end

		local connection = inputBegan:Connect(function(p2)
			callback(p2.KeyCode)
		end)
		return function()
			connection:Disconnect()
		end
	end, { callback, inputBegan })

	React.useEffect(function()
		if not flag then
			return
		end

		ContextActionService:BindCoreAction(v, function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Escape)
		return function()
			ContextActionService:UnbindCoreAction(v)
		end
	end, { flag, v })
end

return useAutocompleteKeyboardNavigation
