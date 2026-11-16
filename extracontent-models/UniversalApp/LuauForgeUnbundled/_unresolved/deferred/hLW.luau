local CorePackages = game:GetService("CorePackages")

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module = require("@luauforge/bundled/dwA")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module3 = require("@luauforge/deferred/hLX")
local module4 = require("@luauforge/bundled/edp")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module5 = require("@luauforge/deferred/hLY")
local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/SharedFlags").ConvertUniverseIdToString
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local fFlagPeopleListContextualMenuFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPeopleListContextualMenuFixFocusNavigation
local fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel

local module6 = require("@luauforge/bundled/fpF")

local module7 = require("@luauforge/bundled/dHo")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local VIEW_GAME_DETAILS_FROM_ICON = module.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_ICON
local VIEW_GAME_DETAILS_FROM_TITLE = module.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_TITLE

local extended = Roact.PureComponent:extend("UserActiveGame")

local function Separator(props)
	local layoutOrder = props.layoutOrder
	local color = props.color
	local transparency = props.transparency

	return Roact.createElement("Frame", {
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 1)
	})
end

local function getGameName(p2, p3)
	local lastLocation = p3 and p3.lastLocation

	if lastLocation then
		return lastLocation
	end

	if not p2 then
		return ""
	end

	if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		return p2.name or ""
	end

	return p2.name
end

function extended:init()
	local function toUrl(p2)
		return p2 and p2.url or module.DEFAULT_GAME_ICON
	end

	self.gameIconSubscription = GameHydrationReact.subscribeGameIcon({
		universeId = convertUniverseIdToString(self.props.universeId),
		onChange = function(p2)
			self:setState({
				gameIconUrl = p2 and p2.url or module.DEFAULT_GAME_ICON
			})
		end
	})

	local current = self.gameIconSubscription.getCurrent()
	self.state = {
		gameIconUrl = current and current.url or module.DEFAULT_GAME_ICON
	}

	function self.createOpenGameDetailsProps()
		return { onClose = self.props.onCloseGameDetails }
	end

	function self.openGameDetails(p2)
		local universePlaceInfo = self.props.universePlaceInfo

		if not (fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel or universePlaceInfo) then
			return
		end

		local analytics = self.props.analytics
		local friend = self.props.friend
		local index = self.props.index
		local absolutePosition = self.props.absolutePosition
		local dismissContextualMenu = self.props.dismissContextualMenu
		local featureContext = self.props.featureContext
		local universeRootPlaceId

		if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId or -1
		else
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId
		end

		local v6 = convertUniverseIdToString(self.props.universeId)

		if featureContext == module5.PeopleList then
			analytics.reportViewProfileFromPeopleList(
				friend.id,
				index,
				absolutePosition,
				universeRootPlaceId,
				p2
			)

			analytics.reportOpenGameDetailFromPeopleList(
				friend.id,
				index,
				absolutePosition,
				universeRootPlaceId,
				v6,
				p2,
				"GameDetailFromUserActiveGame"
			)
		end

		if dismissContextualMenu then
			dismissContextualMenu()
		end

		self.props.openGameDetails(v6, self.createOpenGameDetailsProps())
	end

	function self.getGameTitleHeight(p2, p3, p4, p5)
		return (math.min(40, module6.GetTextHeight(p2, p3, p4, p5) - 2))
	end
end

function extended.willUnmount(p2)
	p2.gameIconSubscription.dispose()
end

function extended:createGameNameButton(p2, text, textXAlignment, textYAlignment, props2)
	local theme = props2.Theme
	local font = props2.Font
	local color = theme.TextEmphasis.Color
	local transparency = theme.TextEmphasis.Transparency
	local v5 = font.BaseSize * font.Header2.RelativeSize
	local font2 = font.Header2.Font

	local createElement = Roact.createElement

	if foundationFontFaceMigration then
		font2 = nil
	end

	local v8 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
	local v7 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = font2,
		FontFace = v8,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, p2),
		Text = text,
		TextColor3 = color,
		TextTransparency = transparency,
		TextSize = v5,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,
		TextXAlignment = textXAlignment,
		TextYAlignment = textYAlignment,
		[Roact.Event.Activated] = function()
			self.openGameDetails(VIEW_GAME_DETAILS_FROM_TITLE, self.createOpenGameDetailsProps())
		end
	}
	local tag = React.Tag
	local v9 = if fFlagLuaAppAddTestIdsForArrow then getTestId(
		"discovery-home-active-game",
		self.props.universeId
	) else nil
	v7[tag] = v9
	return createElement("TextButton", v7)
end

function extended:renderPhone(p2)
	local layoutOrder = self.props.layoutOrder
	local width = self.props.width
	local universeId = self.props.universeId
	local friend = self.props.friend
	local index = self.props.index
	local absolutePosition = self.props.absolutePosition
	local dismissContextualMenu = self.props.dismissContextualMenu
	local featureContext = self.props.featureContext
	local gameIconUrl = self.state.gameIconUrl
	local universePlaceInfo = self.props.universePlaceInfo

	local forwardRef = self.props.forwardRef

	local theme = p2.Theme
	local font = p2.Font
	local v5 = font.BaseSize * font.Header2.RelativeSize
	local font2 = font.Header2.Font
	local v6 = friend and friend.lastLocation

	if not v6 then
		if universePlaceInfo then
			if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
				v6 = universePlaceInfo.name or ""
			else
				v6 = universePlaceInfo.name
			end
		else
			v6 = ""
		end
	end

	local color = theme.BackgroundUIDefault.Color
	local transparency = theme.BackgroundUIDefault.Transparency
	local v7 = gameIconUrl and color or theme.PlaceHolder.Color
	local v8 = gameIconUrl and transparency or theme.PlaceHolder.Transparency

	local v9 = width - 30
	local gameTitleHeight = self.getGameTitleHeight(v6, font2, v5, v9)

	local createElement = Roact.createElement
	local fitImageButton = FitChildren.FitImageButton
	local forwardRefsByRef = {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		[Roact.Ref] = forwardRef
	}

	local createElement2 = Roact.createElement
	local fitFrame = FitChildren.FitFrame
	local v10 = {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		GameIcon = Roact.createElement("Frame", {
			BackgroundColor3 = v7,
			BackgroundTransparency = v8,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(0, 94, 0, 94)
		}, {
			Icon = Roact.createElement(module4, {
				BackgroundColor3 = v7,
				BorderSizePixel = 0,
				Image = gameIconUrl,
				Position = UDim2.new(0, 2, 0, 2),
				Size = UDim2.new(0, 90, 0, 90),
				[Roact.Event.Activated] = function()
					self.openGameDetails(VIEW_GAME_DETAILS_FROM_ICON, self.createOpenGameDetailsProps())
				end
			})
		}),
		GameName = Roact.createElement(
			FitChildren.FitFrame,
			{
				BackgroundTransparency = 1,
				fitAxis = FitChildren.FitAxis.Height,
				LayoutOrder = 2,
				Size = UDim2.new(1, -30, 0, 0)
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				NameButton = self:createGameNameButton(
					gameTitleHeight,
					v6,
					Enum.TextXAlignment.Center,
					Enum.TextYAlignment.Center,
					p2
				),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12)
				})
			}
		),
		InteractiveButton = 0,
		Separator = 0
	}

	local createElement5 = Roact.createElement
	local fitFrame2 = FitChildren.FitFrame
	local v15 = {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = 3,
		Size = UDim2.new(1, -30, 0, 0)
	}
	local v16 = {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 24) }),
		Button = 0
	}

	local createElement6 = Roact.createElement

	local v19 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.universeRootPlaceId else nil

	local v20 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.placeId else nil
	v16.Button = createElement6(module3, {
		maxWidth = v9,
		showLoadingIndicatorWhenDataNotReady = true,
		universeId = universeId,
		universeRootPlaceId = v19,
		placeId = v20,
		friend = friend,
		index = index,
		absolutePosition = absolutePosition,
		callbackOnOpenGameDetails = dismissContextualMenu,
		callbackOnJoinGame = dismissContextualMenu,
		featureContext = featureContext,
		source = self.props.source
	})
	children2.InteractiveButton = createElement5(fitFrame2, v15, v16)

	children2.Separator = Roact.createElement(
		FitChildren.FitFrame,
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 5,
			fitAxis = FitChildren.FitAxis.Height
		},
		{
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Line = Roact.createElement(Separator, {
				color = theme.Divider.Color,
				transparency = theme.Divider.Transparency,
				layoutOrder = 2
			}),
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 23) })
		}
	)
	return createElement(fitImageButton, forwardRefsByRef, {
		GameContent = createElement2(fitFrame, v10, children2),
		Background = Roact.createElement("Frame", {
			BackgroundColor3 = color,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -47),
			Position = UDim2.new(0, 0, 0, 47)
		})
	})
end

function extended:renderTablet(p2)
	local layoutOrder = self.props.layoutOrder
	local width = self.props.width
	local universeId = self.props.universeId
	local friend = self.props.friend
	local index = self.props.index
	local absolutePosition = self.props.absolutePosition
	local dismissContextualMenu = self.props.dismissContextualMenu
	local featureContext = self.props.featureContext
	local gameIconUrl = self.state.gameIconUrl
	local universePlaceInfo = self.props.universePlaceInfo

	local forwardRef = self.props.forwardRef
	local v5 = friend and friend.lastLocation

	if not v5 then
		if universePlaceInfo then
			if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
				v5 = universePlaceInfo.name or ""
			else
				v5 = universePlaceInfo.name
			end
		else
			v5 = ""
		end
	end

	local theme = p2.Theme
	local color = theme.BackgroundUIDefault.Color
	local transparency = theme.BackgroundUIDefault.Transparency
	local v6 = gameIconUrl and color or theme.PlaceHolder.Color
	local v7 = gameIconUrl and transparency or theme.PlaceHolder.Transparency

	local v8 = width - 36 - 90

	local createElement = Roact.createElement
	local fitImageButton = FitChildren.FitImageButton
	local forwardRefsByRef = {
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, width, 0, 0),
		AutoButtonColor = false,
		[Roact.Ref] = forwardRef,
		Selectable = if fFlagPeopleListContextualMenuFixFocusNavigation then false else nil
	}

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		GameContent = 0,
		Separator = 0
	}

	local createElement2 = Roact.createElement
	local fitFrame = FitChildren.FitFrame
	local v10 = {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 11)
		}),
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 15)
		}),
		GameIcon = Roact.createElement(module4, {
			BackgroundColor3 = v6,
			BackgroundTransparency = v7,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Image = gameIconUrl,
			Size = UDim2.new(0, 90, 0, 90),
			[Roact.Event.Activated] = function()
				self.openGameDetails(VIEW_GAME_DETAILS_FROM_ICON, self.createOpenGameDetailsProps())
			end,
			Selectable = if fFlagPeopleListContextualMenuFixFocusNavigation then false else nil
		}, {
			Padding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) })
		}),
		GameInfo = 0
	}

	local createElement4 = Roact.createElement
	local fitFrame2 = FitChildren.FitFrame
	local v14 = {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = 2,
		Size = UDim2.new(1, -105, 0, 0)
	}
	local v15 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		NameButton = self:createGameNameButton(
			40,
			v5,
			Enum.TextXAlignment.Left,
			Enum.TextYAlignment.Top,
			p2
		),
		InteractiveButton = 0
	}

	local createElement5 = Roact.createElement
	local fitFrame3 = FitChildren.FitFrame
	local v16 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		fitAxis = FitChildren.FitAxis.Height
	}
	local children3 = {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		Button = 0,
		Padding = 0
	}

	local createElement6 = Roact.createElement

	local v19 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.universeRootPlaceId else nil

	local v20 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.placeId else nil
	children3.Button = createElement6(module3, {
		layoutOrder = 3,
		maxWidth = v8,
		showLoadingIndicatorWhenDataNotReady = true,
		universeId = universeId,
		universeRootPlaceId = v19,
		placeId = v20,
		friend = friend,
		index = index,
		absolutePosition = absolutePosition,
		callbackOnOpenGameDetails = dismissContextualMenu,
		callbackOnJoinGame = dismissContextualMenu,
		featureContext = featureContext,
		source = self.props.source,
		selectionOrder = fFlagPeopleListContextualMenuFixFocusNavigation and -1 or nil
	})

	children3.Padding = Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, 18)
	})
	v15.InteractiveButton = createElement5(fitFrame3, v16, children3)
	children2.GameInfo = createElement4(fitFrame2, v14, v15)
	children.GameContent = createElement2(fitFrame, v10, children2)

	children.Separator = Roact.createElement(Separator, { layoutOrder = 2 })
	return createElement(fitImageButton, forwardRefsByRef, children)
end

function extended:render()
	local formFactor2 = self.props.formFactor

	return withStyle(function(p2)
		if formFactor2 == formFactor.COMPACT then
			return self:renderPhone(p2)
		end

		return self:renderTablet(p2)
	end)
end

local v5 = RoactRodux.connect(function(p2, data)
	local v6 = convertUniverseIdToString(data.universeId)

	local v7 = fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
		and {
			universeId = v6,
			universeRootPlaceId = tonumber(data.universeRootPlaceId),
			placeId = data.placeId
		}
		or nil

	local v8 = { formFactor = p2.FormFactor, universePlaceInfo = 0 }

	local v9 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then Cryo.Dictionary.union(p2.UniversePlaceInfos[v6] or {}, v7) else p2.UniversePlaceInfos[v6]
	v8.universePlaceInfo = v9
	return v8
end, function(callback)
	return {
		openGameDetails = function(p2, p3)
			callback(module7(p2, p3))
		end
	}
end)(extended)

local v6 = roactServices.connect({
	analytics = roactAnalyticsCommonGameEvents,
	guiService = appGuiService
})(v5)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v6, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
