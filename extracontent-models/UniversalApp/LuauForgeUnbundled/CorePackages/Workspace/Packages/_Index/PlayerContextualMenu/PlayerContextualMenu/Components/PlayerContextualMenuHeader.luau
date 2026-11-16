local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Style")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/UIBlox")
local useDesignTokens = Style.useDesignTokens
local playerName = UIBlox.App.Indicator.PlayerName
local playerContext = UIBlox.App.Indicator.PlayerContext
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local v5 = useDesignTokens(function(p2)
		return {
			contextTextSpacing = p2.Size.Size_150,
			joinEventSpacing = p2.Size.Size_300,
			padding = p2.Size.Size_400,
			joinEventButtonHeight = p2.Size.Size_1200
		}
	end)

	local function fn()
		if not (props.renderJoinEventButton or props.joinEventText) then
			return nil
		end

		local createElement = React.createElement
		local v7 = {
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local v8 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			JoinEventSpacing = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, v5.joinEventSpacing)
			}),
			JoinButton = 0
		}

		local v9 = if props.renderJoinEventButton then props.renderJoinEventButton() else React.createElement(button, {
			buttonType = buttonType.PrimaryContextual,
			onActivated = props.joinEventOnActivated,
			isLoading = false,
			size = UDim2.new(1, 0, 0, v5.joinEventButtonHeight),
			text = props.joinEventText,
			layoutOrder = 5
		})
		v8.JoinButton = v9
		return createElement("Frame", v7, v8)
	end

	local createElement = React.createElement
	local v7 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p2)
			props.onHeaderHeightChanged(p2.AbsoluteSize.Y)
		end
	}
	local v8 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.padding),
			PaddingBottom = UDim.new(0, v5.padding),
			PaddingLeft = UDim.new(0, v5.padding),
			PaddingRight = UDim.new(0, v5.padding)
		}),
		PlayerName = React.createElement(playerName, {
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

	local v9 = if props.contextText then React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v5.contextTextSpacing)
	}) else nil
	v8.ContextTextSpacing = v9

	local v10 = if props.contextText then React.createElement(playerContext, {
		icon = props.contextIcon,
		iconColor = props.contextIconColor,
		iconTransparency = props.contextIconTransparency,
		text = props.contextText,
		layoutOrder = 3,
		Selectable = false
	}) else nil
	v8.PlayerContext = v10

	v8.JoinButton = fn()
	return createElement("Frame", v7, v8)
end
