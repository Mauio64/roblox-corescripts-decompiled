local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux")
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppSessionization").SessionType
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")
local SessionType = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/SessionType")
local SplitL3Store = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitL3Store")
local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppEnums").AppPage
local splitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local tempRnSwitchNavigatorName = NavigationRodux.Constants.TempRnSwitchNavigatorName

local function routeHasSupportAboveContent(list, p2): boolean
	if p2 == nil then
		return false
	end

	local v5 = false

	for i = #list, 1, -1 do
		local v6 = p2[list[i].name]

		if v6 == splitPaneSlot.Support then
			v5 = true
		elseif v5 and v6 == splitPaneSlot.Content then
			return true
		end
	end

	return false
end

local v5 = nil

local function getLevel2RouteAndExclusions(items, eligibilityMap)
	if not routeHasSupportAboveContent(items, eligibilityMap) then
		v5 = nil
		return items, nil
	end

	local v6 = v5 == nil
	local v7 = v5 or {}
	local nameSet = {}
	local result = {}
	local v8 = false

	for k, item in items do
		local v9 = eligibilityMap[item.name]

		if v9 == splitPaneSlot.Support then
			v8 = true
			nameSet[item.name] = true

			if not v6 and v7[item.name] == nil then
				v6 = true
			end
		elseif v9 == splitPaneSlot.Content or not v8 then
			table.insert(result, item)
		else
			nameSet[item.name] = true

			if not v6 and v7[item.name] == nil then
				v6 = true
			end
		end
	end

	if not v6 then
		for k in v7 do
			if nameSet[k] == nil then
				v6 = true
				break
			end
		end
	end

	if v6 then
		v5 = nameSet
	end

	return result, v5
end

local function isAppPageName(p2): boolean
	if p2 == nil then
		return false
	end

	return appPage[p2] ~= nil
end

local function resolveL3Page(list, p2)
	local v6 = nil

	for i = #list, 1, -1 do
		local item = list[i]
		local v7 = p2[item.name]

		if v7 == splitPaneSlot.Content then
			continue
		end

		if v7 == splitPaneSlot.Support then
			if v6 == nil then
				return item, item
			end

			return v6, item
		elseif v6 == nil then
			local name = item.name
			local v8 = not (name == nil) and appPage[name] ~= nil

			if not v8 then
				v6 = item
			end
		end
	end

	return nil, nil
end

local function getSplitSubPaneTagFromRoute(p2, p3)
	local l3Page = resolveL3Page(p2, p3)

	if l3Page == nil then
		return nil
	end

	return SessionType.Tag.SplitSubPane[l3Page.name] or l3Page.name
end

local function getSplitSubPaneDetailFromRoute(p2, p3)
	local l3Page, v6 = resolveL3Page(p2, p3)

	if l3Page == nil then
		return nil
	end

	if l3Page.detail ~= nil then
		return l3Page.detail
	end

	if v6 == nil then
		return nil
	end

	return v6.detail
end

local function getIsSplitL3Enabled(p2)
	return SplitPaneStore.getStore().getIsBreakpointEnabled(p2)
end

local function resolveEligibilityMap(list, callback)
	local eligibilityMap = {}

	for i = #list, 1, -1 do
		local item = list[i]

		if callback == nil then
			continue
		end

		local v6 = callback(item.name)

		if v6 ~= nil then
			eligibilityMap[item.name] = v6
		end
	end

	return eligibilityMap
end

return {
	createGetL2Exclusions = function(p2)
		local fn = p2 ~= nil and function(p3)
			local v6 = {
				state = { routeName = p3 }
			}
			local success, result = pcall(function()
				return p2.getScreenOptions(v6, {})
			end)

			if success and result ~= nil and result.splitPaneEligibility ~= nil then
				return result.splitPaneEligibility
			end

			local v7 = if p2.childRouters then p2.childRouters[tempRnSwitchNavigatorName] else nil

			if v7 ~= nil then
				local success2, result2 = pcall(function()
					return v7.getScreenOptions(v6, {})
				end)

				if success2 and result2 ~= nil and result2.splitPaneEligibility ~= nil then
					return result2.splitPaneEligibility
				end
			end

			return nil
		end or nil

		return function(p3, p4)
			if not SplitPaneStore.getStore().getIsBreakpointEnabled(p3) or p4 == nil then
				return nil
			end

			local level2RouteAndExclusions, v6 = getLevel2RouteAndExclusions(
				p4,
				resolveEligibilityMap(p4, fn)
			)
			return v6
		end
	end,
	createResolveEligibility = function(p2)
		if p2 == nil then
			return nil
		end

		return function(p3)
			local v6 = {
				state = { routeName = p3 }
			}
			local success, result = pcall(function()
				return p2.getScreenOptions(v6, {})
			end)

			if success and result ~= nil and result.splitPaneEligibility ~= nil then
				return result.splitPaneEligibility
			end

			local v7 = if p2.childRouters then p2.childRouters[tempRnSwitchNavigatorName] else nil

			if v7 ~= nil then
				local success2, result2 = pcall(function()
					return v7.getScreenOptions(v6, {})
				end)

				if success2 and result2 ~= nil and result2.splitPaneEligibility ~= nil then
					return result2.splitPaneEligibility
				end
			end

			return nil
		end
	end,
	subscribeToRouteSignal = function(callback, p2)
		local v6 = nil
		local store = SplitL3Store.getStore()
		local function handleRouteChange(p3, p4)
			if p4 and p2 ~= nil then
				local eligibilityMap = resolveEligibilityMap(p3, p2)
				local v7 = routeHasSupportAboveContent(p3, eligibilityMap)
				local setPendingSplitSubPaneTag = store.setPendingSplitSubPaneTag
				local v8

				if v7 then
					local l3Page = resolveL3Page(p3, eligibilityMap)

					if l3Page ~= nil then
						v8 = SessionType.Tag.SplitSubPane[l3Page.name] or l3Page.name
					end
				end

				setPendingSplitSubPaneTag(v8)
				local setPendingSplitSubPaneDetail = store.setPendingSplitSubPaneDetail
				local detail

				if v7 then
					local l3Page, v9 = resolveL3Page(p3, eligibilityMap)

					if l3Page ~= nil then
						if l3Page.detail == nil then
							if v9 ~= nil then
								detail = v9.detail
							end
						else
							detail = l3Page.detail
						end
					end
				end

				setPendingSplitSubPaneDetail(detail)
			else
				store.setPendingSplitSubPaneTag(nil)
				store.setPendingSplitSubPaneDetail(nil)
			end
		end
		local v7 = callback(function(p3)
			v6 = p3
			handleRouteChange(p3, getIsSplitL3Enabled(false))
		end)
		local effect = Signals.createEffect(function(p3)
			local isBreakpointEnabled = SplitPaneStore.getStore().getIsBreakpointEnabled(p3)

			if v6 ~= nil then
				handleRouteChange(v6, isBreakpointEnabled)
			end
		end)
		return function()
			if v7 ~= nil and v7.disconnect ~= nil then
				v7:disconnect()
			end

			effect()
		end
	end,
	onSessionsUpdated = function()
		if not SplitPaneStore.getStore().getIsBreakpointEnabled(false) then
			return
		end

		local store = SplitL3Store.getStore()
		store.setSplitL2SessionVersion(store.getSplitL2SessionVersion(false) + 1)
	end,
	applySplitSubPaneSession = function(object, p2, ...)
		local v6 = select("#", ...) > 0
		local v7 = if v6 then ... else nil

		if not SplitPaneStore.getStore().getIsBreakpointEnabled(false) then
			v6 = true
			v7 = nil
			p2 = nil
		end

		local store = SplitL3Store.getStore()
		local splitL3AppliedDetail = store.getSplitL3AppliedDetail(false)
		local level2b = sessionType.StructuralIdentifier.Level2b
		local splitSubPane = SessionType.StructuralIdentifier.SplitSubPane
		local sessionExists = object:SessionExists(splitSubPane)
		local sessionTag = if sessionExists then object:GetSessionTag(splitSubPane) else nil

		local function writeAppliedDetail()
			if v6 then
				store.setSplitL3AppliedDetail(v7)
			else
				store.setSplitL3AppliedDetail(nil)
			end
		end

		if p2 == nil then
			if sessionExists then
				object:RemoveSession(splitSubPane)
			end

			store.setSplitL3AppliedDetail(nil)
		else
			if not object:SessionExists(level2b) then
				return
			end

			local v8 = v6 and splitL3AppliedDetail ~= v7

			if object:SessionExists(splitSubPane) then
				if sessionTag ~= p2 or v8 then
					object:ReplaceSession(splitSubPane, p2)

					if v6 then
						store.setSplitL3AppliedDetail(v7)
					else
						store.setSplitL3AppliedDetail(nil)
					end
				end
			else
				object:SetSession(level2b, splitSubPane, p2)

				if v6 then
					store.setSplitL3AppliedDetail(v7)
				else
					store.setSplitL3AppliedDetail(nil)
				end
			end
		end
	end
}
