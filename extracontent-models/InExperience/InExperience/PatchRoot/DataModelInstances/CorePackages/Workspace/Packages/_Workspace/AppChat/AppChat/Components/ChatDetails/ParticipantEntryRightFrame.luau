local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local memo = React.memo
local UIBlox = require(AppChatParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local Label = require(AppChat.Components.Label.Label)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local getFFlagAppChatParticipantDialogFoundationMenu = require(AppChat.Flags.getFFlagAppChatParticipantDialogFoundationMenu)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local t1 = {
	shouldShowDots = false,
	dotsSize = UDim2.new(0, 36, 0, 36),
	image = Images["icons/common/more"],
	onDotsActivated = function() -- line: 42
	end
}

function ParticipantEntryRightFrame(t2: {[any]: any}) -- line: 48
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), getFFlagAppChatParticipantDialogFoundationMenu (copy), React (copy), Label (copy), IconButton (copy), IconName (copy), FFlagDebugAppChatEnableDomLocators (copy), IconSize (copy), ButtonVariant (copy), ImageSetLabel (copy)
	local v20 = Cryo.Dictionary.join(t1, t2)
	local v21 = useStyle()
	local v22 = v20.style or v21
	local v23 = getFFlagAppChatParticipantDialogFoundationMenu()

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		[React.Change.AbsoluteSize] = v20[React.Change.AbsoluteSize]
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 22),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 22),
			PaddingRight = UDim.new(0, 22)
		}),
		label = if not v20.labelText then nil else React.createElement(Label, {
			layoutOrder = 1,
			backgroundColor3 = v22.Theme.BackgroundContrast.Color,
			backgroundTransparency = v22.Theme.BackgroundContrast.Transparency,
			bodyText = v20.labelText
		}),
		dots = if not v20.shouldShowDots then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Name = "dots",
			Size = UDim2.new(0, 20, 1, 0)
		}, {
			Dots = if not v23 then React.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = v20.image,
				ImageColor3 = v20.imageColor3 or v22.Theme.IconEmphasis.Color,
				ImageTransparency = v20.imageTransparency or v22.Theme.IconEmphasis.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(0, 36, 0, 36),
				[React.Tag] = if not FFlagDebugAppChatEnableDomLocators or not t2.testId then nil else `data-testid={ t2.testId }`
			}) else React.createElement(IconButton, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				icon = IconName.ThreeDotsHorizontal,
				onActivated = v20.onDotsActivated,
				Position = UDim2.fromScale(0.5, 0.5),
				ref = v20.dotsRef,
				Size = UDim2.new(0, 36, 0, 36),
				testId = if not FFlagDebugAppChatEnableDomLocators then nil else v20.testId,
				size = IconSize.Medium,
				variant = ButtonVariant.Utility
			})
		})
	})
end

return memo(ParticipantEntryRightFrame)
