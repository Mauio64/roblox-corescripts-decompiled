local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = require(CorePackages.Packages.UIBlox).Core.Style.withStyle
local AdjacentTextAndLink = require(Modules.LuaApp.Components.AdjacentTextAndLink)
local FitChildren = require(Modules.LuaApp.FitChildren)
local v8 = Roact.PureComponent:extend("FloodcheckTextAndLink")

game:DefineFastInt("LuaSignupCooldownTimerSeconds", 15)
v8.defaultProps = {
	fontStyle = "CaptionBody",
	textLabelText = "",
	textButtonText = "",
	textButtonEnabled = true
}

function v8.init(p1) -- line: 24
	p1.state = {
		timer = 0
	}
	p1.mounted = false

	local u10 = false

	function p1.onActivated(p2) -- line: 33
		-- upvalues: p1 (copy), u10 (ref)
		local textButtonEnabled = p1.props.textButtonEnabled

		if not u10 and (p1.state.timer == 0 and p1.mounted and textButtonEnabled) then
			u10 = true
			spawn(function() -- line: 37
				-- upvalues: p1 (copy), u10 (ref)
				local v20 = p1.props.cooldownTime or game:GetFastInt("LuaSignupCooldownTimerSeconds")

				u10 = false

				for i = v20, 0, -1 do
					if not p1.mounted then
						return
					end

					p1:setState({
						timer = i
					})
					wait(1)
				end
			end)

			if p1.props.onActivated then
				p1.props.onActivated(p2)
			end
		end
	end
end
function v8.didMount(p3) -- line: 57
	p3.mounted = true
end
function v8.willUnmount(p4) -- line: 61
	p4.mounted = false
end
function v8.render(p5) -- line: 65
	-- upvalues: withStyle (copy), Roact (copy), FitChildren (copy), AdjacentTextAndLink (copy), Cryo (copy)
	return withStyle(function(p6) -- line: 66
		-- upvalues: p5 (copy), Roact (copy), FitChildren (copy), AdjacentTextAndLink (copy), Cryo (copy)
		local fontStyle = p5.props.fontStyle
		local v18 = p6.Font[fontStyle]
		local v19 = v18.RelativeSize * p6.Font.BaseSize

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v19),
			LayoutOrder = p5.props.LayoutOrder,
			fitAxis = FitChildren.FitAxis.Width
		}, {
			TextAndLink = Roact.createElement(AdjacentTextAndLink, Cryo.Dictionary.join(p5.props, {
				textButtonEnabled = p5.state.timer == 0,
				onActivated = p5.onActivated
			})),
			Timer = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = v18.Font,
				TextSize = v19,
				Size = UDim2.fromOffset(0, v19),
				Position = UDim2.fromScale(1, 0),
				TextColor3 = p6.Theme.TextEmphasis.Color,
				Text = p5.state.timer > 0 and " " .. p5.state.timer or "",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTransparency = p5.props.TextTransparency
			})
		})
	end)
end

return v8
