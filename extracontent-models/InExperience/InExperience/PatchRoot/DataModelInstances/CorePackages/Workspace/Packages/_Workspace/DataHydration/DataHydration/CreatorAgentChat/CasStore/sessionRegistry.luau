local createChatSession = require(script.Parent.Parent.createChatSession)

require(script.Parent.Parent.ChatSession.sessionDeps)
require(script.Parent.Parent.types)

return {
	createSessionRegistry = function(p1) -- line: 21
		-- upvalues: createChatSession (copy)
		local t1 = {}
		local t2 = {}

		local function projectKey(n1: number?, n2: number?, s1: string?) -- line: 32
			if typeof(s1) == "string" and s1 ~= "" and (n1 == nil or n2 == nil) then
				return `session:{ s1 }`
			end

			if n1 == nil or n2 == nil then
				return "anonymous"
			end

			return `{ n1 }:{ n2 }`
		end

		return {
			getSessionForProject = function(n3: number?, n4: number?, s2: string?) -- line: 42
				-- upvalues: t1 (copy), t2 (copy), createChatSession (copy), p1 (copy)
				local v14 = if typeof(s2) ~= "string" or (s2 == "" or n3 ~= nil and n4 ~= nil) then if n3 ~= nil and n4 ~= nil then `{ n3 }:{ n4 }` else "anonymous" else `session:{ s2 }`
				local v15 = t1[v14]

				if v15 ~= nil then
					if typeof(s2) == "string" and s2 ~= "" then
						v15.setCasSessionId(s2)

						if typeof(s2) == "string" then
							if s2 == "" then
								return v15
							end

							t2[s2] = v15
						end
					end

					return v15
				end

				local u16 = nil
				local v17 = createChatSession({
					initialize = p1.initialize,
					sessionNew = p1.sessionNew,
					sessionLoad = p1.sessionLoad,
					sessionPrompt = p1.sessionPrompt,
					ingestSessionHistory = p1.ingestSessionHistory,
					submitToolResult = p1.submitToolResult,
					getActiveTurnHandle = p1.getActiveTurnHandle,
					onCasSessionIdChanged = function(p2) -- line: 61
						-- upvalues: u16 (ref), t2 (copy)
						if u16 ~= nil then
							local v20 = u16

							if typeof(p2) == "string" then
								if p2 == "" then
									return
								end

								t2[p2] = v20
							end
						end
					end
				}, n3, n4, s2)

				u16 = v17
				t1[v14] = v17

				if typeof(s2) == "string" and s2 ~= "" then
					t2[s2] = v17
				end

				return v17
			end,
			registerCasSession = function(p3, s3: string?) -- line: 25
				-- upvalues: t2 (copy)
				if typeof(s3) ~= "string" or s3 == "" then
					return
				end

				t2[s3] = p3
			end,
			getSessionByCasSessionId = function(s4: string) -- line: 76
				-- upvalues: t2 (copy)
				return t2[s4]
			end
		}
	end
}
