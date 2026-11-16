local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/InputHandlers")
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/ReactFocusNavigation").useDefaultFocusBehavior

local function mergeRefs(callback, callback2)
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

local function useFocusNavigationRefs(p2, callback)
	local v5, v6 = useDefaultFocusBehavior()
	local v10 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p2)
			}
		},
		isAutoFocusRoot = true
	})

	local v11 = React.useMemo(function()
		local v12 = v10
		local v13 = v6
		return function(current)
			if type(v12) == "function" then
				v12(current)
			elseif v12 ~= nil then
				v12.current = current
			end

			if type(v13) == "function" then
				v13(current)
			elseif v13 ~= nil then
				v13.current = current
			end
		end
	end, { v10, v6 })

	local ref = React.useRef(nil)
	local v12 = React.useMemo(function()
		local v13 = ref
		local v14 = v5
		return function(current)
			if type(v13) == "function" then
				v13(current)
			elseif v13 ~= nil then
				v13.current = current
			end

			if type(v14) == "function" then
				v14(current)
			elseif v14 ~= nil then
				v14.current = current
			end
		end
	end, { v5 })

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

	return v11, v12
end

return useFocusNavigationRefs
