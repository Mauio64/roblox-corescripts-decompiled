local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")

local module2 = require("@luauforge/bundled/gCk")
local module3 = require("@luauforge/bundled/fzO")

local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local extended = Roact.PureComponent:extend("NavigationBar")

extended.defaultProps = {
	icon = "LuaApp/icons/ic-roblox-close",
	iconSize = 36,
	iconColor = Colors.White,
	buttonSize = 36,
	buttonLeftPadding = 10,
	titleFont = Enum.Font.SourceSansBold,
	titleTextSize = 23,
	titleColor = Colors.White,
	paddingTop = 0,
	paddingBottom = 0
}

function extended.render(p2)
	local size = p2.props.Size
	local position = p2.props.Position
	local icon = p2.props.icon
	local iconSize = p2.props.iconSize
	local iconColor = p2.props.iconColor
	local buttonSize = p2.props.buttonSize
	local buttonLeftPadding = p2.props.buttonLeftPadding
	local title = p2.props.title
	local titleFont = p2.props.titleFont
	local titleTextSize = p2.props.titleTextSize
	local titleColor = p2.props.titleColor
	local paddingTop = p2.props.paddingTop
	local paddingBottom = p2.props.paddingBottom

	local onNavigationButtonActivated = p2.props.onNavigationButtonActivated or p2.props.navigateBack

	return Roact.createElement("Frame", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, paddingTop),
			PaddingBottom = UDim.new(0, paddingBottom)
		}),
		NavigationButton = Roact.createElement(module3, {
			Position = UDim2.new(0, buttonLeftPadding, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, buttonSize, 0, buttonSize),
			onActivated = onNavigationButtonActivated,
			icon = icon,
			iconColor = iconColor,
			iconSize = iconSize
		}),
		Title = title and Roact.createElement(module2, {
			Size = UDim2.new(1, 0, 1, 0),
			Text = title,
			Font = titleFont,
			TextSize = titleTextSize,
			TextColor3 = titleColor,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1
		})
	})
end

return RoactRodux.connect(nil, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended)
