local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsUtils")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

local createChatSession = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createChatSession")

local v5 = fFlagBuildExperienceModelPickerData and require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/experimentOverride").isEnabled()
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionDeps")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function createAccountRegistry(data)
	local v6 = {}
	local v7 = {}
	local v8 = {}

	local function projectKey(p2, p3, value)
		if typeof(value) == "string" and value ~= "" and (v5 or p2 == nil or p3 == nil) then
			return `session:{value}`
		end

		if p2 == nil or p3 == nil then
			return "anonymous"
		end

		return `{p2}:{p3}`
	end

	return {
		getSessionForProject = function(p2, p3, value)
			local v9

			if typeof(value) == "string" and value ~= "" and (v5 or p2 == nil or p3 == nil) then
				v9 = `session:{value}`
			else
				v9 = (p2 == nil or p3 == nil) and "anonymous" or `{p2}:{p3}`
			end

			if typeof(value) == "string" and value ~= "" then
				local v10 = v7[value]

				if v10 ~= nil and v10.getCasSessionId() == value then
					v10.universeId = p2 or v10.universeId
					v10.placeId = p3 or v10.placeId
					v6[v9] = v10

					if v5 and p2 ~= nil and p3 ~= nil then
						v6[(p2 == nil or p3 == nil) and "anonymous" or `{p2}:{p3}`] = v10
					end

					return v10
				end
			end

			local v10 = v6[v9]

			if v10 == nil then
				local v11 = nil
				local v12 = createChatSession({
					initialize = data.initialize,
					sessionNew = data.sessionNew,
					sessionLoad = data.sessionLoad,
					sessionPrompt = data.sessionPrompt,
					ingestSessionHistory = data.ingestSessionHistory,
					submitToolResult = data.submitToolResult,
					getActiveTurnHandle = data.getActiveTurnHandle,
					onCasSessionIdChanged = function(value2)
						if v11 ~= nil then
							local v13 = v11

							if typeof(value2) == "string" then
								if value2 == "" then
									return
								end

								local v14 = v8[v13]

								if v14 ~= nil and v14 ~= value2 and v7[v14] == v13 then
									v7[v14] = nil
								end

								local v15 = v7[value2]

								if v15 ~= nil and v15 ~= v13 then
									v8[v15] = nil
								end

								v7[value2] = v13
								v8[v13] = value2
							end
						end
					end
				}, p2, p3, value)

				v11 = v12
				v6[v9] = v12

				if v5 and p2 ~= nil and p3 ~= nil then
					v6[(p2 == nil or p3 == nil) and "anonymous" or `{p2}:{p3}`] = v12
				end

				if typeof(value) ~= "string" or value == "" then
					return v12
				end

				local v13 = v8[v12]

				if v13 ~= nil and v13 ~= value and v7[v13] == v12 then
					v7[v13] = nil
				end

				local v14 = v7[value]

				if v14 ~= nil and v14 ~= v12 then
					v8[v14] = nil
				end

				v7[value] = v12
				v8[v12] = value

				return v12
			else
				if typeof(value) ~= "string" or value == "" then
					return v10
				end

				v10.setCasSessionId(value)

				if not (typeof(value) == "string" and value ~= "") then
					return v10
				end

				local v11 = v8[v10]

				if v11 ~= nil and v11 ~= value and v7[v11] == v10 then
					v7[v11] = nil
				end

				local v12 = v7[value]

				if v12 ~= nil and v12 ~= v10 then
					v8[v12] = nil
				end

				v7[value] = v10
				v8[v10] = value

				return v10
			end
		end,
		registerCasSession = function(p2, value)
			if typeof(value) ~= "string" or value == "" then
				return
			end

			local v9 = v8[p2]

			if v9 ~= nil and v9 ~= value and v7[v9] == p2 then
				v7[v9] = nil
			end

			local v10 = v7[value]

			if v10 ~= nil and v10 ~= p2 then
				v8[v10] = nil
			end

			v7[value] = p2
			v8[p2] = value
		end,
		getSessionByCasSessionId = function(p2)
			local v9 = v7[p2]

			if v9 == nil or v9.getCasSessionId() == p2 then
				return v9
			end

			v7[p2] = nil
			return nil
		end
	}
end

return {
	createSessionRegistry = function(p2)
		if not fFlagBuildExperienceModelPickerData then
			return createAccountRegistry(p2)
		end

		local sessionScopedSignal = SignalsUtils.createSessionScopedSignal(function()
			return createAccountRegistry(p2)
		end)

		return {
			getSessionForProject = function(p3, p4, p5)
				return sessionScopedSignal(false).getSessionForProject(p3, p4, p5)
			end,
			registerCasSession = function(p3, p4)
				sessionScopedSignal(false).registerCasSession(p3, p4)
			end,
			getSessionByCasSessionId = function(p3)
				return sessionScopedSignal(false).getSessionByCasSessionId(p3)
			end
		}
	end
}
