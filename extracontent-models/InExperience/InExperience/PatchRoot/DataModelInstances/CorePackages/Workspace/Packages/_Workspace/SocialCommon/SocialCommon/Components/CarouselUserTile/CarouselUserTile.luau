local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local PlayerTile = UIBlox.App.Tile.PlayerTile
local Interactable = UIBlox.Core.Control.Interactable
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local PlayerName = require(script.Parent.PlayerName)
local Constants = require(script.Parent.Constants)

local function v10() -- line: 14
end

local t1 = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(t2: {[any]: any}) -- line: 49
	-- upvalues: Cryo (copy), t1 (copy), React (copy), PlayerTile (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), PlayerName (copy), Interactable (copy), v10 (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local tileSize = v13.tileSize

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v13.layoutOrder,
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
			PlayerTile = (function() -- line: 57
				-- upvalues: v13 (copy), React (copy), PlayerTile (copy), getStandardSizeAvatarHeadShotRbxthumb (copy)
				if v13.renderPlayerTile then
					return (v13.renderPlayerTile())
				end

				return (React.createElement(PlayerTile, {
					title = "",
					Selectable = true,
					tileSize = UDim2.fromOffset(v13.tileSize, v13.tileSize),
					thumbnail = if not v13.headshotImageUrl then getStandardSizeAvatarHeadShotRbxthumb(v13.userId) else v13.headshotImageUrl,
					onActivated = v13.onActivatedTile,
					buttons = if not v13.renderButtons then nil else v13.renderButtons(),
					buttonRef = v13.buttonRef
				}))
			end)()
		}),
		NameTopPadding = if not v13.nameTopPadding then nil else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v13.nameTopPadding)
		}),
		UserInfo = React.createElement(Interactable, {
			LayoutOrder = 3,
			[React.Event.Activated] = v13.onActivatedContextual,
			AutomaticSize = Enum.AutomaticSize.XY,
			onStateChanged = v10,
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
				PlayerName = (function() -- line: 77
					-- upvalues: v13 (copy), React (copy), PlayerName (copy)
					if v13.renderPlayerName then
						return (v13.renderPlayerName())
					end

					return v13.userName and React.createElement(PlayerName, {
						name = v13.userName,
						width = v13.tileSize
					}) or nil
				end)()
			}),
			ContextualTopPadding = if not v13.contextualTopPadding then nil else React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, v13.contextualTopPadding)
			}),
			ContextualInfoFrame = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				ContextualInfo = if not v13.renderContextualInfo then nil else v13.renderContextualInfo()
			})
		})
	})
end
