local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local Theme = require(RobloxGui.Modules.Settings.Theme)

local font = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local white = Constants.Color.WHITE
local textSize = Theme.textSize(19)

local font2 = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local GRAY3 = Constants.Color.GRAY3
local textSize2 = Theme.textSize(16, "ConversationDetails")

local font3 = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local textSize3 = Theme.textSize(16, "ConversationDetails")

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("ConversationDetails")

function extended.render(p)
	local title = p.props.title
	local subtitle = p.props.subtitle
	local presence = p.props.presence
	local size = p.props.size
	local layoutOrder = p.props.layoutOrder
	local zIndex = p.props.zIndex
	local subtitle2

	if subtitle ~= nil then
		subtitle2 = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, textSize2),
			Text = subtitle,
			Font = font2,
			TextColor3 = GRAY3,
			TextSize = textSize2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			LayoutOrder = 1,
			ZIndex = zIndex
		})
	end

	local presence2

	if presence ~= nil then
		presence2 = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, textSize3),
			Text = translator:FormatByKey(Constants.PresenceTextKey[presence]),
			Font = font3,
			TextColor3 = Constants.PresenceColors[presence],
			TextSize = textSize3,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			ZIndex = zIndex
		})
	end

	return Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = size, LayoutOrder = layoutOrder, ZIndex = zIndex },
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2)
			}),
			Title = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, textSize),
				Text = title or "",
				Font = font,
				TextColor3 = white,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				LayoutOrder = 0,
				ZIndex = zIndex
			}),
			Subtitle = subtitle2,
			Presence = presence2
		}
	)
end

return extended
