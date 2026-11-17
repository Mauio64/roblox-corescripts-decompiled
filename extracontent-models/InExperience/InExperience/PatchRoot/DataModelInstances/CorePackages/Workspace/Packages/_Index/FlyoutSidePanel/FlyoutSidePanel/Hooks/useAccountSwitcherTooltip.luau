local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local AppCommonLib = require(parent.AppCommonLib)
local AppStorageJsonCacheUtils = AppCommonLib.Utils.AppStorageJsonCacheUtils

local FFlagFixFlyoutAccountSwitcherTooltipEmptyString = require(FlyoutSidePanel.Flags.FFlagFixFlyoutAccountSwitcherTooltipEmptyString)

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local defineFastInt = game:DefineFastInt("FlyoutAccountSwitcherTooltipMaxShows", 1)

local function readShowCount(object, flag: boolean?, object2)
	local cachedJsonForKey = object:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", flag)

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

local function writeShowCount(object, object2, p: number) -- 2 equivalent calls inferred from this helper
	if pcall(function()
		object:SetItem("FlyoutSidePanelAccountSwitcherTooltipSeen", HttpService:JSONEncode(p))
		object:Flush()
	end) then
		object2:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", true)
	end
end

local function useAccountSwitcherTooltip(p, flag: boolean, p2, p3)
	local v

	if p2 == nil then
		v = AppStorageService
	else
		v = p2
	end

	local v2 = React.useMemo(function()
		if p2 == nil then
			return AppStorageJsonCacheUtils.default
		end

		return AppStorageJsonCacheUtils.new(v)
	end, { p2, v })
	local v3 = useDrawerVisible()
	local state, setState = React.useState(function()
		local v4

		if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then
			v4 = v
		end

		return readShowCount(v2, nil, v4)
	end)

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	React.useEffect(function()
		setState3(p.current ~= nil)
	end, { p, v3, flag })

	local v4 = flag and v3 and state3 and not state2

	if v4 then
		if state == nil then
			v4 = false
		else
			v4 = state < defineFastInt
		end
	end

	React.useEffect(function()
		if v4 and state ~= nil then
			writeShowCount(v, v2, state + 1) -- inferred equivalent call
		end
	end, { v4, state, v, v2 })

	local useEffect = React.useEffect
	local function fn()
		if not v3 then
			setState2(false)
			local v5

			if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then
				v5 = v
			end

			setState(readShowCount(v2, true, v5))
		end
	end

	local v5

	if FFlagFixFlyoutAccountSwitcherTooltipEmptyString then
		v5 = v
	end

	useEffect(fn, { v3, v2, v5 })

	local v6 = React.useCallback(function()
		setState2(true)
	end, {})

	local current = React.useCallback(function()
		setState2(true)
		writeShowCount(v, v2, defineFastInt) -- inferred equivalent call
	end, { v, v2 })

	if p3 ~= nil then
		p3.current = current
	end

	return v4, current, v6
end

return useAccountSwitcherTooltip
