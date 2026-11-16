local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)

require(BuildExperience.Chat.chatTypes)

local function resolveUniverseIdFromSessionLoad(p)
	if p == nil then
		return nil
	end

	local meta = p._meta
	local roblox

	if meta ~= nil then
		roblox = meta._roblox
	end

	local universeId

	if roblox ~= nil then
		universeId = roblox.universeId
	end

	if typeof(universeId) == "number" and universeId ~= 0 then
		return universeId
	end

	return nil
end

local function gameIconForUniverseId(p: number) -- 1 equivalent call inferred from this helper
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", p)
end

local function makeTarget(universeId: number?, sessionId: string?, p, fallbackExperienceName: string)
	local universeId2 = universeId or 0
	local placeId

	if p ~= nil then
		placeId = p.rootPlaceId
	end

	if p ~= nil and p.name ~= "" then
		fallbackExperienceName = p.name
	end

	local gameIcon

	if universeId2 ~= 0 then
		gameIcon = gameIconForUniverseId(universeId2) -- inferred equivalent call
	end

	return {
		universeId = universeId2,
		placeId = placeId,
		sessionId = sessionId,
		experienceName = fallbackExperienceName,
		gameIcon = gameIcon
	}
end

local function resumeBuildChat(data)
	local sessionId = data.sessionId
	local v

	if typeof(sessionId) == "string" then
		v = sessionId ~= ""
	else
		v = false
	end

	local v2

	if data.universeId == nil then
		v2 = false
	else
		v2 = data.universeId ~= 0
	end

	if not (v2 or v) then
		return nil
	end

	local fallbackExperienceName = data.fallbackExperienceName
	local v3

	if v2 or not v then
		v3 = nil
	else
		v3 = (data.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()).sessionLoad(sessionId)
	end

	local v4 = data.configurationStore
	local function getConfigurationStore() -- 1 equivalent call inferred from this helper
		local configurationStore = v4 or UniverseConfiguration.getUniverseConfigurationStore()
		v4 = configurationStore
		return configurationStore
	end

	local flag = false

	return Signals.createEffect(function(p)
		if flag then
			return
		end

		local universeId

		if v2 then
			universeId = data.universeId
		elseif v3 ~= nil then
			local state = v3.state(p)

			if state.status == "pending" then
				return
			end

			if state.status == "succeeded" then
				local result = state.result

				if result ~= nil then
					local meta = result._meta
					local roblox

					if meta ~= nil then
						roblox = meta._roblox
					end

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
			local fetchSummary = getConfigurationStore().getAndFetchSummary(universeId) -- inferred equivalent call

			if fetchSummary.status(p) == "NotReady" then
				return
			end

			flag = true
			data.onOpenChat(makeTarget(universeId, sessionId, fetchSummary.data(p), fallbackExperienceName))
		end
	end)
end

return resumeBuildChat
