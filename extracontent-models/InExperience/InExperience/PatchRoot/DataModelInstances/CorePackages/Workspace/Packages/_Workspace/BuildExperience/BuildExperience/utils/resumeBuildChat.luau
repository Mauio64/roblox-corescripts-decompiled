local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Signals = require(BuildExperienceParent.Signals)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(BuildExperience.Chat.chatTypes)

local BUILD_ASSISTANT_FALLBACK_NAME = LocalizationStrings.BUILD_ASSISTANT_FALLBACK_NAME

local function resolveUniverseIdFromSessionLoad(p1) -- line: 38
	if p1 == nil then
		return nil
	end

	local _meta = p1._meta
	local v14 = if _meta == nil then nil else _meta._roblox
	local v15 = if v14 == nil then nil else v14.universeId

	if typeof(v15) == "number" and v15 ~= 0 then
		return v15
	end

	return nil
end
local function gameIconForUniverseId(n1: number) -- line: 51
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function makeTarget(n2: number?, s1: string?, p2) -- line: 55
	-- upvalues: BUILD_ASSISTANT_FALLBACK_NAME (copy)
	local v20 = n2 or 0

	return {
		universeId = v20,
		placeId = if p2 == nil then nil else p2.rootPlaceId,
		sessionId = s1,
		experienceName = if p2 == nil or p2.name == "" then BUILD_ASSISTANT_FALLBACK_NAME else p2.name,
		gameIcon = if v20 == 0 then nil else string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v20)
	}
end
local function resumeBuildChat(t1: {[any]: any}) -- line: 66
	-- upvalues: CreatorAgentChat (copy), UniverseConfiguration (copy), Signals (copy), BUILD_ASSISTANT_FALLBACK_NAME (copy), makeTarget (copy)
	local sessionId = t1.sessionId
	local v23 = typeof(sessionId) == "string" and sessionId ~= ""
	local v24 = t1.universeId ~= nil and t1.universeId ~= 0

	if not v24 and not v23 then
		return nil
	end

	local u25 = nil

	if not v24 and v23 then
		u25 = (t1.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()).sessionLoad(sessionId)
	end

	local configurationStore = t1.configurationStore

	local function getConfigurationStore() -- line: 82
		-- upvalues: configurationStore (ref), UniverseConfiguration (copy)
		local v29 = configurationStore or UniverseConfiguration.getUniverseConfigurationStore()

		configurationStore = v29

		return v29
	end

	local u28 = false

	return Signals.createEffect(function(p3) -- line: 90
		-- upvalues: u28 (ref), v24 (copy), t1 (copy), u25 (ref), sessionId (copy), BUILD_ASSISTANT_FALLBACK_NAME (copy), configurationStore (ref), UniverseConfiguration (copy), makeTarget (copy)
		if u28 then
			return
		end

		local universeId

		if v24 then
			universeId = t1.universeId
		elseif u25 ~= nil then
			local v32 = u25.state(p3)

			if v32.status == "pending" then
				return
			end

			if v32.status == "succeeded" then
				local result = v32.result

				if result == nil then
					universeId = nil
				else
					local _meta = result._meta
					local v35 = if _meta == nil then nil else _meta._roblox
					local v36 = if v35 == nil then nil else v35.universeId

					universeId = if typeof(v36) ~= "number" or v36 == 0 then nil else v36
				end
			else
				universeId = nil
			end
		else
			universeId = nil
		end

		if universeId == nil then
			u28 = true

			local onOpenChat = t1.onOpenChat
			local v38 = sessionId

			onOpenChat({
				universeId = 0,
				placeId = nil,
				gameIcon = nil,
				sessionId = v38,
				experienceName = BUILD_ASSISTANT_FALLBACK_NAME
			})

			return
		end

		local v39 = configurationStore or UniverseConfiguration.getUniverseConfigurationStore()

		configurationStore = v39

		local v40 = v39.getAndFetchSummary(universeId)

		if v40.status(p3) == "NotReady" then
			return
		end

		u28 = true
		t1.onOpenChat((makeTarget(universeId, sessionId, v40.data(p3))))
	end)
end

return resumeBuildChat
