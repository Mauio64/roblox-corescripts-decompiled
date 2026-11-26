local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local withStyle = UIBlox.Style.withStyle

local module5 = require("@luauforge/bundled/dzD")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module7 = require("@luauforge/bundled/dAB")
local module8 = require("@luauforge/deferred/geB")
local module9 = require("@luauforge/deferred/geC")
local module10 = require("@luauforge/bundled/dFu")
local module11 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module12 = require("@luauforge/bundled/fvR")
local module13 = require("@luauforge/deferred/geI")
local module14 = require("@luauforge/deferred/geK")

local module15 = require("@luauforge/bundled/ehl")
local module16 = require("@luauforge/bundled/ehm")
local function isSubActive(p2): boolean
	return p2.status == module8.Active
end

local extended = module.Component:extend("DevSubsPage")

function extended:init()
	function self.getDevSubUniverseIds()
		local gameIds = {}

		if self.props.devSubs then
			for k, devSub in self.props.devSubs do
				table.insert(gameIds, (tostring(devSub.gameId)))
			end
		end

		return gameIds
	end

	self.gameIconsSubscription = GameHydrationReact.subscribeGameIcons({
		universeIds = self.getDevSubUniverseIds(),
		onChange = function(p2)
			self:setState({ gameIcons = p2 })
		end
	})

	self.state = {
		gameIcons = self.gameIconsSubscription.getCurrent()
	}

	function self.onGameActivated(p2)
		self.props.navigateDown({ name = module10.DevSubs, detail = p2.id })
	end

	function self.onDevSubActivated(p2, p3, p4)
		self.props.dispatchDevSubMoreMenuOverlay({
			anchorSpacePosition = p3,
			anchorSpaceSize = p4,
			devSub = p2
		})
	end
end

function extended:render()
	return withStyle(function(p2)
		local formFactor2 = self.props.formFactor
		local devSubs = self.props.devSubs
		local selectedGame = self.props.selectedGame

		local v5 = formFactor2 == formFactor.WIDE

		local children = {
			Layout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0)
			}),
			UIPadding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v5 and module5.MORE_PAGE_WIDE_PADDING_HORIZONTAL or 0),
				PaddingRight = UDim.new(0, v5 and module5.MORE_PAGE_WIDE_PADDING_HORIZONTAL or 0),
				PaddingTop = UDim.new(
					0,
					v5 and module5.MORE_PAGE_WIDE_PADDING_VERTICAL or module5.MORE_PAGE_SECTION_PADDING
				),
				PaddingBottom = UDim.new(
					0,
					v5 and module5.MORE_PAGE_WIDE_PADDING_VERTICAL or module5.MORE_PAGE_SECTION_PADDING
				)
			})
		}

		local devSubs2 = self:getDevSubsByGameId(devSubs)
		local games = self:getGamesById(devSubs)

		if selectedGame then
			children.SubList = module.createElement(module14, {
				game = games[selectedGame],
				devSubs = devSubs2[selectedGame],
				onDevSubActivated = self.onDevSubActivated
			})
		else
			children.GameList = module.createElement(module13, {
				games = games,
				subsByGameId = devSubs2,
				onGameActivated = self.onGameActivated
			})
		end

		return module.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency
			},
			{
				TopBarMorePage = module.createElement(module12.Container, {
					leftItem = module12.BackButton
				}),
				PageContent = module.createElement(module12.PageContent, {}, {
					Scroller = module.createElement(FitChildren.FitScrollingFrame, {
						Position = UDim2.fromScale(0, 0),
						Size = UDim2.fromScale(1, 1),
						CanvasSize = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ScrollBarThickness = 0,
						ClipsDescendants = false,
						fitFields = { CanvasSize = FitChildren.FitAxis.Height }
					}, children)
				})
			}
		)
	end)
end

function extended:getDevSubsByGameId(items)
	local devSubs = {}

	for k, item in pairs(items) do
		local gameId = item.gameId

		if devSubs[gameId] then
			table.insert(devSubs[gameId], item)
		else
			devSubs[gameId] = { item }
		end
	end

	return devSubs
end

function extended:getGameIcon(p3)
	local v5 = tostring(p3)
	local gameIcons = self.state.gameIcons

	if gameIcons and gameIcons[v5] then
		return gameIcons[v5].url
	end

	return ""
end

function extended:getGamesById(items)
	local games = {}

	for k, item in pairs(items) do
		local Game = games[item.gameId]
		local v5 = item.status == module8.Active

		if Game then
			if v5 then
				Game.activeSubs += 1
			end
		else
			games[item.gameId] = {
				name = item.gameData.name,
				icon = self:getGameIcon(item.gameId),
				id = item.gameId,
				activeSubs = v5 and 1 or 0
			}
		end
	end

	return games
end

function extended.didMount(p2)
	if p2.props.devSubsFetchingStatus == module7.NotStarted then
		p2.props.dispatchFetchDevSubs(p2.props.networking)
	end
end

function extended.didUpdate(data, p2)
	if p2.devSubs ~= data.props.devSubs then
		data.gameIconsSubscription.update(data.getDevSubUniverseIds())
	end
end

function extended.willUnmount(p2)
	p2.gameIconsSubscription.dispose()
end

local v5 = useSheetNavigation.connect(function(p2, p3)
	return {
		formFactor = p2.FormFactor,
		devSubsFetchingStatus = module9.GetFetchingStatus(p2),
		devSubs = p2.DevSubs
	}
end, function(callback)
	return {
		dispatchFetchDevSubs = function(p2)
			return callback(module9.Fetch(p2))
		end,
		navigateDown = function(...)
			if not fFlagSignalsNavP3Dispatch then
				return callback(module11(...))
			end

			local v6, v7 = ...
			return navigationCommands.down(navigationCommands.fromLegacyPage(v6), v7)
		end,
		dispatchDevSubMoreMenuOverlay = function(p2)
			return callback(module16(module15.DevSubMore, p2))
		end
	}
end)(extended)

return roactServices.connect({ networking = module3 })(v5)
