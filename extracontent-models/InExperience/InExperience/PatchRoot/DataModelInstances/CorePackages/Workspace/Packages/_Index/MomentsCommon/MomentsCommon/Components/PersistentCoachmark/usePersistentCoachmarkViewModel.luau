local parent = script.Parent.Parent.Parent

require(parent.Utils.createCoachmarkImpressionCache)
local parent2 = parent.Parent
local React = require(parent2.React)

local function usePersistentCoachmarkViewModel(data)
	local impressionCache = data.impressionCache
	local onSessionHandled = data.onSessionHandled
	local autoDismissSeconds = data.autoDismissSeconds

	local v = React.useMemo(function(): boolean
		if data.isSessionHandled then
			return false
		end

		local value = impressionCache.getValue()
		return value >= 0 and value < data.maxImpressions
	end, {})

	local state, setState = React.useState(v)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if v and not ref.current then
			ref.current = true
			impressionCache.incrementValue()
			onSessionHandled()

			if data.onImpression ~= nil then
				data.onImpression()
			end
		end
	end, {})

	React.useEffect(function()
		if not state or autoDismissSeconds == nil then
			return
		end

		ref2.current = task.delay(autoDismissSeconds, function()
			setState(false)
		end)

		return function()
			if ref2.current ~= nil then
				task.cancel(ref2.current)
				ref2.current = nil
			end
		end
	end, { state, autoDismissSeconds })

	return {
		isOpen = state,
		onClose = React.useCallback(function()
			impressionCache.dismissValue()

			if data.onDismissed ~= nil then
				data.onDismissed()
			end

			setState(false)
		end, {})
	}
end

return usePersistentCoachmarkViewModel
