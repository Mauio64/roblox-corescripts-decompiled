local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local useDesignTokens = require(ParentParent.Style).useDesignTokens
local UIBlox = require(ParentParent.UIBlox)
local BaseMenu = UIBlox.App.Menu.BaseMenu
local useCursor = UIBlox.App.SelectionCursor.useCursor
local PlayerContextualMenuHeader = require(script.Parent.PlayerContextualMenuHeader)
local t1 = {
	width = UDim.new(1, 0)
}

return function(t2: {[any]: any}) -- line: 28
	-- upvalues: Dash (copy), t1 (copy), useCursor (copy), useDesignTokens (copy), React (copy), PlayerContextualMenuHeader (copy), BaseMenu (copy)
	local v11 = Dash.join(t1, t2)
	local v12 = useCursor()
	local v13 = useDesignTokens(function(p1) -- line: 31
		return {
			overlayBackgroundColor3 = p1.Color.Common.Scrim.Color3,
			overlayBackgroundTransparency = p1.Color.Common.Scrim.Transparency,
			backgroundColor = p1.Color.Surface.Surface_0.Color3,
			backgroundTransparency = p1.Color.Surface.Surface_0.Transparency,
			menuCornerRadius = p1.Radius.Medium
		}
	end)
	local v14, v15 = React.useState(0)
	local v16 = React.useCallback(function() -- line: 43
		-- upvalues: React (copy), PlayerContextualMenuHeader (copy), Dash (copy), v11 (copy), v15 (copy)
		return React.createElement(PlayerContextualMenuHeader, Dash.join(v11.headerProps, {
			onHeaderHeightChanged = v15
		}))
	end, { v11.headerProps })

	return React.createElement("Frame", {
		ZIndex = -1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v13.overlayBackgroundColor3,
		BackgroundTransparency = v13.overlayBackgroundTransparency
	}, {
		PositionFrame = React.createElement("TextButton", {
			AutoButtonColor = false,
			Text = "",
			ZIndex = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v13.backgroundColor,
			BackgroundTransparency = v13.backgroundTransparency,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Selectable = #v11.buttonProps == 0,
			SelectionImageObject = v12,
			Size = UDim2.new(v11.width, UDim.new(0, 0))
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v13.menuCornerRadius)
			}),
			BaseMenu = React.createElement(BaseMenu, {
				topElementRounded = false,
				enableTokenOverride = true,
				buttonProps = v11.buttonProps,
				width = v11.width,
				renderHeader = v16,
				headerHeight = v14
			})
		})
	})
end
