local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Common = Modules.Common
local LuaApp = Modules.LuaApp
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local Constants = require(LuaApp.Constants)
local FitChildren = require(LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local GameButton = require(LuaApp.Components.GameButton)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local FeatureContext = require(LuaApp.Enum.FeatureContext)
local ConvertUniverseIdToString = require(CorePackages.Workspace.Packages.SharedFlags).ConvertUniverseIdToString
local FFlagPeopleListContextualMenuFixFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPeopleListContextualMenuFixFocusNavigation
local FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require(CorePackages.Workspace.Packages.SharedFlags).FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
local Text = require(Common.Text)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer
local VIEW_GAME_DETAILS_FROM_ICON = Constants.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_ICON
local VIEW_GAME_DETAILS_FROM_TITLE = Constants.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_TITLE
local v26 = Roact.PureComponent:extend("UserActiveGame")

local function Separator(p1) -- line: 54
	-- upvalues: Roact (copy)
	local layoutOrder = p1.layoutOrder
	local color = p1.color
	local transparency = p1.transparency

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 1)
	})
end
local function getGameName(p2, p3) -- line: 70
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy)
	local v37 = p3 and p3.lastLocation

	if v37 then
		return v37
	end

	if p2 then
		if FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
			return p2.name or ""
		end

		return p2.name
	end

	return ""
end

function v26.init(p4) -- line: 85
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), ConvertUniverseIdToString (copy), FeatureContext (copy), Text (copy)
	function p4.createOpenGameDetailsProps() -- line: 86
		-- upvalues: p4 (copy)
		return {
			onClose = p4.props.onCloseGameDetails
		}
	end
	function p4.openGameDetails(p5) -- line: 92
		-- upvalues: p4 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), ConvertUniverseIdToString (copy), FeatureContext (copy)
		local universePlaceInfo = p4.props.universePlaceInfo

		if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel and not universePlaceInfo then
			return
		end

		local analytics = p4.props.analytics
		local friend = p4.props.friend
		local index = p4.props.index
		local absolutePosition = p4.props.absolutePosition
		local dismissContextualMenu = p4.props.dismissContextualMenu
		local featureContext = p4.props.featureContext
		local v116 = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.universeRootPlaceId else universePlaceInfo.universeRootPlaceId or -1
		local v117 = ConvertUniverseIdToString(p4.props.universeId)

		if featureContext == FeatureContext.PeopleList then
			analytics.reportViewProfileFromPeopleList(friend.id, index, absolutePosition, v116, p5)
			analytics.reportOpenGameDetailFromPeopleList(friend.id, index, absolutePosition, v116, v117, p5, "GameDetailFromUserActiveGame")
		end

		if dismissContextualMenu then
			dismissContextualMenu()
		end

		p4.props.openGameDetails(v117, p4.createOpenGameDetailsProps())
	end
	function p4.getGameTitleHeight(p6, p7, p8, p9) -- line: 136
		-- upvalues: Text (copy)
		return (math.min(40, Text.GetTextHeight(p6, p7, p8, p9) - 2))
	end
end
function v26.createGameNameButton(p10, p11, p12, p13, p14, p15) -- line: 147
	-- upvalues: Roact (copy), VIEW_GAME_DETAILS_FROM_TITLE (copy)
	local Theme = p15.Theme
	local p15Font = p15.Font
	local TextEmphasisColor = Theme.TextEmphasis.Color
	local TextEmphasisTransparency = Theme.TextEmphasis.Transparency
	local v49 = p15Font.BaseSize * p15Font.Header2.RelativeSize
	local Header2Font = p15Font.Header2.Font

	return Roact.createElement("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Header2Font,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, p11),
		Text = p12,
		TextColor3 = TextEmphasisColor,
		TextTransparency = TextEmphasisTransparency,
		TextSize = v49,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,
		TextXAlignment = p13,
		TextYAlignment = p14,
		[Roact.Event.Activated] = function() -- line: 170
			-- upvalues: p10 (copy), VIEW_GAME_DETAILS_FROM_TITLE (copy)
			p10.openGameDetails(VIEW_GAME_DETAILS_FROM_TITLE, p10.createOpenGameDetailsProps())
		end
	})
end
function v26.renderPhone(p16, p17) -- line: 176
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Roact (copy), FitChildren (copy), DEPRECATED_ImageSetButton (copy), VIEW_GAME_DETAILS_FROM_ICON (copy), GameButton (copy), Separator (copy)
	local layoutOrder = p16.props.layoutOrder
	local width = p16.props.width
	local universeId = p16.props.universeId
	local friend = p16.props.friend
	local index = p16.props.index
	local absolutePosition = p16.props.absolutePosition
	local dismissContextualMenu = p16.props.dismissContextualMenu
	local featureContext = p16.props.featureContext
	local gameThumbnail = p16.props.gameThumbnail
	local universePlaceInfo = p16.props.universePlaceInfo
	local forwardRef = p16.props.forwardRef
	local Theme = p17.Theme
	local p17Font = p17.Font
	local v66 = p17Font.BaseSize * p17Font.Header2.RelativeSize
	local Header2Font = p17Font.Header2.Font
	local v68 = friend and friend.lastLocation
	local v69 = if not v68 then not universePlaceInfo and "" or if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.name else universePlaceInfo.name or "" else v68
	local BackgroundUIDefaultColor = Theme.BackgroundUIDefault.Color
	local BackgroundUIDefaultTransparency = Theme.BackgroundUIDefault.Transparency
	local v72 = gameThumbnail and BackgroundUIDefaultColor or Theme.PlaceHolder.Color
	local v73 = gameThumbnail and BackgroundUIDefaultTransparency or Theme.PlaceHolder.Transparency
	local v74 = width - 30
	local v75 = p16.getGameTitleHeight(v69, Header2Font, v66, v74)

	return Roact.createElement(FitChildren.FitImageButton, {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		[Roact.Ref] = forwardRef
	}, {
		GameContent = Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			GameIcon = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				BackgroundColor3 = v72,
				BackgroundTransparency = v73,
				Size = UDim2.new(0, 94, 0, 94)
			}, {
				Icon = Roact.createElement(DEPRECATED_ImageSetButton, {
					BackgroundColor3 = v72,
					BorderSizePixel = 0,
					Image = gameThumbnail,
					Position = UDim2.new(0, 2, 0, 2),
					Size = UDim2.new(0, 90, 0, 90),
					[Roact.Event.Activated] = function() -- line: 240
						-- upvalues: p16 (copy), VIEW_GAME_DETAILS_FROM_ICON (copy)
						p16.openGameDetails(VIEW_GAME_DETAILS_FROM_ICON, p16.createOpenGameDetailsProps())
					end
				})
			}),
			GameName = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, -30, 0, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				NameButton = p16:createGameNameButton(v75, v69, Enum.TextXAlignment.Center, Enum.TextYAlignment.Center, p17),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12)
				})
			}),
			InteractiveButton = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, -30, 0, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24)
				}),
				Button = Roact.createElement(GameButton, {
					showLoadingIndicatorWhenDataNotReady = true,
					maxWidth = v74,
					universeId = universeId,
					universeRootPlaceId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else universePlaceInfo.universeRootPlaceId,
					placeId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else universePlaceInfo.placeId,
					friend = friend,
					index = index,
					absolutePosition = absolutePosition,
					callbackOnOpenGameDetails = dismissContextualMenu,
					callbackOnJoinGame = dismissContextualMenu,
					featureContext = featureContext,
					source = p16.props.source
				})
			}),
			Separator = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Line = Roact.createElement(Separator, {
					layoutOrder = 2,
					color = Theme.Divider.Color,
					transparency = Theme.Divider.Transparency
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 23)
				})
			})
		}),
		Background = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = BackgroundUIDefaultColor,
			BackgroundTransparency = BackgroundUIDefaultTransparency,
			Size = UDim2.new(1, 0, 1, -47),
			Position = UDim2.new(0, 0, 0, 47)
		})
	})
end
function v26.renderTablet(p18, p19) -- line: 336
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Roact (copy), FitChildren (copy), FFlagPeopleListContextualMenuFixFocusNavigation (copy), DEPRECATED_ImageSetButton (copy), VIEW_GAME_DETAILS_FROM_ICON (copy), GameButton (copy), Separator (copy)
	local layoutOrder = p18.props.layoutOrder
	local width = p18.props.width
	local universeId = p18.props.universeId
	local friend = p18.props.friend
	local index = p18.props.index
	local absolutePosition = p18.props.absolutePosition
	local dismissContextualMenu = p18.props.dismissContextualMenu
	local featureContext = p18.props.featureContext
	local gameThumbnail = p18.props.gameThumbnail
	local universePlaceInfo = p18.props.universePlaceInfo
	local forwardRef = p18.props.forwardRef
	local v89 = friend and friend.lastLocation
	local v90 = if not v89 then not universePlaceInfo and "" or if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.name else universePlaceInfo.name or "" else v89
	local Theme = p19.Theme
	local BackgroundUIDefaultColor = Theme.BackgroundUIDefault.Color
	local BackgroundUIDefaultTransparency = Theme.BackgroundUIDefault.Transparency
	local v94 = gameThumbnail and BackgroundUIDefaultColor or Theme.PlaceHolder.Color
	local v95 = gameThumbnail and BackgroundUIDefaultTransparency or Theme.PlaceHolder.Transparency
	local v96 = width - 36 - 90

	return Roact.createElement(FitChildren.FitImageButton, {
		BackgroundColor3 = BackgroundUIDefaultColor,
		BackgroundTransparency = BackgroundUIDefaultTransparency,
		BorderSizePixel = 0,
		fitAxis = FitChildren.FitAxis.Height,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, width, 0, 0),
		AutoButtonColor = false,
		[Roact.Ref] = forwardRef,
		Selectable = not FFlagPeopleListContextualMenuFixFocusNavigation and nil
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		GameContent = Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
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
			GameIcon = Roact.createElement(DEPRECATED_ImageSetButton, {
				BackgroundColor3 = v94,
				BackgroundTransparency = v95,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Image = gameThumbnail,
				Size = UDim2.new(0, 90, 0, 90),
				[Roact.Event.Activated] = function() -- line: 406
					-- upvalues: p18 (copy), VIEW_GAME_DETAILS_FROM_ICON (copy)
					p18.openGameDetails(VIEW_GAME_DETAILS_FROM_ICON, p18.createOpenGameDetailsProps())
				end,
				Selectable = not FFlagPeopleListContextualMenuFixFocusNavigation and nil
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12)
				})
			}),
			GameInfo = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, -105, 0, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				NameButton = p18:createGameNameButton(40, v90, Enum.TextXAlignment.Left, Enum.TextYAlignment.Top, p19),
				InteractiveButton = Roact.createElement(FitChildren.FitFrame, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				}, {
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Right
					}),
					Button = Roact.createElement(GameButton, {
						layoutOrder = 3,
						showLoadingIndicatorWhenDataNotReady = true,
						maxWidth = v96,
						universeId = universeId,
						universeRootPlaceId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else universePlaceInfo.universeRootPlaceId,
						placeId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else universePlaceInfo.placeId,
						friend = friend,
						index = index,
						absolutePosition = absolutePosition,
						callbackOnOpenGameDetails = dismissContextualMenu,
						callbackOnJoinGame = dismissContextualMenu,
						featureContext = featureContext,
						source = p18.props.source,
						selectionOrder = if not FFlagPeopleListContextualMenuFixFocusNavigation then nil else -1
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 18)
					})
				})
			})
		}),
		Separator = Roact.createElement(Separator, {
			layoutOrder = 2
		})
	})
end
function v26.render(p20) -- line: 479
	-- upvalues: FormFactor (copy), withStyle (copy)
	local formFactor = p20.props.formFactor

	return withStyle(function(p21) -- line: 482
		-- upvalues: formFactor (copy), FormFactor (copy), p20 (copy)
		if formFactor == FormFactor.COMPACT then
			return p20:renderPhone(p21)
		end

		return p20:renderTablet(p21)
	end)
end

local v29 = RoactRodux.connect(function(p22, p23) -- line: 493
	-- upvalues: ConvertUniverseIdToString (copy), GameIconReducer (copy), Constants (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Cryo (copy)
	local v101 = ConvertUniverseIdToString(p23.universeId)
	local v102 = p22[GameIconReducer.key][v101]
	local v103 = v102 and v102.url or Constants.DEFAULT_GAME_ICON
	local t1 = nil

	if FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		t1 = {
			universeId = v101,
			universeRootPlaceId = tonumber(p23.universeRootPlaceId),
			placeId = p23.placeId
		}
	end

	return {
		formFactor = p22.FormFactor,
		gameThumbnail = v103,
		universePlaceInfo = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then p22.UniversePlaceInfos[v101] else Cryo.Dictionary.union(p22.UniversePlaceInfos[v101] or {}, t1)
	}
end, function(p24) -- line: 517
	-- upvalues: OpenGameDetails (copy)
	return {
		openGameDetails = function(p25, p26) -- line: 519
			-- upvalues: p24 (copy), OpenGameDetails (copy)
			p24(OpenGameDetails(p25, p26))
		end
	}
end)(v26)
local u30 = RoactServices.connect({
	analytics = RoactAnalyticsCommonGameEvents,
	guiService = AppGuiService
})(v29)

return Roact.forwardRef(function(p27, p28) -- line: 530
	-- upvalues: Roact (copy), u30 (ref), Cryo (copy)
	return Roact.createElement(u30, Cryo.Dictionary.join(p27, {
		forwardRef = p28
	}))
end)
