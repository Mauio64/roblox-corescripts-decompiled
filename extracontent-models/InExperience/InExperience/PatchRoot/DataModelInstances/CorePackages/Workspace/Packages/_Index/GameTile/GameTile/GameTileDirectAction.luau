local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local Cryo = require(parent.Cryo)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

require(GameTile.GameTileOverflowMenu)
local useGameTileActions = require(GameTile.useGameTileActions)

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppGameTileDirectActionTelemetry = SharedFlags.FFlagLuaAppGameTileDirectActionTelemetry

local function GameTileDirectAction(props)
	local v = useTokens()
	local availableMenuItems = React.useMemo(function()
		return { [props.actionId] = true }
	end, { props.actionId })
	local joined = Cryo.Dictionary.join(props, { availableMenuItems = availableMenuItems })
	local v2

	if FFlagLuaAppGameTileDirectActionTelemetry then
		local useCallback = React.useCallback
		local function fn(p: string)
			local v3 = {
				universeId = props.universeId,
				sortId = props.collectionId or "",
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = p,
				availableMenuItems = p,
				contentType = 0,
				isDirectAction = true
			}
			local contentType

			if FFlagLuaAppEnableHomepageOneByTwoTile then
				contentType = props.contentType
			end

			v3.contentType = contentType
			gameTileOverflowMenuAction(v3, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local collectionId = props.collectionId
		local v3

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			v3 = props.contentType
		end

		v2 = useCallback(fn, { appPage, universeId, collectionId, v3 })
	end

	if not FFlagLuaAppGameTileDirectActionTelemetry then
		v2 = nil
	end

	local v3 = useGameTileActions(joined, v2)[1]

	if not (v3 and props.isHovered) then
		return nil
	end

	local iconOverride = props.iconOverride or v3.icon
	local id = v3.id
	local onActivated = v3.onActivated

	if iconOverride and id and onActivated then
		return React.createElement(View, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v.Padding.Medium, 0, v.Padding.Medium),
			backgroundStyle = v.Color.OverMedia.OverMedia_0,
			tag = "auto-xy radius-circle"
		}, {
			IconButton = React.createElement(IconButton, {
				icon = iconOverride,
				isCircular = true,
				onActivated = function()
					onActivated(id)
				end,
				size = IconSize.Small,
				testId = "game-tile-direct-action",
				variant = ButtonVariant.Utility
			})
		})
	end

	return nil
end

return GameTileDirectAction
