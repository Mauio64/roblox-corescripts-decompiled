local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local playerTile = UIBlox.App.Tile.PlayerTile
local interactable = UIBlox.Core.Control.Interactable
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb

local FFlagCarouselUserTileUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Flags/FFlagCarouselUserTileUseProfileFrameThumbnail")

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/PlayerName")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/Constants")

local function fn() end

local v5 = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local tileSize = joined.tileSize
	local v6

	if joined.renderPlayerTile then
		v6 = joined.renderPlayerTile()
	else
		local createElement = React.createElement
		local v8 = {
			title = "",
			tileSize = UDim2.fromOffset(joined.tileSize, joined.tileSize),
			thumbnail = 0,
			onActivated = 0,
			buttons = 0,
			Selectable = true,
			buttonRef = 0
		}
		local v9 = if joined.headshotImageUrl then joined.headshotImageUrl else getStandardSizeAvatarHeadShotRbxthumb(
			joined.userId,
			FFlagCarouselUserTileUseProfileFrameThumbnail
		)
		v8.thumbnail = v9

		v8.onActivated = joined.onActivatedTile
		local v10 = if joined.renderButtons then joined.renderButtons() else nil
		v8.buttons = v10

		v8.buttonRef = joined.buttonRef
		v6 = createElement(playerTile, v8)
	end

	local function fn2()
		if joined.renderPlayerName then
			return (joined.renderPlayerName())
		end

		return joined.userName
			and React.createElement(module5, {
				name = joined.userName,
				width = joined.tileSize
			})
			or nil
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.new(0, tileSize, 1, 0),
		BackgroundTransparency = 1
	}

	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerTileFrame = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.fromOffset(tileSize, tileSize),
				BackgroundTransparency = 1
			},
			{ PlayerTile = v6 }
		),
		NameTopPadding = 0,
		UserInfo = 0
	}

	local v10 = if joined.nameTopPadding then React.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(0, joined.nameTopPadding),
		BackgroundTransparency = 1
	}) else nil
	v9.NameTopPadding = v10

	local createElement2 = React.createElement
	local onActivatedContextualsByActivated = {
		LayoutOrder = 3,
		[React.Event.Activated] = joined.onActivatedContextual,
		AutomaticSize = Enum.AutomaticSize.XY,
		onStateChanged = fn,
		BackgroundTransparency = 1,
		Selectable = false
	}

	local v12 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerNameFrame = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			},
			{ PlayerName = fn2() }
		),
		ContextualTopPadding = 0,
		ContextualInfoFrame = 0
	}

	local v13 = if joined.contextualTopPadding then React.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(0, joined.contextualTopPadding),
		BackgroundTransparency = 1
	}) else nil
	v12.ContextualTopPadding = v13

	local createElement3 = React.createElement
	local v15 = {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v17 = if joined.renderContextualInfo then joined.renderContextualInfo() else nil

	v12.ContextualInfoFrame = createElement3("Frame", v15, { ContextualInfo = v17 })
	v9.UserInfo = createElement2(interactable, onActivatedContextualsByActivated, v12)
	return createElement("Frame", v8, v9)
end
