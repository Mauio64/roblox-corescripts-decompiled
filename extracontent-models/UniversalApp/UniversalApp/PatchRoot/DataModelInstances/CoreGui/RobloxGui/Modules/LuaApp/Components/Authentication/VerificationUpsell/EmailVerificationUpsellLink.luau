local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local v6 = Roact.PureComponent:extend(script.Name)

v6.defaultProps = {
	textPadding = 8,
	shouldUseAutomaticSize = false
}

function v6.render(p1) -- line: 18
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy)
	local textKey = p1.props.textKey
	local layoutOrder = p1.props.layoutOrder
	local onActivatedCallback = p1.props.onActivatedCallback
	local isPrimaryLink = p1.props.isPrimaryLink
	local textPadding = p1.props.textPadding
	local shouldUseAutomaticSize = p1.props.shouldUseAutomaticSize

	return withStyle(function(p2) -- line: 26
		-- upvalues: withLocalization (copy), textKey (copy), isPrimaryLink (copy), onActivatedCallback (copy), Roact (copy), shouldUseAutomaticSize (copy), textPadding (copy), layoutOrder (copy)
		return withLocalization({
			linkText = textKey
		})(function(p3) -- line: 29
			-- upvalues: isPrimaryLink (copy), p2 (copy), onActivatedCallback (copy), Roact (copy), shouldUseAutomaticSize (copy), textPadding (copy), layoutOrder (copy)
			local v16 = isPrimaryLink and p2.Font.SubHeader1 or p2.Font.CaptionBody
			local v17 = onActivatedCallback and p2.Theme.SystemPrimaryDefault.Color or p2.Theme.UIDefault.Color
			local v18 = v16.RelativeSize * p2.Font.BaseSize

			return Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				RichText = true,
				Text = string.format("<u>%s</u>", p3.linkText),
				Size = if not shouldUseAutomaticSize then UDim2.new(1, 0, 0, v18 + textPadding) else UDim2.new(0, 0, 0, 0),
				AutomaticSize = if not shouldUseAutomaticSize then nil else Enum.AutomaticSize.XY,
				Font = v16.Font,
				TextColor3 = v17,
				TextTransparency = p2.Theme.TextDefault.Transparency,
				TextSize = v18,
				LayoutOrder = layoutOrder,
				[Roact.Event.Activated] = onActivatedCallback
			})
		end)
	end)
end

return v6
