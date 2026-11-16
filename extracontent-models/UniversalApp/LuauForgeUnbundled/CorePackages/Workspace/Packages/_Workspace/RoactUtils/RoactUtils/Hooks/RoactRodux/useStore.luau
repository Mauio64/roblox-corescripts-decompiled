local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local storeContext = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactRodux").StoreContext

local function useStore()
	local v5 = React.useContext(storeContext)
	assert(
		v5,
		"useDispatch and useSelector can only be called from a descendant of the Rodux Store Provider"
	)
	return v5
end

return useStore
