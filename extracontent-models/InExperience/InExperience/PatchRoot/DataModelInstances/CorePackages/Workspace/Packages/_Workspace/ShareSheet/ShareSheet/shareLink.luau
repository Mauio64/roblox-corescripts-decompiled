local Parent = script:FindFirstAncestor("ShareSheet").Parent
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default

local function shareLink(t1: {[any]: any}) -- line: 12
	-- upvalues: default (copy)
	default:shareUrl({
		context = t1.context,
		url = t1.url
	})
end

return shareLink
