local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.LuaApp.Constants)
local JoinableFriendsList = require(Modules.LuaApp.Components.Home.JoinableFriendsList)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local UserActiveGame = require(Modules.LuaApp.Components.Home.UserActiveGame)
local FeatureContext = require(Modules.LuaApp.Enum.FeatureContext)
local ApiFetchGamesDataByPlaceIds = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.ApiFetchGamesDataByPlaceIds
local FormBasedContextualMenu = require(Modules.LuaApp.Components.FormBasedContextualMenu)
local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = Constants.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH
local DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT = Constants.DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT
local v18 = Roact.PureComponent:extend("PlacesListContextualMenu")

function v18.init(p1) -- line: 30
	-- upvalues: Roact (copy)
	local analytics = p1.props.analytics
	local placeId = p1.props.game.placeId

	analytics.reportOpenModalFromGameTileForPlacesList(placeId)
	p1.state = {
		headerHeight = 0
	}
	p1.headerRef = Roact.createRef()

	function p1.updateHeaderHeight() -- line: 41
		-- upvalues: p1 (copy)
		p1:setState({
			headerHeight = p1.headerRef.current and p1.headerRef.current.AbsoluteSize.Y or 0
		})
	end
end
function v18.didMount(p2) -- line: 48
	p2.props.requestGameData(p2.props.networking, p2.props.game.placeId)
	p2.headerSizeChanged = p2.headerRef.current and p2.headerRef.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 56
		-- upvalues: p2 (copy)
		p2.updateHeaderHeight()
	end)
	p2.updateHeaderHeight()
end
function v18.render(p3) -- line: 62
	-- upvalues: FormFactor (copy), DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH (copy), Constants (copy), DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT (copy), Roact (copy), FormBasedContextualMenu (copy), UserActiveGame (copy), FeatureContext (copy), JoinableFriendsList (copy)
	local game2 = p3.props.game
	local anchorSpaceSize = p3.props.anchorSpaceSize
	local anchorSpacePosition = p3.props.anchorSpacePosition
	local screenSize = p3.props.screenSize
	local formFactor = p3.props.formFactor
	local topBarHeight = p3.props.topBarHeight
	local closeCallback = p3.props.closeCallback
	local headerHeight = p3.state.headerHeight
	local v33 = formFactor == FormFactor.WIDE
	local v34 = v33 and DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH or screenSize.X
	local v35 = topBarHeight + 50
	local v36 = Constants.BOTTOM_BAR_SIZE + 10
	local v37 = v33 and screenSize.Y - v35 - v36 - headerHeight or screenSize.Y * 0.5 - DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT

	return Roact.createElement(FormBasedContextualMenu, {
		anchorSpaceSize = anchorSpaceSize,
		anchorSpacePosition = anchorSpacePosition,
		itemWidth = v34
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		Header = Roact.createElement(UserActiveGame, {
			layoutOrder = 1,
			width = v34,
			universeId = game2.universeId,
			dismissContextualMenu = closeCallback,
			featureContext = FeatureContext.PlacesList,
			[Roact.Ref] = p3.headerRef
		}),
		Divider = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Constants.Color.GRAY4
		}),
		JoinableFriendsList = Roact.createElement(JoinableFriendsList, {
			LayoutOrder = 3,
			maxHeight = v37,
			width = v34,
			universeId = game2.universeId
		})
	})
end
function v18.willUnmount(p4) -- line: 116
	if p4.headerSizeChanged then
		p4.headerSizeChanged:Disconnect()
	end
end

local v19 = RoactRodux.connect(function(p5, _) -- line: 122
	return {
		topBarHeight = p5.TopBar.topBarHeight,
		formFactor = p5.FormFactor,
		screenSize = p5.ScreenSize
	}
end, function(p7) -- line: 128
	-- upvalues: ApiFetchGamesDataByPlaceIds (copy), CloseCentralOverlay (copy)
	return {
		requestGameData = function(p8, p9) -- line: 130
			-- upvalues: p7 (copy), ApiFetchGamesDataByPlaceIds (copy)
			return p7(ApiFetchGamesDataByPlaceIds(p8, { p9 }))
		end,
		closeCallback = function() -- line: 133
			-- upvalues: p7 (copy), CloseCentralOverlay (copy)
			p7(CloseCentralOverlay())
		end
	}
end)(v18)

return (RoactServices.connect({
	analytics = RoactAnalyticsCommonGameEvents,
	networking = RoactNetworking
})(v19))
