local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local usePrevious = RoactUtils.Hooks.usePrevious
local ArgCheck = require(parent.ArgCheck)

local defineFastFlag = game:DefineFastFlag("LuaAppEnableWaitForPropWrapperAssert", false)

local function WaitForPropWrapper(data)
	local waitForProp = data.waitForProp
	local maxUpdatesToDelay = data.maxUpdatesToDelay
	local wrappedComponent = data.wrappedComponent

	local v = usePrevious(waitForProp)
	local state, setState = React.useState(maxUpdatesToDelay)
	local v2

	if v == nil or waitForProp ~= nil or maxUpdatesToDelay == nil then
		v2 = false
	else
		v2 = state < maxUpdatesToDelay
	end

	React.useEffect(function()
		if not (maxUpdatesToDelay and waitForProp == nil) then
			return
		end

		if v2 then
			task.delay(0, function()
				setState(maxUpdatesToDelay)
			end)
		elseif state and state > 0 then
			task.delay(0, function()
				setState(state - 1)
			end)
		end
	end, { waitForProp, maxUpdatesToDelay, state, v2 })

	local flag = true

	if waitForProp == nil and maxUpdatesToDelay ~= nil then
		if v2 or state and state > 0 then
			flag = false
		elseif defineFastFlag then
			ArgCheck.assert(
				waitForProp,
				`Missing data for prop for this game collection, after waiting {maxUpdatesToDelay} updates`
			)
		end
	end

	return if flag then wrappedComponent else nil
end

return WaitForPropWrapper
