local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v5 = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
local v6 = Theme.textSize(19)
local color3 = Color3.fromRGB(222, 225, 227)
local color3_2 = Color3.fromRGB(255, 255, 255)
local v9 = Roact.PureComponent:extend("ShareButton")

function v9.init(p1) -- line: 14
	p1.state = {
		isHovering = false
	}
end
function v9.render(p2) -- line: 20
	-- upvalues: Roact (copy), color3 (copy), color3_2 (copy), Theme (copy), v6 (copy), v5 (copy)
	local size = p2.props.size
	local layoutOrder = p2.props.layoutOrder
	local onShare = p2.props.onShare
	local isEnabled = p2.props.isEnabled
	local text = p2.props.text
	local t1 = {
		Border = Roact.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = if not p2.state.isHovering or not isEnabled then color3_2 else color3,
			Thickness = Theme.DefaultStokeThickness,
			Transparency = not isEnabled and 0.5 or 0
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = Theme.DefaultCornerRadius
		})
	}

	return Roact.createElement("TextButton", {
		LayoutOrder = layoutOrder,
		Size = size,
		Text = text,
		TextSize = v6,
		Font = v5,
		AutoButtonColor = false,
		BackgroundColor3 = if not p2.state.isHovering or not isEnabled then color3_2 else color3,
		Transparency = not isEnabled and 0.5 or 0,
		[Roact.Event.Activated] = function() -- line: 48
			-- upvalues: isEnabled (copy), onShare (copy)
			if isEnabled then
				onShare()
			end
		end,
		[Roact.Event.InputBegan] = function() -- line: 53
			-- upvalues: p2 (copy)
			p2:setState({
				isHovering = true
			})
		end,
		[Roact.Event.InputEnded] = function() -- line: 56
			-- upvalues: p2 (copy)
			p2:setState({
				isHovering = false
			})
		end
	}, t1)
end

return v9
