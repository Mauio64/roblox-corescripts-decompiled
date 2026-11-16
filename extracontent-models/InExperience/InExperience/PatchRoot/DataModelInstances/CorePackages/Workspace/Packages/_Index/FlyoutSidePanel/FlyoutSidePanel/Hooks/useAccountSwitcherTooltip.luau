local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local AppCommonLib = require(parent.AppCommonLib)
local AppStorageJsonCacheUtils = AppCommonLib.Utils.AppStorageJsonCacheUtils

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local defineFastInt = game:DefineFastInt("FlyoutAccountSwitcherTooltipMaxShows", 1)

local function readShowCount(object, flag: boolean?) -- 2 equivalent calls inferred from this helper
	local cachedJsonForKey = object:getCachedJsonForKey("FlyoutSidePanelAccountSwitcherTooltipSeen", flag)

	if typeof(cachedJsonForKey) == "number" then
		return cachedJsonForKey
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
		return readShowCount(v2) -- inferred equivalent call
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

	React.useEffect(function()
		if not v3 then
			setState2(false)
			setState(readShowCount(v2, true)) -- inferred equivalent call
		end
	end, { v3, v2 })

	local v5 = React.useCallback(function()
		setState2(true)
	end, {})

	local current = React.useCallback(function()
		setState2(true)
		writeShowCount(v, v2, defineFastInt) -- inferred equivalent call
	end, { v, v2 })

	if p3 ~= nil then
		p3.current = current
	end

	return v4, current, v5
end

return useAccountSwitcherTooltip
