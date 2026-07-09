local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

local function GenericText(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), React (copy)
	local v7 = useDesignTokens()
	local uDim = UDim.new(0, v7.Size.Size_600)
	local v9 = v7.Semantic.Typography[t1.type]
	local v10 = if not t1.emphasis then v7.Color.Content.Default else v7.Color.Content.Emphasis
	local v11 = t1.padding or uDim

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = v11,
			PaddingRight = v11
		}),
		Text = React.createElement("TextLabel", {
			LayoutOrder = 1,
			TextWrapped = true,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.text,
			Font = v9.Font,
			TextColor3 = v10.Color3,
			TextTransparency = v10.Transparency,
			TextSize = v9.FontSize,
			TextXAlignment = t1.TextXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = t1.TextYAlignment or Enum.TextYAlignment.Center,
			Size = t1.size or UDim2.new(1, 0, 1, 0)
		})
	})
end

return {
	HeaderText = function(t2: {[any]: any}) -- line: 58
		-- upvalues: React (copy), GenericText (copy), Dash (copy)
		return React.createElement(GenericText, Dash.join(t2, {
			type = "Header",
			emphasis = true,
			padding = UDim.new(0, 0)
		}))
	end,
	SubheaderText = function(t3: {[any]: any}) -- line: 65
		-- upvalues: React (copy), GenericText (copy), Dash (copy)
		return React.createElement(GenericText, Dash.join(t3, {
			type = "Subheader",
			emphasis = true
		}))
	end,
	BodyText = function(t4: {[any]: any}) -- line: 69
		-- upvalues: React (copy), GenericText (copy), Dash (copy)
		return React.createElement(GenericText, Dash.join(t4, {
			type = "Body",
			emphasis = false
		}))
	end,
	BoldBodyText = function(t5: {[any]: any}) -- line: 73
		-- upvalues: React (copy), GenericText (copy), Dash (copy)
		return React.createElement(GenericText, Dash.join(t5, {
			type = "Header",
			emphasis = false
		}))
	end
}
