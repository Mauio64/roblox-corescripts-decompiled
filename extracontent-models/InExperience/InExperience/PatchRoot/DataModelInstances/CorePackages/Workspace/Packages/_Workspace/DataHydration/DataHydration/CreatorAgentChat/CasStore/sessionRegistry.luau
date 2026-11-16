local parent = script:FindFirstAncestor("DataHydration").Parent
local SignalsUtils = require(parent.SignalsUtils)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

local createChatSession = require(script.Parent.Parent.createChatSession)
local v

if FFlagBuildExperienceModelPickerData then
	local experimentOverride = require(script.Parent.Parent.experimentOverride)
	v = experimentOverride.isEnabled()
else
	v = FFlagBuildExperienceModelPickerData
end

require(script.Parent.Parent.ChatSession.sessionDeps)
require(script.Parent.Parent.types)

local function createAccountRegistry(data)
	local v2 = {}
	local v3 = {}
	local v4 = {}

	local function registerCasSession(chatSession, value: string?) -- 1 equivalent call inferred from this helper
		if typeof(value) ~= "string" or value == "" then
			return
		end

		local v5 = v4[chatSession]

		if v5 ~= nil and v5 ~= value and v3[v5] == chatSession then
			v3[v5] = nil
		end

		local v6 = v3[value]

		if v6 ~= nil and v6 ~= chatSession then
			v4[v6] = nil
		end

		v3[value] = chatSession
		v4[chatSession] = value
	end

	local function projectKey(p: number?, p2: number?, value: string?) -- 1 equivalent call inferred from this helper
		if typeof(value) == "string" and value ~= "" and (v or p == nil or p2 == nil) then
			return `session:{value}`
		end

		if p == nil or p2 == nil then
			return "anonymous"
		end

		return `{p}:{p2}`
	end

	return {
		getSessionForProject = function(p: number?, p2: number?, value: string?)
			local v5 = projectKey(p, p2, value) -- inferred equivalent call

			if typeof(value) == "string" and value ~= "" then
				local v6 = v3[value]

				if v6 ~= nil and v6.getCasSessionId() == value then
					v6.universeId = p or v6.universeId
					v6.placeId = p2 or v6.placeId
					v2[v5] = v6

					if v and p ~= nil and p2 ~= nil then
						v2[(p == nil or p2 == nil) and "anonymous" or `{p}:{p2}`] = v6
					end

					return v6
				end
			end

			local v6 = v2[v5]

			if v6 == nil then
				local v7 = nil
				local chatSession = createChatSession({
					initialize = data.initialize,
					sessionNew = data.sessionNew,
					sessionLoad = data.sessionLoad,
					sessionPrompt = data.sessionPrompt,
					ingestSessionHistory = data.ingestSessionHistory,
					submitToolResult = data.submitToolResult,
					getActiveTurnHandle = data.getActiveTurnHandle,
					onCasSessionIdChanged = function(value2)
						if v7 ~= nil then
							local v8 = v7

							if typeof(value2) == "string" then
								if value2 == "" then
									return
								end

								local v9 = v4[v8]

								if v9 ~= nil and v9 ~= value2 and v3[v9] == v8 then
									v3[v9] = nil
								end

								local v10 = v3[value2]

								if v10 ~= nil and v10 ~= v8 then
									v4[v10] = nil
								end

								v3[value2] = v8
								v4[v8] = value2
							end
						end
					end
				}, p, p2, value)

				v7 = chatSession
				v2[v5] = chatSession

				if v and p ~= nil and p2 ~= nil then
					v2[(p == nil or p2 == nil) and "anonymous" or `{p}:{p2}`] = chatSession
				end

				registerCasSession(chatSession, value) -- inferred equivalent call
				return chatSession
			else
				if typeof(value) ~= "string" or value == "" then
					return v6
				end

				v6.setCasSessionId(value)

				if not (typeof(value) == "string" and value ~= "") then
					return v6
				end

				local v7 = v4[v6]

				if v7 ~= nil and v7 ~= value and v3[v7] == v6 then
					v3[v7] = nil
				end

				local v8 = v3[value]

				if v8 ~= nil and v8 ~= v6 then
					v4[v8] = nil
				end

				v3[value] = v6
				v4[v6] = value

				return v6
			end
		end,
		registerCasSession = registerCasSession,
		getSessionByCasSessionId = function(p: string)
			local v5 = v3[p]

			if v5 == nil or v5.getCasSessionId() == p then
				return v5
			end

			v3[p] = nil
			return nil
		end
	}
end

return {
	createSessionRegistry = function(p)
		if not FFlagBuildExperienceModelPickerData then
			return createAccountRegistry(p)
		end

		local sessionScopedSignal = SignalsUtils.createSessionScopedSignal(function()
			return createAccountRegistry(p)
		end)

		return {
			getSessionForProject = function(p2, p3, p4)
				return sessionScopedSignal(false).getSessionForProject(p2, p3, p4)
			end,
			registerCasSession = function(p2, p3)
				sessionScopedSignal(false).registerCasSession(p2, p3)
			end,
			getSessionByCasSessionId = function(p2)
				return sessionScopedSignal(false).getSessionByCasSessionId(p2)
			end
		}
	end
}
