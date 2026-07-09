local Parent = script:FindFirstAncestor("GameFilters").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function OpenFilterMenuPeekView(p1, p2, p3, p4) -- line: 12
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	return function(p5) -- line: 13
		-- upvalues: AppPage (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GameFilterMenuPeekView,
			extraProps = {
				filter = p1,
				onFilterApplied = p2,
				onFilterMenuClosed = p3,
				sendFilterClick = p4
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v5.down(v5.fromLegacyPage(t1))

			return
		end

		p5:dispatch(NavigateDown(t1))
	end
end

return OpenFilterMenuPeekView
