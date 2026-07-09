local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Roact = require(CorePackages.Packages.Roact)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local FlexLayout = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.FlexLayout
local Images = UIBlox.App.ImageSet.Images
local v9 = Images["icons/navigation/close"]
local v10 = Images["icons/actions/truncationExpand"]
local RobuxBalance = require(Modules.AvatarExperience.Catalog.Components.RobuxBalance)

return function(p1) -- line: 17
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), FlexLayout (copy), ImageSetButton (copy), v9 (copy), v10 (copy), RobuxBalance (copy)
	local stylePalette = p1.stylePalette
	local showDropDownButton = p1.showDropDownButton
	local navigateBack = p1.navigateBack
	local onCloseButtonPressed = p1.onCloseButtonPressed
	local robuxBalanceRef = p1.robuxBalanceRef
	local v18 = if not FFlagRenameDeprecatedUIBloxTokens then stylePalette.Tokens.Global.Size_400 else stylePalette.Tokens.Size.Size_800
	local v19 = if not FFlagRenameDeprecatedUIBloxTokens then stylePalette.Tokens.Global.Size_400 else stylePalette.Tokens.Size.Size_800
	local v20 = if not FFlagRenameDeprecatedUIBloxTokens then stylePalette.Tokens.Global.Space_200 else stylePalette.Tokens.Size.Size_400

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0)
	}, {
		FlexLayout = Roact.createElement(FlexLayout, {
			flexSlot = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v20)
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v20)
				}),
				CloseButton = not showDropDownButton and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, v18, 0, v19)
				}, {
					CloseButtonIcon = Roact.createElement(ImageSetButton, {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, v19, 0, v19),
						Image = v9,
						ImageColor3 = stylePalette.Theme.SystemPrimaryDefault.Color,
						Position = UDim2.new(0, 0, 0.5, 0),
						[Roact.Event.Activated] = navigateBack
					})
				}) or nil,
				DropDownButton = showDropDownButton and Roact.createElement(ImageSetButton, {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v18, 0, v19),
					Image = v10,
					ImageColor3 = stylePalette.Theme.SystemPrimaryDefault.Color,
					[Roact.Event.Activated] = onCloseButtonPressed
				}) or nil
			}),
			rigidSlot = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, v20)
				}),
				RobuxBalanceContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					RobuxBalance = Roact.createElement(RobuxBalance, {
						[Roact.Ref] = robuxBalanceRef
					})
				})
			}) or nil
		})
	})
end
