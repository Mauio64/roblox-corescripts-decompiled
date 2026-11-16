local parent = script:FindFirstAncestor("RoactUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagMigrateRoactUtilsToReactUtils = SharedFlags.GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.usePrevious
end

local React = require(parent.React)

local function usePrevious(current)
	local ref = React.useRef(nil)
	React.useEffect(function()
		ref.current = current
	end)
	return ref.current
end

return usePrevious
