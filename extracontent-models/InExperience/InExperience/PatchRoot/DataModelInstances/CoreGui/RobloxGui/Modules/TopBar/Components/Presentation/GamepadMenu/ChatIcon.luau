local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Badge = UIBlox.App.Indicator.Badge

local iconsmenuchat_on = Images["icons/menu/chat_on"]
local iconsmenuchat_off = Images["icons/menu/chat_off"]

local extended = Roact.PureComponent:extend("ChatIcon")

extended.validateProps = t.strictInterface({ chatVisible = t.boolean, unreadMessages = t.integer })

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme

		local image = iconsmenuchat_on

		if not p.props.chatVisible then
			image = iconsmenuchat_off
		end

		return Roact.createElement(ImageSetLabel, {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = image,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = theme.IconEmphasis.Transparency,
			ZIndex = 2
		}, {
			Badge = p.props.unreadMessages > 0 and Roact.createElement(Badge, {
				position = UDim2.new(0, 24, 0.5, 0),
				anchorPoint = Vector2.new(0, 0.5),
				hasShadow = false,
				value = p.props.unreadMessages
			})
		})
	end)
end

local function mapStateToProps(p)
	return { chatVisible = p.chat.visible, unreadMessages = p.chat.unreadMessages }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
