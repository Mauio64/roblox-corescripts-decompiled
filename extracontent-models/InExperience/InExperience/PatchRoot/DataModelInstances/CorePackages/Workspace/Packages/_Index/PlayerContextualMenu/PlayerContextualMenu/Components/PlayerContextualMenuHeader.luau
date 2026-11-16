local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local UIBlox = require(parent.UIBlox)
local useDesignTokens = Style.useDesignTokens
local PlayerName = UIBlox.App.Indicator.PlayerName
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local v = useDesignTokens(function(p)
		return {
			contextTextSpacing = p.Size.Size_150,
			joinEventSpacing = p.Size.Size_300,
			padding = p.Size.Size_400,
			joinEventButtonHeight = p.Size.Size_1200
		}
	end)

	local function fn()
		if not (props.renderJoinEventButton or props.joinEventText) then
			return nil
		end

		local createElement = React.createElement
		local v2 = {
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local v3 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			JoinEventSpacing = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, v.joinEventSpacing)
			}),
			JoinButton = 0
		}
		local joinButton

		if props.renderJoinEventButton then
			joinButton = props.renderJoinEventButton()
		else
			joinButton = React.createElement(Button, {
				buttonType = ButtonType.PrimaryContextual,
				onActivated = props.joinEventOnActivated,
				isLoading = false,
				size = UDim2.new(1, 0, 0, v.joinEventButtonHeight),
				text = props.joinEventText,
				layoutOrder = 5
			})
		end

		v3.JoinButton = joinButton
		return createElement("Frame", v2, v3)
	end

	local createElement = React.createElement
	local v2 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p)
			props.onHeaderHeightChanged(p.AbsoluteSize.Y)
		end
	}
	local v3 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.padding),
			PaddingBottom = UDim.new(0, v.padding),
			PaddingLeft = UDim.new(0, v.padding),
			PaddingRight = UDim.new(0, v.padding)
		}),
		PlayerName = React.createElement(PlayerName, {
			automaticSize = Enum.AutomaticSize.XY,
			displayNameItem = props.displayNameItem,
			layoutOrder = 1,
			userNameItem = props.userNameItem,
			vendorNameItem = props.vendorNameItem
		}),
		ContextTextSpacing = 0,
		PlayerContext = 0,
		JoinButton = 0
	}
	local contextTextSpacing

	if props.contextText then
		contextTextSpacing = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v.contextTextSpacing)
		})
	end

	v3.ContextTextSpacing = contextTextSpacing
	local playerContext

	if props.contextText then
		playerContext = React.createElement(PlayerContext, {
			icon = props.contextIcon,
			iconColor = props.contextIconColor,
			iconTransparency = props.contextIconTransparency,
			text = props.contextText,
			layoutOrder = 3,
			Selectable = false
		})
	end

	v3.PlayerContext = playerContext

	v3.JoinButton = fn()
	return createElement("Frame", v2, v3)
end
