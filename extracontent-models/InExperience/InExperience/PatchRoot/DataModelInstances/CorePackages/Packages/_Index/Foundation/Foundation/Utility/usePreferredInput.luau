local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local UserInputService = require(Foundation.Utility.Wrappers.Services).UserInputService

local function usePreferredInput() -- line: 7
	-- upvalues: React (copy), UserInputService (copy)
	local v6, v7 = React.useState(UserInputService.PreferredInput)

	React.useEffect(function() -- line: 10
		-- upvalues: UserInputService (copy), v7 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 12
			-- upvalues: v7 (copy), UserInputService (copy)
			v7(UserInputService.PreferredInput)
		end)

		v7(UserInputService.PreferredInput)

		return function() -- line: 18
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	return v6
end

return usePreferredInput
