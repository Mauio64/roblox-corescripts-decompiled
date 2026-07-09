local Parent = script:FindFirstAncestor("Responsive").Parent
local React = require(Parent.React)
local RoactServiceTags = require(Parent.RoactServiceTags)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService

local function useIsInFullScreen() -- line: 6
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), React (copy)
	local v6 = useRoactService(RoactServiceTags.AppUserGameSettings)
	local v7, v8 = React.useState(v6:InFullScreen())

	React.useEffect(function() -- line: 10
		-- upvalues: v8 (copy), v6 (copy)
		v8(v6:InFullScreen())

		local connection = v6.FullscreenChanged:Connect(function(b1: boolean) -- line: 12
			-- upvalues: v8 (copy)
			v8(b1)
		end)

		return function() -- line: 16
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v7
end

return useIsInFullScreen
