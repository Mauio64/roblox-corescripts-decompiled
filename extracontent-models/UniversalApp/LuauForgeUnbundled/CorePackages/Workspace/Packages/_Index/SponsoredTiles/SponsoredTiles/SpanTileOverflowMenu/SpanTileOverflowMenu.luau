local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")

local useOverflowMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/AppBlox").useOverflowMenuOpen
local gameTileOverflowMenuAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryAnalytics").Events.gameTileOverflowMenuAction

local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameTile")
local gameTileContextualActions = GameTile.GameTileContextualActions
local gameTileOverflowMenu = GameTile.GameTileOverflowMenu

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags")
local fFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

local function SpanTileOverflowMenu(props)
	local hoverKey = props.hoverKey
	local v5 = useOverflowMenuOpen(hoverKey)

	local v6 = React.useMemo(function()
		local v7 = {}

		for k, availableMenuItem in props.availableMenuItems do
			table.insert(v7, k)
		end

		return table.concat(v7, ",")
	end, { props.availableMenuItems })

	local useCallback = React.useCallback
	local function fn(p2, availableMenuItems)
		local v8 = if fFlagLuaAppEnableHomepageOneByTwoTile then tostring(props.universeId or "") else props.universeId
		local v7 = {
			universeId = v8,
			sortId = props.topicId,
			actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened",
			availableMenuItems = availableMenuItems,
			contentType = 0
		}

		local v9 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
		v7.contentType = v9

		gameTileOverflowMenuAction(v7, props.appPage or "Unknown")
	end

	local universeId = props.universeId
	local appPage = props.appPage
	local topicId = props.topicId
	local v8 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
	local v9 = useCallback(fn, { universeId, appPage, topicId, v8 })

	local ref = React.useRef(false)
	local v10 = React.useCallback(function(p2, p3)
		ref.current = true
		v9(p2, p3)
	end, { v9 })

	local ref2 = React.useRef(v5)
	React.useEffect(function()
		if v5 ~= ref2.current then
			ref2.current = v5

			if v5 and not ref.current then
				v9(false, v6)
			end

			ref.current = false
		end
	end, { v5, v6, v9 })
	local v11

	if props.isHovered or props.isSelected or v5 then
		v11 = next(props.availableMenuItems) ~= nil
	else
		v11 = v5
	end

	if not v11 then
		return nil
	end

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = props.zIndex
	}

	local createElement2 = React.createElement
	local v15

	if fFlagLuaAppGameTileNotInterestedDirectAction then
		v15 = gameTileContextualActions
	else
		v15 = gameTileOverflowMenu
	end

	local v16 = {
		isHovered = props.isHovered,
		isSelected = props.isSelected,
		universeId = tostring(props.universeId or ""),
		placeId = props.placeId,
		collectionId = props.topicId,
		appPage = props.appPage,
		setGameHidden = props.setGameHidden,
		menuKey = hoverKey,
		menuOpen = v5,
		onMenuOpenChanged = v10,
		parentRef = props.parentRef,
		isSponsored = props.isSponsored,
		payerName = props.payerName,
		sponsoredUserCohort = props.sponsoredUserCohort,
		adId = props.adId,
		availableMenuItems = props.availableMenuItems,
		contentType = 0
	}
	local v17 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
	v16.contentType = v17
	return createElement("Frame", v13, { OverflowMenu = createElement2(v15, v16) })
end

return SpanTileOverflowMenu
