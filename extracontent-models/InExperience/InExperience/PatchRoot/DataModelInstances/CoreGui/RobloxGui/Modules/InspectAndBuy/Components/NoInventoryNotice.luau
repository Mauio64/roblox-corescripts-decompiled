local CorePackages = game:GetService("CorePackages")
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Colors = require(parent.Colors)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local extended = Roact.PureComponent:extend("NoInventoryNotice")

function extended.render(p)
	local locale = p.props.locale
	local assets = p.props.assets
	local visible = p.props.isLoaded

	local createElement = Roact.createElement
	local v = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = 0 }

	if next(assets) ~= nil then
		visible = false
	end

	v.Visible = visible
	return createElement("Frame", v, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 15),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		NotWearingImage = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.25, 0, 0.25, 0),
			LayoutOrder = 1,
			Image = "rbxasset://textures/ui/InspectMenu/ico_isnt-wearing.png",
			ImageColor3 = Colors.White
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		}),
		NotWearingText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.8, 0, 0.3, 0),
			LayoutOrder = 2,
			Font = AppFonts.default:getDefault(),
			Text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Description.NoInventoryNotice", locale),
			TextScaled = true,
			TextColor3 = Colors.White,
			TextSize = 20,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true
		}, {
			UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", { MaxTextSize = 20 })
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return { assets = data.assets, locale = data.locale, isLoaded = data.isLoaded }
end)(extended)
