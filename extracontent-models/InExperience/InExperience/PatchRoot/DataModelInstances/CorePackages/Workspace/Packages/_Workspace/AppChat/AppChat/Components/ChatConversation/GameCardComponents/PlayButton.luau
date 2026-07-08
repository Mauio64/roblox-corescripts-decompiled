local Parent = script:FindFirstAncestor("AppChat").Parent
local UIBlox = require(Parent.UIBlox)
local Roact = require(Parent.Roact)
local Button = require(script.Parent.Button)
local v5 = Roact.PureComponent:extend("PlayButton")

v5.defaultProps = {
	text = "Play!",
	LayoutOrder = 0,
	onActivated = function() -- line: 15
		print("Play button activated!")
	end
}

function v5.render(p1) -- line: 20
	-- upvalues: UIBlox (copy), Roact (copy), Button (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 21
		-- upvalues: Roact (copy), Button (copy), p1 (copy)
		return Roact.createElement(Button, {
			textSize = 23,
			text = p1.props.text,
			textColor = Color3.fromRGB(255, 255, 255),
			font = p2.Font.Body.Font,
			transparency = p2.Theme.ContextualPrimaryDefault.Transparency,
			color = p2.Theme.ContextualPrimaryDefault.Color,
			LayoutOrder = p1.props.LayoutOrder or 0,
			onActivated = p1.props.onActivated
		})
	end)
end

return v5
