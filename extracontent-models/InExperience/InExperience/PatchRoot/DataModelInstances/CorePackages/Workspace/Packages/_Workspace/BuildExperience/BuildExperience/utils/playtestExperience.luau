local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local BuildModeLaunch = require(script.Parent.BuildModeLaunch)
local launchExperience = require(script.Parent.launchExperience)
local teleportToPlace = require(script.Parent.teleportToPlace)
local debug = CreatorAgentChat.debug

local function isAlreadyInPlace(n1: number, n2: number) -- line: 24
	return n2 ~= 0 and n2 == n1
end
local function listenForTeleportFailure(p1: ((...any) -> ...any)) -- line: 28
	-- upvalues: Players (copy), TeleportService (copy)
	local LocalPlayer = Players.LocalPlayer
	local connection = TeleportService.TeleportInitFailed:Connect(function(p2) -- line: 32
		-- upvalues: LocalPlayer (copy), p1 (copy)
		if p2 == LocalPlayer then
			p1()
		end
	end)

	return function() -- line: 38
		-- upvalues: connection (copy)
		connection:Disconnect()
	end
end
local function playtestExperience(n3: number, s1: string, t1: {[any]: any}?) -- line: 43
	-- upvalues: debug (copy), Players (copy), TeleportService (copy), BuildModeLaunch (copy), teleportToPlace (copy), launchExperience (copy)
	local v20 = if not t1 or t1.currentPlaceId == nil then game.PlaceId else t1.currentPlaceId
	local v21 = if not t1 then nil else t1.isTeamTest

	debug.log("info", "playtestExperience", {
		isTeamTest = v21,
		placeId = n3,
		currentPlaceId = v20,
		source = s1
	})

	if v20 ~= 0 and v20 == n3 then
		local u22 = nil

		if t1 and t1.onTeleportFailed then
			local onTeleportFailed = t1.onTeleportFailed

			local function v24() -- line: 58
				-- upvalues: u22 (ref), onTeleportFailed (copy)
				if u22 then
					u22()
					u22 = nil
				end

				onTeleportFailed()
			end

			local LocalPlayer = Players.LocalPlayer
			local connection = TeleportService.TeleportInitFailed:Connect(function(p3) -- line: 32
				-- upvalues: LocalPlayer (copy), v24 (copy)
				if p3 == LocalPlayer then
					v24()
				end
			end)

			function u22() -- line: 38
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		BuildModeLaunch:set()
		teleportToPlace(n3)

		return "teleport_pending"
	end

	launchExperience(n3, s1, v21)

	return "experience_launch"
end

return playtestExperience
