local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/RoactRodux/useStore")

local function useDispatch()
	local v5 = useStore()

	return (React.useCallback(function(...)
		return v5:dispatch(...)
	end, { v5 }))
end

return useDispatch
