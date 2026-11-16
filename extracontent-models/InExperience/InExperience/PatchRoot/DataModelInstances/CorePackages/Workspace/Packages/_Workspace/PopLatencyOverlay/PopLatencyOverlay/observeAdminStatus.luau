local function observeAdminStatus(instance, callback, callback2)
	local count = 0
	local userIdChangedConnection = nil
	local v = nil
	local v2 = nil
	local v3 = nil
	local v4 = nil

	local function disconnectUserIdConnection() -- 3 equivalent calls inferred from this helper
		if userIdChangedConnection then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end
	end

	local function refresh()
		count += 1
		v4 = nil
		v = nil
		v2 = nil
		v3 = nil
		disconnectUserIdConnection() -- inferred equivalent call
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

		if v == localPlayer and v2 == userId and v3 ~= nil then
			return v3
		end

		if v4 == count then
			return false
		end

		local v5 = count
		v4 = v5
		local success, result = pcall(function()
			return callback(userId)
		end)

		if v4 == v5 then
			v4 = nil
		end

		if v5 ~= count or instance.LocalPlayer ~= localPlayer or localPlayer.UserId ~= userId or not success then
			return false
		end

		v = localPlayer
		v2 = userId
		v3 = result == true
		return v3
	end

	local localPlayerChangedConnection = instance:GetPropertyChangedSignal("LocalPlayer"):Connect(refresh)
	count += 1
	v4 = nil
	v = nil
	v2 = nil
	v3 = nil
	disconnectUserIdConnection() -- inferred equivalent call
	local localPlayer = instance.LocalPlayer

	if localPlayer then
		userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(refresh)
	end

	callback2()

	local function disconnect()
		count += 1
		disconnectUserIdConnection() -- inferred equivalent call
		localPlayerChangedConnection:Disconnect()
	end

	return authorize, disconnect
end

return observeAdminStatus
