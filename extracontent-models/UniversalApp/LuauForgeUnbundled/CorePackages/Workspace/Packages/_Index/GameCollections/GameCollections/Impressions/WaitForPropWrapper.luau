local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.usePrevious
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/ArgCheck")

local defineFastFlag = game:DefineFastFlag("LuaAppEnableWaitForPropWrapperAssert", false)

local function WaitForPropWrapper(data)
	local waitForProp = data.waitForProp
	local maxUpdatesToDelay = data.maxUpdatesToDelay
	local wrappedComponent = data.wrappedComponent

	local v5 = usePrevious(waitForProp)
	local state, setState = React.useState(maxUpdatesToDelay)
	local v6

	if v5 == nil or waitForProp ~= nil or maxUpdatesToDelay == nil then
		v6 = false
	else
		v6 = state < maxUpdatesToDelay
	end

	React.useEffect(function()
		if not (maxUpdatesToDelay and waitForProp == nil) then
			return
		end

		if v6 then
			task.delay(0, function()
				setState(maxUpdatesToDelay)
			end)
		elseif state and state > 0 then
			task.delay(0, function()
				setState(state - 1)
			end)
		end
	end, { waitForProp, maxUpdatesToDelay, state, v6 })

	local flag = true

	if waitForProp == nil and maxUpdatesToDelay ~= nil then
		if v6 or state and state > 0 then
			flag = false
		elseif defineFastFlag then
			ArgCheck.assert(
				waitForProp,
				`Missing data for prop for this game collection, after waiting {maxUpdatesToDelay} updates`
			)
		end
	end

	if flag then
		return wrappedComponent
	end

	return nil
end

return WaitForPropWrapper
