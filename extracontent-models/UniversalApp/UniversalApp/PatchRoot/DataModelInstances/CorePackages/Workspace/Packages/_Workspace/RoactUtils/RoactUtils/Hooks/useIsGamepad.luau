local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local isGamepadInput = require(script.Parent.Parent.isGamepadInput)

local function useIsGamepad(p1) -- line: 13
	-- upvalues: UserInputService (copy), isGamepadInput (copy), React (copy), useExternalEvent (copy)
	local v8 = p1 or UserInputService

	local function wasLastInputGamepad() -- line: 16
		-- upvalues: v8 (copy), isGamepadInput (copy)
		local LastInputType = v8:GetLastInputType()

		return isGamepadInput(LastInputType)
	end

	local v10, v11 = React.useState(wasLastInputGamepad)
	local v12 = React.useCallback(function(p2) -- line: 23
		-- upvalues: isGamepadInput (copy), v11 (copy)
		local v15 = isGamepadInput(p2)

		if v15 ~= nil then
			v11(v15)
		end
	end)

	useExternalEvent(v8.LastInputTypeChanged, v12)
	React.useEffect(function() -- line: 34
		-- upvalues: v11 (copy), wasLastInputGamepad (copy)
		v11(wasLastInputGamepad())
	end, {})

	return v10
end

return useIsGamepad
