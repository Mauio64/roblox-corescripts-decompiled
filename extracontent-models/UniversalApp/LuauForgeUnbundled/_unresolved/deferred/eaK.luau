local default = require("@luauforge/deferred/eaL").ExternalContentSharingProtocol.default

local module = require("@luauforge/deferred/dZs")
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")

local shareLinksNetworking = Networking.ShareLinksNetworking
local linkType = Networking.ShareLinksRodux.Enums.LinkType

return function(p2, p3)
	return function(object)
		local v5 = {
			linkType = linkType.ContentPost.rawValue(),
			postCreatorId = p2,
			postId = p3
		}

		object:dispatch(shareLinksNetworking.GetOrGenerateLink.API(v5)):andThen(function(p4)
			local shortUrl = p4.responseBody.shortUrl

			if not default then
				return
			end

			assert(default ~= nil, "ExternalContentSharingProtocol is required")

			default:shareUrl({ context = module.ContentFeedContext, url = shortUrl })
		end):catch(function(p4) end)
	end
end
