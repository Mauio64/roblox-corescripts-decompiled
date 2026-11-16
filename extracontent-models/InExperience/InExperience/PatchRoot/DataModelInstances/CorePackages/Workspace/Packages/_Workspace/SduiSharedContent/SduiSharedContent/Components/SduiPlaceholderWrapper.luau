local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Sine = Enum.EasingStyle.Sine

local v = {
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

local function PlaceholderHost(data)
	local fadeOut = data.fadeOut
	local durationSeconds = data.durationSeconds
	local onFadeComplete = data.onFadeComplete

	local v2 = React.useCallback(function(p: number)
		if p >= 1 then
			onFadeComplete()
		end
	end, { onFadeComplete })

	local transparencyBinding, v3 = ReactOtter.useAnimatedBinding(fadeOut and 1 or 0, v2)

	local ref = React.useRef(fadeOut)

	React.useEffect(function()
		local current = ref.current
		ref.current = fadeOut

		if current == fadeOut then
			return
		end

		v3((ReactOtter.ease(fadeOut and 1 or 0, { duration = durationSeconds, easingStyle = Sine })))
	end, { fadeOut, durationSeconds, v3 })

	return React.cloneElement(data.placeholder, {
		transparencyBinding = transparencyBinding,
		zIndex = data.zIndex
	})
end

local function SduiPlaceholderWrapper(p)
	local isPlaceholder = p.isPlaceholder == true
	local transitionDurationSeconds = p.transitionDurationSeconds or 0.15

	local state, setState = React.useState(isPlaceholder)

	React.useEffect(function()
		if isPlaceholder and not state then
			setState(true)
		end
	end, { isPlaceholder, state })

	local onFadeComplete = React.useCallback(function()
		setState(false)
	end, {})

	local mountRealDuringPlaceholder = p.mountRealDuringPlaceholder == true
	local real

	if (not state or not isPlaceholder or mountRealDuringPlaceholder) and p.real then
		local v2 = nil

		for k, v3 in p do
			if v[k] then
				continue
			end

			v2 = v2 == nil and {} or v2

			v2[k] = v3
		end

		if v2 then
			real = React.cloneElement(p.real, v2)
		else
			real = p.real
		end
	end

	local placeholder

	if state and p.placeholder then
		placeholder = React.createElement(PlaceholderHost, {
			placeholder = p.placeholder,
			fadeOut = not isPlaceholder,
			durationSeconds = transitionDurationSeconds,
			onFadeComplete = onFadeComplete,
			zIndex = 1e999
		})
	end

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		ZIndex = p.zIndex
	}, { Real = real, Placeholder = placeholder })
end

return React.memo(SduiPlaceholderWrapper)
