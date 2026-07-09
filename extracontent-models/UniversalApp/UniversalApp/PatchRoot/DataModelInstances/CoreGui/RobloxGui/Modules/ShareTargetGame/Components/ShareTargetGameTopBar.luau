local CorePackages = game:GetService("CorePackages")
local LuaApp = game:GetService("CoreGui").RobloxGui.Modules.LuaApp
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local NavigationBar = require(LuaApp.Components.NavigationBar)
local v6 = Roact.PureComponent:extend("ShareTargetGameTopBar")

v6.defaultProps = {
	LayoutOrder = 0
}

function v6.render(p1) -- line: 25
	-- upvalues: UIBlox (copy), Roact (copy), NavigationBar (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 26
		-- upvalues: Roact (copy), p1 (copy), NavigationBar (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, 88),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			topBar = Roact.createElement(NavigationBar, {
				paddingTop = 12,
				title = "Feature.Chat.Heading.ShareGameToChat",
				iconSize = 36,
				icon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
				buttonLeftPadding = 15,
				titleFont = p2.Font.Header2.Font,
				titleTextSize = p2.Font.Header2.RelativeSize * p2.Font.BaseSize,
				titleColor = p2.Theme.TextEmphasis.Color,
				iconColor = p2.Theme.IconEmphasis.Color,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return v6
