local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local React = require(parent.React)
require(script.Parent.RestyleTimerView)
local getCloudClientService = require(InExperienceCloudPlay.getCloudClientService)
local useSecondsLeft = require(InExperienceCloudPlay.Hooks.useSecondsLeft)
local useServiceProperty = require(InExperienceCloudPlay.Hooks.useServiceProperty)

local function formatTimeLeft(p: number) -- 1 equivalent call inferred from this helper
	return string.format("%02d:%02d", p // 60, p % 60)
end

local function useRestyleTimerViewModel(data)
	local v = React.useMemo(getCloudClientService, {})
	local v2 = useServiceProperty(v, "IsRobloxRealityEnvironment")
	local v3 = useServiceProperty(v, "RobloxRealityFilterEnabled")
	local v4 = useServiceProperty(v, "SessionTimeLimit")
	local v5

	if v2 == true then
		v5 = not data.isHidden
	else
		v5 = false
	end

	local v6

	if v5 then
		v6 = v
	end

	if typeof(v4) ~= "number" then
		v4 = nil
	end

	local v7 = useSecondsLeft(v6, v4)

	local state, setState = React.useState(false)

	local onChipActivated = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})
	local onPopoverClosed = React.useCallback(function()
		setState(false)
	end, {})
	local onRestyleToggled = React.useCallback(function(robloxRealityFilterEnabled: boolean)
		if v then
			v.RobloxRealityFilterEnabled = robloxRealityFilterEnabled
		end
	end, { v })
	local onAreaChanged = data.onAreaChanged
	local onAreaChanged2 = React.useCallback(function(p)
		if onAreaChanged then
			onAreaChanged("restyle-timer", p.AbsolutePosition, p.AbsoluteSize)
		end
	end, { onAreaChanged })

	local ref = React.useRef(data.onAreaRemoved)
	ref.current = data.onAreaRemoved
	React.useEffect(function()
		if v5 then
			return function()
				local current = ref.current

				if current then
					current("restyle-timer")
				end
			end
		end

		setState(false)
		return nil
	end, { v5 })

	if not v5 then
		return nil
	end

	local timeLeft

	if v7 then
		timeLeft = formatTimeLeft(v7) -- inferred equivalent call
	end

	return {
		timeLeft = timeLeft,
		isPopoverOpen = state,
		isRestyleEnabled = v3 == true,
		buttonSize = data.buttonSize,
		layoutOrder = data.layoutOrder,
		onChipActivated = onChipActivated,
		onPopoverClosed = onPopoverClosed,
		onRestyleToggled = onRestyleToggled,
		onAreaChanged = onAreaChanged2
	}
end

return useRestyleTimerViewModel
