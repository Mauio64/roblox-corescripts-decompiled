local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local React = require(parent.React)

local function useInExpOpenLink()
	return React.useCallback(function(p: string)
		if p ~= nil and p ~= "" then
			default:openURL(p)
		end
	end, {})
end

return useInExpOpenLink
