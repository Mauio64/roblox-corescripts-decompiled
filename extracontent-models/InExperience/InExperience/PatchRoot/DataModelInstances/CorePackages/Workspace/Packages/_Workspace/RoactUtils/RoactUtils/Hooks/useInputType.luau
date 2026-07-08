local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local getInputGroup = require(Parent.InputType).getInputGroup

local function useInputType(p1) -- line: 13
	-- upvalues: UserInputService (copy), getInputGroup (copy), React (copy), useExternalEvent (copy)
	local v8 = p1 or UserInputService

	local function getLastInputType() -- line: 16
		-- upvalues: v8 (copy), getInputGroup (copy)
		local LastInputType = v8:GetLastInputType()

		return getInputGroup(LastInputType)
	end

	local v10, v11 = React.useState(getLastInputType)
	local v12 = React.useCallback(function(p2) -- line: 23
		-- upvalues: getInputGroup (copy), v11 (copy)
		local v15 = getInputGroup(p2)

		if v15 ~= nil then
			v11(v15)
		end
	end)

	useExternalEvent(v8.LastInputTypeChanged, v12)
	React.useEffect(function() -- line: 34
		-- upvalues: v11 (copy), getLastInputType (copy)
		v11(getLastInputType())
	end, {})

	return v10
end

return useInputType
