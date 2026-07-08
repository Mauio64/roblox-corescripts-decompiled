local Parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DeviceType = RobloxAppEnums.DeviceType
local getDeviceType = require(Parent.AppCommonLib).getDeviceType
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(s1: string, s2: string) -- line: 14
	-- upvalues: getDeviceType (copy), DeviceType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
	return function(p1) -- line: 15
		-- upvalues: getDeviceType (copy), DeviceType (copy), AppPage (copy), s1 (copy), s2 (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
		local v12 = getDeviceType(p1:getState().DeviceOrientation)

		if v12 ~= DeviceType.Phone and v12 ~= DeviceType.Tablet then
			return
		end

		local t1 = {
			name = AppPage.InfoPeekView,
			extraProps = {
				title = s1,
				body = s2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v8.down(v8.fromLegacyPage(t1))

			return
		end

		p1:dispatch(NavigateDown(t1))
	end
end
