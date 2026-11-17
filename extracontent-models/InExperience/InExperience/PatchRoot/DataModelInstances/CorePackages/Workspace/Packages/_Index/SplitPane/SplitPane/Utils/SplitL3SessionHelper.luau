local SplitPane = script:FindFirstAncestor("SplitPane")
local parent = SplitPane.Parent

local AppSplitView = require(parent.AppSplitView)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType
local Signals = require(parent.Signals)
local SessionType2 = require(SplitPane.SessionType)
local SplitL3Store = require(SplitPane.Stores.SplitL3Store)
local SplitPaneStore = require(SplitPane.Stores.SplitPaneStore)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local TempRnSwitchNavigatorName = NavigationRodux.Constants.TempRnSwitchNavigatorName

local function routeHasSupportAboveContent(list, p): boolean
	if p == nil then
		return false
	end

	local v = false

	for i = #list, 1, -1 do
		local v2 = p[list[i].name]

		if v2 == SplitPaneSlot.Support then
			v = true
		elseif v and v2 == SplitPaneSlot.Content then
			return true
		end
	end

	return false
end

local function createResolveEligibility(p) -- 1 equivalent call inferred from this helper
	if p == nil then
		return nil
	end

	return function(routeName: string)
		local v = {
			state = { routeName = routeName }
		}
		local success, result = pcall(function()
			return p.getScreenOptions(v, {})
		end)

		if success and result ~= nil and result.splitPaneEligibility ~= nil then
			return result.splitPaneEligibility
		end

		local v2

		if p.childRouters then
			v2 = p.childRouters[TempRnSwitchNavigatorName]
		else
			v2 = nil
		end

		if v2 ~= nil then
			local success2, result2 = pcall(function()
				return v2.getScreenOptions(v, {})
			end)

			if success2 and result2 ~= nil and result2.splitPaneEligibility ~= nil then
				return result2.splitPaneEligibility
			end
		end

		return nil
	end
end

local v = nil

local function getLevel2RouteAndExclusions(items, eligibilityMap)
	if not routeHasSupportAboveContent(items, eligibilityMap) then
		v = nil
		return items, nil
	end

	local v2 = v == nil
	local v3 = v or {}
	local nameSet = {}
	local result = {}
	local v4 = false

	for _, item in items do
		local v5 = eligibilityMap[item.name]

		if v5 == SplitPaneSlot.Support then
			v4 = true
			nameSet[item.name] = true

			if not v2 and v3[item.name] == nil then
				v2 = true
			end
		elseif v5 == SplitPaneSlot.Content or not v4 then
			table.insert(result, item)
		else
			nameSet[item.name] = true

			if not v2 and v3[item.name] == nil then
				v2 = true
			end
		end
	end

	if not v2 then
		for k in v3 do
			if nameSet[k] == nil then
				v2 = true
				break
			end
		end
	end

	if v2 then
		v = nameSet
	end

	return result, v
end

local function isAppPageName(name: string?): boolean -- 1 equivalent call inferred from this helper
	return name ~= nil and AppPage[name] ~= nil
end

local function resolveL3Page(list, p)
	local v2 = nil

	for i = #list, 1, -1 do
		local item = list[i]
		local v3 = p[item.name]

		if v3 == SplitPaneSlot.Content then
			continue
		end

		if v3 == SplitPaneSlot.Support then
			if v2 == nil then
				return item, item
			end

			return v2, item
		elseif v2 == nil and not isAppPageName(item.name) then -- inferred equivalent call
			v2 = item
		end
	end

	return nil, nil
end

local function getSplitSubPaneTagFromRoute(p, eligibilityMap) -- 1 equivalent call inferred from this helper
	local l3Page = resolveL3Page(p, eligibilityMap)

	if l3Page == nil then
		return nil
	end

	return SessionType2.Tag.SplitSubPane[l3Page.name] or l3Page.name
end

local function getSplitSubPaneDetailFromRoute(p, eligibilityMap) -- 1 equivalent call inferred from this helper
	local l3Page, v2 = resolveL3Page(p, eligibilityMap)

	if l3Page == nil then
		return nil
	end

	if l3Page.detail ~= nil then
		return l3Page.detail
	end

	return if v2 ~= nil then v2.detail else nil
end

local function getIsSplitL3Enabled(p) -- 4 equivalent calls inferred from this helper
	return SplitPaneStore.getStore().getIsBreakpointEnabled(p)
end

local function resolveEligibilityMap(list, callback)
	local eligibilityMap = {}

	for i = #list, 1, -1 do
		local item = list[i]

		if callback == nil then
			continue
		end

		local v2 = callback(item.name)

		if v2 ~= nil then
			eligibilityMap[item.name] = v2
		end
	end

	return eligibilityMap
end

local SplitL3SessionHelper = {}

function SplitL3SessionHelper.createGetL2Exclusions(p)
	local resolveEligibility = createResolveEligibility(p) -- inferred equivalent call
	return function(p2, p3)
		if not getIsSplitL3Enabled(p2) or p3 == nil then -- inferred equivalent call
			return nil
		end

		local _, v2 = getLevel2RouteAndExclusions(p3, resolveEligibilityMap(p3, resolveEligibility))
		return v2
	end
end

SplitL3SessionHelper.createResolveEligibility = createResolveEligibility

function SplitL3SessionHelper.subscribeToRouteSignal(callback, callback2)
	local v2 = nil
	local store = SplitL3Store.getStore()
	local function handleRouteChange(p, flag: boolean)
		if flag and callback2 ~= nil then
			local eligibilityMap = resolveEligibilityMap(p, callback2)
			local v3 = routeHasSupportAboveContent(p, eligibilityMap)
			local setPendingSplitSubPaneTag = store.setPendingSplitSubPaneTag
			local v4

			if v3 then
				v4 = getSplitSubPaneTagFromRoute(p, eligibilityMap) -- inferred equivalent call
			end

			setPendingSplitSubPaneTag(v4)
			local setPendingSplitSubPaneDetail = store.setPendingSplitSubPaneDetail
			local v5

			if v3 then
				v5 = getSplitSubPaneDetailFromRoute(p, eligibilityMap) -- inferred equivalent call
			end

			setPendingSplitSubPaneDetail(v5)
		else
			store.setPendingSplitSubPaneTag(nil)
			store.setPendingSplitSubPaneDetail(nil)
		end
	end
	local v3 = callback(function(p)
		v2 = p
		handleRouteChange(p, getIsSplitL3Enabled(false))
	end)
	local effect = Signals.createEffect(function(p)
		local isSplitL3Enabled = getIsSplitL3Enabled(p) -- inferred equivalent call

		if v2 ~= nil then
			handleRouteChange(v2, isSplitL3Enabled)
		end
	end)
	return function()
		if v3 ~= nil and v3.disconnect ~= nil then
			v3:disconnect()
		end

		effect()
	end
end

function SplitL3SessionHelper.onSessionsUpdated()
	if not getIsSplitL3Enabled(false) then -- inferred equivalent call
		return
	end

	local store = SplitL3Store.getStore()
	store.setSplitL2SessionVersion(store.getSplitL2SessionVersion(false) + 1)
end

function SplitL3SessionHelper.applySplitSubPaneSession(object, p: string?, ...)
	local v2 = select("#", ...) > 0
	local v3

	if v2 then
		v3 = ...
	else
		v3 = nil
	end

	if not getIsSplitL3Enabled(false) then -- inferred equivalent call
		v2 = true
		v3 = nil
		p = nil
	end

	local store = SplitL3Store.getStore()
	local splitL3AppliedDetail = store.getSplitL3AppliedDetail(false)
	local level2b = SessionType.StructuralIdentifier.Level2b
	local splitSubPane = SessionType2.StructuralIdentifier.SplitSubPane
	local sessionExists = object:SessionExists(splitSubPane)
	local sessionTag

	if sessionExists then
		sessionTag = object:GetSessionTag(splitSubPane)
	end

	local function writeAppliedDetail() -- 2 equivalent calls inferred from this helper
		if v2 then
			store.setSplitL3AppliedDetail(v3)
		else
			store.setSplitL3AppliedDetail(nil)
		end
	end

	if p == nil then
		if sessionExists then
			object:RemoveSession(splitSubPane)
		end

		store.setSplitL3AppliedDetail(nil)
	else
		if not object:SessionExists(level2b) then
			return
		end

		local v4 = v2 and splitL3AppliedDetail ~= v3

		if object:SessionExists(splitSubPane) then
			if sessionTag ~= p or v4 then
				object:ReplaceSession(splitSubPane, p)
				writeAppliedDetail() -- inferred equivalent call
			end
		else
			object:SetSession(level2b, splitSubPane, p)
			writeAppliedDetail() -- inferred equivalent call
		end
	end
end

return SplitL3SessionHelper
