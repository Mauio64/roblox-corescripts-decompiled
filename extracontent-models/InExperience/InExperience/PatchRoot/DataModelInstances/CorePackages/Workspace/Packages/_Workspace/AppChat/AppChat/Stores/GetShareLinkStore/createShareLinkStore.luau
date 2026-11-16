local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

local NetworkingShareLinks = require(AppChat.Http.NetworkingShareLinks)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function createShareLinkStore()
	local signal, v2 = Signals.createSignal({})

	local v3 = {}
	return {
		getShareLinkMetadataTable = function(p)
			return signal(p)
		end,
		getShareLinkMetadataComputed = function(p: string)
			if not v3[p] then
				v3[p] = Signals.createComputed(function(p2)
					return signal(p2)[p]
				end)
			end

			return v3[p]
		end,
		fetchShareLinkMetadata = function(callback, linkId: string, linkType: string)
			callback(NetworkingShareLinks.GetMetadata.API({ linkId = linkId, linkType = linkType })):andThen(function(p)
				local responseBody = p.responseBody

				if responseBody.data then
					local jsonDecode = HttpService:JSONDecode(responseBody.data)

					if not jsonDecode.universeId then
						v:warning("Invalid share link metadata: ", jsonDecode)
					end

					v2(function(p2)
						local clone = table.clone(p2)
						clone[linkId] = jsonDecode
						return clone
					end)
				end
			end):catch(function(p)
				v:warning("Error fetching share link metadata: ", p)
			end)
		end
	}
end

return createShareLinkStore
