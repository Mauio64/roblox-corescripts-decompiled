local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)

require(Parent.Signals)

local SignalsReact = require(Parent.SignalsReact)
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local function useDelayedFalse(b1: boolean, n1: number) -- line: 22
	-- upvalues: React (copy)
	local v15, v16 = React.useState(b1)

	React.useEffect(function() -- line: 25
		-- upvalues: b1 (copy), v16 (copy), n1 (copy)
		if b1 then
			v16(true)

			return
		end

		local thread = task.delay(n1, function() -- line: 31
			-- upvalues: v16 (copy)
			v16(false)
		end)

		return function() -- line: 35
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		b1,
		n1
	})

	return v15
end
local function useOscillatingWidth(b2: boolean, n2: number, n3: number) -- line: 46
	-- upvalues: React (copy)
	local v20, v21 = React.useState(n3)

	React.useEffect(function() -- line: 49
		-- upvalues: b2 (copy), v21 (copy), n3 (copy), n2 (copy)
		if not b2 then
			v21(n3)

			return
		end

		local thread = nil

		local function scheduleNext() -- line: 56
			-- upvalues: thread (ref), n2 (copy), n3 (copy), v21 (copy), scheduleNext (copy)
			thread = task.delay(0.15, function() -- line: 57
				-- upvalues: n2 (copy), n3 (copy), v21 (copy), scheduleNext (copy)
				local v32 = n2 + math.random() * (n3 - n2)

				v21(v32)
				scheduleNext()
			end)
		end

		thread = task.delay(0.15, function() -- line: 57
			-- upvalues: n2 (copy), n3 (copy), v21 (copy), scheduleNext (copy)
			local v31 = n2 + math.random() * (n3 - n2)

			v21(v31)
			scheduleNext()
		end)

		return function() -- line: 65
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		b2,
		n2,
		n3
	})

	if b2 then
		return v20
	end

	return n3
end
local function VoiceSpeakingIcon(t1: {[any]: any}) -- line: 80
	-- upvalues: useTokens (copy), SignalsReact (copy), useDelayedFalse (copy), useOscillatingWidth (copy), React (copy), View (copy), Icon (copy), IconName (copy), IconVariant (copy)
	local v23 = useTokens()
	local Time_1000 = v23.Time.Time_1000
	local v25 = SignalsReact.useSignalState(t1.isSpeakingSignal)
	local v26 = useDelayedFalse(v25, Time_1000)
	local v27 = useOscillatingWidth(v26, 0.2, 1)

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.layoutOrder
	}, {
		GreenFilledIconContainer = if not v26 then nil else React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.fromScale(v27, 1)
		}, {
			GreenFilledIcon = React.createElement(Icon, {
				name = IconName.Speaker,
				variant = IconVariant.Filled,
				style = v23.Color.System.Success
			})
		}),
		Icon = React.createElement(Icon, {
			name = IconName.Speaker,
			style = v23.Color.Content.Default
		})
	})
end

return React.memo(VoiceSpeakingIcon)
