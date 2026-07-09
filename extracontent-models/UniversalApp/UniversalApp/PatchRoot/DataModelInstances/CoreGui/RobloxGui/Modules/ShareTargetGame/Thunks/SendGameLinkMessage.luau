local CorePackages = game:GetService("CorePackages")
local SendGameLinkMessagePolicy = require(script.Parent.SendPolicies.SendGameLinkMessagePolicy)
local SendMessageUsingPolicy = require(CorePackages.Workspace.Packages.AppChat.SendMessageUsingPolicy)

return function(p1, p2, b1: boolean?, n1: number?, n2: number?) -- line: 6
	-- upvalues: SendGameLinkMessagePolicy (copy), SendMessageUsingPolicy (copy)
	local v9 = SendGameLinkMessagePolicy:new(p1, p2, nil, b1 or false, n1 or 0, n2 or 0)

	return SendMessageUsingPolicy(v9)
end
