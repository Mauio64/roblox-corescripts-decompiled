local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local shell = RobloxGui:FindFirstChild("Modules"):FindFirstChild("Shell")

local Analytics = require(script.Parent.Analytics)
local AppState = require(script.Parent.AppState)
local GlobalSettings = require(script.Parent.GlobalSettings)
local ScreenItem = require(script.Parent.Models.ScreenItem)
local PageHeartbeatTimer = require(script.Parent.PageHeartbeatTimer)
local InsertScreen = require(script.Parent.Actions.InsertScreen)
local RemoveScreen = require(script.Parent.Actions.RemoveScreen)
local contentHistory = require(shell.XboxPrimaryNav:FindFirstChild("contentHistory"))
local GetFIntXboxPrimaryNavABLogging = require(shell.Flags.GetFIntXboxPrimaryNavABLogging)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local ScreenManager = {}

local v = {}

local v2 = { RobloxGui }

local function getScreenPriority(object) -- 1 equivalent call inferred from this helper
	local screenPriority = GlobalSettings.DefaultPriority

	if object.GetPriority ~= nil then
		screenPriority = object:GetPriority()
	end

	return screenPriority
end

local function setRBXEventStream_Screen(screen, status)
	if screen and type(screen.GetAnalyticsInfo) == "function" then
		local analyticsInfo = screen:GetAnalyticsInfo()

		if type(analyticsInfo) == "table" and analyticsInfo[Analytics.WidgetNames("WidgetId")] then
			analyticsInfo.Status = status
			Analytics.SetRBXEventStream("Widget", analyticsInfo)
		end
	end
end

function ScreenManager.GetScreenGuiByPriority(_, p)
	local v3 = math.max(1, p)

	if not v2[v3] then
		for i = 1, v3 do
			if not v2[i] then
				v2[i] = Create("ScreenGui")({
					Name = "AppShell" .. tostring(i),
					Parent = CoreGui
				})
			end
		end
	end

	return v2[v3]
end

function ScreenManager.OpenScreen(_, screen, p)
	local v3 = {
		hidePrevious = p == nil or p
	}

	local v4 = tostring(screen)
	v[v4] = { screen = screen, isShown = false }

	local v5 = ScreenItem.new(v4, getScreenPriority(screen), v3) -- inferred equivalent call

	local topScreen = GetFIntXboxPrimaryNavABLogging() > 0 and ScreenManager:GetTopScreen()

	if topScreen then
		contentHistory:setLastSelectedContent(topScreen)
	end

	AppState.store:dispatch(InsertScreen(v5))
end

function ScreenManager.CloseCurrent(_, p)
	local screenList = AppState.store:getState().ScreenList
	local v3 = #screenList > 0 and screenList[1]

	if not (v3 and v[v3.id]) or p and v3.id ~= tostring(p) then
		return
	end

	AppState.store:dispatch(RemoveScreen(v3))
end

local function handleScreensRemoved(list)
	local idSet = {}

	for _, item in ipairs(list) do
		idSet[item.id] = true
	end

	local v3 = {}

	for k, _ in pairs(v) do
		if not idSet[k] then
			table.insert(v3, k)
		end
	end

	for _, v4 in ipairs(v3) do
		local v5 = v[v4]

		if v5 then
			local screen = v5.screen

			screen:RemoveFocus()
			screen:Hide()

			if screen.ScreenRemoved then
				screen:ScreenRemoved()
			end

			setRBXEventStream_Screen(screen, "Close")
		end

		v[v4] = nil
	end
end

local function handleScreensAdded(list)
	for i = #list, 1, -1 do
		local v3 = v[list[i].id]

		if not v3 then
			continue
		end

		local screen = v3.screen

		if i > 1 then
			local item = list[i - 1]
			local v4 = not (item and item.data) or item.data.hidePrevious

			screen:RemoveFocus()

			if v4 then
				screen:Hide()
				v3.isShown = false
			end

			if not (v3.isShown or v4) then
				screen:Show()
				v3.isShown = true
			end
		else
			if not v3.isShown then
				screen:Show()
				v3.isShown = true
				setRBXEventStream_Screen(screen, "Show")
			end

			screen:Focus()
			setRBXEventStream_Screen(screen, "Focus")

			local v4 = v3.screen.GetAnalyticsInfo and v3.screen.GetAnalyticsInfo()

			if v4 then
				PageHeartbeatTimer.onPageChanged(v4[Analytics.WidgetNames("WidgetId")])
			end
		end
	end

	Analytics.reportPageChanged()
end

local function update(screenList) -- 1 equivalent call inferred from this helper
	handleScreensRemoved(screenList)
	handleScreensAdded(screenList)
end

AppState.store.changed:connect(function(p, p2)
	local screenList = p.ScreenList

	if screenList == p2.ScreenList then
		return
	end

	update(screenList) -- inferred equivalent call
end)

function ScreenManager:GetTopScreen()
	local screenList = AppState.store:getState().ScreenList

	if screenList and #screenList > 0 then
		return v[screenList[1].id].screen
	end

	return nil
end

return ScreenManager
