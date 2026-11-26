local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")

local GameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileDirectAction")
local GameTileOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileOverflowMenu")
local tileOverflowMenuItems = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants").TileOverflowMenuItems

local iconName = Foundation.Enums.IconName
local useLastInput = Responsive.useLastInput

local function countAvailableActions(p2)
	local count = 0

	for k, tileOverflowMenuItem in tileOverflowMenuItems do
		if p2[tileOverflowMenuItem] then
			count += 1
		end
	end

	return count
end

local function GameTileContextualActions(p2)
	local v5 = useLastInput()
	local availableMenuItems = p2.availableMenuItems
	local count = 0

	for k, tileOverflowMenuItem in tileOverflowMenuItems do
		if availableMenuItems[tileOverflowMenuItem] then
			count += 1
		end
	end

	if
		v5 == Responsive.Input.Pointer
		and not p2.menuOpen
		and count == 1
		and p2.availableMenuItems[tileOverflowMenuItems.NotInterested]
	then
		return React.createElement(GameTileDirectAction, Cryo.Dictionary.join(p2, {
			actionId = tileOverflowMenuItems.NotInterested,
			iconOverride = { name = iconName.X }
		}))
	end

	return React.createElement(GameTileOverflowMenu, p2)
end

return GameTileContextualActions
