local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)

local GameTileDirectAction = require(GameTile.GameTileDirectAction)
local GameTileOverflowMenu = require(GameTile.GameTileOverflowMenu)
local GameTileConstants = require(GameTile.GameTileConstants)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems

local IconName = Foundation.Enums.IconName
local useLastInput = Responsive.useLastInput

local function countAvailableActions(availableMenuItems) -- 1 equivalent call inferred from this helper
	local count = 0

	for _, tileOverflowMenuItem in TileOverflowMenuItems do
		if availableMenuItems[tileOverflowMenuItem] then
			count += 1
		end
	end

	return count
end

local function GameTileContextualActions(p)
	local v = useLastInput()
	local count = countAvailableActions(p.availableMenuItems) -- inferred equivalent call

	if
		v == Responsive.Input.Pointer
		and not p.menuOpen
		and count == 1
		and p.availableMenuItems[TileOverflowMenuItems.NotInterested]
	then
		return React.createElement(GameTileDirectAction, Cryo.Dictionary.join(p, {
			actionId = TileOverflowMenuItems.NotInterested,
			iconOverride = { name = IconName.X }
		}))
	end

	return React.createElement(GameTileOverflowMenu, p)
end

return GameTileContextualActions
