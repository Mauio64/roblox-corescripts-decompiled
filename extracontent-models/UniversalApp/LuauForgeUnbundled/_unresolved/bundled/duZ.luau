local module = require("@luauforge/bundled/dva")
local none = module.None
local module2 = require("@luauforge/bundled/dui")
local module3 = require("@luauforge/bundled/dul")
local roactServices = require("@luauforge/bundled/duj").RoactServices
local withNavigation = require("@luauforge/bundled/dvb").withNavigation
local module4 = require("@luauforge/bundled/dun")
local gameTileThumbnailBadges = module4.GameTileThumbnailBadges
local sponsoredGamesRecordClick = require("@luauforge/bundled/dtq").Requests.sponsoredGamesRecordClick
local appExperienceActionRow = module4.AppExperienceActionRow
local getTileBadgeByPositionConfigFromEntry = module4.getTileBadgeByPositionConfigFromEntry
local apiFetchGameDetails = require("@luauforge/bundled/dvc").GameDetails.ApiFetchGameDetails
local impressionsTagUtility = require("@luauforge/bundled/dvd").ImpressionsTagUtility
local openGameDetails = require("@luauforge/bundled/dve").OpenGameDetails
local module5 = require("@luauforge/bundled/dtp")
local gameCollectionItemTypes = module5.GameCollectionItemTypes
local roactNetworking = require("@luauforge/bundled/dum").RoactNetworking
local module6 = require("@luauforge/bundled/duV")
local appUserLayers = require("@luauforge/bundled/duW").AppUserLayers
local module7 = require("@luauforge/bundled/duU")

local module8 = require("@luauforge/bundled/dvf")
local module9 = require("@luauforge/bundled/dvg")
local module10 = require("@luauforge/bundled/dvh")
local module11 = require("@luauforge/bundled/dvn")

local module12 = require("@luauforge/bundled/dtC")
local module13 = require("@luauforge/bundled/dtD")
local fFlagLuaAppUnifyPlayButtonTile = module13.FFlagLuaAppUnifyPlayButtonTile
local fFlagLuaAppSduiEdpEnabled = module13.FFlagLuaAppSduiEdpEnabled

local GAME_GRID_CHILD_PADDING = module5.Constants.GAME_GRID_CHILD_PADDING
local v5 = module5.Constants.GAME_GRID_CHILD_PADDING * 2
local v6 = fFlagLuaAppUnifyPlayButtonTile and 6 or nil
local extended = module.PureComponent:extend("AppFeaturedGameTileTwoByTwo")

extended.validateProps = module3.strictInterface({
	entry = module3.table,
	index = module3.optional(module3.number),
	layoutOrder = module3.optional(module3.number),
	reportGameDetailOpened = module3.optional(module3.callback),
	reportExperienceLaunched = module3.optional(module3.callback),
	size = module3.optional(module3.Vector2),
	position = module3.optional(module3.Vector2),
	source = module3.optional(module3.string),
	referralSource = module3.optional(module3.string),
	hasBackground = module3.optional(module3.boolean),
	hasActionRow = module3.optional(module3.boolean),
	isDynamic = module3.optional(module3.boolean),
	impressionsTag = module3.optional(module3.string),
	launchExperienceEventContext = module3.optional(module3.string),
	universeId = module3.optional(module3.string),
	name = module3.optional(module3.string),
	creatorName = module3.optional(module3.string),
	placeId = module3.optional(module3.string),
	totalUpVotes = module3.optional(module3.number),
	totalDownVotes = module3.optional(module3.number),
	gameDetail = module3.optional(module3.table),
	thumbnail = module3.optional(module3.table),
	openGameDetails = module3.callback,
	fetchGameDetails = module3.callback,
	navigation = module3.any,
	networking = module3.callback,
	shouldShowFeaturedTileCreatorName = module3.optional(module3.boolean)
})

function extended:init()
	self.isMounted = false
	self.gameIconSubscription = module7.subscribeGameIcon({
		universeId = self.props.universeId,
		size = module7.GameIconSize.Large,
		onChange = function(p2)
			local v9 = if p2 then p2.url else nil
			self:setState({ gameIconUrl = v9 })
		end
	})

	local current = self.gameIconSubscription.getCurrent()
	local v8 = if current then current.url else nil
	self.state = { gameIconUrl = v8 }

	self.gameInfoSubscription = module7.subscribeGameInfo({
		universeId = self.props.entry.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none,
				storeVotes = p2.votes or none
			})
		end
	})

	self.gameTileRef = module.createRef()

	function self.onActivated()
		if not self.isMounted then
			return
		end

		local universeId = self.props.universeId
		local v9 = {
			source = self.props.source,
			index = self.props.index,
			onPeekViewClosed = self.props.onPeekViewClosed,
			experienceJoinData = {
				tileType = self.props.entry and self.props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = self.props.entry and self.props.entry.adId
			}
		}

		local openGameDetails2 = self.props.openGameDetails

		local navigation = self.props.navigation
		local v10 = if fFlagLuaAppSduiEdpEnabled then self.props.networking else nil
		openGameDetails2(universeId, v9, navigation, v10)

		local index = self.props.index
		local reportGameDetailOpened = self.props.reportGameDetailOpened

		if index and reportGameDetailOpened then
			reportGameDetailOpened(index)
		end

		local networking = self.props.networking
		local entry = self.props.entry

		if entry.isSponsored then
			sponsoredGamesRecordClick(networking, entry.adId)
		end
	end

	function self.renderActionRow()
		local createElement = module.createElement
		local v10 = {
			universeId = self.props.universeId,
			referralSource = self.props.referralSource,
			launchSource = "FeaturedSearchTile",
			reportExperienceLaunched = self.props.reportExperienceLaunched,
			openGameDetails = self.onActivated,
			entry = self.props.entry,
			launchExperienceEventContext = self.props.launchExperienceEventContext,
			showButtonText = true,
			width = 0,
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = 0
		}

		local v11 = if fFlagLuaAppUnifyPlayButtonTile then UDim.new(1, -2 * v6) else nil
		v10.width = v11
		v10.horizontalPadding = if fFlagLuaAppUnifyPlayButtonTile then v6 else nil
		v10.verticalPadding = if fFlagLuaAppUnifyPlayButtonTile then v6 else nil
		v10.isUnifiedGameTileEnabled = fFlagLuaAppUnifyPlayButtonTile and true or nil
		return createElement(appExperienceActionRow, v10)
	end

	function self.renderBottomPanel()
		local entry = self.props.entry
		local gameInfo = self.state.gameInfo
		local storeVotes = self.state.storeVotes
		local name = gameInfo and gameInfo.name
		local upVotes = storeVotes and storeVotes.upVotes
		local downVotes = storeVotes and storeVotes.downVotes
		local name2 = gameInfo and gameInfo.creator and gameInfo.creator.name
		local gameDetail = self.props.gameDetail
		local hasVerifiedBadge = gameDetail and gameDetail.creator and gameDetail.creator.hasVerifiedBadge
		local id = gameDetail and gameDetail.creator and gameDetail.creator.id
		local description = gameDetail and gameDetail.description or ""
		local shouldShowFeaturedTileCreatorName = self.props.shouldShowFeaturedTileCreatorName

		local isDynamic = self.props.isDynamic
		local licenseDescription = if gameDetail then gameDetail.licenseDescription else nil
		local localizedFiatPrice = if gameDetail then gameDetail.localizedFiatPrice else nil

		local v9 = {
			hasBackground = self.props.hasBackground,
			padding = 8,
			title = name,
			creatorName = 0,
			creatorVerified = 0,
			creatorId = 0,
			description = 0,
			licenseDescription = 0,
			paidAccessDescription = 0,
			footerData = 0
		}

		if not shouldShowFeaturedTileCreatorName then
			name2 = nil
		end

		v9.creatorName = name2
		v9.creatorVerified = hasVerifiedBadge
		v9.creatorId = id
		v9.description = description
		v9.licenseDescription = licenseDescription
		v9.paidAccessDescription = localizedFiatPrice

		v9.footerData = {
			rating = module8(upVotes, downVotes),
			playingCount = entry.playerCount
		}

		if isDynamic then
			return module.createElement(module10, v9)
		end

		return module.createElement(module11, v9)
	end
end

function extended:didMount()
	self.isMounted = true
	impressionsTagUtility.AddTag(self.gameTileRef, self.props.impressionsTag, self.props.index)

	local networking = self.props.networking
	local universeId = self.props.universeId
	self.props.fetchGameDetails(networking, universeId)
end

function extended:willUnmount()
	self.isMounted = false
	self.gameIconSubscription.dispose()
	self.gameInfoSubscription.dispose()
	impressionsTagUtility.RemoveTag(self.gameTileRef, self.props.impressionsTag, self.props.index)
end

function extended.didUpdate(data, p2)
	if p2.impressionsTag ~= data.props.impressionsTag or p2.index ~= data.props.index then
		impressionsTagUtility.RemoveTag(data.gameTileRef, p2.impressionsTag, p2.index)
		impressionsTagUtility.AddTag(data.gameTileRef, data.props.impressionsTag, data.props.index)
	end

	data.gameIconSubscription.update(data.props.universeId)
	data.gameInfoSubscription.update(data.props.entry.universeId)
end

function extended.render(props)
	local layoutOrder = props.props.layoutOrder
	local size = props.props.size
	local position = props.props.position

	local gameIconUrl = props.state.gameIconUrl

	local x = if size then size.X else nil
	local y = if size then size.Y else nil
	local v7 = if size then x * 2 + GAME_GRID_CHILD_PADDING else nil
	local v8 = if size then y * 2 + v5 else nil

	local hasBackground = props.props.hasBackground
	local hasActionRow = props.props.hasActionRow

	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.props.entry)
	local v9

	if tileBadgeByPositionConfigFromEntry then
		v9 = module.createElement(gameTileThumbnailBadges, {
			tileBadgesByPosition = tileBadgeByPositionConfigFromEntry
		})
	end

	local createElement = module.createElement

	local v12 = if hasActionRow then props.renderActionRow else nil
	local v13 = createElement(module9, {
		hasBackground = hasBackground,
		hasOutline = hasBackground,
		thumbnail = gameIconUrl,
		thumbnailOverlay = v9,
		renderActionRow = v12,
		renderBottomPanel = props.renderBottomPanel,
		onActivated = props.onActivated
	})

	local createElement2 = module.createElement
	local v16 = if size and position then UDim2.fromOffset(position.X, position.Y) else nil
	local v17 = if size then UDim2.new(0, x, 0, y) else UDim2.new(1, 0, 1, 0)
	local v15 = {
		Position = v16,
		Size = v17,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		ref = props.gameTileRef
	}

	if size then
		v13 = module.createElement("Frame", {
			Size = UDim2.new(0, v7, 0, v8),
			Position = UDim2.new(0, 0, 0, -y - v5),
			BackgroundTransparency = 1
		}, { Tile = v13 })
	end

	return createElement2("Frame", v15, { FeaturedTile = v13 })
end

local v7 = withNavigation((module2.connect(function(p2, p3)
	local universeId = p3.entry.universeId
	return { universeId = universeId, gameDetail = p2.GameDetails[universeId] }
end, function(callback)
	return {
		openGameDetails = function(p2, p3, p4, p5)
			if not fFlagLuaAppSduiEdpEnabled then
				p5 = nil
			end

			callback(openGameDetails(p2, p4, p3, p5))
		end,
		fetchGameDetails = function(p2, p3)
			callback(apiFetchGameDetails.Fetch(p2, { p3 }))
		end
	}
end)(extended)))

local v8 = roactServices.connect({ networking = roactNetworking })(v7)

return (module6.connectUserLayer(
	{ if module12() then appUserLayers.PlayerAppSearchResultsPageUXLayer or nil else nil },
	function(p2, p3)
		return {
			shouldShowFeaturedTileCreatorName = (p2[appUserLayers.PlayerAppSearchResultsPageUXLayer] or {}).ShouldShowFeaturedTileCreatorName == true
		}
	end
)(v8))
