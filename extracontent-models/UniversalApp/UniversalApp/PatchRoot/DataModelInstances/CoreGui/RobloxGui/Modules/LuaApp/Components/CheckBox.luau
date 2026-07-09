local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Common = Modules.Common
local Roact = require(Common.Roact)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local v6 = Roact.PureComponent:extend("CheckBox")

function v6.init(p1) -- line: 17
	p1.state = {
		hovering = false
	}

	function p1.onActivated() -- line: 22
		-- upvalues: p1 (copy)
		if p1.props.Enabled and p1.props.OnActivated then
			p1.props.OnActivated()
		end
	end
	function p1.onMouseEnter(_) -- line: 28
		-- upvalues: p1 (copy)
		spawn(function() -- line: 29
			-- upvalues: p1 (copy)
			p1:setState({
				hovering = true
			})
		end)
	end
	function p1.onMouseLeave(_) -- line: 36
		-- upvalues: p1 (copy)
		spawn(function() -- line: 37
			-- upvalues: p1 (copy)
			p1:setState({
				hovering = false
			})
		end)
	end
end
function v6.render(p4) -- line: 45
	-- upvalues: Roact (copy), DEPRECATED_ImageSetButton (copy), DEPRECATED_ImageSetLabel (copy)
	local propsEnabled = p4.props.Enabled
	local propsLayoutOrder = p4.props.LayoutOrder
	local Selected = p4.props.Selected
	local propsHeight = p4.props.Height
	local s1 = nil

	if p4.state.hovering then
		s1 = "LuaApp/graphic/checkbox_unchecked_hover"
	elseif not propsEnabled and not p4.state.hovering then
		s1 = "LuaApp/graphic/checkbox_unchecked_disabled"
	elseif propsEnabled then
		s1 = "LuaApp/graphic/checkbox_unchecked"
	end

	local v14 = not propsEnabled and "LuaApp/graphic/checkbox_checked_disabled" or "LuaApp/graphic/checkbox_checked"

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, propsHeight, 0, propsHeight)
	}, {
		Background = Roact.createElement(DEPRECATED_ImageSetButton, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ImageTransparency = not propsEnabled and 0.4 or 0,
			Image = s1,
			LayoutOrder = propsLayoutOrder or 1,
			AutoButtonColor = false,
			[Roact.Event.Activated] = p4.onActivated,
			[Roact.Event.MouseEnter] = p4.onMouseEnter,
			[Roact.Event.MouseLeave] = p4.onMouseLeave
		}, {
			Selection = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = Selected,
				Image = v14
			})
		})
	})
end

return v6
