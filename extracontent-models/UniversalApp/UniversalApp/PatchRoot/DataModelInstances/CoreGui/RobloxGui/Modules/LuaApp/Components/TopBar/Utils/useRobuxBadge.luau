local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local SetShowBuyRobuxButtonBadge = require(Modules.LuaApp.Actions.Economy.SetShowBuyRobuxButtonBadge)
local SetBuyRobuxButtonClicked = require(Modules.LuaApp.Actions.Economy.SetBuyRobuxButtonClicked)
local SetHasFetchedRobuxBadge = require(Modules.LuaApp.Actions.Economy.SetHasFetchedRobuxBadge)
local ApiFetchRobuxBadge = require(Modules.LuaApp.Thunks.Economy.ApiFetchRobuxBadge)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService

local function setLocalVirtualItemRobuxBadgeAcknowledgeTime(n1: number) -- line: 23
	-- upvalues: AppStorageService (copy)
	AppStorageService:SetItem("VirtualItemRobuxBadgeAcknowledgeTime", (tostring(n1)))
	AppStorageService:Flush()
end
local function getLocalVirtualItemRobuxBadgeAcknowledgeTime() -- line: 28
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1
end
local function useRobuxBadge() -- line: 32
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useSelector (copy), React (copy), ApiFetchRobuxBadge (copy), AppStorageService (copy), SetShowBuyRobuxButtonBadge (copy), SetHasFetchedRobuxBadge (copy), SetBuyRobuxButtonClicked (copy)
	local v17 = useRoactService(RoactNetworking)
	local v18 = useDispatch()
	local v19 = useSelector(function(p1) -- line: 35
		return p1.RobuxVirtualItem.buyRobuxButtonClicked
	end)
	local v20 = useSelector(function(p2) -- line: 38
		return p2.RobuxVirtualItem.hasFetchedRobuxBadge
	end)
	local v21, v22 = React.useState({
		isVirtualItemAvailable = false,
		activeVirtualItemStartTimeSecondsUtc = -1
	})

	React.useEffect(function() -- line: 47
		-- upvalues: v20 (copy), v18 (copy), ApiFetchRobuxBadge (copy), v17 (copy), AppStorageService (copy), SetShowBuyRobuxButtonBadge (copy), SetHasFetchedRobuxBadge (copy), v22 (copy)
		if v20 then
			return
		end

		v18(ApiFetchRobuxBadge(v17)):andThen(function(t1: {[any]: any}) -- line: 53
			-- upvalues: AppStorageService (copy), v18 (copy), SetShowBuyRobuxButtonBadge (copy), SetHasFetchedRobuxBadge (copy), v22 (copy)
			if t1.is_virtual_item_available == nil or t1.active_virtual_item_start_time_seconds_utc == nil then
				return
			end

			local num = tonumber(AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1)

			if t1.is_virtual_item_available and num < t1.active_virtual_item_start_time_seconds_utc then
				v18(SetShowBuyRobuxButtonBadge(true))
			end

			v18(SetHasFetchedRobuxBadge())
			v22({
				isVirtualItemAvailable = t1.is_virtual_item_available,
				activeVirtualItemStartTimeSecondsUtc = t1.active_virtual_item_start_time_seconds_utc
			})
		end):catch(function() -- line: 75
		end)
	end, {
		v18,
		v17,
		v20
	})
	React.useEffect(function() -- line: 80
		-- upvalues: v19 (copy), v18 (copy), SetBuyRobuxButtonClicked (copy), v21 (copy), AppStorageService (copy), SetShowBuyRobuxButtonBadge (copy)
		if v19 then
			v18(SetBuyRobuxButtonClicked(false))

			if not v21 then
				return
			end

			if not v21.isVirtualItemAvailable or not v21.activeVirtualItemStartTimeSecondsUtc then
				return
			end

			if tonumber(AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1) < v21.activeVirtualItemStartTimeSecondsUtc then
				local timestamp = os.time(os.date("!*t"))

				AppStorageService:SetItem("VirtualItemRobuxBadgeAcknowledgeTime", (tostring(timestamp)))
				AppStorageService:Flush()
			end

			v18(SetShowBuyRobuxButtonBadge(false))
		end
	end, {
		v19,
		v21
	})

	return nil
end

return useRobuxBadge
