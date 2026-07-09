local Parent = script:FindFirstAncestor("RoactUtils").Parent
local GetFFlagMigrateRoactUtilsToReactUtils = require(Parent.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(Parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.usePrevious
end

local React = require(Parent.React)

local function usePrevious(p1) -- line: 16
	-- upvalues: React (copy)
	local v7 = React.useRef(nil)

	React.useEffect(function() -- line: 18
		-- upvalues: v7 (copy), p1 (copy)
		v7.current = p1
	end)

	return v7.current
end

return usePrevious
