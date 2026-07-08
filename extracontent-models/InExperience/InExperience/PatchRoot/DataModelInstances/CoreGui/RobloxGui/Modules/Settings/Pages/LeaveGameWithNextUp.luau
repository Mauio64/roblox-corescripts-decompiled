local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local RobloxGui = CoreGui.RobloxGui
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local Constants = require(RobloxGui.Modules.InGameMenu.Resources.Constants)
local View = Foundation.View
local BaseComponent = require(script.BaseComponent)
local NextUpComponent = require(script.NextUpComponent)
local LeaveButtonsContainer = require(script.LeaveButtonsContainer)
local useNextUpSort = require(script.useNextUpSort)
local v15 = game:DefineFastInt("NextUpShadowTrafficPercent", 0)
local FFlagEnableInGameExitModalNextUpUi = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableInGameExitModalNextUpUi
local FFlagEnableInGameExitModalNextUpUiRequestCache = require(script.Flags.FFlagEnableInGameExitModalNextUpUiRequestCache)
local FFlagInGameExitModalFixModalPadding = require(script.Flags.FFlagInGameExitModalFixModalPadding)

if not FFlagEnableInGameExitModalNextUpUi then
	local LocalPlayer = Players.LocalPlayer

	if v15 > (LocalPlayer and LocalPlayer.UserId or 99) % 100 then
		ReactRoblox.createRoot(Instance.new("ScreenGui")):render(React.createElement(BaseComponent, nil, {
			nextUpShadowTraffic = React.createElement(function() -- line: 34
				-- upvalues: useNextUpSort (copy)
				useNextUpSort()

				return nil
			end)
		}))
	end

	return require(script.Parent.LeaveGame)
end

local v20 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

v20.TabHeader = nil
v20.Page.Name = "LeaveGamePage"
v20.ShouldShowBottomBar = false
v20.ShouldShowHubBar = false
v20.ShrinkwrapPageViewClipper = true
v20.DisableTopPadding = true
v20.MaintainVerticalSize = true
v20.Page.Size = UDim2.fromScale(1, 0)
v20.Page.AutomaticSize = Enum.AutomaticSize.Y

function v20.GetSize(p1) -- line: 58
	local AbsoluteSize = p1.Page.AbsoluteSize

	return Vector2.new(math.ceil(AbsoluteSize.X), (math.max(math.ceil(AbsoluteSize.Y), 350)))
end

local function onDontLeave(b1: boolean) -- line: 65
	-- upvalues: v20 (copy), RbxAnalyticsService (copy), Constants (copy)
	if v20.HubRef then
		v20.HubRef:PopMenu(b1, true)
	end

	RbxAnalyticsService:SendEventDeferred(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
		confirmed = Constants.AnalyticsCancelledName,
		universeid = tostring(game.GameId),
		source = Constants.AnalyticsLeaveGameSource,
		playsessionid = RbxAnalyticsService:GetPlaySessionId()
	})
end

local v22 = not require(RobloxGui.Modules.TenFootInterface):IsEnabled() and 200 or 300

local function LeaveGameWithNextUpComponent() -- line: 86
	-- upvalues: React (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), useNextUpSort (copy), v20 (copy), BaseComponent (copy), View (copy), FFlagInGameExitModalFixModalPadding (copy), LeaveButtonsContainer (copy), onDontLeave (copy), v22 (copy), NextUpComponent (copy)
	local v27, v28 = React.useState(false)
	local v29 = if not FFlagEnableInGameExitModalNextUpUiRequestCache then nil else useNextUpSort()

	React.useEffect(function() -- line: 90
		-- upvalues: v20 (copy), v28 (copy)
		local t1 = {}

		table.insert(t1, v20.Displayed.Event:connect(function() -- line: 94
			-- upvalues: v28 (copy)
			v28(true)
		end))
		table.insert(t1, v20.Hidden.Event:connect(function() -- line: 101
			-- upvalues: v28 (copy)
			v28(false)
		end))

		return function() -- line: 106
			-- upvalues: t1 (copy)
			for _, v32 in t1 do
				v32:Disconnect()
			end
		end
	end, {})

	if not v27 then
		return React.None
	end

	return React.createElement(BaseComponent, nil, {
		mainContainer = React.createElement(View, {
			tag = not FFlagInGameExitModalFixModalPadding and "size-full-0 auto-y padding-large col gap-large" or "size-full-0 auto-y padding-large col gap-xxlarge"
		}, {
			LeaveButtonsContainer = React.createElement(LeaveButtonsContainer, {
				onDontLeave = onDontLeave,
				buttonSize = v22
			}),
			nextUpComponent = React.createElement(NextUpComponent, {
				tilePairWidth = v22,
				nextUpSort = if not FFlagEnableInGameExitModalNextUpUiRequestCache then nil else v29
			})
		})
	})
end

ReactRoblox.createRoot(v20.Page):render(React.createElement(BaseComponent, nil, {
	leaveGameWithNextUp = React.createElement(LeaveGameWithNextUpComponent)
}))

return v20
