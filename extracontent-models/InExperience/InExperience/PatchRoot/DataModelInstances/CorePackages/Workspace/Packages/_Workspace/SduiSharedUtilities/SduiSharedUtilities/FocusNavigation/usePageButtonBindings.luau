local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local CollectionService = game:GetService("CollectionService")

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SduiFocusTags = require(script.Parent.SduiFocusTags)

local function usePageButtonBindings(p, p2, p3)
	local state, setState = React.useState(true)

	React.useEffect(function()
		local function updateSuppression()
			local v = false

			for _, v2 in CollectionService:GetTagged(SduiFocusTags.SuppressBindings) do
				if p.current and v2:IsDescendantOf(p.current) then
					v = true
					break
				end
			end

			setState(not v)
		end

		updateSuppression()

		local connection = CollectionService:GetInstanceAddedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)
		local connection2 = CollectionService:GetInstanceRemovedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { p })

	local ref = React.useRef(nil)
	local v = ReactFocusNavigation.useEventMap(not state and {} or p2, ref)
	return (ReactFocusNavigation.useEventHandlerMap(not state and {} or p3, v))
end

return usePageButtonBindings
