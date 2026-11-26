local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/deferred/gHF")

local extended = Roact.PureComponent:extend("ShareTargetGameTopBar")
extended.defaultProps = { LayoutOrder = 0 }

function extended.render(p2)
	return UIBlox.Style.withStyle(function(p3)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, 88),
			LayoutOrder = p2.props.LayoutOrder
		}, {
			topBar = Roact.createElement(module, {
				paddingTop = 12,
				title = "Feature.Chat.Heading.ShareGameToChat",
				titleFont = p3.Font.Header2.Font,
				titleTextSize = p3.Font.Header2.RelativeSize * p3.Font.BaseSize,
				titleColor = p3.Theme.TextEmphasis.Color,
				iconSize = 36,
				icon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
				iconColor = p3.Theme.IconEmphasis.Color,
				buttonLeftPadding = 15,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return extended
