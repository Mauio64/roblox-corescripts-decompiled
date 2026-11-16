local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function resolveUniverseIdFromSessionLoad(p2)
	if p2 == nil then
		return nil
	end

	local meta = p2._meta
	local roblox = if meta ~= nil then meta._roblox else nil
	local universeId = if roblox ~= nil then roblox.universeId else nil

	if typeof(universeId) == "number" and universeId ~= 0 then
		return universeId
	end

	return nil
end

local function gameIconForUniverseId(p2)
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", p2)
end

local function makeTarget(universeId, sessionId, p2, fallbackExperienceName)
	local v5 = universeId or 0

	local v6 = if p2 ~= nil then p2.rootPlaceId else nil

	if p2 ~= nil and p2.name ~= "" then
		fallbackExperienceName = p2.name
	end

	local v7 = if v5 ~= 0 then string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v5) else nil

	return {
		universeId = v5,
		placeId = v6,
		sessionId = sessionId,
		experienceName = fallbackExperienceName,
		gameIcon = v7
	}
end

local function resumeBuildChat(data)
	local sessionId = data.sessionId
	local v5 = typeof(sessionId) == "string" and sessionId ~= ""
	local v6 = not (data.universeId == nil) and data.universeId ~= 0

	if not (v6 or v5) then
		return nil
	end

	local fallbackExperienceName = data.fallbackExperienceName
	local v7

	if v6 or not v5 then
		v7 = nil
	else
		v7 = (data.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()).sessionLoad(sessionId)
	end

	local v8 = data.configurationStore
	local function getConfigurationStore()
		local configurationStore = v8 or UniverseConfiguration.getUniverseConfigurationStore()
		v8 = configurationStore
		return configurationStore
	end

	local flag = false

	return Signals.createEffect(function(p2)
		if flag then
			return
		end

		local universeId

		if v6 then
			universeId = data.universeId
		elseif v7 ~= nil then
			local state = v7.state(p2)

			if state.status == "pending" then
				return
			end

			if state.status == "succeeded" then
				local result = state.result

				if result ~= nil then
					local meta = result._meta
					local roblox = if meta ~= nil then meta._roblox else nil

					if roblox ~= nil then
						universeId = roblox.universeId
					end

					if typeof(universeId) ~= "number" or universeId == 0 then
						universeId = nil
					end
				end
			end
		end

		if universeId == nil then
			flag = true
			data.onOpenChat({
				universeId = 0,
				placeId = nil,
				sessionId = sessionId,
				experienceName = fallbackExperienceName,
				gameIcon = nil
			})
		else
			local v9 = v8 or UniverseConfiguration.getUniverseConfigurationStore()
			v8 = v9

			local fetchSummary = v9.getAndFetchSummary(universeId)

			if fetchSummary.status(p2) == "NotReady" then
				return
			end

			flag = true
			data.onOpenChat(makeTarget(universeId, sessionId, fetchSummary.data(p2), fallbackExperienceName))
		end
	end)
end

return resumeBuildChat
