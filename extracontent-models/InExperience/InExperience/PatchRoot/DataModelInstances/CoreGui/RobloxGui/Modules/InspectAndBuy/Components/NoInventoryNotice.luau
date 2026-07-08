local CorePackages = game:GetService("CorePackages")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Colors = require(ParentParent.Colors)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v8 = Roact.PureComponent:extend("NoInventoryNotice")

function v8.render(p1) -- line: 13
	-- upvalues: Roact (copy), Colors (copy), AppFonts (copy), RobloxTranslator (copy)
	local locale = p1.props.locale
	local assets = p1.props.assets
	local isLoaded = p1.props.isLoaded

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = next(assets) == nil and isLoaded
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 15),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		NotWearingImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = "rbxasset://textures/ui/InspectMenu/ico_isnt-wearing.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0.25, 0, 0.25, 0),
			ImageColor3 = Colors.White
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		}),
		NotWearingText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextScaled = true,
			TextSize = 20,
			TextWrapped = true,
			Size = UDim2.new(0.8, 0, 0.3, 0),
			Font = AppFonts.default:getDefault(),
			Text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Description.NoInventoryNotice", locale),
			TextColor3 = Colors.White,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top
		}, {
			UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = 20
			})
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2, _) -- line: 62
	return {
		assets = p2.assets,
		locale = p2.locale,
		isLoaded = p2.isLoaded
	}
end)(v8)
