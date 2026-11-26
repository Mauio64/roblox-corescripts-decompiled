local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/React")
local TransientUIOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/TransientUIOverlay")
local getCloudClientService = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/getCloudClientService")
local useSecondsLeft = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/Hooks/useSecondsLeft")
local useServiceProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/Hooks/useServiceProperty")

local function RestyleTimeLimitSnackbar(): nil
	local v5 = React.useMemo(getCloudClientService, {})
	local v6 = useServiceProperty(v5, "IsRobloxRealityEnvironment") == true
	local v7 = useServiceProperty(v5, "SessionTimeLimit")

	if not v6 then
		v5 = nil
	end

	if typeof(v7) ~= "number" then
		v7 = nil
	end

	local v9 = useSecondsLeft(v5, v7)

	local ref = React.useRef(false)

	local v10 = not (v9 == nil or not (v9 > 0)) and v9 <= 60
	React.useEffect(function()
		if v10 and not ref.current then
			ref.current = true
			TransientUIOverlay.displaySnackbar(
				{
					kind = "snackbar",
					title = "Restyle ends in 1 minute, and you’ll leave the game."
				},
				7
			)
		end
	end, { v10 })

	return nil
end

return RestyleTimeLimitSnackbar
