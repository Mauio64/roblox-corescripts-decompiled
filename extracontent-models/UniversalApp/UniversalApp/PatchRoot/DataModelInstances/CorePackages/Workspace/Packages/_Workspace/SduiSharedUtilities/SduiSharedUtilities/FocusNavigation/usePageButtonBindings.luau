local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local CollectionService = game:GetService("CollectionService")
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local SduiFocusTags = require(script.Parent.SduiFocusTags)

local function usePageButtonBindings(t1: {[any]: any}, p1, p2) -- line: 16
	-- upvalues: React (copy), CollectionService (copy), SduiFocusTags (copy), ReactFocusNavigation (copy)
	local v10, v11 = React.useState(true)

	React.useEffect(function() -- line: 23
		-- upvalues: CollectionService (copy), SduiFocusTags (copy), t1 (copy), v11 (copy)
		local function updateSuppression() -- line: 24
			-- upvalues: CollectionService (copy), SduiFocusTags (copy), t1 (copy), v11 (copy)
			local v17 = false

			for _, v19 in CollectionService:GetTagged(SduiFocusTags.SuppressBindings) do
				if t1.current and v19:IsDescendantOf(t1.current) then
					v17 = true

					break
				end
			end

			v11(not v17)
		end

		updateSuppression()

		local connection = CollectionService:GetInstanceAddedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)
		local connection2 = CollectionService:GetInstanceRemovedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)

		return function() -- line: 42
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { t1 })

	local v12 = React.useRef(nil)
	local v13 = ReactFocusNavigation.useEventMap(if not v10 then {} else p1, v12)

	return (ReactFocusNavigation.useEventHandlerMap(if not v10 then {} else p2, v13))
end

return usePageButtonBindings
