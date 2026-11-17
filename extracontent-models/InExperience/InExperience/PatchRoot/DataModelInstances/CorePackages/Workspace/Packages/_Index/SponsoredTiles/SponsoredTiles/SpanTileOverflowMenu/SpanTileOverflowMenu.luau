local parent = script:FindFirstAncestor("SponsoredTiles").Parent

local React = require(parent.React)

local AppBlox = require(parent.AppBlox)
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local GameTile = require(parent.GameTile)
local GameTileContextualActions = GameTile.GameTileContextualActions
local GameTileOverflowMenu = GameTile.GameTileOverflowMenu

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning

local function SpanTileOverflowMenu(props)
	local hoverKey = props.hoverKey
	local v = useOverflowMenuOpen(hoverKey)

	local v2 = React.useMemo(function()
		local v2 = {}

		for k, _ in props.availableMenuItems do
			table.insert(v2, k)
		end

		return table.concat(v2, ",")
	end, { props.availableMenuItems })

	local useCallback = React.useCallback
	local function fn(flag: boolean, availableMenuItems: string?)
		local universeId

		if FFlagLuaAppEnableNxMRoduxApportioning then
			universeId = tostring(props.universeId or "")
		else
			universeId = props.universeId
		end

		local v3 = {
			universeId = universeId,
			sortId = props.topicId,
			actionType = flag and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened",
			availableMenuItems = availableMenuItems,
			contentType = 0
		}
		local contentType

		if FFlagLuaAppEnableNxMRoduxApportioning then
			contentType = props.contentType
		end

		v3.contentType = contentType

		gameTileOverflowMenuAction(v3, props.appPage or "Unknown")
	end

	local universeId = props.universeId
	local appPage = props.appPage
	local topicId = props.topicId
	local v3

	if FFlagLuaAppEnableNxMRoduxApportioning then
		v3 = props.contentType
	end

	local v4 = useCallback(fn, { universeId, appPage, topicId, v3 })

	local ref = React.useRef(false)
	local onMenuOpenChanged = React.useCallback(function(flag: boolean, p: string?)
		ref.current = true
		v4(flag, p)
	end, { v4 })

	local ref2 = React.useRef(v)
	React.useEffect(function()
		if v ~= ref2.current then
			ref2.current = v

			if v and not ref.current then
				v4(false, v2)
			end

			ref.current = false
		end
	end, { v, v2, v4 })
	local v5

	if props.isHovered or props.isSelected or v then
		v5 = next(props.availableMenuItems) ~= nil
	else
		v5 = v
	end

	if not v5 then
		return nil
	end

	local createElement = React.createElement
	local v6 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = props.zIndex }

	local createElement2 = React.createElement
	local v7

	if FFlagLuaAppGameTileNotInterestedDirectAction then
		v7 = GameTileContextualActions
	else
		v7 = GameTileOverflowMenu
	end

	local v8 = {
		isHovered = props.isHovered,
		isSelected = props.isSelected,
		universeId = tostring(props.universeId or ""),
		placeId = props.placeId,
		collectionId = props.topicId,
		appPage = props.appPage,
		setGameHidden = props.setGameHidden,
		menuKey = hoverKey,
		menuOpen = v,
		onMenuOpenChanged = onMenuOpenChanged,
		parentRef = props.parentRef,
		isSponsored = props.isSponsored,
		payerName = props.payerName,
		sponsoredUserCohort = props.sponsoredUserCohort,
		adId = props.adId,
		availableMenuItems = props.availableMenuItems,
		contentType = 0
	}
	local contentType

	if FFlagLuaAppEnableNxMRoduxApportioning then
		contentType = props.contentType
	end

	v8.contentType = contentType
	return createElement("Frame", v6, { OverflowMenu = createElement2(v7, v8) })
end

return SpanTileOverflowMenu
