return {
	lock = function(button, button2, state)
		local v = {}
		local connections = {}
		local v2 = false

		local v3 = {}

		local function writeLocked(instance) -- 2 equivalent calls inferred from this helper
			if not instance.Active then
				return
			end

			v3[instance] = false
			instance.Active = false
		end

		local function suppress(button3)
			if v[button3] ~= nil then
				return
			end

			v[button3] = button3.Active
			table.insert(connections, button3:GetPropertyChangedSignal("Active"):Connect(function()
				if v3[button3] == button3.Active then
					v3[button3] = nil
					return
				end

				v[button3] = button3.Active

				if not v2 and button3.Active then
					writeLocked(button3) -- inferred equivalent call
				end
			end))

			table.insert(connections, button3:GetPropertyChangedSignal("Interactable"):Connect(function()
				v[button3] = button3.Interactable
			end))
			writeLocked(button3) -- inferred equivalent call
		end

		local parent

		if state == nil or state.Parent == button then
			parent = nil
		else
			parent = state.Parent
		end

		if button ~= nil then
			if button:IsA("GuiButton") then
				suppress(button)
			end

			for _, button3 in button:GetDescendants() do
				if button3:IsA("GuiButton") and button3 ~= parent then
					suppress(button3)
				end
			end

			table.insert(connections, button.DescendantAdded:Connect(function(button3)
				if button3:IsA("GuiButton") and button3 ~= parent then
					suppress(button3)
				end
			end))
		end

		if button2 ~= nil and button2:IsA("GuiButton") then
			suppress(button2)
		end

		local scrollingEnabled

		if state == nil then
			scrollingEnabled = nil
		else
			scrollingEnabled = state.ScrollingEnabled
		end

		if state ~= nil then
			state.ScrollingEnabled = false
		end

		return function()
			v2 = true

			for _, connection in connections do
				connection:Disconnect()
			end

			for k, active in v do
				if k.Parent ~= nil then
					k.Active = active
				end
			end

			table.clear(v)

			if state ~= nil and state.Parent ~= nil and scrollingEnabled ~= nil then
				state.ScrollingEnabled = scrollingEnabled
			end
		end
	end
}
