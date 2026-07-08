local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local StoreContext = require(Parent.RoactRodux).StoreContext

local function useStore() -- line: 16
	-- upvalues: React (copy), StoreContext (copy)
	local v5 = React.useContext(StoreContext)

	assert(v5, "useDispatch and useSelector can only be called from a descendant of the Rodux Store Provider")

	return v5
end

return useStore
