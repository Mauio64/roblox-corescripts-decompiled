local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local function mergeRefs(callback, callback2) -- 2 equivalent calls inferred from this helper
	return function(current)
		if type(callback) == "function" then
			callback(current)
		elseif callback ~= nil then
			callback.current = current
		end

		if type(callback2) == "function" then
			callback2(current)
		elseif callback2 ~= nil then
			callback2.current = current
		end
	end
end

local function useFocusNavigationRefs(p, callback)
	local v, v2 = useDefaultFocusBehavior()
	local v3 = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = InputHandlers.onRelease(p) }
		},
		isAutoFocusRoot = true
	})

	local v4 = React.useMemo(function()
		return mergeRefs(v3, v2) -- inferred equivalent call
	end, { v3, v2 })

	local ref = React.useRef(nil)
	local v5 = React.useMemo(function()
		return mergeRefs(ref, v) -- inferred equivalent call
	end, { v })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		local current = ref.current

		if current and not ref2.current then
			ref2.current = true

			if callback then
				callback(current)
			end
		end
	end, { ref.current, callback })

	return v4, v5
end

return useFocusNavigationRefs
