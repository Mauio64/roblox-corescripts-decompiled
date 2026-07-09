local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Colors = require(Modules.LuaApp.Themes.Colors)
local LocalizedTextLabel = require(Modules.LuaApp.Components.LocalizedTextLabel)
local TouchFriendlyIconButton = require(Modules.LuaApp.Components.Generic.TouchFriendlyIconButton)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v11 = Roact.PureComponent:extend("NavigationBar")

v11.defaultProps = {
	icon = "LuaApp/icons/ic-roblox-close",
	iconSize = 36,
	buttonSize = 36,
	buttonLeftPadding = 10,
	titleTextSize = 23,
	paddingTop = 0,
	paddingBottom = 0,
	iconColor = Colors.White,
	titleFont = Enum.Font.SourceSansBold,
	titleColor = Colors.White
}

function v11.render(p1) -- line: 41
	-- upvalues: Roact (copy), TouchFriendlyIconButton (copy), LocalizedTextLabel (copy)
	local propsSize = p1.props.Size
	local propsPosition = p1.props.Position
	local icon = p1.props.icon
	local iconSize = p1.props.iconSize
	local iconColor = p1.props.iconColor
	local buttonSize = p1.props.buttonSize
	local buttonLeftPadding = p1.props.buttonLeftPadding
	local title = p1.props.title
	local titleFont = p1.props.titleFont
	local titleTextSize = p1.props.titleTextSize
	local titleColor = p1.props.titleColor
	local paddingTop = p1.props.paddingTop
	local paddingBottom = p1.props.paddingBottom
	local v26 = p1.props.onNavigationButtonActivated or p1.props.navigateBack

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = propsSize,
		Position = propsPosition
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, paddingTop),
			PaddingBottom = UDim.new(0, paddingBottom)
		}),
		NavigationButton = Roact.createElement(TouchFriendlyIconButton, {
			Position = UDim2.new(0, buttonLeftPadding, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, buttonSize, 0, buttonSize),
			onActivated = v26,
			icon = icon,
			iconColor = iconColor,
			iconSize = iconSize
		}),
		Title = title and Roact.createElement(LocalizedTextLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = title,
			Font = titleFont,
			TextSize = titleTextSize,
			TextColor3 = titleColor,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return RoactRodux.connect(nil, function(p2) -- line: 89
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 91
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), p2 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v10.back()
			end

			return p2(NavigateBack())
		end
	}
end)(v11)
