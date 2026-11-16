local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

local uiBlox = dependencies.UIBlox
local playerTile = uiBlox.App.Tile.PlayerTile
local interactable = uiBlox.Core.Control.Interactable

local getUserAvatarImage = require(SocialLibraries.User.getUserAvatarImage)
local PlayerName = require(script.Parent.PlayerName)
require(script.Parent.StyleTypes)
local Constants = require(script.Parent.Constants)

local function fn() end

local v = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(p)
	local joined = llama.Dictionary.join(v, p)
	local tileSize = joined.tileSize

	local function fn2() -- 1 equivalent call inferred from this helper
		if joined.renderButtons then
			return (joined.renderButtons())
		end

		return nil
	end

	local function fn3()
		if joined.renderPlayerTile then
			return (joined.renderPlayerTile())
		end

		return (roact.createElement(playerTile, {
			tileSize = UDim2.fromOffset(joined.tileSize, joined.tileSize),
			thumbnail = getUserAvatarImage(joined.userId),
			onActivated = joined.onActivatedTile,
			buttons = fn2() -- inferred equivalent call
		}))
	end

	local function fn4()
		if joined.renderPlayerName then
			return (joined.renderPlayerName())
		end

		return joined.userName
			and roact.createElement(PlayerName, { name = joined.userName, width = joined.tileSize })
			or nil
	end

	local createElement = roact.createElement
	local v2 = {
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.fromOffset(tileSize, 0),
		BackgroundTransparency = 1
	}

	local v3 = {
		UIListLayout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerTileFrame = roact.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.fromOffset(tileSize, tileSize),
				BackgroundTransparency = 1
			},
			{ PlayerTile = fn3() }
		),
		NameTopPadding = 0,
		UserInfo = 0
	}
	local nameTopPadding

	if joined.nameTopPadding then
		nameTopPadding = roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, joined.nameTopPadding),
			BackgroundTransparency = 1
		})
	end

	v3.NameTopPadding = nameTopPadding

	local createElement2 = roact.createElement
	local onActivatedContextualsByActivated = {
		LayoutOrder = 3,
		[roact.Event.Activated] = joined.onActivatedContextual,
		AutomaticSize = Enum.AutomaticSize.XY,
		onStateChanged = fn,
		BackgroundTransparency = 1
	}

	local v4 = {
		UIListLayout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerNameFrame = roact.createElement(
			"Frame",
			{ LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
			{ PlayerName = fn4() }
		),
		ContextualTopPadding = 0,
		ContextualInfoFrame = 0
	}
	local contextualTopPadding

	if joined.contextualTopPadding then
		contextualTopPadding = roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, joined.contextualTopPadding),
			BackgroundTransparency = 1
		})
	end

	v4.ContextualTopPadding = contextualTopPadding

	local function fn5() -- 1 equivalent call inferred from this helper
		if joined.renderContextualInfo then
			return (joined.renderContextualInfo())
		end

		return nil
	end

	v4.ContextualInfoFrame = roact.createElement(
		"Frame",
		{ LayoutOrder = 3, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
		{ ContextualInfo = fn5() } -- inferred equivalent call
	)
	v3.UserInfo = createElement2(interactable, onActivatedContextualsByActivated, v4)
	return createElement("Frame", v2, v3)
end
