local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Cryo")

local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useNavigationProps")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/types")

local function withNavigationProps(p2)
	return function(p3)
		return function(p4)
			return React.createElement(p3, Cryo.Dictionary.join(p4, useNavigationProps(p2)))
		end
	end
end

return withNavigationProps
