local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Localization").Hooks.useLocalization

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox").Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

return function()
	local v5 = useStyle()
	local v6 = if foundationFontFaceMigration then useTokens() else nil
	local font = v5.Font
	local font2 = if not foundationFontFaceMigration then font.Header1.Font else nil
	local v7

	if foundationFontFaceMigration then
		v7 = normalizeFontFace(v6.Typography.TitleLarge.Font)
	end

	local v8 = if foundationFontFaceMigration then v6.Typography.TitleLarge.FontSize else font.BaseSize

	local v9 = useLocalization({ emptyText = constants.Text.EmptyKey })

	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, constants.DefaultPadding)
			}),
			React.createElement("TextLabel", {
				Text = v9 and v9.emptyText,
				LayoutOrder = 2,
				Font = font2,
				FontFace = v7,
				TextSize = v8,
				BackgroundTransparency = 1,
				TextColor3 = v5.Theme.TextDefault.Color,
				Size = UDim2.new(1, 0, 0, constants.EmptyNotifications.LabelHeight)
			})
		}
	)
end
