local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible
local appStorageJsonCacheUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/AppCommonLib").Utils.AppStorageJsonCacheUtils

local FFlagFixFlyoutAccountSwitcherTooltipEmptyString = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFixFlyoutAccountSwitcherTooltipEmptyString")

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local defineFastInt = game:DefineFastInt("FlyoutAccountSwitcherTooltipMaxShows", 1)

local function readShowCount(object, p2, object2)
	local cachedJsonForKey = object:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", p2)

	if typeof(cachedJsonForKey) == "number" then
		return cachedJsonForKey
	end

	if FFlagFixFlyoutAccountSwitcherTooltipEmptyString and object2 ~= nil then
		local success, result = pcall(function()
			return object2:GetItem("FlyoutSidePanelAccountSwitcherTooltipSeen")
		end)

		if success and result == "" then
			return 0
		end
	end

	return nil
end

local function writeShowCount(object, object2, p2)
	if pcall(function()
		object:SetItem("FlyoutSidePanelAccountSwitcherTooltipSeen", HttpService:JSONEncode(p2))
		object:Flush()
	end) then
		object2:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", true)
	end
end

local function useAccountSwitcherTooltip(p2, p3, p4, p5)
	local v5 = if p4 == nil then AppStorageService else p4
	local v6 = React.useMemo(function()
		if p4 == nil then
			return appStorageJsonCacheUtils.default
		end

		return appStorageJsonCacheUtils.new(v5)
	end, { p4, v5 })
	local v7 = useDrawerVisible()
	local state, setState = React.useState(function()
		local v11 = if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then v5 else nil
		return readShowCount(v6, nil, v11)
	end)

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	React.useEffect(function()
		setState3(p2.current ~= nil)
	end, { p2, v7, p3 })

	local v8 = p3 and v7 and state3 and not state2

	if v8 then
		v8 = not (state == nil) and state < defineFastInt
	end

	React.useEffect(function()
		if v8 and state ~= nil then
			local v9 = v5
			local v10 = v6
			local v11 = state + 1

			if pcall(function()
				v9:SetItem("FlyoutSidePanelAccountSwitcherTooltipSeen", HttpService:JSONEncode(v11))
				v9:Flush()
			end) then
				v10:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", true)
			end
		end
	end, { v8, state, v5, v6 })

	local function fn()
		if not v7 then
			setState2(false)
			local v13 = if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then v5 else nil
			setState(readShowCount(v6, true, v13))
		end
	end

	React.useEffect(fn, { v7, v6, if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then v5 else nil })

	local v11 = React.useCallback(function()
		setState2(true)
	end, {})

	local v12 = React.useCallback(function()
		setState2(true)
		local v13 = v5
		local v14 = v6
		local v15 = defineFastInt

		if pcall(function()
			v13:SetItem("FlyoutSidePanelAccountSwitcherTooltipSeen", HttpService:JSONEncode(v15))
			v13:Flush()
		end) then
			v14:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", true)
		end
	end, { v5, v6 })

	if p5 ~= nil then
		p5.current = v12
	end

	return v8, v12, v11
end

return useAccountSwitcherTooltip
