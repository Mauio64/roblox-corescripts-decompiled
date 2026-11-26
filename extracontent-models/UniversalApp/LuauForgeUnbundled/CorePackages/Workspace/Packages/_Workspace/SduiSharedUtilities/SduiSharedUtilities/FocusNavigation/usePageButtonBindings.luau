local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")
local SduiFocusTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/SduiFocusTags")

local function usePageButtonBindings(p2, p3, p4)
	local state, setState = React.useState(true)

	React.useEffect(function()
		local function updateSuppression()
			local v5 = false

			for k, v7 in CollectionService:GetTagged(SduiFocusTags.SuppressBindings) do
				if p2.current and v7:IsDescendantOf(p2.current) then
					v5 = true
					break
				end
			end

			setState(not v5)
		end

		updateSuppression()

		local connection = CollectionService:GetInstanceAddedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)
		local connection2 = CollectionService:GetInstanceRemovedSignal(SduiFocusTags.SuppressBindings):Connect(updateSuppression)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { p2 })

	local ref = React.useRef(nil)
	local v5 = ReactFocusNavigation.useEventMap(not state and {} or p3, ref)
	return (ReactFocusNavigation.useEventHandlerMap(not state and {} or p4, v5))
end

return usePageButtonBindings
