local Parent = script:FindFirstAncestor("ShareSheet").Parent
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default

local function copyLink(t1: {[any]: any}) -- line: 12
	-- upvalues: default (copy)
	default:setClipboardText({
		context = t1.context,
		text = t1.url
	})
end

return copyLink
