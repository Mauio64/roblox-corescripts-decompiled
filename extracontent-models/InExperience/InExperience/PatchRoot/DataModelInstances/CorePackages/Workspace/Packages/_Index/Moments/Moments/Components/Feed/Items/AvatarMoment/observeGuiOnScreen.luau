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
	local v = nil
	local flag = false

	local function evaluate() -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		local onScreen = isOnScreen(instance)

		if onScreen ~= v then
			v = onScreen
			callback(onScreen)
		end
	end

	local function disconnectAncestors() -- 2 equivalent calls inferred from this helper
		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	local function rewire()
		disconnectAncestors() -- inferred equivalent call
		local instance2 = instance

		while instance2 ~= nil do
			if instance2:IsA("GuiObject") then
				table.insert(connections, instance2:GetPropertyChangedSignal("Visible"):Connect(evaluate))
			elseif instance2:IsA("LayerCollector") then
				table.insert(connections, instance2:GetPropertyChangedSignal("Enabled"):Connect(evaluate))
			end

			instance2 = instance2.Parent
		end

		evaluate() -- inferred equivalent call
	end

	local ancestryChangedConnection = instance.AncestryChanged:Connect(rewire)
	rewire()

	return function()
		flag = true
		ancestryChangedConnection:Disconnect()
		disconnectAncestors() -- inferred equivalent call
	end
end

return observeGuiOnScreen
