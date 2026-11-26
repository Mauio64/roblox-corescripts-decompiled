local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module3 = require("@luauforge/bundled/egx")

local module4 = require("@luauforge/bundled/dzD")
local module5 = require("@luauforge/deferred/hWx")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module6 = require("@luauforge/bundled/fCM")
local module7 = require("@luauforge/deferred/hWE")
local module8 = require("@luauforge/deferred/hWG")

local apiFetchGamesDataByPlaceIds = require("@luauforge/bundled/dBl").GamesByPlaceId.ApiFetchGamesDataByPlaceIds
local module9 = require("@luauforge/deferred/hWH")

local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = module4.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH
local DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT = module4.DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT

local extended = module.PureComponent:extend("PlacesListContextualMenu")

function extended:init()
	local analytics = self.props.analytics
	local placeId = self.props.game.placeId

	analytics.reportOpenModalFromGameTileForPlacesList(placeId)

	self.state = { headerHeight = 0 }

	self.headerRef = module.createRef()
	function self.updateHeaderHeight()
		self:setState({
			headerHeight = self.headerRef.current and self.headerRef.current.AbsoluteSize.Y or 0
		})
	end
end

function extended:didMount()
	self.props.requestGameData(self.props.networking, self.props.game.placeId)

	self.headerSizeChanged = self.headerRef.current
		and self.headerRef.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			self.updateHeaderHeight()
		end)
	self.updateHeaderHeight()
end

function extended.render(props)
	local Game = props.props.game
	local anchorSpaceSize = props.props.anchorSpaceSize
	local anchorSpacePosition = props.props.anchorSpacePosition
	local screenSize = props.props.screenSize
	local formFactor2 = props.props.formFactor
	local topBarHeight = props.props.topBarHeight
	local closeCallback = props.props.closeCallback

	local headerHeight = props.state.headerHeight

	local v5 = formFactor2 == formFactor.WIDE
	local v6 = v5 and DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH or screenSize.X

	local v7 = topBarHeight + 50
	local v8 = module4.BOTTOM_BAR_SIZE + 10

	local v9 = v5 and screenSize.Y - v7 - v8 - headerHeight
		or screenSize.Y * 0.5 - DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT

	return module.createElement(
		module9,
		{
			anchorSpaceSize = anchorSpaceSize,
			anchorSpacePosition = anchorSpacePosition,
			itemWidth = v6
		},
		{
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			Header = module.createElement(module7, {
				layoutOrder = 1,
				width = v6,
				universeId = Game.universeId,
				dismissContextualMenu = closeCallback,
				featureContext = module8.PlacesList,
				[module.Ref] = props.headerRef
			}),
			Divider = module.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = module4.Color.GRAY4,
				BorderSizePixel = 0
			}),
			JoinableFriendsList = module.createElement(module5, {
				LayoutOrder = 3,
				maxHeight = v9,
				width = v6,
				universeId = Game.universeId
			})
		}
	)
end

function extended.willUnmount(p2)
	if p2.headerSizeChanged then
		p2.headerSizeChanged:Disconnect()
	end
end

local v5 = useSheetNavigation.connect(function(data, p2)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		formFactor = data.FormFactor,
		screenSize = data.ScreenSize
	}
end, function(callback)
	return {
		requestGameData = function(p2, p3)
			return callback(apiFetchGamesDataByPlaceIds(p2, { p3 }))
		end,
		closeCallback = function()
			callback(module6())
		end
	}
end)(extended)

return (roactServices.connect({
	analytics = roactAnalyticsCommonGameEvents,
	networking = module3
})(v5))
