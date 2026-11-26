local function isOnScreen(instance): boolean
	if not instance:IsDescendantOf(game) then
		return false
	end

	while instance ~= nil do
		if instance:IsA("GuiObject") and not instance.Visible then
			return false
		end

		if instance:IsA("LayerCollector") and not instance.Enabled then
			return false
		end

		instance = instance.Parent
	end

	return true
end

local function observeGuiOnScreen(instance, callback)
	local connections = {}
	local v5 = nil
	local flag = false

	local function evaluate()
		if flag then
			return
		end

		local onScreen = isOnScreen(instance)

		if onScreen ~= v5 then
			v5 = onScreen
			callback(onScreen)
		end
	end

	local function disconnectAncestors()
		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	local function rewire()
		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		local instance2 = instance

		while instance2 ~= nil do
			if instance2:IsA("GuiObject") then
				table.insert(connections, instance2:GetPropertyChangedSignal("Visible"):Connect(evaluate))
			elseif instance2:IsA("LayerCollector") then
				table.insert(connections, instance2:GetPropertyChangedSignal("Enabled"):Connect(evaluate))
			end

			instance2 = instance2.Parent
		end

		if flag then
			return
		end

		local onScreen = isOnScreen(instance)

		if onScreen ~= v5 then
			v5 = onScreen
			callback(onScreen)
		end
	end

	local ancestryChangedConnection = instance.AncestryChanged:Connect(rewire)
	rewire()

	return function()
		flag = true
		ancestryChangedConnection:Disconnect()

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end
end

return observeGuiOnScreen
