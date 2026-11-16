local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/ftF")
local module2 = require("@luauforge/bundled/ftD")
local module3 = require("@luauforge/bundled/ftG")
local module4 = require("@luauforge/bundled/ftH")
local module5 = require("@luauforge/bundled/eda")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local fFlagUseSignalsForRobuxVirtualItem = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForRobuxVirtualItem
local getRobuxVirtualItemStore

if fFlagUseSignalsForRobuxVirtualItem then
	getRobuxVirtualItemStore = require("@luauforge/bundled/ftJ").GetRobuxVirtualItemStore
else
	getRobuxVirtualItemStore = nil
end

local function setLocalVirtualItemRobuxBadgeAcknowledgeTime(p2)
	AppStorageService:SetItem("VirtualItemRobuxBadgeAcknowledgeTime", (tostring(p2)))
	AppStorageService:Flush()
end

local function getLocalVirtualItemRobuxBadgeAcknowledgeTime()
	return AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1
end

local function useRobuxBadge(): nil
	local v5 = useRoactService(module5)
	local v6 = useDispatch()

	local v7 = if fFlagUseSignalsForRobuxVirtualItem then getRobuxVirtualItemStore(false) else nil
	local v8

	if fFlagUseSignalsForRobuxVirtualItem then
		v8 = useSignalState(v7.getBuyRobuxButtonClicked)
	else
		v8 = useSelector(function(p2)
			return p2.RobuxVirtualItem.buyRobuxButtonClicked
		end)
	end

	local v9

	if fFlagUseSignalsForRobuxVirtualItem then
		v9 = useSignalState(v7.getHasFetchedRobuxBadge)
	else
		v9 = useSelector(function(p2)
			return p2.RobuxVirtualItem.hasFetchedRobuxBadge
		end)
	end

	local state, setState = React.useState({
		isVirtualItemAvailable = false,
		activeVirtualItemStartTimeSecondsUtc = -1
	})

	React.useEffect(function()
		if v9 then
			return
		end

		v6(module4(v5)):andThen(function(p2)
			if
				p2.is_virtual_item_available == nil
				or p2.active_virtual_item_start_time_seconds_utc == nil
			then
				return
			end

			local item = tonumber(AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1)

			if p2.is_virtual_item_available and item < p2.active_virtual_item_start_time_seconds_utc then
				if fFlagUseSignalsForRobuxVirtualItem then
					v7.setShowBuyRobuxButtonBadge(true)
				else
					v6(module(true))
				end
			end

			if fFlagUseSignalsForRobuxVirtualItem then
				v7.setHasFetchedRobuxBadge(true)
			else
				v6(module3())
			end

			setState({
				isVirtualItemAvailable = p2.is_virtual_item_available,
				activeVirtualItemStartTimeSecondsUtc = p2.active_virtual_item_start_time_seconds_utc
			})
		end):catch(function() end)
	end, { v6, v5, v9, v7 })

	React.useEffect(function()
		if v8 then
			if fFlagUseSignalsForRobuxVirtualItem then
				v7.setBuyRobuxButtonClicked(false)
			else
				v6(module2(false))
			end

			if not (state and (state.isVirtualItemAvailable and state.activeVirtualItemStartTimeSecondsUtc)) then
				return
			end

			if tonumber(AppStorageService:GetItem("VirtualItemRobuxBadgeAcknowledgeTime") or -1) < state.activeVirtualItemStartTimeSecondsUtc then
				local v10 = os.time(os.date("!*t"))
				AppStorageService:SetItem("VirtualItemRobuxBadgeAcknowledgeTime", (tostring(v10)))
				AppStorageService:Flush()
			end

			if fFlagUseSignalsForRobuxVirtualItem then
				v7.setShowBuyRobuxButtonBadge(false)
			else
				v6(module(false))
			end
		end
	end, { v6, v8, state, v7 })

	return nil
end

return useRobuxBadge
