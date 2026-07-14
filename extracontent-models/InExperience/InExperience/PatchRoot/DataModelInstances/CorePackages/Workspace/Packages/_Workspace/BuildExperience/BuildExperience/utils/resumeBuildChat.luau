local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Signals = require(BuildExperienceParent.Signals)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)

require(BuildExperience.Chat.chatTypes)

local function resolveUniverseIdFromSessionLoad(p1) -- line: 37
	if p1 == nil then
		return nil
	end

	local _meta = p1._meta
	local v12 = if _meta == nil then nil else _meta._roblox
	local v13 = if v12 == nil then nil else v12.universeId

	if typeof(v13) == "number" and v13 ~= 0 then
		return v13
	end

	return nil
end
local function gameIconForUniverseId(n1: number) -- line: 50
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function makeTarget(n2: number?, s1: string?, p2) -- line: 54
	local v18 = n2 or 0

	return {
		universeId = v18,
		placeId = if p2 == nil then nil else p2.rootPlaceId,
		sessionId = s1,
		experienceName = (p2 == nil or p2.name == "") and "Build Assistant" or p2.name,
		gameIcon = if v18 == 0 then nil else string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v18)
	}
end
local function resumeBuildChat(t1: {[any]: any}) -- line: 65
	-- upvalues: CreatorAgentChat (copy), UniverseConfiguration (copy), Signals (copy), makeTarget (copy)
	local sessionId = t1.sessionId
	local v21 = typeof(sessionId) == "string" and sessionId ~= ""
	local v22 = t1.universeId ~= nil and t1.universeId ~= 0

	if not v22 and not v21 then
		return nil
	end

	local u23 = nil

	if not v22 and v21 then
		u23 = (t1.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()).sessionLoad(sessionId)
	end

	local configurationStore = t1.configurationStore

	local function getConfigurationStore() -- line: 81
		-- upvalues: configurationStore (ref), UniverseConfiguration (copy)
		local v27 = configurationStore or UniverseConfiguration.getUniverseConfigurationStore()

		configurationStore = v27

		return v27
	end

	local u26 = false

	return Signals.createEffect(function(p3) -- line: 89
		-- upvalues: u26 (ref), v22 (copy), t1 (copy), u23 (ref), sessionId (copy), configurationStore (ref), UniverseConfiguration (copy), makeTarget (copy)
		if u26 then
			return
		end

		local universeId

		if v22 then
			universeId = t1.universeId
		elseif u23 ~= nil then
			local v30 = u23.state(p3)

			if v30.status == "pending" then
				return
			end

			if v30.status == "succeeded" then
				local result = v30.result

				if result == nil then
					universeId = nil
				else
					local _meta = result._meta
					local v33 = if _meta == nil then nil else _meta._roblox
					local v34 = if v33 == nil then nil else v33.universeId

					universeId = if typeof(v34) ~= "number" or v34 == 0 then nil else v34
				end
			else
				universeId = nil
			end
		else
			universeId = nil
		end

		if universeId == nil then
			u26 = true

			local onOpenChat = t1.onOpenChat
			local v36 = sessionId

			onOpenChat({
				universeId = 0,
				placeId = nil,
				experienceName = "Build Assistant",
				gameIcon = nil,
				sessionId = v36
			})

			return
		end

		local v37 = configurationStore or UniverseConfiguration.getUniverseConfigurationStore()

		configurationStore = v37

		local v38 = v37.getAndFetchSummary(universeId)

		if v38.status(p3) == "NotReady" then
			return
		end

		u26 = true
		t1.onOpenChat((makeTarget(universeId, sessionId, v38.data(p3))))
	end)
end

return resumeBuildChat
