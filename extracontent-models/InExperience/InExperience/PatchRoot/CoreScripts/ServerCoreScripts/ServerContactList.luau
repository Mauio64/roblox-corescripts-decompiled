local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local SocialService = game:GetService("SocialService")
local TeleportService = game:GetService("TeleportService")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local EngineFeature = game:GetEngineFeature("EnableIrisRerouteToRCC")
local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "ContactListInvokeIrisInvite"
RemoteEvent.Parent = RobloxReplicatedStorage
RemoteEvent.OnServerEvent:Connect(function(player, p1, p2, p3, p4, p5, p6, p7) -- line: 22
	-- upvalues: SocialService (copy), EngineFeature (copy)
	if typeof(p1) ~= "string" or #p1 > 1000 or typeof(p3) ~= "string" or #p3 > 1000 or typeof(p2) ~= "number" then
		return
	end

	SocialService:InvokeIrisInvite(player, p1, {
		{
			userId = player.UserId,
			combinedName = player.DisplayName,
			muted = p4,
			camEnabled = p5,
			userAgent = if not EngineFeature then nil else p6,
			version = if not EngineFeature then nil else p7
		},
		{
			userId = p2,
			combinedName = p3
		}
	})
end)

local RemoteEvent2 = Instance.new("RemoteEvent")

RemoteEvent2.Name = "ContactListIrisInviteTeleport"
RemoteEvent2.Parent = RobloxReplicatedStorage

local t1 = {}

Players.PlayerRemoving:Connect(function(player) -- line: 56
	-- upvalues: t1 (copy)
	t1[player.UserId] = nil
end)

local function validateCallId(s1: string) -- line: 60
	if typeof(s1) ~= "string" or #s1 > 50 then
		return false
	end

	return string.match(s1, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

RemoteEvent2.OnServerEvent:Connect(function(player, p8, _, _, p11) -- line: 69
	-- upvalues: t1 (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), TeleportService (copy)
	local v36 = t1[player.UserId]

	if v36 ~= nil and v36 > 5 then
		return
	end

	if v36 == nil then
		t1[player.UserId] = 1
	else
		t1[player.UserId] = v36 + 1
	end

	if typeof(p11) ~= "string" or (#p11 > 50 or string.match(p11, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") == nil) or typeof(p8) ~= "number" or p8 <= 0 then
		return
	end

	if typeof(p11) == "string" and #p11 <= 50 then
		local ok, result = pcall(function() -- line: 86
			-- upvalues: Url (copy), p11 (copy), player (copy), HttpRbxApiService (copy), HttpService (copy)
			local v69 = Url.APIS_URL .. `call/v1/get-call-status-rcc?callId={ p11 }&userId={ player.UserId }`
			local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v69)

			return HttpService:JSONDecode(AsyncFullUrl)
		end)

		if ok and result.status == "CallAccepted" and result.reservedServerAccessCode then
			local TeleportOptions = Instance.new("TeleportOptions")

			TeleportOptions.ReservedServerAccessCode = result.reservedServerAccessCode
			TeleportService:TeleportAsync(p8, { player }, TeleportOptions)
		end
	end
end)

local RemoteEvent3 = Instance.new("RemoteEvent")

RemoteEvent3.Name = "UpdateCurrentCall"
RemoteEvent3.Parent = RobloxReplicatedStorage

local u15 = nil
local t2 = {}

local function enforceCallParticipants() -- line: 109
	-- upvalues: u15 (ref), Players (copy)
	if u15 ~= nil then
		local v40 = false

		for _, player in pairs(Players:GetPlayers()) do
			local str = tostring(player.UserId)

			if table.find(u15.participants, str) == nil then
				v40 = true

				break
			end
		end

		if v40 then
			for _, player in pairs(Players:GetPlayers()) do
				local str = tostring(player.UserId)

				if table.find(u15.participants, str) ~= nil then
					player:Kick()
				end
			end

			u15 = nil
		end
	end
end
local function terminateCall(s2: string) -- line: 138
	-- upvalues: Url (copy), HttpService (copy), HttpRbxApiService (copy)
	local ok, _ = pcall(function() -- line: 139
		-- upvalues: Url (copy), HttpService (copy), s2 (copy), HttpRbxApiService (copy)
		local v71 = Url.APIS_URL .. "call/v1/force-terminate-call-rcc"
		local json = HttpService:JSONEncode({
			callId = s2
		})
		local v73 = HttpRbxApiService:PostAsyncFullUrl(v71, json)

		return HttpService:JSONDecode(v73)
	end)

	return ok
end
local function validateCallParticipants(t3: {[any]: any}) -- line: 148
	if typeof(t3) ~= "table" or t3 == nil or #t3 ~= 2 then
		return false
	end

	for _, v in ipairs(t3) do
		if typeof(v) ~= "string" or #v > 50 or tonumber(v) == nil then
			return false
		end
	end

	return true
end
local function validateCall(p12, s3: string, t4: {[any]: any}) -- line: 161
	-- upvalues: validateCallParticipants (copy), Url (copy), HttpService (copy), HttpRbxApiService (copy)
	if typeof(s3) ~= "string" or (#s3 > 50 or string.match(s3, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") == nil) or not validateCallParticipants(t4) then
		return 400
	end

	local ok, _ = pcall(function() -- line: 165
		-- upvalues: Url (copy), t4 (copy), s3 (copy), p12 (copy), HttpService (copy), HttpRbxApiService (copy)
		local v74 = Url.APIS_URL .. "call/v1/verify-valid-call"
		local t5 = {}

		for i, v in ipairs(t4) do
			t5[i] = tonumber(v)
		end

		local t6 = {
			callId = s3,
			userId = p12.UserId,
			instanceId = game.JobId,
			callParticipants = t5
		}
		local json = HttpService:JSONEncode(t6)
		local v80 = HttpRbxApiService:PostAsyncFullUrl(v74, json)

		return HttpService:JSONDecode(v80)
	end)

	if ok then
		return 200
	end

	return 400
end

RemoteEvent3.OnServerEvent:Connect(function(player, t7: {[any]: any}?) -- line: 190
	-- upvalues: t2 (copy), validateCall (copy), u15 (ref), Url (copy), HttpService (copy), HttpRbxApiService (copy), enforceCallParticipants (copy)
	if t2[player.UserId] ~= nil and t2[player.UserId] > 10 then
		return
	end

	if t2[player.UserId] ~= nil then
		t2[player.UserId] = t2[player.UserId] + 1
	else
		t2[player.UserId] = 1
	end

	if t7 ~= nil and validateCall(player, t7.callId, t7.participants) ~= 200 then
		player:Kick()

		return
	end

	if u15 ~= nil and t7 ~= nil and u15.callId ~= t7.callId then
		local callId = u15.callId
		local _, _ = pcall(function() -- line: 139
			-- upvalues: Url (copy), HttpService (copy), callId (copy), HttpRbxApiService (copy)
			local v81 = Url.APIS_URL .. "call/v1/force-terminate-call-rcc"
			local json = HttpService:JSONEncode({
				callId = callId
			})
			local v83 = HttpRbxApiService:PostAsyncFullUrl(v81, json)

			return HttpService:JSONDecode(v83)
		end)

		enforceCallParticipants()
	end

	u15 = t7
	enforceCallParticipants()
end)
Players.PlayerAdded:Connect(function(_) -- line: 227
	-- upvalues: enforceCallParticipants (copy)
	enforceCallParticipants()
end)
Players.PlayerRemoving:Connect(function(player) -- line: 231
	-- upvalues: t2 (copy), u15 (ref), Url (copy), HttpService (copy), HttpRbxApiService (copy)
	t2[player.UserId] = nil

	if u15 ~= nil then
		local str = tostring(player.UserId)

		if table.find(u15.participants, str) ~= nil then
			local callId = u15.callId
			local ok, _ = pcall(function() -- line: 139
				-- upvalues: Url (copy), HttpService (copy), callId (copy), HttpRbxApiService (copy)
				local v84 = Url.APIS_URL .. "call/v1/force-terminate-call-rcc"
				local json = HttpService:JSONEncode({
					callId = callId
				})
				local v86 = HttpRbxApiService:PostAsyncFullUrl(v84, json)

				return HttpService:JSONDecode(v86)
			end)

			if ok then
				u15 = nil
			end
		end
	end
end)
