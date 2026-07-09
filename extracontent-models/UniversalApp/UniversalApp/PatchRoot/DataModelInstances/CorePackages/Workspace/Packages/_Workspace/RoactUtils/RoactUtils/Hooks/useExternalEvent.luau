local Parent = script:FindFirstAncestor("RoactUtils").Parent
local GetFFlagMigrateRoactUtilsToReactUtils = require(Parent.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(Parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.useEventConnection
end

local React = require(Parent.React)

local function useExternalEvent(p1, p2: ((...any) -> ...any)) -- line: 17
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 18
		-- upvalues: p1 (copy), p2 (copy)
		if p1 == nil then
			return nil
		end

		local connection = p1:Connect(p2)

		return function() -- line: 24
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		p1,
		p2
	})
end

return useExternalEvent
