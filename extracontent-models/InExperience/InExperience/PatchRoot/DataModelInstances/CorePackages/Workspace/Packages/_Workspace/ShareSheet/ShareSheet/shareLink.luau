local parent = script:FindFirstAncestor("ShareSheet").Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

local function shareLink(p)
	default:shareUrl({ context = p.context, url = p.url })
end

return shareLink
