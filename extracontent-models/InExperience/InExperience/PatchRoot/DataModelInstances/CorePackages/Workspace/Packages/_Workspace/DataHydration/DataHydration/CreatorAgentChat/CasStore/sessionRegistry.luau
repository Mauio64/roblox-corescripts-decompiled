local createChatSession = require(script.Parent.Parent.createChatSession)

require(script.Parent.Parent.ChatSession.sessionDeps)
require(script.Parent.Parent.types)

return {
	createSessionRegistry = function(p1) -- line: 20
		-- upvalues: createChatSession (copy)
		local t1 = {}
		local t2 = {}
		local t3 = {}

		local function projectKey(n1: number?, n2: number?, s1: string?) -- line: 45
			if typeof(s1) == "string" and s1 ~= "" and (n1 == nil or n2 == nil) then
				return `session:{ s1 }`
			end

			if n1 == nil or n2 == nil then
				return "anonymous"
			end

			return `{ n1 }:{ n2 }`
		end

		return {
			getSessionForProject = function(n3: number?, n4: number?, s2: string?) -- line: 55
				-- upvalues: t2 (copy), t1 (copy), t3 (copy), createChatSession (copy), p1 (copy)
				local v17 = if typeof(s2) ~= "string" or (s2 == "" or n3 ~= nil and n4 ~= nil) then if n3 ~= nil and n4 ~= nil then `{ n3 }:{ n4 }` else "anonymous" else `session:{ s2 }`

				if typeof(s2) == "string" and s2 ~= "" then
					local v18 = t2[s2]

					if v18 ~= nil and s2 == v18.getCasSessionId() then
						v18.universeId = n3 or v18.universeId
						v18.placeId = n4 or v18.placeId
						t1[v17] = v18

						return v18
					end
				end

				local v19 = t1[v17]

				if v19 ~= nil then
					if typeof(s2) ~= "string" or s2 == "" then
						return v19
					end

					v19.setCasSessionId(s2)

					if typeof(s2) == "string" then
						if s2 == "" then
							return v19
						end

						local v20 = t3[v19]

						if v20 ~= nil and v20 ~= s2 and v19 == t2[v20] then
							t2[v20] = nil
						end

						local v21 = t2[s2]

						if v21 ~= nil and v21 ~= v19 then
							t3[v21] = nil
						end

						t2[s2] = v19
						t3[v19] = s2
					end

					return v19
				end

				local u22 = nil
				local v23 = createChatSession({
					initialize = p1.initialize,
					sessionNew = p1.sessionNew,
					sessionLoad = p1.sessionLoad,
					sessionPrompt = p1.sessionPrompt,
					ingestSessionHistory = p1.ingestSessionHistory,
					submitToolResult = p1.submitToolResult,
					getActiveTurnHandle = p1.getActiveTurnHandle,
					onCasSessionIdChanged = function(p2) -- line: 85
						-- upvalues: u22 (ref), t3 (copy), t2 (copy)
						if u22 ~= nil then
							local v29 = u22

							if typeof(p2) == "string" then
								if p2 == "" then
									return
								end

								local v30 = t3[v29]

								if v30 ~= nil and v30 ~= p2 and v29 == t2[v30] then
									t2[v30] = nil
								end

								local v31 = t2[p2]

								if v31 ~= nil and v31 ~= v29 then
									t3[v31] = nil
								end

								t2[p2] = v29
								t3[v29] = p2
							end
						end
					end
				}, n3, n4, s2)

				u22 = v23
				t1[v17] = v23

				if typeof(s2) == "string" and s2 ~= "" then
					local v24 = t3[v23]

					if v24 ~= nil and v24 ~= s2 and v23 == t2[v24] then
						t2[v24] = nil
					end

					local v25 = t2[s2]

					if v25 ~= nil and v25 ~= v23 then
						t3[v25] = nil
					end

					t2[s2] = v23
					t3[v23] = s2
				end

				return v23
			end,
			registerCasSession = function(p3, s3: string?) -- line: 25
				-- upvalues: t3 (copy), t2 (copy)
				if typeof(s3) ~= "string" or s3 == "" then
					return
				end

				local v9 = t3[p3]

				if v9 ~= nil and v9 ~= s3 and p3 == t2[v9] then
					t2[v9] = nil
				end

				local v10 = t2[s3]

				if v10 ~= nil and v10 ~= p3 then
					t3[v10] = nil
				end

				t2[s3] = p3
				t3[p3] = s3
			end,
			getSessionByCasSessionId = function(s4: string) -- line: 100
				-- upvalues: t2 (copy)
				local v27 = t2[s4]

				if v27 ~= nil and s4 ~= v27.getCasSessionId() then
					t2[s4] = nil

					return nil
				end

				return v27
			end
		}
	end
}
