local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSetDrawerVisible = require(Parent.Drawer).Hooks.useSetDrawerVisible
local GetDrawerVisibleStore = require(Parent.Drawer).Stores.GetDrawerVisibleStore

local function useDismissFlyoutOnPartyTopBanner() -- line: 9
	-- upvalues: useSetDrawerVisible (copy), useSelector (copy), React (copy), GetDrawerVisibleStore (copy)
	local v7 = useSetDrawerVisible()
	local v8 = useSelector(function(p1) -- line: 12
		if p1.AppTopBanner then
			return p1.AppTopBanner.expanded
		end

		return false
	end)
	local v9 = React.useRef(v8)

	React.useEffect(function() -- line: 18
		-- upvalues: GetDrawerVisibleStore (copy), v9 (copy), v8 (copy), v7 (copy)
		if GetDrawerVisibleStore(false).getDrawerVisible() and (v9.current and not v8) then
			v7(false)
		end

		v9.current = v8
	end, {
		v8,
		v7
	})
end

return useDismissFlyoutOnPartyTopBanner
