local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.PureComponent:extend("LimitedLabel")

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

function extended.render(p)
	local frameSize = p.props.frameSize
	local framePosition = p.props.framePosition
	local imageSize = p.props.imageSize
	local imagePosition = p.props.imagePosition
	local textSize = p.props.textSize
	local textPosition = p.props.textPosition
	local text = p.props.text

	local iconsstatusitemlimited = Images["icons/status/item/limited"]

	local createElement = Roact.createElement
	local v = {
		Size = frameSize,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Position = framePosition,
		BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	}
	local v2 = {
		Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		CollectiblesIcon = Roact.createElement(ImageSetLabel, {
			Position = imagePosition,
			Size = imageSize,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Visible = true,
			Image = iconsstatusitemlimited
		}),
		CollectiblesText = 0
	}
	local collectiblesText

	if not (GetFFlagIBEnableCollectiblesSystemSupport() and not text) then
		collectiblesText = Roact.createElement("TextLabel", {
			Position = textPosition,
			Size = textSize,
			BackgroundTransparency = 1,
			Text = text,
			Font = AppFonts.default:getDefault(),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1)
		})
	end

	v2.CollectiblesText = collectiblesText
	return createElement("Frame", v, v2)
end

return extended
