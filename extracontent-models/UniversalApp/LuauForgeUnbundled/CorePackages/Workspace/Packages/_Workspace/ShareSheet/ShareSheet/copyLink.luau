local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

local function copyLink(p2)
	default:setClipboardText({ context = p2.context, text = p2.url })
end

return copyLink
