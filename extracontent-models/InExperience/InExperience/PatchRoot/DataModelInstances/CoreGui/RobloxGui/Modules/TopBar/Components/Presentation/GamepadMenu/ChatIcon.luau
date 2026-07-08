local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Badge = UIBlox.App.Indicator.Badge
local v10 = Images["icons/menu/chat_on"]
local v11 = Images["icons/menu/chat_off"]
local v12 = Roact.PureComponent:extend("ChatIcon")

v12.validateProps = t.strictInterface({
	chatVisible = t.boolean,
	unreadMessages = t.integer
})

function v12.render(p1) -- line: 24
	-- upvalues: withStyle (copy), v10 (copy), v11 (copy), Roact (copy), ImageSetLabel (copy), Badge (copy)
	return withStyle(function(p2) -- line: 25
		-- upvalues: v10 (copy), p1 (copy), v11 (copy), Roact (copy), ImageSetLabel (copy), Badge (copy)
		local Theme = p2.Theme
		local v18 = v10

		if not p1.props.chatVisible then
			v18 = v11
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			Image = v18,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = Theme.IconEmphasis.Transparency
		}, {
			Badge = p1.props.unreadMessages > 0 and Roact.createElement(Badge, {
				hasShadow = false,
				position = UDim2.new(0, 24, 0.5, 0),
				anchorPoint = Vector2.new(0, 0.5),
				value = p1.props.unreadMessages
			})
		})
	end)
end

local function mapStateToProps(p3) -- line: 52
	return {
		chatVisible = p3.chat.visible,
		unreadMessages = p3.chat.unreadMessages
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v12)
