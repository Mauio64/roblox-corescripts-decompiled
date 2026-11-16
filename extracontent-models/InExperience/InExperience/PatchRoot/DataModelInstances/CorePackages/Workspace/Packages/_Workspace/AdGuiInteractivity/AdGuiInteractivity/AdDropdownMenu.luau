local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable

local RobloxTranslator = require(parent.RobloxTranslator)
local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.WhyThisAd")
local formatByKey2 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.ReportAd")

local iconsactionsinfo = Images["icons/actions/info"]
local iconsactionsfeedback = Images["icons/actions/feedback"]

local Flags = require(script.Parent.Flags)
local v = Flags.GetAdGuiInteractivityPixelsPerStud() / 50

local function applyScalingUDim(udim: UDim) -- 13 equivalent calls inferred from this helper
	return UDim.new(udim.Scale, udim.Offset * v)
end

local function applyScalingUDim2(udim: UDim2) -- 3 equivalent calls inferred from this helper
	return UDim2.new(udim.X.Scale, udim.X.Offset * v, udim.Y.Scale, udim.Y.Offset * v)
end

local function applyScalingNumber(p: number) -- 2 equivalent calls inferred from this helper
	return p * v
end

local function WhyThisAdRow(props)
	return Roact.createElement(Interactable, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = props.onWhyThisAdActivated,
		onStateChanged = function() end
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = applyScalingUDim(UDim.new(0, 10)) -- inferred equivalent call
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = applyScalingUDim(UDim.new(0, 16)), -- inferred equivalent call
			PaddingBottom = applyScalingUDim(UDim.new(0, 8)), -- inferred equivalent call
			PaddingLeft = applyScalingUDim(UDim.new(0, 16)), -- inferred equivalent call
			PaddingRight = applyScalingUDim(UDim.new(0, 48)) -- inferred equivalent call
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = applyScalingUDim(UDim.new(0, 16)) -- inferred equivalent call
		}),
		Icon = Roact.createElement(ImageSetLabel, {
			Image = iconsactionsinfo,
			Size = applyScalingUDim2(UDim2.fromOffset(24, 24)), -- inferred equivalent call
			BackgroundTransparency = 1
		}),
		TextLabel = Roact.createElement("TextLabel", {
			Text = formatByKey,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = applyScalingNumber(24), -- inferred equivalent call
			TextScaled = false,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	})
end

local function ReportAdRow(props)
	return Roact.createElement(Interactable, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = props.onReportAdActivated,
		onStateChanged = function() end
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = applyScalingUDim(UDim.new(0, 10)) -- inferred equivalent call
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = applyScalingUDim(UDim.new(0, 8)), -- inferred equivalent call
			PaddingBottom = applyScalingUDim(UDim.new(0, 16)), -- inferred equivalent call
			PaddingLeft = applyScalingUDim(UDim.new(0, 16)), -- inferred equivalent call
			PaddingRight = applyScalingUDim(UDim.new(0, 48)) -- inferred equivalent call
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = applyScalingUDim(UDim.new(0, 16)) -- inferred equivalent call
		}),
		Icon = Roact.createElement(ImageSetLabel, {
			Image = iconsactionsfeedback,
			Size = applyScalingUDim2(UDim2.fromOffset(24, 24)), -- inferred equivalent call
			BackgroundTransparency = 1
		}),
		TextLabel = Roact.createElement("TextLabel", {
			Text = formatByKey2,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = applyScalingNumber(24), -- inferred equivalent call
			TextScaled = false,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	})
end

function AdDropdownMenu(props)
	return Roact.createElement("Frame", {
		Visible = props.showDropDownMenu,
		Position = props.Position or UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = props.transparency,
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Size = applyScalingUDim2(UDim2.new(0.24, 0, 0.12, 0)), -- inferred equivalent call
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = applyScalingUDim(UDim.new(0, 10)) -- inferred equivalent call
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		WhyThisAdRow(props),
		ReportAdRow(props)
	})
end

return AdDropdownMenu
