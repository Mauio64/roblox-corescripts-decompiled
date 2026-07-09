local Parent = script:FindFirstAncestor("OnPlatformSurveys").Parent
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local React = require(Parent.React)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local useDefaultFocusBehavior = require(Parent.ReactFocusNavigation).useDefaultFocusBehavior

local function mergeRefs(p1, p2) -- line: 21
	return function(p3) -- line: 22
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
local function useSurveyFocusRefs(p4, p5: ((...any) -> ...any)) -- line: 37
	-- upvalues: useDefaultFocusBehavior (copy), useAppFocusRoot (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), React (copy)
	local v14 = useDefaultFocusBehavior()
	local v15 = useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = p4,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p5)
			}
		}
	})

	return React.useMemo(function() -- line: 49
		-- upvalues: v15 (copy), v14 (copy)
		local v17 = v15
		local v18 = v14

		return function(p6) -- line: 22
			-- upvalues: v17 (copy), v18 (copy)
			if type(v17) == "function" then
				v17(p6)
			elseif v17 ~= nil then
				v17.current = p6
			end

			if type(v18) == "function" then
				v18(p6)

				return
			end

			if v18 ~= nil then
				v18.current = p6
			end
		end
	end, {
		v15,
		v14
	})
end

return useSurveyFocusRefs
