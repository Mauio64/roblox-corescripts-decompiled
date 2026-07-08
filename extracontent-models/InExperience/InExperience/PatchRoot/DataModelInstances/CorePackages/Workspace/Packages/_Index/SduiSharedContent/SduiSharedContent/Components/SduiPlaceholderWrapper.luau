local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Sine = Enum.EasingStyle.Sine
local t1 = {
	isPlaceholder = true,
	real = true,
	placeholder = true,
	transitionDurationSeconds = true,
	mountRealDuringPlaceholder = true,
	layoutOrder = true,
	zIndex = true,
	componentConfig = true,
	sduiContext = true,
	debugName = true,
	analyticsContext = true
}

local function PlaceholderHost(t2: {[any]: any}) -- line: 36
	-- upvalues: React (copy), ReactOtter (copy), Sine (copy)
	local fadeOut = t2.fadeOut
	local durationSeconds = t2.durationSeconds
	local onFadeComplete = t2.onFadeComplete
	local v12 = React.useCallback(function(n1: number) -- line: 43
		-- upvalues: onFadeComplete (copy)
		if n1 >= 1 then
			onFadeComplete()
		end
	end, { onFadeComplete })
	local v13, v14 = ReactOtter.useAnimatedBinding(not fadeOut and 0 or 1, v12)
	local v15 = React.useRef(fadeOut)

	React.useEffect(function() -- line: 53
		-- upvalues: v15 (copy), fadeOut (copy), v14 (copy), ReactOtter (copy), durationSeconds (copy), Sine (copy)
		local current = v15.current

		v15.current = fadeOut

		if current == fadeOut then
			return
		end

		v14((ReactOtter.ease(not fadeOut and 0 or 1, {
			duration = durationSeconds,
			easingStyle = Sine
		})))
	end, {
		fadeOut,
		durationSeconds,
		v14
	})

	return React.cloneElement(t2.placeholder, {
		transparencyBinding = v13,
		zIndex = t2.zIndex
	})
end
local function SduiPlaceholderWrapper(t3: {[any]: any}) -- line: 83
	-- upvalues: React (copy), t1 (copy), PlaceholderHost (copy)
	local v17 = t3.isPlaceholder == true
	local v18 = t3.transitionDurationSeconds or 0.15
	local v19, v20 = React.useState(v17)

	React.useEffect(function() -- line: 89
		-- upvalues: v17 (copy), v19 (copy), v20 (copy)
		if v17 and not v19 then
			v20(true)
		end
	end, {
		v17,
		v19
	})

	local v21 = React.useCallback(function() -- line: 95
		-- upvalues: v20 (copy)
		v20(false)
	end, {})
	local v22 = t3.mountRealDuringPlaceholder == true
	local v23 = nil

	if (not v19 or (not v17 or v22)) and t3.real then
		local t4 = nil

		for v25, v26 in t3 do
			if not t1[v25] then
				if t4 == nil then
					t4 = {}
				end

				t4[v25] = v26
			end
		end

		v23 = if not t4 then t3.real else React.cloneElement(t3.real, t4)
	end

	local v27 = if not v19 or not t3.placeholder then nil else React.createElement(PlaceholderHost, {
		zIndex = 1e999,
		placeholder = t3.placeholder,
		fadeOut = not v17,
		durationSeconds = v18,
		onFadeComplete = v21
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t3.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		ZIndex = t3.zIndex
	}, {
		Real = v23,
		Placeholder = v27
	})
end

return React.memo(SduiPlaceholderWrapper)
