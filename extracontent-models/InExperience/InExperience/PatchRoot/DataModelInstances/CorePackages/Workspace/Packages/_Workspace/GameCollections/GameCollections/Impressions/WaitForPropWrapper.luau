local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local usePrevious = require(Parent.RoactUtils).Hooks.usePrevious
local ArgCheck = require(Parent.ArgCheck)
local v5 = game:DefineFastFlag("LuaAppEnableWaitForPropWrapperAssert", false)

local function WaitForPropWrapper(t1: {[any]: any}) -- line: 15
	-- upvalues: usePrevious (copy), React (copy), v5 (copy), ArgCheck (copy)
	local waitForProp = t1.waitForProp
	local maxUpdatesToDelay = t1.maxUpdatesToDelay
	local wrappedComponent = t1.wrappedComponent
	local v11 = usePrevious(waitForProp)
	local v12, v13 = React.useState(maxUpdatesToDelay)
	local v14 = v11 ~= nil and (waitForProp == nil and (maxUpdatesToDelay ~= nil and v12 < maxUpdatesToDelay))

	React.useEffect(function() -- line: 27
		-- upvalues: maxUpdatesToDelay (copy), waitForProp (copy), v14 (copy), v13 (copy), v12 (copy)
		if not maxUpdatesToDelay then
			return
		end

		if waitForProp ~= nil then
			return
		end

		if v14 then
			task.delay(0, function() -- line: 38
				-- upvalues: v13 (copy), maxUpdatesToDelay (copy)
				v13(maxUpdatesToDelay)
			end)

			return
		end

		if v12 and v12 > 0 then
			task.delay(0, function() -- line: 43
				-- upvalues: v13 (copy), v12 (copy)
				v13(v12 - 1)
			end)
		end
	end, {
		waitForProp,
		maxUpdatesToDelay,
		v12,
		v14
	})

	local v15 = true

	if waitForProp == nil and maxUpdatesToDelay ~= nil then
		if v14 then
			v15 = false
		elseif v12 and v12 > 0 then
			v15 = false
		elseif v5 then
			ArgCheck.assert(waitForProp, `Missing data for prop for this game collection, after waiting { maxUpdatesToDelay } updates`)
		end
	end

	if v15 then
		return wrappedComponent
	end

	return nil
end

return WaitForPropWrapper
