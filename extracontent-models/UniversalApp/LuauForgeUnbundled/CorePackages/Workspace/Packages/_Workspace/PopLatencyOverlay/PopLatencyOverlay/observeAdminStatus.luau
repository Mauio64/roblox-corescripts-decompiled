local function observeAdminStatus(instance, callback, callback2)
	local count = 0
	local userIdChangedConnection = nil
	local v5 = nil
	local v6 = nil
	local v7 = nil
	local v8 = nil

	local function disconnectUserIdConnection()
		if userIdChangedConnection then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end
	end

	local function refresh()
		count += 1
		v8 = nil
		v5 = nil
		v6 = nil
		v7 = nil

		if userIdChangedConnection then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		local localPlayer = instance.LocalPlayer

		if localPlayer then
			userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(refresh)
		end

		callback2()
	end

	local function authorize()
		local localPlayer = instance.LocalPlayer

		if not localPlayer or localPlayer.UserId <= 0 then
			return false
		end

		local userId = localPlayer.UserId

		if v5 == localPlayer and v6 == userId and v7 ~= nil then
			return v7
		end

		if v8 == count then
			return false
		end

		local v9 = count
		v8 = v9
		local success, result = pcall(function()
			return callback(userId)
		end)

		if v8 == v9 then
			v8 = nil
		end

		if
			v9 ~= count
			or instance.LocalPlayer ~= localPlayer
			or localPlayer.UserId ~= userId
			or not success
		then
			return false
		end

		v5 = localPlayer
		v6 = userId
		v7 = result == true
		return v7
	end

	local localPlayerChangedConnection = instance:GetPropertyChangedSignal("LocalPlayer"):Connect(refresh)
	count += 1
	v8 = nil
	v5 = nil
	v6 = nil
	v7 = nil

	if userIdChangedConnection then
		userIdChangedConnection:Disconnect()
		userIdChangedConnection = nil
	end

	local localPlayer = instance.LocalPlayer

	if localPlayer then
		userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(refresh)
	end

	callback2()

	local function disconnect()
		count += 1

		if userIdChangedConnection then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		localPlayerChangedConnection:Disconnect()
	end

	return authorize, disconnect
end

return observeAdminStatus
