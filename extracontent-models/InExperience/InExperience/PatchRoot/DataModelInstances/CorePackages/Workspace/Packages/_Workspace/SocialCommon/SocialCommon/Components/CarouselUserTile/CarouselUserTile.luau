local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local React = require(SocialCommonParent.React)
local Cryo = require(SocialCommonParent.Cryo)
local UIBlox = require(SocialCommonParent.UIBlox)
local PlayerTile = UIBlox.App.Tile.PlayerTile
local Interactable = UIBlox.Core.Control.Interactable
local getStandardSizeAvatarHeadShotRbxthumb = require(SocialCommonParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagCarouselUserTileUseProfileFrameThumbnail = require(SocialCommon.Flags.FFlagCarouselUserTileUseProfileFrameThumbnail)
local PlayerName = require(script.Parent.PlayerName)
local Constants = require(script.Parent.Constants)

local function v12() -- line: 16
end

local t1 = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(t2: {[any]: any}) -- line: 51
	-- upvalues: Cryo (copy), t1 (copy), React (copy), PlayerTile (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagCarouselUserTileUseProfileFrameThumbnail (copy), PlayerName (copy), Interactable (copy), v12 (copy)
	local v15 = Cryo.Dictionary.join(t1, t2)
	local tileSize = v15.tileSize
	local v17 = if not v15.renderPlayerTile then React.createElement(PlayerTile, {
		title = "",
		Selectable = true,
		tileSize = UDim2.fromOffset(v15.tileSize, v15.tileSize),
		thumbnail = if not v15.headshotImageUrl then getStandardSizeAvatarHeadShotRbxthumb(v15.userId, FFlagCarouselUserTileUseProfileFrameThumbnail) else v15.headshotImageUrl,
		onActivated = v15.onActivatedTile,
		buttons = if not v15.renderButtons then nil else v15.renderButtons(),
		buttonRef = v15.buttonRef
	}) else v15.renderPlayerTile()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v15.layoutOrder,
		Size = UDim2.new(0, tileSize, 1, 0)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerTileFrame = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(tileSize, tileSize)
		}, {
			PlayerTile = v17
		}),
		NameTopPadding = if not v15.nameTopPadding then nil else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v15.nameTopPadding)
		}),
		UserInfo = React.createElement(Interactable, {
			LayoutOrder = 3,
			[React.Event.Activated] = v15.onActivatedContextual,
			AutomaticSize = Enum.AutomaticSize.XY,
			onStateChanged = v12,
			BackgroundTransparency = 1,
			Selectable = false
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			PlayerNameFrame = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				PlayerName = (function() -- line: 76
					-- upvalues: v15 (copy), React (copy), PlayerName (copy)
					if v15.renderPlayerName then
						return (v15.renderPlayerName())
					end

					return v15.userName and React.createElement(PlayerName, {
						name = v15.userName,
						width = v15.tileSize
					}) or nil
				end)()
			}),
			ContextualTopPadding = if not v15.contextualTopPadding then nil else React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, v15.contextualTopPadding)
			}),
			ContextualInfoFrame = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				ContextualInfo = if not v15.renderContextualInfo then nil else v15.renderContextualInfo()
			})
		})
	})
end
