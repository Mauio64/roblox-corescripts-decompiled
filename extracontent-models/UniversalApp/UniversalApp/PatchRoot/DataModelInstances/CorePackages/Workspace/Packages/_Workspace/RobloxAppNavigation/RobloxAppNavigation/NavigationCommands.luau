local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local RoactNavigation = require(Parent.RoactNavigation)
local AppNavigationRegistry = require(script.Parent.AppNavigationRegistry)
local FFlagLuaAppNavigationTTITracking = require(Parent.SharedFlags).FFlagLuaAppNavigationTTITracking
local trackStart = nil

if FFlagLuaAppNavigationTTITracking then
	trackStart = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker.trackStart
end

local function isNavigationLocked(b1: boolean?) -- line: 37
	-- upvalues: AppNavigationRegistry (copy)
	return not b1 and AppNavigationRegistry.get().getIsNavigating(false)
end

return {
	back = function(b2: boolean?) -- line: 69
		-- upvalues: AppNavigationRegistry (copy), RoactNavigation (copy)
		if not b2 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.back())
	end,
	down = function(t1: {[any]: any}, b3: boolean?) -- line: 76
		-- upvalues: AppNavigationRegistry (copy), trackStart (ref), RoactNavigation (copy)
		if not b3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. t1.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.push(t1))
	end,
	to = function(t2: {[any]: any}, b4: boolean?) -- line: 86
		-- upvalues: AppNavigationRegistry (copy), trackStart (ref), RoactNavigation (copy)
		if not b4 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. t2.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(t2))
	end,
	sideways = function(t3: {[any]: any}, b5: boolean?) -- line: 96
		-- upvalues: AppNavigationRegistry (copy), trackStart (ref), RoactNavigation (copy)
		if not b5 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. t3.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(t3))
	end,
	fromWebView = function(t4: {[any]: any}, b6: boolean?) -- line: 106
		-- upvalues: AppNavigationRegistry (copy), trackStart (ref), RoactNavigation (copy)
		if not b6 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. t4.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.replace(t4))
	end,
	resetStack = function(t5: {[any]: any}, t6: {[any]: any}?, b7: boolean?) -- line: 120
		-- upvalues: AppNavigationRegistry (copy), RoactNavigation (copy), trackStart (ref)
		if not b7 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		local t7 = {}
		local v25 = if not t6 then nil else t6.wrapAction

		for _, v27 in t5 do
			local v28 = RoactNavigation.Actions.navigate(v27)

			if v25 then
				v28 = v25(v28, v27) or v28
			end

			table.insert(t7, v28)
		end

		if trackStart then
			local v29 = t5[#t5]

			if v29 then
				trackStart("NavigateTo_" .. v29.routeName, true)
			end
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.reset({
			index = #t7,
			actions = t7
		}))
	end,
	fromLegacyPage = function(t8: {[any]: any}) -- line: 52
		local t9 = nil

		for v10, v11 in t8 do
			if v10 ~= "name" and v10 ~= "rnKey" and v10 ~= "key" then
				if t9 == nil then
					t9 = {}
				end

				t9[v10] = v11
			end
		end

		return {
			routeName = t8.name,
			params = t9,
			key = t8.rnKey or t8.key
		}
	end
}
