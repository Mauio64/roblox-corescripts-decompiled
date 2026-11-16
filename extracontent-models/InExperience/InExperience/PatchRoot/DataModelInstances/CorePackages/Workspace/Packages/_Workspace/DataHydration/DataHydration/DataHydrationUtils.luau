local parent = script:FindFirstAncestor("DataHydration").Parent

local Players = game:GetService("Players")

local Cryo = require(parent.Cryo)

local function getLocalPlayerUserId() -- 2 equivalent calls inferred from this helper
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	return if not (userId == nil or userId <= 0) then userId else nil
end

local DataHydrationUtils = {}

function DataHydrationUtils.areAllKeysPresent(p, list): boolean
	if p == nil or type(p) ~= "table" then
		return #list == 0
	end

	for _, item in list do
		if p[item] == nil then
			return false
		end
	end

	return true
end

DataHydrationUtils.getLocalPlayerUserId = getLocalPlayerUserId

function DataHydrationUtils.observeLocalPlayerUserId(callback)
	local userId = getLocalPlayerUserId() -- inferred equivalent call
	local userIdChangedConnection = nil

	local flag = false

	local function notifyIfChanged() -- 1 equivalent call inferred from this helper
		local localPlayerUserId = getLocalPlayerUserId() -- inferred equivalent call

		if localPlayerUserId == userId then
			return
		end

		userId = localPlayerUserId
		callback(localPlayerUserId)
	end

	local function bindLocalPlayer() -- 2 equivalent calls inferred from this helper
		if userIdChangedConnection ~= nil then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		local localPlayer = Players.LocalPlayer

		if localPlayer ~= nil then
			userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(notifyIfChanged)
		end
	end

	bindLocalPlayer() -- inferred equivalent call
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		bindLocalPlayer() -- inferred equivalent call
		notifyIfChanged() -- inferred equivalent call
	end)

	return function()
		if flag then
			return
		end

		flag = true

		if userIdChangedConnection ~= nil then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		if localPlayerChangedConnection ~= nil then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end
	end
end

function DataHydrationUtils.mergeListsWithoutDuplicates(list, list2, p: string?)
	if list2 and #list2 ~= 0 then
		if not list or #list == 0 then
			return list2
		end

		local set = Cryo.List.toSet(Cryo.List.map(list, function(p2)
			if p then
				return p2[p]
			end

			return p2
		end))

		local filtered = Cryo.List.filter(list2, function(p2): boolean
			if p then
				p2 = p2[p]
			end

			return not set[p2]
		end)

		return Cryo.List.join(table.clone(list), filtered)
	end

	return list or {}
end

return DataHydrationUtils
