local parent = script:FindFirstAncestor("ShareSheet").Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

local function copyLink(p)
	default:setClipboardText({ context = p.context, text = p.url })
end

return copyLink
