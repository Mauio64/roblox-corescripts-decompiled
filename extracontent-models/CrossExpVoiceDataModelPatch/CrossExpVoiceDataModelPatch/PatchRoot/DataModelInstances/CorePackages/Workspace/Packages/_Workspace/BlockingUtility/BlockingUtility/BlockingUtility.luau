local Parent = script:FindFirstAncestor("BlockingUtility").Parent
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Url = require(Parent.Http).Url
local v8 = game:DefineFastFlag("BlockingUtilityClearUnblockedFromBlockedList", false)
local v9 = game:DefineFastFlag("BlockingUtilityRefireOnReplace", false)
local t1 = {}

t1.__index = t1

local UpdatePlayerBlockList = nil

spawn(function() -- line: 23
	-- upvalues: UpdatePlayerBlockList (ref), RobloxReplicatedStorage (copy)
	UpdatePlayerBlockList = RobloxReplicatedStorage:WaitForChild("UpdatePlayerBlockList", 1e999)
end)

local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")
local BindableEvent3 = Instance.new("BindableEvent")
local u15 = false
local BindableEvent4 = Instance.new("BindableEvent")
local t2 = {}
local t3 = {}

local function getBlockedUserIdsFromBlockedList() -- line: 36
	-- upvalues: t2 (ref)
	local t4 = {}

	for v36, _ in t2 do
		table.insert(t4, v36)
	end

	return t4
end
local function getBlockedUserIds() -- line: 44
	-- upvalues: Players (copy), u15 (ref), t2 (ref)
	if Players.LocalPlayer.UserId > 0 then
		local n1 = 0

		repeat
			if u15 then
				local t5 = {}

				for v40, _ in t2 do
					table.insert(t5, v40)
				end

				return t5
			end

			n1 += wait()
		until n1 > 5

		return {}
	end

	return {}
end
local function isBlocked(p1) -- line: 61
	-- upvalues: t2 (ref)
	if t2[p1] then
		return true
	end

	return false
end
local function isMuted(p2) -- line: 68
	-- upvalues: t3 (copy)
	if t3[p2] ~= nil and t3[p2] == true then
		return true
	end

	return false
end
local function BlockPlayerAsync(p3) -- line: 75
	-- upvalues: Players (copy), t2 (ref), BindableEvent (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), UpdatePlayerBlockList (ref), BindableEvent2 (copy)
	local LocalPlayer = Players.LocalPlayer

	if p3 and LocalPlayer ~= p3 then
		local UserId = p3.UserId

		if UserId > 0 then
			if not t2[UserId] then
				t2[UserId] = true
				BindableEvent:Fire(UserId, true)

				local ok, result = pcall(function() -- line: 85
					-- upvalues: Url (copy), p3 (copy), HttpRbxApiService (copy), HttpService (copy)
					local v89 = Url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p3.UserId) .. "/block-user"
					local v90 = HttpRbxApiService:PostAsyncFullUrl(v89, "")

					if v90 then
						return (HttpService:JSONDecode(v90))
					end
				end)

				if ok and result then
					if UpdatePlayerBlockList then
						UpdatePlayerBlockList:FireServer(UserId, true)
					end

					BindableEvent2:Fire(UserId, true)
				else
					t2[UserId] = nil
					BindableEvent:Fire(UserId, false)
				end

				return ok and result
			end

			return true
		end
	end

	return false
end
local function UnblockPlayerAsync(p4) -- line: 119
	-- upvalues: t2 (ref), BindableEvent (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), UpdatePlayerBlockList (ref), BindableEvent2 (copy)
	if p4 then
		local UserId = p4.UserId

		if not not t2[UserId] then
			t2[UserId] = nil
			BindableEvent:Fire(UserId, false)

			local ok, result = pcall(function() -- line: 128
				-- upvalues: Url (copy), p4 (copy), HttpRbxApiService (copy), HttpService (copy)
				local v91 = Url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p4.UserId) .. "/unblock-user"
				local v92 = HttpRbxApiService:PostAsyncFullUrl(v91, "")

				if v92 then
					local data = HttpService:JSONDecode(v92)

					return data and not data.errors
				end
			end)

			if ok and result then
				if UpdatePlayerBlockList then
					UpdatePlayerBlockList:FireServer(UserId, false)
				end

				BindableEvent2:Fire(UserId, false)
			else
				t2[UserId] = true
				BindableEvent:Fire(UserId, true)
			end

			return ok and result
		end

		return true
	end

	return false
end
local function AddPlayerToBlockList(p5) -- line: 165
	-- upvalues: Players (copy), t2 (ref), BindableEvent (copy), UpdatePlayerBlockList (ref), BindableEvent2 (copy)
	local LocalPlayer = Players.LocalPlayer

	if p5 and LocalPlayer ~= p5 then
		local UserId = p5.UserId

		if UserId > 0 then
			if not t2[UserId] then
				t2[UserId] = true
				BindableEvent:Fire(UserId, true)

				if UpdatePlayerBlockList then
					UpdatePlayerBlockList:FireServer(UserId, true)
				end

				if BindableEvent2 then
					BindableEvent2:Fire(UserId, true)
				end
			end

			return true
		end
	end

	return false
end
local function RemovePlayerFromBlockList(p6) -- line: 193
	-- upvalues: t2 (ref), BindableEvent (copy), UpdatePlayerBlockList (ref), BindableEvent2 (copy)
	if p6 then
		local UserId = p6.UserId

		if not not t2[UserId] then
			t2[UserId] = nil
			BindableEvent:Fire(UserId, false)

			if UpdatePlayerBlockList then
				UpdatePlayerBlockList:FireServer(UserId, false)
			end

			if BindableEvent2 then
				BindableEvent2:Fire(UserId, false)
			end
		end

		return true
	end

	return false
end
local function MutePlayer(p7) -- line: 215
	-- upvalues: Players (copy), t3 (copy), BindableEvent3 (copy)
	local LocalPlayer = Players.LocalPlayer

	if p7 and LocalPlayer ~= p7 then
		local UserId = p7.UserId

		if UserId > 0 and (t3[UserId] == nil or t3[UserId] ~= true) then
			t3[UserId] = true
			BindableEvent3:Fire(UserId, true)
		end
	end
end
local function UnmutePlayer(p8) -- line: 228
	-- upvalues: t3 (copy), BindableEvent3 (copy)
	if p8 then
		local UserId = p8.UserId

		t3[UserId] = nil
		BindableEvent3:Fire(UserId, false)
	end
end

local BindableEvent5 = Instance.new("BindableEvent")
local BindableEvent6 = Instance.new("BindableEvent")
local BindableEvent7 = Instance.new("BindableEvent")
local BindableEvent8 = Instance.new("BindableEvent")

local function blockedStatusChanged(p9, p10) -- line: 243
	-- upvalues: Players (copy), BindableEvent5 (copy), BindableEvent6 (copy)
	local PlayerByUserId = Players:GetPlayerByUserId(p9)

	if PlayerByUserId then
		if p10 then
			BindableEvent5:Fire(PlayerByUserId)

			return
		end

		BindableEvent6:Fire(PlayerByUserId)
	end
end

BindableEvent.Event:Connect(blockedStatusChanged)

local function muteStatusChanged(p11, p12) -- line: 256
	-- upvalues: Players (copy), BindableEvent7 (copy), BindableEvent8 (copy)
	local PlayerByUserId = Players:GetPlayerByUserId(p11)

	if PlayerByUserId then
		if p12 then
			BindableEvent7:Fire(PlayerByUserId)

			return
		end

		BindableEvent8:Fire(PlayerByUserId)
	end
end

BindableEvent3.Event:Connect(muteStatusChanged)
StarterGui:RegisterGetCore("PlayerBlockedEvent", function() -- line: 269
	-- upvalues: BindableEvent5 (copy)
	return BindableEvent5
end)
StarterGui:RegisterGetCore("PlayerUnblockedEvent", function() -- line: 272
	-- upvalues: BindableEvent6 (copy)
	return BindableEvent6
end)
StarterGui:RegisterGetCore("PlayerMutedEvent", function() -- line: 275
	-- upvalues: BindableEvent7 (copy)
	return BindableEvent7
end)
StarterGui:RegisterGetCore("PlayerUnmutedEvent", function() -- line: 278
	-- upvalues: BindableEvent8 (copy)
	return BindableEvent8
end)
task.spawn(function() -- line: 282
	-- upvalues: v9 (copy), t2 (ref), u15 (ref), BindableEvent (copy), BindableEvent4 (copy)
	game:GetService("RobloxReplicatedStorage"):WaitForChild("SendPlayerBlockList", 1e999).OnClientEvent:Connect(function(p13) -- line: 285
		-- upvalues: v9 (copy), t2 (ref), u15 (ref), BindableEvent (copy), BindableEvent4 (copy)
		local t6 = {}

		for v96, _ in p13 do
			t6[tonumber(v96)] = true
		end

		if v9 then
			local v98 = t2

			t2 = t6
			u15 = true

			for v99 in t6 do
				if not v98[v99] then
					BindableEvent:Fire(v99, true)
				end
			end

			for v100 in v98 do
				if not t6[v100] then
					BindableEvent:Fire(v100, false)
				end
			end
		else
			t2 = t6
			u15 = true
		end

		BindableEvent4:Fire()
	end)
end)
task.spawn(function() -- line: 315
	-- upvalues: v8 (copy), t2 (ref), BindableEvent (copy)
	game:GetService("RobloxReplicatedStorage"):WaitForChild("UpdateLocalPlayerBlockList", 1e999).OnClientEvent:Connect(function(p14, p15) -- line: 319
		-- upvalues: v8 (copy), t2 (ref), BindableEvent (copy)
		if v8 then
			t2[p14] = not not p15 or nil
		else
			t2[p14] = p15
		end

		BindableEvent:Fire(p14, p15)
	end)
end)

function t1.BlockPlayerAsync(_, p17) -- line: 329
	-- upvalues: BlockPlayerAsync (copy)
	return (BlockPlayerAsync(p17))
end
function t1.UnblockPlayerAsync(_, p19) -- line: 333
	-- upvalues: UnblockPlayerAsync (copy)
	return (UnblockPlayerAsync(p19))
end
function t1.MutePlayer(_, p21) -- line: 337
	-- upvalues: MutePlayer (copy)
	return MutePlayer(p21)
end
function t1.UnmutePlayer(_, p23) -- line: 341
	-- upvalues: UnmutePlayer (copy)
	return UnmutePlayer(p23)
end
function t1.IsPlayerBlockedByUserId(_, p25) -- line: 345
	-- upvalues: t2 (ref)
	if t2[p25] then
		return true
	end

	return false
end
function t1.GetBlockedStatusChangedEvent(_) -- line: 349
	-- upvalues: BindableEvent (copy)
	return BindableEvent.Event
end
function t1.GetAfterBlockedStatusChangedEvent(_) -- line: 355
	-- upvalues: BindableEvent2 (copy)
	return BindableEvent2.Event
end
function t1.GetMutedStatusChangedEvent(_) -- line: 359
	-- upvalues: BindableEvent3 (copy)
	return BindableEvent3.Event
end
function t1.IsPlayerMutedByUserId(_, p30) -- line: 363
	-- upvalues: t3 (copy)
	if t3[p30] ~= nil and t3[p30] == true then
		return true
	end

	return false
end
function t1.GetBlockedUserIdsAsync(_) -- line: 367
	-- upvalues: getBlockedUserIds (copy)
	return (getBlockedUserIds())
end
function t1.AddPlayerToBlockList(_, p33) -- line: 371
	-- upvalues: AddPlayerToBlockList (copy)
	return (AddPlayerToBlockList(p33))
end
function t1.RemovePlayerFromBlockList(_, p35) -- line: 375
	-- upvalues: RemovePlayerFromBlockList (copy)
	return (RemovePlayerFromBlockList(p35))
end

return t1
