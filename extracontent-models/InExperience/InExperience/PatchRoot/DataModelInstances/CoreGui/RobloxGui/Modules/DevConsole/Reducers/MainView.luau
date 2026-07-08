local Immutable = require(script.Parent.Parent.Immutable)
local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)
local SetTabList = require(script.Parent.Parent.Actions.SetTabList)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 14
	-- upvalues: SetActiveTab (copy), Immutable (copy), SetTabList (copy)
	local v6 = t1 or {
		isDeveloperView = false,
		isClientView = true,
		currTabIndex = nil,
		tabList = {}
	}

	if t2.type == SetActiveTab.name then
		if v6.tabList[t2.newTabIndex] then
			local t3 = {
				currTabIndex = t2.newTabIndex,
				isClientView = t2.isClientView
			}

			if v6.currTabIndex ~= t2.newTabIndex then
				t3.isClientView = true
			end

			local v8 = Immutable.JoinDictionaries(v6, t3)

			if t3.isClientView == nil then
				v8 = Immutable.RemoveFromDictionary(v8, "isClientView")
			end

			return v8
		end
	elseif t2.type == SetTabList.name and t2.tabList[t2.initIndex] then
		local t4 = {
			isClientView = true,
			currTabIndex = t2.initIndex,
			tabList = t2.tabList,
			isDeveloperView = t2.isDeveloperView
		}

		return Immutable.JoinDictionaries(v6, t4)
	end

	return v6
end
