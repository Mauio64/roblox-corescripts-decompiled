local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle

local module = require("@luauforge/deferred/hVL")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local extended = Roact.PureComponent:extend("FloodcheckTextAndLink")

game:DefineFastInt("LuaSignupCooldownTimerSeconds", 15)

extended.defaultProps = {
	fontStyle = "CaptionBody",
	textLabelText = "",
	textButtonText = "",
	textButtonEnabled = true
}

function extended:init()
	self.state = { timer = 0 }

	self.mounted = false

	local v5 = false

	function self.onActivated(p2)
		local textButtonEnabled = self.props.textButtonEnabled

		if not v5 and self.state.timer == 0 and self.mounted and textButtonEnabled then
			v5 = true
			spawn(function()
				local cooldownTime = self.props.cooldownTime
					or game:GetFastInt("LuaSignupCooldownTimerSeconds")
				v5 = false

				for i = cooldownTime, 0, -1 do
					if not self.mounted then
						break
					end

					self:setState({ timer = i })

					wait(1)
				end
			end)

			if self.props.onActivated then
				self.props.onActivated(p2)
			end
		end
	end
end

function extended:didMount()
	self.mounted = true
end

function extended:willUnmount()
	self.mounted = false
end

function extended.render(data)
	return withStyle(function(p2)
		local fontStyle = data.props.fontStyle
		local v5 = p2.Font[fontStyle]
		local v6 = v5.RelativeSize * p2.Font.BaseSize

		return Roact.createElement(
			FitChildren.FitFrame,
			{
				Size = UDim2.fromOffset(0, v6),
				LayoutOrder = data.props.LayoutOrder,
				BackgroundTransparency = 1,
				fitAxis = FitChildren.FitAxis.Width
			},
			{
				TextAndLink = Roact.createElement(module, Cryo.Dictionary.join(data.props, {
					textButtonEnabled = data.state.timer == 0,
					onActivated = data.onActivated
				})),
				Timer = Roact.createElement("TextLabel", {
					Font = v5.Font,
					TextSize = v6,
					Size = UDim2.fromOffset(0, v6),
					Position = UDim2.fromScale(1, 0),
					TextColor3 = p2.Theme.TextEmphasis.Color,
					Text = data.state.timer > 0 and " " .. data.state.timer or "",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = data.props.TextTransparency,
					BackgroundTransparency = 1
				})
			}
		)
	end)
end

return extended
