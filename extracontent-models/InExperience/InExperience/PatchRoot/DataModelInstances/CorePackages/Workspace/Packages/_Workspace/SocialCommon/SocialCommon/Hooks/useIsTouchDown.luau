local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ReactUtils = require(ParentParentParent.ReactUtils)
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local useEventConnection = ReactUtils.useEventConnection
local InputUtilities = require(ParentParent.Utils.InputUtilities)

return function() -- line: 13
	-- upvalues: React (copy), InputUtilities (copy), useEventConnection (copy), UserInputService (copy)
	local v8, v9 = React.useState(false)
	local v10 = React.useCallback(function(p1) -- line: 16
		-- upvalues: InputUtilities (copy), v9 (copy)
		if InputUtilities.isTouchInput(p1) then
			v9(true)
		end
	end, { v9 })
	local v11 = React.useCallback(function(p2) -- line: 22
		-- upvalues: InputUtilities (copy), v9 (copy)
		if InputUtilities.isTouchInput(p2) then
			v9(false)
		end
	end, { v9 })

	useEventConnection(UserInputService.InputBegan, v10)
	useEventConnection(UserInputService.InputEnded, v11)

	return v8
end
