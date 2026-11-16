local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)

local StoreContext = RoactRodux.StoreContext

local function useStore()
	local v = React.useContext(StoreContext)
	assert(v, "useDispatch and useSelector can only be called from a descendant of the Rodux Store Provider")
	return v
end

return useStore
