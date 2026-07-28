local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.ShareLinksNetworking)

local function classifyShareLinkV2(p1) -- line: 14
	if p1.status ~= "Valid" then
		return {
			type = "invalid"
		}
	end

	if p1.linkType == "Moments" then
		return {
			type = "moment",
			momentId = p1.targetId
		}
	end

	return {
		type = "unhandled"
	}
end

return classifyShareLinkV2
