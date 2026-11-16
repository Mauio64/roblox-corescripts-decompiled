local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)

local Roact = require(CorePackages.Packages.Roact)
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local flexLayout = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.FlexLayout
local images = UIBlox.App.ImageSet.Images

local iconsnavigationclose = images["icons/navigation/close"]
local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]

local module = require("@luauforge/deferred/gma")

return function(props)
	local stylePalette = props.stylePalette
	local showDropDownButton = props.showDropDownButton
	local navigateBack = props.navigateBack
	local onCloseButtonPressed = props.onCloseButtonPressed
	local robuxBalanceRef = props.robuxBalanceRef

	local size_800 = stylePalette.Tokens.Size.Size_800
	local size_800_2 = stylePalette.Tokens.Size.Size_800
	local size_400 = stylePalette.Tokens.Size.Size_400

	local createElement = Roact.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0)
	}

	local createElement2 = Roact.createElement
	local createElement3 = Roact.createElement
	local v11 = {
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local v12 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_400)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_400)
		}),
		CloseButton = 0,
		DropDownButton = 0
	}
	local v13

	if not showDropDownButton then
		v13 = Roact.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, size_800, 0, size_800_2)
				},
				{
					CloseButtonIcon = Roact.createElement(imageSetButton, {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, size_800_2, 0, size_800_2),
						Image = iconsnavigationclose,
						ImageColor3 = stylePalette.Theme.SystemPrimaryDefault.Color,
						Position = UDim2.new(0, 0, 0.5, 0),
						[Roact.Event.Activated] = navigateBack
					})
				}
			)
			or nil
	end

	v12.CloseButton = v13
	local v14

	if showDropDownButton then
		local createElement4 = Roact.createElement
		local onCloseButtonPressedsByActivated = {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, size_800, 0, size_800_2),
			Image = iconsactionstruncationExpand,
			ImageColor3 = stylePalette.Theme.SystemPrimaryDefault.Color,
			[Roact.Event.Activated] = onCloseButtonPressed
		}
		v14 = createElement4(imageSetButton, onCloseButtonPressedsByActivated) or nil
	end

	v12.DropDownButton = v14
	return createElement("Frame", v6, {
		FlexLayout = createElement2(flexLayout, {
			flexSlot = createElement3("Frame", v11, v12),
			rigidSlot = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY
				},
				{
					UIPadding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, size_400)
					}),
					RobuxBalanceContainer = Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						RobuxBalance = Roact.createElement(module, {
							[Roact.Ref] = robuxBalanceRef
						})
					})
				}
			) or nil
		})
	})
end
