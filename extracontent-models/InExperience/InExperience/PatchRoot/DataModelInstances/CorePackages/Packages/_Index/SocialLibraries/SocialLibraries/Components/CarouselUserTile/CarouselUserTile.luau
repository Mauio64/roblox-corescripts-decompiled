local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local UIBlox = dependencies.UIBlox
local PlayerTile = UIBlox.App.Tile.PlayerTile
local Interactable = UIBlox.Core.Control.Interactable
local getUserAvatarImage = require(SocialLibraries.User.getUserAvatarImage)
local PlayerName = require(script.Parent.PlayerName)

require(script.Parent.StyleTypes)

local Constants = require(script.Parent.Constants)

local function v11() -- line: 16
end

local t1 = {
	tileSize = Constants.TILE_SIZE,
	nameTopPadding = Constants.NAME_TOP_PADDING,
	contextualTopPadding = Constants.CONTEXTUAL_TOP_PADDING
}

return function(t2: {[any]: any}) -- line: 49
	-- upvalues: llama (copy), t1 (copy), Roact (copy), PlayerTile (copy), getUserAvatarImage (copy), PlayerName (copy), Interactable (copy), v11 (copy)
	local v14 = llama.Dictionary.join(t1, t2)
	local tileSize = v14.tileSize

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v14.layoutOrder,
		Size = UDim2.fromOffset(tileSize, 0)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayerTileFrame = Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(tileSize, tileSize)
		}, {
			PlayerTile = (function() -- line: 59
				-- upvalues: v14 (copy), Roact (copy), PlayerTile (copy), getUserAvatarImage (copy)
				if v14.renderPlayerTile then
					return (v14.renderPlayerTile())
				end

				return (Roact.createElement(PlayerTile, {
					tileSize = UDim2.fromOffset(v14.tileSize, v14.tileSize),
					thumbnail = getUserAvatarImage(v14.userId),
					onActivated = v14.onActivatedTile,
					buttons = if not v14.renderButtons then nil else v14.renderButtons()
				}))
			end)()
		}),
		NameTopPadding = if not v14.nameTopPadding then nil else Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v14.nameTopPadding)
		}),
		UserInfo = Roact.createElement(Interactable, {
			LayoutOrder = 3,
			[Roact.Event.Activated] = v14.onActivatedContextual,
			AutomaticSize = Enum.AutomaticSize.XY,
			onStateChanged = v11,
			BackgroundTransparency = 1
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			PlayerNameFrame = Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				PlayerName = (function() -- line: 76
					-- upvalues: v14 (copy), Roact (copy), PlayerName (copy)
					if v14.renderPlayerName then
						return (v14.renderPlayerName())
					end

					return v14.userName and Roact.createElement(PlayerName, {
						name = v14.userName,
						width = v14.tileSize
					}) or nil
				end)()
			}),
			ContextualTopPadding = if not v14.contextualTopPadding then nil else Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, v14.contextualTopPadding)
			}),
			ContextualInfoFrame = Roact.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				ContextualInfo = if not v14.renderContextualInfo then nil else v14.renderContextualInfo()
			})
		})
	})
end
