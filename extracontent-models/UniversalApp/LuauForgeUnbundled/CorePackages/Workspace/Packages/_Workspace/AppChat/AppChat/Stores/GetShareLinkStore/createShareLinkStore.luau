local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingShareLinks")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createShareLinkStore")

local function createShareLinkStore()
	local signal, v6 = Signals.createSignal({})

	local v7 = {}
	return {
		getShareLinkMetadataTable = function(p2)
			return signal(p2)
		end,
		getShareLinkMetadataComputed = function(p2)
			if not v7[p2] then
				v7[p2] = Signals.createComputed(function(p3)
					return signal(p3)[p2]
				end)
			end

			return v7[p2]
		end,
		fetchShareLinkMetadata = function(callback, p2, p3)
			callback(NetworkingShareLinks.GetMetadata.API({ linkId = p2, linkType = p3 })):andThen(function(p4)
				local responseBody = p4.responseBody

				if responseBody.data then
					local jsonDecode = HttpService:JSONDecode(responseBody.data)

					if not jsonDecode.universeId then
						v5:warning("Invalid share link metadata: ", jsonDecode)
					end

					v6(function(p5)
						local clone = table.clone(p5)
						clone[p2] = jsonDecode
						return clone
					end)
				end
			end):catch(function(p4)
				v5:warning("Error fetching share link metadata: ", p4)
			end)
		end
	}
end

return createShareLinkStore
