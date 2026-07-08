local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Style = require(ParentParent.Style)
local UIBlox = require(ParentParent.UIBlox)
local useDesignTokens = Style.useDesignTokens
local PlayerName = UIBlox.App.Indicator.PlayerName
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(p1) -- line: 40
	-- upvalues: useDesignTokens (copy), React (copy), Button (copy), ButtonType (copy), PlayerName (copy), PlayerContext (copy)
	local v11 = useDesignTokens(function(p2) -- line: 41
		return {
			contextTextSpacing = p2.Size.Size_150,
			joinEventSpacing = p2.Size.Size_300,
			padding = p2.Size.Size_400,
			joinEventButtonHeight = p2.Size.Size_1200
		}
	end)

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p3) -- line: 88
			-- upvalues: p1 (copy)
			p1.onHeaderHeightChanged(p3.AbsoluteSize.Y)
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v11.padding),
			PaddingBottom = UDim.new(0, v11.padding),
			PaddingLeft = UDim.new(0, v11.padding),
			PaddingRight = UDim.new(0, v11.padding)
		}),
		PlayerName = React.createElement(PlayerName, {
			layoutOrder = 1,
			automaticSize = Enum.AutomaticSize.XY,
			displayNameItem = p1.displayNameItem,
			userNameItem = p1.userNameItem,
			vendorNameItem = p1.vendorNameItem
		}),
		ContextTextSpacing = if not p1.contextText then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v11.contextTextSpacing)
		}),
		PlayerContext = if not p1.contextText then nil else React.createElement(PlayerContext, {
			layoutOrder = 3,
			Selectable = false,
			icon = p1.contextIcon,
			iconColor = p1.contextIconColor,
			iconTransparency = p1.contextIconTransparency,
			text = p1.contextText
		}),
		JoinButton = (function() -- line: 50
			-- upvalues: p1 (copy), React (copy), v11 (copy), Button (copy), ButtonType (copy)
			if p1.renderJoinEventButton or p1.joinEventText then
				return React.createElement("Frame", {
					LayoutOrder = 5,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					JoinEventSpacing = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, v11.joinEventSpacing)
					}),
					JoinButton = if not p1.renderJoinEventButton then React.createElement(Button, {
						isLoading = false,
						layoutOrder = 5,
						buttonType = ButtonType.PrimaryContextual,
						onActivated = p1.joinEventOnActivated,
						size = UDim2.new(1, 0, 0, v11.joinEventButtonHeight),
						text = p1.joinEventText
					}) else p1.renderJoinEventButton()
				})
			end

			return nil
		end)()
	})
end
