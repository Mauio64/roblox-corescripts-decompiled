local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Roact = require(CorePackages.Packages.Roact)
local v8 = Roact.PureComponent:extend("LimitedLabel")
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

function v8.render(p1) -- line: 21
	-- upvalues: Images (copy), Roact (copy), ImageSetLabel (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy), AppFonts (copy)
	local frameSize = p1.props.frameSize
	local framePosition = p1.props.framePosition
	local imageSize = p1.props.imageSize
	local imagePosition = p1.props.imagePosition
	local textSize = p1.props.textSize
	local textPosition = p1.props.textPosition
	local text = p1.props.text
	local v18 = Images["icons/status/item/limited"]

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Size = frameSize,
		Position = framePosition,
		BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		CollectiblesIcon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Visible = true,
			Position = imagePosition,
			Size = imageSize,
			Image = v18
		}),
		CollectiblesText = if not GetFFlagIBEnableCollectiblesSystemSupport() or text then Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextSize = 12,
			Position = textPosition,
			Size = textSize,
			Text = text,
			Font = AppFonts.default:getDefault(),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1, 1, 1)
		}) else nil
	})
end

return v8
