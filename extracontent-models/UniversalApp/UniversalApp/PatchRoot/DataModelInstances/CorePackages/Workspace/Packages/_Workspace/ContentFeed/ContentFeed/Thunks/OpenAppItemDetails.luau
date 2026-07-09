local ParentParent = script.Parent.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local NavigationRodux = require(ParentParent.NavigationRodux)
local AppPage = require(ParentParent.RobloxAppEnums).AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParent.RobloxAppNavigation).NavigationCommands

return function(s1: string) -- line: 18
	-- upvalues: AppPage (copy), Cryo (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	return function(p1) -- line: 19
		-- upvalues: s1 (copy), AppPage (copy), Cryo (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		local v10 = "Asset" .. s1
		local t1 = {
			fromContentFeed = true,
			itemType = "Asset",
			mountAnimation = false,
			mountAsFullView = true,
			itemDetailsPeekViewRefs = {},
			itemId = s1
		}
		local t2 = {
			name = AppPage.AvatarExperienceWrapper,
			detail = v10,
			extraProps = {
				routeName = "ItemDetails",
				params = Cryo.Dictionary.join(t1, {
					detail = v10
				})
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t2))

			return
		end

		p1:dispatch(NavigateDown(t2))
	end
end
