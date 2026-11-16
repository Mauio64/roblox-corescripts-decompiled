local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local Promise = require(CorePackages.Packages.Promise)
local RoCaptchaUtils = require(RobloxGui.Modules.Server.RoCaptcha.RoCaptchaUtils)
local FStringRoCaptchaUniverseIds = require(RobloxGui.Modules.Common.Flags.FStringRoCaptchaUniverseIds)
local defineFastFlag = game:DefineFastFlag("RoCaptchaExperienceValidate", false)

local v = game:DefineFastFlag("RoCaptchaExperienceKick", false) and defineFastFlag

if RunService:IsStudio() or not RoCaptchaUtils.isUniverseAllowed(FStringRoCaptchaUniverseIds, game.GameId) then
	return
end

local v2 = Url.APIS_URL .. "rocaptcha-service/v1/challenge/"
local v3 = Url.APIS_URL .. "challenge/v1/continue"

local set = {
	[Enum.TeleportResult.Failure] = true,
	[Enum.TeleportResult.Flooded] = true,
	[Enum.TeleportResult.IsTeleporting] = true
}

local set2 = { [Enum.TeleportResult.GameEnded] = true, [Enum.TeleportResult.GameFull] = true }

local _ = { Validating = "Validating", Ready = "Ready", Verifying = "Verifying", Done = "Done" }

local function postJson(p, p2)
	local jsonDecode = HttpService:JSONDecode((HttpRbxApiService:PostAsyncFullUrl(
		p,
		HttpService:JSONEncode(p2),
		Enum.ThrottlingPriority.Default,
		Enum.HttpContentType.ApplicationJson
	)))

	if type(jsonDecode) ~= "table" then
		error("unexpected response body")
	end

	return jsonDecode
end

local function withRetry(p, fn)
	local result = nil

	for i = 1, 3 do
		local success
		success, result = pcall(fn)

		if success then
			return true, result
		end

		warn(string.format("[RoCaptcha] %s failed (attempt %d/%d): %s", p, i, 3, (tostring(result))))

		if i < 3 then
			task.wait(2 ^ (i - 1) * 0.5)
		end
	end

	return false, result
end

local function callValidate(challengeId, userId) -- 1 equivalent call inferred from this helper
	return withRetry("validate", function()
		return postJson(v2 .. "validate", {
			challengeId = challengeId,
			userId = userId,
			placeId = game.PlaceId
		})
	end)
end

local function callVerify(challengeId, userId) -- 1 equivalent call inferred from this helper
	return withRetry("verify", function()
		return postJson(v2 .. "verify", {
			challengeId = challengeId,
			solvingUserId = userId,
			placeId = game.PlaceId
		})
	end)
end

local function callGcsContinue(challengeId) -- 1 equivalent call inferred from this helper
	return withRetry("continue", function()
		return postJson(v3, {
			challengeId = challengeId,
			challengeType = "rocaptcha",
			challengeMetadata = ""
		})
	end)
end

local v4 = {}

local function createSession(object)
	local joinData = object:GetJoinData()
	local launchData = RoCaptchaUtils.parseLaunchData(joinData and joinData.LaunchData)

	if launchData then
		return {
			challengeId = launchData.challengeId,
			desiredPlaceId = launchData.desiredPlaceId,
			serverInstanceId = launchData.serverInstanceId,
			state = "Validating",
			teleportInitRetries = 0,
			teleportStartedAt = nil,
			retryPending = false
		}
	end

	return nil
end

local function kick(object, p: string) -- 3 equivalent calls inferred from this helper
	warn("[RoCaptcha] Kicking player, reason:", p)
	v4[object] = nil

	if object.Parent then
		object:Kick()
	end
end

local v5 = {}

local function reject(p, reason: string, failureReason) -- 3 equivalent calls inferred from this helper
	warn("[RoCaptcha] Rejecting player, reason:", reason, failureReason)
	v4[p] = nil

	if not p.Parent then
		return
	end

	v5[p] = { reason = reason, detail = failureReason }
end

local function onPlayerAdded(object)
	local session = createSession(object)

	if session then
		v4[object] = session
		local v6, v7 = callValidate(session.challengeId, object.UserId) -- inferred equivalent call

		if v4[object] ~= session then
			return
		end

		if v6 then
			if v7.valid == true then
				session.state = "Ready"
			elseif v then
				reject(object, "validate_failed", v7.failureReason) -- inferred equivalent call
			else
				kick(object, "validate_failed:" .. tostring(v7.failureReason)) -- inferred equivalent call
			end
		else
			warn("[RoCaptcha] validate unavailable - deferring to verify")
			session.state = "Ready"
		end
	elseif v then
		reject(object, "invalid_launch_data") -- inferred equivalent call
	else
		kick(object, "invalid_launch_data") -- inferred equivalent call
	end
end

local v6 = {}

local function startValidation(player) -- 1 equivalent call inferred from this helper
	local v7 = v6[player]

	if not v7 then
		v7 = Promise.new(function(callback)
			onPlayerAdded(player)
			local v8 = v4[player]
			local v9 = v5[player]

			if v8 and v8.state == "Ready" then
				callback({ valid = true })
			elseif v9 then
				callback({ valid = false, reason = v9.reason, detail = v9.detail })
			else
				callback({ valid = false, reason = "no_session" })
			end
		end)
		v6[player] = v7
	end

	return v7
end

local function onPlayerJoined(p)
	if defineFastFlag then
		if not v6[p] then
			v6[p] = Promise.new(function(callback)
				onPlayerAdded(p)
				local v7 = v4[p]
				local v8 = v5[p]

				if v7 and v7.state == "Ready" then
					callback({ valid = true })
				elseif v8 then
					callback({ valid = false, reason = v8.reason, detail = v8.detail })
				else
					callback({ valid = false, reason = "no_session" })
				end
			end)
		end
	else
		onPlayerAdded(p)
	end
end

Players.PlayerAdded:Connect(onPlayerJoined)

for _, v7 in Players:GetPlayers() do
	task.spawn(onPlayerJoined, v7)
end

Players.PlayerRemoving:Connect(function(player)
	v4[player] = nil
	v6[player] = nil
	v5[player] = nil
end)

local function teleportBack(player, state)
	state.teleportStartedAt = os.clock()

	local serverInstanceId = state.serverInstanceId
	local teleportOptions

	if serverInstanceId then
		teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ServerInstanceId = serverInstanceId
	else
		teleportOptions = nil
	end

	local success, result = pcall(function()
		TeleportService:TeleportAsync(state.desiredPlaceId, { player }, teleportOptions)
	end)

	if not success then
		state.teleportStartedAt = nil
		warn("[RoCaptcha] TeleportAsync failed:", result)
	end

	return success
end

local function isTeleporting(p): boolean -- 2 equivalent calls inferred from this helper
	local teleportStartedAt = p.teleportStartedAt
	return teleportStartedAt ~= nil and os.clock() - teleportStartedAt < 30
end

local function giveUpTeleport(p, p2: string) -- 2 equivalent calls inferred from this helper
	p.teleportStartedAt = nil
	warn("[RoCaptcha] Teleport back failed, reason:", p2)
end

TeleportService.TeleportInitFailed:Connect(function(player, p, p2: string)
	if not player:IsA("Player") then
		return
	end

	local v7 = v4[player]

	if v7 and v7.state == "Done" and isTeleporting(v7) and not v7.retryPending then -- inferred equivalent call
		warn("[RoCaptcha] TeleportInitFailed:", p, p2)
		local v8

		if v7.serverInstanceId == nil then
			v8 = false
		else
			v8 = set2[p] == true
		end

		if v8 then
			warn("[RoCaptcha] Target server unavailable - falling back to any server:", p)
			v7.serverInstanceId = nil
		end

		if set[p] or v8 then
			if v7.teleportInitRetries >= 3 then
				giveUpTeleport(v7, "teleport_retries_exhausted:" .. tostring(p)) -- inferred equivalent call
			else
				v7.teleportInitRetries += 1
				v7.retryPending = true
				task.wait(2 ^ (v7.teleportInitRetries - 1) * 0.5)
				v7.retryPending = false

				if player.Parent and v4[player] == v7 then
					teleportBack(player, v7)
				end
			end
		else
			giveUpTeleport(v7, "teleport_failed:" .. tostring(p)) -- inferred equivalent call
		end
	end
end)

local roCaptchaVerify = Instance.new("BindableFunction")
roCaptchaVerify.Name = "RoCaptchaVerify"

function roCaptchaVerify.OnInvoke(player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		return { success = false, reason = "invalid_player" }
	end

	local v7 = v4[player]

	if not v7 then
		return { success = false, reason = "no_session" }
	end

	if v7.state == "Validating" then
		return { success = false, reason = "not_validated" }
	end

	if v7.state == "Done" then
		if isTeleporting(v7) then -- inferred equivalent call
			return { success = false, reason = "teleport_in_progress" }
		end

		if teleportBack(player, v7) then
			return { success = true }
		end

		return { success = false, reason = "teleport_error" }
	else
		if v7.state ~= "Ready" then
			return { success = false, reason = "already_in_progress" }
		end

		v7.state = "Verifying"

		local challengeId = v7.challengeId
		local v8, v9 = callVerify(challengeId, player.UserId) -- inferred equivalent call

		if not v8 then
			v7.state = "Ready"
			return { success = false, reason = "verify_error" }
		end

		if v9.verified == true then
			if not callGcsContinue(challengeId) then -- inferred equivalent call
				warn("[RoCaptcha] continue failed - teleporting anyway")
			end

			v7.state = "Done"

			if not player.Parent or teleportBack(player, v7) then
				return { success = true }
			end

			return { success = false, reason = "teleport_error" }
		end

		if v then
			reject(player, "verify_failed", v9.failureReason) -- inferred equivalent call
		else
			kick(player, "verify_failed:" .. tostring(v9.failureReason)) -- inferred equivalent call
		end

		return { success = false, reason = "verify_failed", detail = v9.failureReason }
	end
end

roCaptchaVerify.Parent = ServerStorage

if defineFastFlag then
	local roCaptchaValidate = Instance.new("BindableFunction")
	roCaptchaValidate.Name = "RoCaptchaValidate"

	function roCaptchaValidate.OnInvoke(player)
		if typeof(player) ~= "Instance" or not player:IsA("Player") then
			return { valid = false, reason = "invalid_player" }
		end

		if not player.Parent then
			return { valid = false, reason = "no_session" }
		end

		local v7, v8 = startValidation(player):await() -- inferred equivalent call

		if v7 then
			return v8
		end

		return { valid = false, reason = "no_session" }
	end

	roCaptchaValidate.Parent = ServerStorage
end
