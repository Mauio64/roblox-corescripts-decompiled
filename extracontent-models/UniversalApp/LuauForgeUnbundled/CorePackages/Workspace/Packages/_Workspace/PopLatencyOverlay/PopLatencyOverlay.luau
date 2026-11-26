local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/React")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local GameplayOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/GameplayOverlay")
local Overlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/Overlay")
local fetchAdminStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/fetchAdminStatus")
local observeAdminStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/observeAdminStatus")

local function isUserAdmin(p2)
	return fetchAdminStatus(p2, HttpRbxApiService, HttpService, ContentProvider.BaseUrl)
end

local function PopLatencyOverlay(p2)
	return React.createElement(
		"ScreenGui",
		{
			Name = "PopLatencyOverlay",
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = 1000
		},
		React.createElement(Overlay, p2)
	)
end

local function useAdminAuthorization()
	local state, setState = React.useState(0)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local v5, v6 = observeAdminStatus(Players, isUserAdmin, function()
			setState(function(p2)
				return p2 + 1
			end)
		end)
		ref.current = v5

		return function()
			ref.current = nil
			v6()
		end
	end, {})

	return React.useCallback(function()
		local current = ref.current
		return current ~= nil and current()
	end, {}), state
end

local function AdminPopLatencyOverlay(p2)
	local v5, v6 = useAdminAuthorization()
	return React.createElement(PopLatencyOverlay, {
		authorizationVersion = v6,
		authorizeToggle = v5,
		deferServiceUntilToggle = true,
		failClosedOnProbeCheck = true
	})
end

local function GameplayPopLatencyOverlay(p2)
	return React.createElement(
		"ScreenGui",
		{
			Name = "GameplayPopLatencyOverlay",
			ResetOnSpawn = false,
			DisplayOrder = 1000
		},
		React.createElement(GameplayOverlay, p2)
	)
end

local function AdminGameplayPopLatencyOverlay(p2)
	local v5, v6 = useAdminAuthorization()
	return React.createElement(GameplayPopLatencyOverlay, {
		experienceService = p2.experienceService,
		authorizationVersion = v6,
		authorizeToggle = v5
	})
end

return {
	adminOnly = AdminPopLatencyOverlay,
	default = PopLatencyOverlay,
	gameplay = GameplayPopLatencyOverlay,
	gameplayAdminOnly = AdminGameplayPopLatencyOverlay
}
