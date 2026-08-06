local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Button = require(script.Parent.Button)
local v5 = Roact.PureComponent:extend("ViewDetailsButton")

v5.defaultProps = {
	text = nil,
	LayoutOrder = nil,
	onActivated = function() -- line: 14
		print("View details button pressed!")
	end
}

function v5.render(p1) -- line: 19
	-- upvalues: UIBlox (copy), Roact (copy), Button (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 20
		-- upvalues: Roact (copy), Button (copy), p1 (copy)
		return Roact.createElement(Button, {
			text = p1.props.text,
			textColor = p2.Theme.SystemPrimaryContent.Color,
			textSize = p2.Font.Body.RelativeSize * p2.Font.BaseSize,
			font = p2.Font.Body.Font,
			transparency = p2.Theme.SystemPrimaryDefault.Transparency,
			color = p2.Theme.SystemPrimaryDefault.Color,
			LayoutOrder = p1.props.LayoutOrder or 0,
			onActivated = p1.props.onActivated
		})
	end)
end

return v5
