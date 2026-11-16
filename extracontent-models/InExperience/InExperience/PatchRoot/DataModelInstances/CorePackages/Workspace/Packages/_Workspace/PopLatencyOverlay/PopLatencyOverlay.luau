local parent = script.Parent
local React = require(parent.React)
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local GameplayOverlay = require(script.GameplayOverlay)
local Overlay = require(script.Overlay)
local fetchAdminStatus = require(script.fetchAdminStatus)
local observeAdminStatus = require(script.observeAdminStatus)

local function isUserAdmin(p)
	return fetchAdminStatus(p, HttpRbxApiService, HttpService, ContentProvider.BaseUrl)
end

local function PopLatencyOverlay(p)
	return React.createElement(
		"ScreenGui",
		{
			Name = "PopLatencyOverlay",
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = 1000
		},
		React.createElement(Overlay, p)
	)
end

local function useAdminAuthorization()
	local state, setState = React.useState(0)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local current, v = observeAdminStatus(Players, isUserAdmin, function()
			setState(function(p)
				return p + 1
			end)
		end)
		ref.current = current

		return function()
			ref.current = nil
			v()
		end
	end, {})

	return React.useCallback(function()
		local current = ref.current
		return current ~= nil and current()
	end, {}), state
end

local function AdminPopLatencyOverlay(_)
	local authorizeToggle, authorizationVersion = useAdminAuthorization()
	return React.createElement(PopLatencyOverlay, {
		authorizationVersion = authorizationVersion,
		authorizeToggle = authorizeToggle,
		deferServiceUntilToggle = true,
		failClosedOnProbeCheck = true
	})
end

local function GameplayPopLatencyOverlay(p)
	return React.createElement(
		"ScreenGui",
		{ Name = "GameplayPopLatencyOverlay", ResetOnSpawn = false, DisplayOrder = 1000 },
		React.createElement(GameplayOverlay, p)
	)
end

local function AdminGameplayPopLatencyOverlay(p)
	local authorizeToggle, authorizationVersion = useAdminAuthorization()
	return React.createElement(GameplayPopLatencyOverlay, {
		experienceService = p.experienceService,
		authorizationVersion = authorizationVersion,
		authorizeToggle = authorizeToggle
	})
end

return {
	["jest.config"] = script["jest.config"],
	adminOnly = AdminPopLatencyOverlay,
	default = PopLatencyOverlay,
	gameplay = GameplayPopLatencyOverlay,
	gameplayAdminOnly = AdminGameplayPopLatencyOverlay
}
