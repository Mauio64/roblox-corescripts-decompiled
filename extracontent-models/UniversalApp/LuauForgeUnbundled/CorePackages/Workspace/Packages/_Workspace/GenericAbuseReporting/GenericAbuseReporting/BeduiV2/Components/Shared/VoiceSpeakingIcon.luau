local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SignalsReact")

local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local function useDelayedFalse(p2, time_1000)
	local state, setState = React.useState(p2)

	React.useEffect(function()
		if p2 then
			setState(true)
		else
			local thread = task.delay(time_1000, function()
				setState(false)
			end)

			return function()
				task.cancel(thread)
			end
		end
	end, { p2, time_1000 })

	return state
end

local function useOscillatingWidth(p2, p3, p4)
	local state, setState = React.useState(p4)

	React.useEffect(function()
		if not p2 then
			setState(p4)
			return
		end

		local thread = nil
		local function scheduleNext()
			thread = task.delay(0.15, function()
				setState(p3 + math.random() * (p4 - p3))
				scheduleNext()
			end)
		end

		thread = task.delay(0.15, function()
			setState(p3 + math.random() * (p4 - p3))
			scheduleNext()
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { p2, p3, p4 })

	if p2 then
		return state
	end

	return p4
end

local function VoiceSpeakingIcon(p2)
	local v5 = useTokens()
	local time_1000 = v5.Time.Time_1000
	local v7 = useDelayedFalse(SignalsReact.useSignalState(p2.isSpeakingSignal), time_1000)
	local v8 = useOscillatingWidth(v7, 0.2, 1)

	local createElement = React.createElement
	local v10 = { tag = "auto-xy", LayoutOrder = p2.layoutOrder }

	local v12 = if v7 then React.createElement(
		"Frame",
		{
			ClipsDescendants = true,
			Size = UDim2.fromScale(v8, 1),
			BackgroundTransparency = 1,
			ZIndex = 2
		},
		{
			GreenFilledIcon = React.createElement(icon, {
				name = iconName.Speaker,
				variant = iconVariant.Filled,
				style = v5.Color.System.Success
			})
		}
	) else nil
	return createElement(view, v10, {
		GreenFilledIconContainer = v12,
		Icon = React.createElement(icon, {
			name = iconName.Speaker,
			style = v5.Color.Content.Default
		})
	})
end

return React.memo(VoiceSpeakingIcon)
