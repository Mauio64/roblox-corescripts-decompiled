local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local NetworkingShareLinks = require(AppChat.Http.NetworkingShareLinks)
local v6 = require(AppChat.Logger):new(script.Name)

local function createShareLinkStore() -- line: 23
	-- upvalues: Signals (copy), NetworkingShareLinks (copy), HttpService (copy), v6 (copy)
	local v8, v9 = Signals.createSignal({})
	local t1 = {}

	return {
		getShareLinkMetadataTable = function(p1) -- line: 27
			-- upvalues: v8 (copy)
			return v8(p1)
		end,
		getShareLinkMetadataComputed = function(s1: string) -- line: 32
			-- upvalues: t1 (copy), Signals (copy), v8 (copy)
			if not t1[s1] then
				t1[s1] = Signals.createComputed(function(p2) -- line: 34
					-- upvalues: v8 (copy), s1 (copy)
					return v8(p2)[s1]
				end)
			end

			return t1[s1]
		end,
		fetchShareLinkMetadata = function(p3, s2: string, s3: string) -- line: 41
			-- upvalues: NetworkingShareLinks (copy), HttpService (copy), v6 (copy), v9 (copy)
			p3(NetworkingShareLinks.GetMetadata.API({
				linkId = s2,
				linkType = s3
			})):andThen(function(p4) -- line: 43
				-- upvalues: HttpService (copy), v6 (copy), v9 (copy), s2 (copy)
				local responseBody = p4.responseBody

				if responseBody.data then
					local data = HttpService:JSONDecode(responseBody.data)

					if not data.universeId then
						v6:warning("Invalid share link metadata: ", data)
					end

					v9(function(p5) -- line: 50
						-- upvalues: s2 (copy), data (copy)
						local v22 = table.clone(p5)

						v22[s2] = data

						return v22
					end)
				end
			end):catch(function(p6) -- line: 57
				-- upvalues: v6 (copy)
				v6:warning("Error fetching share link metadata: ", p6)
			end)
		end
	}
end

return createShareLinkStore
