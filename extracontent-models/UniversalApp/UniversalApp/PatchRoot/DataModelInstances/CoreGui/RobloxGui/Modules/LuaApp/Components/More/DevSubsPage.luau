local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local DevSubs = require(Modules.LuaApp.Thunks.DevSubs)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local DevSubGameList = require(Modules.LuaApp.Components.More.DevSubGameList)
local DevSubList = require(Modules.LuaApp.Components.More.DevSubList)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer

local function isSubActive(p1) -- line: 36
	-- upvalues: DevSubStatus (copy)
	return p1.status == DevSubStatus.Active
end

local v26 = Roact.Component:extend("DevSubsPage")

function v26.init(p2) -- line: 42
	-- upvalues: AppPage (copy)
	function p2.onGameActivated(p3) -- line: 43
		-- upvalues: p2 (copy), AppPage (copy)
		p2.props.navigateDown({
			name = AppPage.DevSubs,
			detail = p3.id
		})
	end
	function p2.onDevSubActivated(p4, p5, p6) -- line: 50
		-- upvalues: p2 (copy)
		p2.props.dispatchDevSubMoreMenuOverlay({
			anchorSpacePosition = p5,
			anchorSpaceSize = p6,
			devSub = p4
		})
	end
end
function v26.render(p7) -- line: 59
	-- upvalues: withStyle (copy), FormFactor (copy), Roact (copy), Constants (copy), DevSubList (copy), DevSubGameList (copy), TopBar (copy), FitChildren (copy)
	return withStyle(function(p8) -- line: 60
		-- upvalues: p7 (copy), FormFactor (copy), Roact (copy), Constants (copy), DevSubList (copy), DevSubGameList (copy), TopBar (copy), FitChildren (copy)
		local formFactor = p7.props.formFactor
		local devSubs = p7.props.devSubs
		local selectedGame = p7.props.selectedGame
		local v60 = formFactor == FormFactor.WIDE
		local t1 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0)
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v60 and Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL or 0),
				PaddingRight = UDim.new(0, v60 and Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL or 0),
				PaddingTop = UDim.new(0, v60 and Constants.MORE_PAGE_WIDE_PADDING_VERTICAL or Constants.MORE_PAGE_SECTION_PADDING),
				PaddingBottom = UDim.new(0, v60 and Constants.MORE_PAGE_WIDE_PADDING_VERTICAL or Constants.MORE_PAGE_SECTION_PADDING)
			})
		}
		local v62 = p7:getDevSubsByGameId(devSubs)
		local v63 = p7:getGamesById(devSubs)

		if selectedGame then
			t1.SubList = Roact.createElement(DevSubList, {
				game = v63[selectedGame],
				devSubs = v62[selectedGame],
				onDevSubActivated = p7.onDevSubActivated
			})
		else
			t1.GameList = Roact.createElement(DevSubGameList, {
				games = v63,
				subsByGameId = v62,
				onGameActivated = p7.onGameActivated
			})
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p8.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p8.Theme.BackgroundDefault.Transparency
		}, {
			TopBarMorePage = Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton
			}),
			PageContent = Roact.createElement(TopBar.PageContent, {}, {
				Scroller = Roact.createElement(FitChildren.FitScrollingFrame, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 0,
					ClipsDescendants = false,
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1),
					CanvasSize = UDim2.new(1, 0, 0, 0),
					fitFields = {
						CanvasSize = FitChildren.FitAxis.Height
					}
				}, t1)
			})
		})
	end)
end
function v26.getDevSubsByGameId(_, p10) -- line: 133
	local t2 = {}

	for _, v in pairs(p10) do
		local gameId = v.gameId

		if t2[gameId] then
			table.insert(t2[gameId], v)
		else
			t2[gameId] = { v }
		end
	end

	return t2
end
function v26.getGameIcon(p11, p12) -- line: 148
	local str = tostring(p12)
	local gameIcons = p11.props.gameIcons

	if gameIcons and gameIcons[str] then
		return gameIcons[str].url
	end

	return ""
end
function v26.getGamesById(p13, p14) -- line: 159
	-- upvalues: DevSubStatus (copy)
	local t3 = {}

	for _, v in pairs(p14) do
		local v46 = t3[v.gameId]
		local v47 = v.status == DevSubStatus.Active

		if v46 then
			if v47 then
				v46.activeSubs = v46.activeSubs + 1
			end
		else
			t3[v.gameId] = {
				name = v.gameData.name,
				icon = p13:getGameIcon(v.gameId),
				id = v.gameId,
				activeSubs = not v47 and 0 or 1
			}
		end
	end

	return t3
end
function v26.didMount(p15) -- line: 186
	-- upvalues: RetrievalStatus (copy)
	if p15.props.devSubsFetchingStatus == RetrievalStatus.NotStarted then
		p15.props.dispatchFetchDevSubs(p15.props.networking)
	end
end

local v27 = RoactRodux.connect(function(p16, _) -- line: 192
	-- upvalues: DevSubs (copy), GameIconReducer (copy)
	return {
		formFactor = p16.FormFactor,
		devSubsFetchingStatus = DevSubs.GetFetchingStatus(p16),
		devSubs = p16.DevSubs,
		gameIcons = p16[GameIconReducer.key]
	}
end, function(p18) -- line: 199
	-- upvalues: DevSubs (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), SetCentralOverlay (copy), OverlayType (copy)
	return {
		dispatchFetchDevSubs = function(p19) -- line: 201
			-- upvalues: p18 (copy), DevSubs (copy)
			return p18(DevSubs.Fetch(p19))
		end,
		navigateDown = function(...) -- line: 204
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), p18 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				local v65, v66 = ...

				return v18.down(v18.fromLegacyPage(v65), v66)
			end

			return p18(NavigateDown(...))
		end,
		dispatchDevSubMoreMenuOverlay = function(p20) -- line: 212
			-- upvalues: p18 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p18(SetCentralOverlay(OverlayType.DevSubMore, p20))
		end
	}
end)(v26)

return RoactServices.connect({
	networking = RoactNetworking
})(v27)
