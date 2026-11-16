local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local UIBlox = require(parent.UIBlox)
local PlayerTile = UIBlox.App.Tile.PlayerTile
local Interactable = UIBlox.Core.Control.Interactable
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local FFlagCarouselUserTileUseProfileFrameThumbnail = require(SocialCommon.Flags.FFlagCarouselUserTileUseProfileFrameThumbnail)

local PlayerName = require(script.Parent.PlayerName)
local Constants = require(script.Parent.Constants)

local function fn() end

local v = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(p)
	local joined = Cryo.Dictionary.join(v, p)
	local tileSize = joined.tileSize
	local playerTile

	if joined.renderPlayerTile then
		playerTile = joined.renderPlayerTile()
	else
		local createElement = React.createElement
		local v2 = {
			title = "",
			tileSize = UDim2.fromOffset(joined.tileSize, joined.tileSize),
			thumbnail = 0,
			onActivated = 0,
			buttons = 0,
			Selectable = true,
			buttonRef = 0
		}
		local thumbnail

		if joined.headshotImageUrl then
			thumbnail = joined.headshotImageUrl
		else
			thumbnail = getStandardSizeAvatarHeadShotRbxthumb(
				joined.userId,
				FFlagCarouselUserTileUseProfileFrameThumbnail
			)
		end

		v2.thumbnail = thumbnail

		v2.onActivated = joined.onActivatedTile
		local buttons

		if joined.renderButtons then
			buttons = joined.renderButtons()
		end

		v2.buttons = buttons

		v2.buttonRef = joined.buttonRef
		playerTile = createElement(PlayerTile, v2)
	end

	local function fn2()
		if joined.renderPlayerName then
			return (joined.renderPlayerName())
		end

		return joined.userName
			and React.createElement(PlayerName, { name = joined.userName, width = joined.tileSize })
			or nil
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.new(0, tileSize, 1, 0),
		BackgroundTransparency = 1
	}

	local v3 = {
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
			{ PlayerTile = playerTile }
		),
		NameTopPadding = 0,
		UserInfo = 0
	}
	local nameTopPadding

	if joined.nameTopPadding then
		nameTopPadding = React.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, joined.nameTopPadding),
			BackgroundTransparency = 1
		})
	end

	v3.NameTopPadding = nameTopPadding

	local createElement2 = React.createElement
	local onActivatedContextualsByActivated = {
		LayoutOrder = 3,
		[React.Event.Activated] = joined.onActivatedContextual,
		AutomaticSize = Enum.AutomaticSize.XY,
		onStateChanged = fn,
		BackgroundTransparency = 1,
		Selectable = false
	}

	local v4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerNameFrame = React.createElement(
			"Frame",
			{ LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
			{ PlayerName = fn2() }
		),
		ContextualTopPadding = 0,
		ContextualInfoFrame = 0
	}
	local contextualTopPadding

	if joined.contextualTopPadding then
		contextualTopPadding = React.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, joined.contextualTopPadding),
			BackgroundTransparency = 1
		})
	end

	v4.ContextualTopPadding = contextualTopPadding

	local function fn3() -- 1 equivalent call inferred from this helper
		if joined.renderContextualInfo then
			return (joined.renderContextualInfo())
		end

		return nil
	end

	v4.ContextualInfoFrame = React.createElement(
		"Frame",
		{ LayoutOrder = 3, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
		{ ContextualInfo = fn3() } -- inferred equivalent call
	)
	v3.UserInfo = createElement2(Interactable, onActivatedContextualsByActivated, v4)
	return createElement("Frame", v2, v3)
end
