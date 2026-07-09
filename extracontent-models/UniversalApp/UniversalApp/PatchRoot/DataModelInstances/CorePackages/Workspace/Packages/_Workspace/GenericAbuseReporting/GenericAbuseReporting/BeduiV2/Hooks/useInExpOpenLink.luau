local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local React = require(Parent.React)

local function useInExpOpenLink() -- line: 13
	-- upvalues: React (copy), default (copy)
	return React.useCallback(function(s1: string) -- line: 14
		-- upvalues: default (copy)
		if s1 ~= nil and s1 ~= "" then
			default:openURL(s1)
		end
	end, {})
end

return useInExpOpenLink
