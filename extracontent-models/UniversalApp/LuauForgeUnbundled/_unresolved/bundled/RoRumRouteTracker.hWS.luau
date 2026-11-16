local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local React = require(CorePackages.Packages.React)
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")

local v5 = nil
local function getRoRum()
	if v5 == nil then
		v5 = require("@luauforge/bundled/hWv") or false
	end

	if v5 then
		return v5
	end

	return nil
end

local getActiveRoutes = Navigation.getActiveRoutes
local useNavigation = Navigation.useNavigation

local function formatRoutePath(items)
	local routeNames = {}

	for k, item in items do
		table.insert(routeNames, item.routeName or item.name or item.key or "?")
	end

	return table.concat(routeNames, " > ")
end

local function recordNavigationSpan(p2)
	if v5 == nil then
		v5 = require("@luauforge/bundled/hWv") or false
	end

	local v6 = if v5 then v5 else nil

	if not v6 then
		return
	end

	local v7 = v6:startSpan({
		log_type = "navigation",
		category = "active_route",
		message = p2
	})

	v7:setExtraMetadata({ route = p2 })

	v7:endSpan()

	if RunService:IsStudio() then
		print("[LuaAppRoRum]", HttpService:JSONEncode(v7:toDisplay()))
	end
end

local function useActiveRoutesEffect(state, onActiveRoutesChanged)
	local v6 = React.useMemo(function()
		return getActiveRoutes(state)
	end, { state })

	local v7 = { (React.useMemo(function()
			local v8 = {}

			for k, v9 in v6 do
				table.insert(v8, v9.key or v9.routeName or "")
			end

			return table.concat(v8, ">")
		end, { v6 })) }
	React.useEffect(function()
		recordNavigationSpan(formatRoutePath(v6))

		local v8 = onActiveRoutesChanged

		if v8 ~= nil then
			v8(v6)
		end
	end, v7)
end

local function RoRumRouteTracker(p2): nil
	useActiveRoutesEffect(useNavigation().state, p2.onActiveRoutesChanged)
	return nil
end

return RoRumRouteTracker
