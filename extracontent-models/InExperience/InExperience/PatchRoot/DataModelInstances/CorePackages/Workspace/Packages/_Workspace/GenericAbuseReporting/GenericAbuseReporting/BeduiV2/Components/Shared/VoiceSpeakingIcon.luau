local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local function useDelayedFalse(flag: boolean, time_1000: number)
	local state, setState = React.useState(flag)

	React.useEffect(function()
		if flag then
			setState(true)
		else
			local thread = task.delay(time_1000, function()
				setState(false)
			end)

			return function()
				task.cancel(thread)
			end
		end
	end, { flag, time_1000 })

	return state
end

local function useOscillatingWidth(flag: boolean, p: number, p2: number)
	local state, setState = React.useState(p2)

	React.useEffect(function()
		if not flag then
			setState(p2)
			return
		end

		local thread = nil
		local function scheduleNext()
			thread = task.delay(0.15, function()
				setState(p + math.random() * (p2 - p))
				scheduleNext()
			end)
		end

		thread = task.delay(0.15, function()
			setState(p + math.random() * (p2 - p))
			scheduleNext()
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { flag, p, p2 })
	return if flag then state else p2
end

local function VoiceSpeakingIcon(p)
	local v = useTokens()
	local time_1000 = v.Time.Time_1000
	local v2 = useDelayedFalse(SignalsReact.useSignalState(p.isSpeakingSignal), time_1000)
	local v3 = useOscillatingWidth(v2, 0.2, 1)

	local createElement = React.createElement
	local v4 = { tag = "auto-xy", LayoutOrder = p.layoutOrder }
	local greenFilledIconContainer

	if v2 then
		greenFilledIconContainer = React.createElement(
			"Frame",
			{
				ClipsDescendants = true,
				Size = UDim2.fromScale(v3, 1),
				BackgroundTransparency = 1,
				ZIndex = 2
			},
			{
				GreenFilledIcon = React.createElement(Icon, {
					name = IconName.Speaker,
					variant = IconVariant.Filled,
					style = v.Color.System.Success
				})
			}
		)
	end

	return createElement(View, v4, {
		GreenFilledIconContainer = greenFilledIconContainer,
		Icon = React.createElement(Icon, {
			name = IconName.Speaker,
			style = v.Color.Content.Default
		})
	})
end

return React.memo(VoiceSpeakingIcon)
