local Immutable = require(script.Parent.Parent.Immutable)

local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)
local SetTabList = require(script.Parent.Parent.Actions.SetTabList)

local FFlagDevConsoleTabReselectKeepsClientView = require(script.Parent.Flags.FFlagDevConsoleTabReselectKeepsClientView)

return function(p, data)
	local v = p or {
		isDeveloperView = false,
		isClientView = true,
		tabList = {},
		currTabIndex = nil
	}

	if data.type == SetActiveTab.name then
		if v.tabList[data.newTabIndex] then
			local v2 = { currTabIndex = data.newTabIndex, isClientView = data.isClientView }

			if v.currTabIndex ~= data.newTabIndex then
				v2.isClientView = true
			end

			if FFlagDevConsoleTabReselectKeepsClientView and v2.isClientView == nil then
				v2.isClientView = true
			end

			local joinDictionaries = Immutable.JoinDictionaries(v, v2)

			if v2.isClientView == nil then
				joinDictionaries = Immutable.RemoveFromDictionary(joinDictionaries, "isClientView")
			end

			return joinDictionaries
		end
	elseif data.type == SetTabList.name and data.tabList[data.initIndex] then
		local v2 = {
			currTabIndex = data.initIndex,
			tabList = data.tabList,
			isDeveloperView = data.isDeveloperView,
			isClientView = true
		}

		return Immutable.JoinDictionaries(v, v2)
	end

	return v
end
