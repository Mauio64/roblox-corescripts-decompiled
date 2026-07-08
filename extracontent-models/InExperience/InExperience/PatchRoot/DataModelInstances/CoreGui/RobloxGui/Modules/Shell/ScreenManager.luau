local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local Shell = RobloxGui:FindFirstChild("Modules"):FindFirstChild("Shell")
local Analytics = require(script.Parent.Analytics)
local AppState = require(script.Parent.AppState)
local GlobalSettings = require(script.Parent.GlobalSettings)
local ScreenItem = require(script.Parent.Models.ScreenItem)
local PageHeartbeatTimer = require(script.Parent.PageHeartbeatTimer)
local InsertScreen = require(script.Parent.Actions.InsertScreen)
local RemoveScreen = require(script.Parent.Actions.RemoveScreen)
local contentHistory = require(Shell.XboxPrimaryNav:FindFirstChild("contentHistory"))
local GetFIntXboxPrimaryNavABLogging = require(Shell.Flags.GetFIntXboxPrimaryNavABLogging)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local t1 = {}
local t2 = {}
local t3 = {
	[1] = RobloxGui
}

local function getScreenPriority(p1) -- line: 25
	-- upvalues: GlobalSettings (copy)
	local DefaultPriority = GlobalSettings.DefaultPriority

	if p1.GetPriority ~= nil then
		DefaultPriority = p1:GetPriority()
	end

	return DefaultPriority
end
local function setRBXEventStream_Screen(p2, p3) -- line: 33
	-- upvalues: Analytics (copy)
	if p2 and type(p2.GetAnalyticsInfo) == "function" then
		local AnalyticsInfo = p2:GetAnalyticsInfo()

		if type(AnalyticsInfo) == "table" and AnalyticsInfo[Analytics.WidgetNames("WidgetId")] then
			AnalyticsInfo.Status = p3
			Analytics.SetRBXEventStream("Widget", AnalyticsInfo)
		end
	end
end

function t1.GetScreenGuiByPriority(_, p5) -- line: 43
	-- upvalues: t3 (copy), Create (copy), CoreGui (copy)
	local v30 = math.max(1, p5)

	if not t3[v30] then
		for i = 1, v30 do
			if not t3[i] then
				t3[i] = Create("ScreenGui")({
					Name = "AppShell" .. tostring(i),
					Parent = CoreGui
				})
			end
		end
	end

	return t3[v30]
end
function t1.OpenScreen(_, p7, p8) -- line: 60
	-- upvalues: t2 (copy), ScreenItem (copy), GlobalSettings (copy), GetFIntXboxPrimaryNavABLogging (copy), t1 (copy), contentHistory (copy), AppState (copy), InsertScreen (copy)
	if p8 == nil then
		p8 = true
	end

	local t4 = {
		hidePrevious = p8
	}
	local str = tostring(p7)

	t2[str] = {
		isShown = false,
		screen = p7
	}

	local new = ScreenItem.new
	local DefaultPriority = GlobalSettings.DefaultPriority

	if p7.GetPriority ~= nil then
		DefaultPriority = p7:GetPriority()
	end

	local v39 = new(str, DefaultPriority, t4)

	if GetFIntXboxPrimaryNavABLogging() > 0 then
		local TopScreen = t1:GetTopScreen()

		if TopScreen then
			contentHistory:setLastSelectedContent(TopScreen)
		end
	end

	AppState.store:dispatch(InsertScreen(v39))
end
function t1.CloseCurrent(_, p10) -- line: 87
	-- upvalues: AppState (copy), t2 (copy), RemoveScreen (copy)
	local ScreenList = AppState.store:getState().ScreenList
	local v44 = #ScreenList > 0 and ScreenList[1]

	if not v44 or not t2[v44.id] then
		return
	end

	if p10 and v44.id ~= tostring(p10) then
		return
	end

	AppState.store:dispatch(RemoveScreen(v44))
end

local function handleScreensRemoved(p11) -- line: 104
	-- upvalues: t2 (copy), setRBXEventStream_Screen (copy)
	local t5 = {}

	for _, v in ipairs(p11) do
		t5[v.id] = true
	end

	local t6 = {}

	for k, _ in pairs(t2) do
		if not t5[k] then
			table.insert(t6, k)
		end
	end

	for _, v in ipairs(t6) do
		local v54 = t2[v]

		if v54 then
			local screen = v54.screen

			screen:RemoveFocus()
			screen:Hide()

			if screen.ScreenRemoved then
				screen:ScreenRemoved()
			end

			setRBXEventStream_Screen(screen, "Close")
		end

		t2[v] = nil
	end
end
local function handleScreensAdded(p12) -- line: 136
	-- upvalues: t2 (copy), setRBXEventStream_Screen (copy), PageHeartbeatTimer (copy), Analytics (copy)
	for i = #p12, 1, -1 do
		local v58 = t2[p12[i].id]

		if v58 then
			local screen = v58.screen

			if i > 1 then
				local v60 = true
				local v61 = p12[i - 1]

				if v61 and v61.data then
					v60 = v61.data.hidePrevious
				end

				screen:RemoveFocus()

				if v60 then
					screen:Hide()
					v58.isShown = false
				end

				if not v58.isShown and not v60 then
					screen:Show()
					v58.isShown = true
				end
			else
				if not v58.isShown then
					screen:Show()
					v58.isShown = true
					setRBXEventStream_Screen(screen, "Show")
				end

				screen:Focus()
				setRBXEventStream_Screen(screen, "Focus")

				local v62 = v58.screen.GetAnalyticsInfo and v58.screen.GetAnalyticsInfo()

				if v62 then
					PageHeartbeatTimer.onPageChanged(v62[Analytics.WidgetNames("WidgetId")])
				end
			end
		end
	end

	Analytics.reportPageChanged()
end
local function update(p13) -- line: 181
	-- upvalues: handleScreensRemoved (copy), handleScreensAdded (copy)
	handleScreensRemoved(p13)
	handleScreensAdded(p13)
end

AppState.store.changed:connect(function(p14, p15) -- line: 186
	-- upvalues: handleScreensRemoved (copy), handleScreensAdded (copy)
	local ScreenList = p14.ScreenList

	if ScreenList == p15.ScreenList then
		return
	end

	handleScreensRemoved(ScreenList)
	handleScreensAdded(ScreenList)
end)

function t1.GetTopScreen(_) -- line: 197
	-- upvalues: AppState (copy), t2 (copy)
	local ScreenList = AppState.store:getState().ScreenList

	if ScreenList and #ScreenList > 0 then
		return t2[ScreenList[1].id].screen
	end

	return nil
end

return t1
