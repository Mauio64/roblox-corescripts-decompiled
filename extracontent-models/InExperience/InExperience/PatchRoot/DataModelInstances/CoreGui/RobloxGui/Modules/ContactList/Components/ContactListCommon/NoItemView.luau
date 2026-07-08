local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local dependencies = require(ContactList.dependencies)
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.Hooks.useLocalization
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local function NoItemView(t1: {[any]: any}) -- line: 29
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), ImageSetLabel (copy), Images (copy)
	local v13 = useStyle()
	local Font = v13.Font
	local Theme = v13.Theme
	local v16 = useLocalization({
		failedLabel = "Feature.Call.Label.Retry",
		placeCallLabel = "Feature.Call.Prompt.StartCall"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 10000,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 20),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		Image = if not t1.isImageEnabled then nil else React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = Images[t1.imageName],
			Size = UDim2.fromOffset(96, 96)
		}),
		Message = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = true,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Font.Body.Font,
			Text = t1.messageText,
			TextColor3 = Theme.TextDefault.Color,
			TextSize = Font.Body.RelativeSize * Font.BaseSize,
			TextTransparency = Theme.TextDefault.Transparency
		}),
		FailedButton = if not t1.isFailedButtonEnabled then nil else React.createElement("TextButton", {
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Theme.SystemPrimaryDefault.Color,
			BackgroundTransparency = Theme.SystemPrimaryDefault.Transparency,
			BorderSizePixel = 0,
			Font = Font.Header2.Font,
			LayoutOrder = 3,
			Text = v16.failedLabel,
			TextColor3 = Theme.SystemPrimaryContent.Color,
			TextSize = Font.Header2.RelativeSize * Font.BaseSize,
			TextTransparency = Theme.SystemPrimaryContent.Transparency,
			[React.Event.Activated] = t1.onFailedButtonActivated
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(108, 36)
			})
		}),
		CallButton = if not t1.isCallButtonEnabled then nil else React.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundColor3 = Theme.SystemPrimaryDefault.Color,
			BackgroundTransparency = Theme.SystemPrimaryDefault.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			[React.Event.Activated] = t1.onCallButtonActivated
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			StartCallIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = "rbxassetid://15239343417",
				LayoutOrder = 1,
				Size = UDim2.fromOffset(24, 24),
				ImageColor3 = Theme.SystemPrimaryContent.Color
			}),
			StartCallButtonText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = Font.Header2.Font,
				Text = v16.placeCallLabel,
				TextColor3 = Theme.SystemPrimaryContent.Color,
				TextSize = Font.Header2.RelativeSize * Font.BaseSize,
				TextTransparency = Theme.SystemPrimaryContent.Transparency
			})
		})
	})
end

return NoItemView
