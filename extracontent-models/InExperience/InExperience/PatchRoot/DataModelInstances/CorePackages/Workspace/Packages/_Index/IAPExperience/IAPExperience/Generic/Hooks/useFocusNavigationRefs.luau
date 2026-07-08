local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local FocusNavigationUtils = require(ParentParent.FocusNavigationUtils)
local InputHandlers = require(ParentParent.InputHandlers)
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require(ParentParent.ReactFocusNavigation).useDefaultFocusBehavior

local function mergeRefs(p1, p2) -- line: 13
	return function(p3) -- line: 14
		-- upvalues: p1 (copy), p2 (copy)
		if type(p1) == "function" then
			p1(p3)
		elseif p1 ~= nil then
			p1.current = p3
		end

		if type(p2) == "function" then
			p2(p3)

			return
		end

		if p2 ~= nil then
			p2.current = p3
		end
	end
end
local function useFocusNavigationRefs(p4, p5) -- line: 31
	-- upvalues: useDefaultFocusBehavior (copy), useFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), React (copy)
	local v15, v16 = useDefaultFocusBehavior()
	local v17 = useFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p4)
			}
		}
	})
	local v18 = React.useMemo(function() -- line: 44
		-- upvalues: v17 (copy), v16 (copy)
		local v23 = v17
		local v24 = v16

		return function(p6) -- line: 14
			-- upvalues: v23 (copy), v24 (copy)
			if type(v23) == "function" then
				v23(p6)
			elseif v23 ~= nil then
				v23.current = p6
			end

			if type(v24) == "function" then
				v24(p6)

				return
			end

			if v24 ~= nil then
				v24.current = p6
			end
		end
	end, {
		v17,
		v16
	})
	local v19 = React.useRef(nil)
	local v20 = React.useMemo(function() -- line: 50
		-- upvalues: v19 (copy), v15 (copy)
		local v25 = v19
		local v26 = v15

		return function(p7) -- line: 14
			-- upvalues: v25 (copy), v26 (copy)
			if type(v25) == "function" then
				v25(p7)
			elseif v25 ~= nil then
				v25.current = p7
			end

			if type(v26) == "function" then
				v26(p7)

				return
			end

			if v26 ~= nil then
				v26.current = p7
			end
		end
	end, { v15 })
	local v21 = React.useRef(false)

	React.useEffect(function() -- line: 56
		-- upvalues: v19 (copy), v21 (copy), p5 (copy)
		local current = v19.current

		if current and not v21.current then
			v21.current = true

			if p5 then
				p5(current)
			end
		end
	end, {
		v19.current,
		p5
	})

	return v18, v20
end

return useFocusNavigationRefs
