local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v7 = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local WHITE = Constants.Color.WHITE
local v9 = Theme.textSize(19)
local v10 = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local GRAY3 = Constants.Color.GRAY3
local v12 = Theme.textSize(16, "ConversationDetails")
local v13 = Theme.font(Enum.Font.SourceSans, "ConversationDetails")
local v14 = Theme.textSize(16, "ConversationDetails")
local v15 = require(ShareGame.getTranslator)()
local v16 = Roact.PureComponent:extend("ConversationDetails")

function v16.render(p1) -- line: 30
	-- upvalues: Roact (copy), v12 (copy), v10 (copy), GRAY3 (copy), v14 (copy), v15 (copy), Constants (copy), v13 (copy), v9 (copy), v7 (copy), WHITE (copy)
	local title = p1.props.title
	local subtitle = p1.props.subtitle
	local presence = p1.props.presence
	local size = p1.props.size
	local layoutOrder = p1.props.layoutOrder
	local zIndex = p1.props.zIndex
	local v24 = nil

	if subtitle ~= nil then
		v24 = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v12),
			Text = subtitle,
			Font = v10,
			TextColor3 = GRAY3,
			TextSize = v12,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = zIndex
		})
	end

	local v25 = nil

	if presence ~= nil then
		v25 = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v14),
			Text = v15:FormatByKey(Constants.PresenceTextKey[presence]),
			Font = v13,
			TextColor3 = Constants.PresenceColors[presence],
			TextSize = v14,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = zIndex
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		}),
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, v9),
			Text = title or "",
			Font = v7,
			TextColor3 = WHITE,
			TextSize = v9,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = zIndex
		}),
		Subtitle = v24,
		Presence = v25
	})
end

return v16
