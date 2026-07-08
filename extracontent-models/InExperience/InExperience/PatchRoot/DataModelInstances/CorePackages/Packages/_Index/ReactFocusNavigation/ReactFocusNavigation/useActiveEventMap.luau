local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useActiveEventMap() -- line: 13
	-- upvalues: React (copy), FocusNavigationContext (copy)
	local v5 = React.useContext(FocusNavigationContext)
	local v6 = if not v5 then {} else v5.activeEventMap:getValue()
	local v7, v8 = React.useState(v6)

	React.useEffect(function() -- line: 18
		-- upvalues: v7 (copy), v6 (copy), v8 (copy), v5 (copy)
		if v7 ~= v6 then
			v8(v6)
		end

		if v5 then
			local v9 = v5.activeEventMap:subscribe(v8)

			return function() -- line: 27
				-- upvalues: v9 (copy)
				v9:unsubscribe()
			end
		end

		return nil
	end, { v5 })

	return v7
end

return useActiveEventMap
