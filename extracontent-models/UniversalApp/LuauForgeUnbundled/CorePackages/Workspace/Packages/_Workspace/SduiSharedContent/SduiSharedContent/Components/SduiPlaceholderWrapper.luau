local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ReactOtter")

local sine = Enum.EasingStyle.Sine

local v5 = {
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

	local v6 = React.useCallback(function(p2)
		if p2 >= 1 then
			onFadeComplete()
		end
	end, { onFadeComplete })

	local v7, v8 = ReactOtter.useAnimatedBinding(fadeOut and 1 or 0, v6)

	local ref = React.useRef(fadeOut)

	React.useEffect(function()
		local current = ref.current
		ref.current = fadeOut

		if current == fadeOut then
			return
		end

		v8(ReactOtter.ease(fadeOut and 1 or 0, {
			duration = durationSeconds,
			easingStyle = sine
		}))
	end, { fadeOut, durationSeconds, v8 })

	return React.cloneElement(data.placeholder, {
		transparencyBinding = v7,
		zIndex = data.zIndex
	})
end

local function SduiPlaceholderWrapper(p2)
	local isPlaceholder = p2.isPlaceholder == true
	local transitionDurationSeconds = p2.transitionDurationSeconds or 0.15

	local state, setState = React.useState(isPlaceholder)

	React.useEffect(function()
		if isPlaceholder and not state then
			setState(true)
		end
	end, { isPlaceholder, state })

	local v6 = React.useCallback(function()
		setState(false)
	end, {})

	local mountRealDuringPlaceholder = p2.mountRealDuringPlaceholder == true
	local v7

	if (not state or not isPlaceholder or mountRealDuringPlaceholder) and p2.real then
		local v8 = nil

		for k, v9 in p2 do
			if v5[k] then
				continue
			end

			v8 = v8 == nil and {} or v8

			v8[k] = v9
		end

		v7 = if v8 then React.cloneElement(p2.real, v8) else p2.real
	end

	local v8 = if state and p2.placeholder then React.createElement(PlaceholderHost, {
		placeholder = p2.placeholder,
		fadeOut = not isPlaceholder,
		durationSeconds = transitionDurationSeconds,
		onFadeComplete = v6,
		zIndex = 1e999
	}) else nil

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p2.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		ZIndex = p2.zIndex
	}, { Real = v7, Placeholder = v8 })
end

return React.memo(SduiPlaceholderWrapper)
