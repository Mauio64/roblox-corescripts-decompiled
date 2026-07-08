local CorePackages = game:GetService("CorePackages")
local Constants = require(script.Parent.Parent.Constants)
local Roact = require(CorePackages.Packages.Roact)
local v4 = Roact.Component:extend("Checkbox")

function v4.render(p1) -- line: 8
	-- upvalues: Constants (copy), Roact (copy)
	local propsSize = p1.props.Size
	local v7 = p1.props.Position or UDim2.new(0, 0, 0, 0)
	local v8 = p1.props.LayoutOrder or 0
	local propsName = p1.props.Name
	local v10 = p1.props.SelectedColor or Constants.Color.SelectedBlue
	local v11 = p1.props.UnselectedColor or Constants.Color.UnselectedGray
	local OnSelectedStateChanged = p1.props.OnSelectedStateChanged
	local s1 = ""
	local n1 = 1

	if p1.props.IsSelected then
		s1 = Constants.Image.Check
		n1 = 0
		v11 = v10
	end

	return Roact.createElement("ImageButton", {
		Size = propsSize,
		Position = v7,
		Image = s1,
		BackgroundColor3 = v11,
		BackgroundTransparency = 0,
		BorderColor3 = Constants.Color.Text,
		BorderSizePixel = n1,
		LayoutOrder = v8,
		[Roact.Event.Activated] = function(_) -- line: 39
			-- upvalues: OnSelectedStateChanged (copy), propsName (copy), p1 (copy)
			if OnSelectedStateChanged then
				OnSelectedStateChanged(propsName, not p1.props.IsSelected)
			end
		end
	})
end

return v4
