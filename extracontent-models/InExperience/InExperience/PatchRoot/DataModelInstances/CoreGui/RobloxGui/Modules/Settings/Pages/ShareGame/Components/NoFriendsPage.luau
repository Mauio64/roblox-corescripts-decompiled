local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame

local Roact = require(CorePackages.Packages.Roact)
local Constants = require(ShareGame.Constants)

local ShareGameIcons = require(ShareGame.Spritesheets.ShareGameIcons)
local frame = ShareGameIcons:GetFrame("friends")
local imagePath = ShareGameIcons:GetImagePath()
local Theme = require(RobloxGui.Modules.Settings.Theme)

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("NoFriendsPage")

function extended.render(p)
	local layoutOrder = p.props.LayoutOrder
	local zIndex = p.props.ZIndex
	local position = p.props.Position

	local count = 0
	local function incrementLayoutOrder() -- 4 equivalent calls inferred from this helper
		count += 1
		return count
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = position
	}, {
		listLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		friendsIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = imagePath,
			ImageRectOffset = frame.offset,
			ImageRectSize = frame.size,
			Size = UDim2.new(0, 72, 0, 72),
			LayoutOrder = incrementLayoutOrder(), -- inferred equivalent call
			ZIndex = zIndex
		}),
		iconToSubtitleSpacer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 34),
			LayoutOrder = incrementLayoutOrder(), -- inferred equivalent call
			ZIndex = zIndex
		}),
		subtitle = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = translator:FormatByKey("Feature.SettingsHub.Label.NoFriendsScreen"),
			TextColor3 = Constants.Color.GRAY5,
			TextTransparency = 0.22,
			TextSize = Theme.textSize(21),
			TextWrapped = true,
			Font = Theme.font(Enum.Font.SourceSans),
			LayoutOrder = incrementLayoutOrder(), -- inferred equivalent call
			Size = UDim2.new(0, 280, 0, 42),
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = zIndex
		}),
		bottomSpacer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 120),
			LayoutOrder = incrementLayoutOrder(), -- inferred equivalent call
			ZIndex = zIndex
		})
	})
end

return extended
