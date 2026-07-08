local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local Colors = require(ParentParent.Colors)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v8 = Roact.PureComponent:extend("Notification")

function v8.render(p1) -- line: 11
	-- upvalues: Roact (copy), Colors (copy), AppFonts (copy), RobloxTranslator (copy)
	local locale = p1.props.locale
	local noticeKey = p1.props.noticeKey

	return Roact.createElement("Frame", {
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -10, 0, 45)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ExclamationPoint = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InspectMenu/ico_alert_tilt.png",
			LayoutOrder = 1,
			Size = UDim2.new(0, 16, 0, 16),
			ImageColor3 = Colors.White
		}),
		PartOfBundleText = Roact.createElement("TextLabel", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = true,
			TextScaled = true,
			TextSize = 12,
			Size = UDim2.new(1, -30, 1, 0),
			TextColor3 = Colors.White,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = AppFonts.default:getDefault(),
			Text = RobloxTranslator:FormatByKeyForLocale(noticeKey, locale)
		}, {
			UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = 16
			})
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2, _) -- line: 54
	return {
		locale = p2.locale
	}
end)(v8)
