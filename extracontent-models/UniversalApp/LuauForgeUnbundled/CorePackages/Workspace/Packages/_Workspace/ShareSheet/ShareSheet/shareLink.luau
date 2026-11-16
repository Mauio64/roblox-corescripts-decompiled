local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

local function shareLink(p2)
	default:shareUrl({ context = p2.context, url = p2.url })
end

return shareLink
