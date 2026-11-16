local default = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/LinkingProtocol").LinkingProtocol.default
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function useInExpOpenLink()
	return React.useCallback(function(p2)
		if p2 ~= nil and p2 ~= "" then
			default:openURL(p2)
		end
	end, {})
end

return useInExpOpenLink
