local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

local function getResponseBody(p1) -- line: 6
	if p1 == nil then
		return nil
	end

	return p1.responseBody or p1
end

return getResponseBody
