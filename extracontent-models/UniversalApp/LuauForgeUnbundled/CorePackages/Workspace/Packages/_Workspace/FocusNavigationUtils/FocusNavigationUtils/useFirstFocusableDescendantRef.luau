local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local getFirstFocusableDescendant = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/getFirstFocusableDescendant")

local function safeDisconnect(connection)
	if connection then
		connection:Disconnect()
	end
end

local function useFirstFocusableDescendantRef(instance)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local selectableChangedConnection = nil
		local descendantAddedConnection = nil
		local ancestryChangedConnection = nil
		local function updateFirstFocusable(instance2)
			local connection = selectableChangedConnection

			if connection then
				connection:Disconnect()
			end

			local connection2 = ancestryChangedConnection

			if connection2 then
				connection2:Disconnect()
			end

			local v5 = getFirstFocusableDescendant(instance2)

			if v5 then
				selectableChangedConnection = v5:GetPropertyChangedSignal("Selectable"):Connect(function()
					updateFirstFocusable(instance2)
				end)

				ancestryChangedConnection = v5.AncestryChanged:Connect(function()
					updateFirstFocusable(instance2)
				end)
			end

			ref.current = v5
		end

		if instance then
			updateFirstFocusable(instance)
			descendantAddedConnection = instance.DescendantAdded:Connect(function()
				updateFirstFocusable(instance)
			end)
		else
			ref.current = nil
		end

		return function()
			local connection = selectableChangedConnection

			if connection then
				connection:Disconnect()
			end

			local connection2 = descendantAddedConnection

			if connection2 then
				connection2:Disconnect()
			end

			local connection3 = ancestryChangedConnection

			if connection3 then
				connection3:Disconnect()
			end
		end
	end, { instance })

	return ref
end

return useFirstFocusableDescendantRef
