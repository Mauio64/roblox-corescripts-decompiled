local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local default = require(ParentParentParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Constants = require(ParentParent.Constants)
local Networking = require(ParentParent.App.Networking)
local ShareLinksNetworking = Networking.ShareLinksNetworking
local LinkType = Networking.ShareLinksRodux.Enums.LinkType

return function(n1: number, s1: string) -- line: 15
	-- upvalues: LinkType (copy), ShareLinksNetworking (copy), default (copy), Constants (copy)
	return function(p1) -- line: 16
		-- upvalues: LinkType (copy), n1 (copy), s1 (copy), ShareLinksNetworking (copy), default (copy), Constants (copy)
		local t1 = {
			linkType = LinkType.ContentPost.rawValue(),
			postCreatorId = n1,
			postId = s1
		}

		p1:dispatch(ShareLinksNetworking.GetOrGenerateLink.API(t1)):andThen(function(p2) -- line: 25
			-- upvalues: default (copy), Constants (copy)
			local shortUrl = p2.responseBody.shortUrl

			if not default then
				return
			end

			assert(default ~= nil, "ExternalContentSharingProtocol is required")
			default:shareUrl({
				context = Constants.ContentFeedContext,
				url = shortUrl
			})
		end):catch(function(_) -- line: 38
		end)
	end
end
