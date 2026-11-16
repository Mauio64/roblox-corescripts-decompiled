local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local parent = script.Parent.Parent

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local GameIcon = require(parent.Components.GameIcon)

local function GameIconHeader(p)
	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 148)
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingTop = UDim.new(0, 24)
		}),
		GameIcon = Roact.createElement(GameIcon, { gameId = game.GameId, iconSize = 100 }),
		GameName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Title",
			themeKey = "TextEmphasis",
			Position = UDim2.new(0, 112, 0, 0),
			Size = UDim2.new(1, -112, 1, 0),
			Text = p.gameName,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p)
	return { gameName = p.gameInfo.name }
end)(GameIconHeader)
