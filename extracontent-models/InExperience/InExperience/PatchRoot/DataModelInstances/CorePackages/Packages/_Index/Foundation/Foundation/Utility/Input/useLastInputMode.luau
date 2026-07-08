local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(FoundationParent.React)
local useEventConnection = require(FoundationParent.ReactUtils).useEventConnection

require(Foundation.Utility.Input.InputMode)

local getInputMode = require(Foundation.Utility.Input.getInputMode)

local function getLastInputMode() -- line: 16
	-- upvalues: getInputMode (copy), UserInputService (copy)
	return getInputMode(UserInputService:GetLastInputType())
end
local function useLastInputMode() -- line: 20
	-- upvalues: React (copy), getLastInputMode (copy), useEventConnection (copy), UserInputService (copy)
	local v9, v10 = React.useState(getLastInputMode)

	useEventConnection(UserInputService.LastInputTypeChanged, function() -- line: 23
		-- upvalues: v10 (copy), getLastInputMode (copy)
		v10(getLastInputMode())
	end)

	return v9
end

return useLastInputMode
