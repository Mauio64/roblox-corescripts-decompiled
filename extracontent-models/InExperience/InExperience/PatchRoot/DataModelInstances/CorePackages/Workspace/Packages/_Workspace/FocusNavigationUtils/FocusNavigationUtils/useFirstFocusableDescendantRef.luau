local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)
local getFirstFocusableDescendant = require(script.Parent.getFirstFocusableDescendant)

local function safeDisconnect(connection) -- 5 equivalent calls inferred from this helper
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
			safeDisconnect(selectableChangedConnection) -- inferred equivalent call
			safeDisconnect(ancestryChangedConnection) -- inferred equivalent call
			local firstFocusableDescendant = getFirstFocusableDescendant(instance2)

			if firstFocusableDescendant then
				selectableChangedConnection = firstFocusableDescendant:GetPropertyChangedSignal("Selectable"):Connect(function()
					updateFirstFocusable(instance2)
				end)

				ancestryChangedConnection = firstFocusableDescendant.AncestryChanged:Connect(function()
					updateFirstFocusable(instance2)
				end)
			end

			ref.current = firstFocusableDescendant
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
			safeDisconnect(selectableChangedConnection) -- inferred equivalent call
			safeDisconnect(descendantAddedConnection) -- inferred equivalent call
			safeDisconnect(ancestryChangedConnection) -- inferred equivalent call
		end
	end, { instance })

	return ref
end

return useFirstFocusableDescendantRef
