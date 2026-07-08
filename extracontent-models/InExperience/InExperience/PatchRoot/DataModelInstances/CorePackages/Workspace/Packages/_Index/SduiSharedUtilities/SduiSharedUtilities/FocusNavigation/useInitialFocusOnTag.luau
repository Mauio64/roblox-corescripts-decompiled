local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local CollectionService = game:GetService("CollectionService")
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Responsive = require(Parent.Responsive)

local function useInitialFocusOnTag(s1: string, t1: {[any]: any}) -- line: 12
	-- upvalues: Responsive (copy), ReactFocusNavigation (copy), React (copy), CollectionService (copy)
	local v9 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v10 = ReactFocusNavigation.useFocusGuiObject()
	local v11 = React.useRef(false)

	React.useEffect(function() -- line: 17
		-- upvalues: v9 (copy), t1 (copy), CollectionService (copy), s1 (copy), v11 (copy), v10 (copy)
		if not v9 then
			return
		end

		local current = t1.current

		if not current then
			return
		end

		for _, v14 in CollectionService:GetTagged(s1) do
			if not v11.current and v14:IsDescendantOf(current) then
				v11.current = true
				v10(v14)

				return
			end
		end

		local connection = CollectionService:GetInstanceAddedSignal(s1):Connect(function(p1) -- line: 35
			-- upvalues: v11 (copy), current (copy), v10 (copy)
			if not v11.current and (current and p1:IsDescendantOf(current)) then
				v11.current = true
				v10(p1)
			end
		end)

		return function() -- line: 42
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v9,
		s1,
		v10
	})
end

return useInitialFocusOnTag
