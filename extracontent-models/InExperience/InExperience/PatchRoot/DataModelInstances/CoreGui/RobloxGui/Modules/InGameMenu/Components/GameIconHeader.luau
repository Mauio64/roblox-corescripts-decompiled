local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ParentParent = script.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local GameIcon = require(ParentParent.Components.GameIcon)

local function GameIconHeader(p1) -- line: 17
	-- upvalues: Roact (copy), GameIcon (copy), ThemedTextLabel (copy)
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
		GameIcon = Roact.createElement(GameIcon, {
			iconSize = 100,
			gameId = game.GameId
		}),
		GameName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Title",
			themeKey = "TextEmphasis",
			TextWrapped = true,
			Position = UDim2.new(0, 112, 0, 0),
			Size = UDim2.new(1, -112, 1, 0),
			Text = p1.gameName,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2) -- line: 47
	return {
		gameName = p2.gameInfo.name
	}
end)(GameIconHeader)
