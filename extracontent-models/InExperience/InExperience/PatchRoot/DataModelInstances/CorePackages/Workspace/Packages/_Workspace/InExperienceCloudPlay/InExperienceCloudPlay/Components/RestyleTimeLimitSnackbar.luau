local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local React = require(parent.React)
local TransientUIOverlay = require(parent.TransientUIOverlay)
local getCloudClientService = require(InExperienceCloudPlay.getCloudClientService)
local useSecondsLeft = require(InExperienceCloudPlay.Hooks.useSecondsLeft)
local useServiceProperty = require(InExperienceCloudPlay.Hooks.useServiceProperty)

local function RestyleTimeLimitSnackbar(): nil
	local v = React.useMemo(getCloudClientService, {})
	local v2 = useServiceProperty(v, "IsRobloxRealityEnvironment") == true
	local v3 = useServiceProperty(v, "SessionTimeLimit")

	if not v2 then
		v = nil
	end

	if typeof(v3) ~= "number" then
		v3 = nil
	end

	local v4 = useSecondsLeft(v, v3)

	local ref = React.useRef(false)
	local v5

	if v4 == nil or not (v4 > 0) then
		v5 = false
	else
		v5 = v4 <= 60
	end

	React.useEffect(function()
		if v5 and not ref.current then
			ref.current = true
			TransientUIOverlay.displaySnackbar(
				{
					kind = "snackbar",
					title = "Restyle ends in 1 minute, and you’ll leave the game."
				},
				7
			)
		end
	end, { v5 })

	return nil
end

return RestyleTimeLimitSnackbar
