local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useCurrentFocus() -- line: 11
	-- upvalues: React (copy), FocusNavigationContext (copy)
	local v5 = React.useContext(FocusNavigationContext)
	local v6 = if not v5 then nil else v5.focusedGuiObject:getValue()
	local v7, v8 = React.useState(v6)

	React.useEffect(function() -- line: 16
		-- upvalues: v7 (copy), v6 (copy), v8 (copy), v5 (copy)
		if v7 ~= v6 then
			v8(v6)
		end

		if v5 then
			local v9 = v5.focusedGuiObject:subscribe(v8)

			return function() -- line: 25
				-- upvalues: v9 (copy)
				v9:unsubscribe()
			end
		end

		return nil
	end, { v5 })

	return v7
end

return useCurrentFocus
