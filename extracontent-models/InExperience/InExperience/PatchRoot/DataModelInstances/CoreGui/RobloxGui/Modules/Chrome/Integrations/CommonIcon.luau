local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
require(Chrome.ChromeShared.Service.ChromeUtils)
local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local UnibarStyle = Chrome2.UnibarStyle

local function isFoundationIconName(icon): boolean -- 1 equivalent call inferred from this helper
	return IconName[icon] ~= nil
end

function CommonIconComponent(props)
	local ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_SIZE = UnibarStyle.use().ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
	end

	local v

	if props.activeSignalValue then
		v = useMappedSignal(props.activeSignalValue) or false
	else
		v = false
	end

	local image = props.icon

	if v and props.iconOn then
		image = props.iconOn
	end

	local v2 = useStyle()
	local v3 = React.useContext(SubMenuContext)
	local color = v2.Theme.IconEmphasis.Color
	local transparency = v2.Theme.IconEmphasis.Transparency

	if isFoundationIconName(props.icon) then -- inferred equivalent call
		local style = not v3 and { Color3 = color, Transparency = transparency } or v3:map(function(p)
			return {
				Color3 = color,
				Transparency = transparency + (1 - transparency) * (1 - p)
			}
		end)

		local createElement = React.createElement
		local icon = Foundation.Icon
		local v4 = {
			name = IconName[props.icon],
			size = IconSize.Large,
			style = style,
			variant = 0
		}
		local variant

		if v then
			variant = IconVariant.Filled
		else
			variant = IconVariant.Regular
		end

		v4.variant = variant
		return createElement(icon, v4)
	else
		if typeof(image) == "string" and image:sub(1, 11) ~= "rbxasset://" then
			image = Images[image]
		end

		local createElement = React.createElement
		local v4 = {
			BackgroundTransparency = 1,
			Image = image,
			Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
			ImageColor3 = color,
			ImageTransparency = 0
		}
		local imageTransparency

		if v3 then
			imageTransparency = v3:map(function(p)
				return transparency + (1 - transparency) * (1 - p)
			end)
		else
			imageTransparency = transparency
		end

		v4.ImageTransparency = imageTransparency
		return createElement(ImageSetLabel, v4)
	end
end

function CommonIcon(icon, iconOn, activeSignalValue)
	return React.createElement(CommonIconComponent, {
		icon = icon,
		iconOn = iconOn,
		activeSignalValue = activeSignalValue
	})
end

return CommonIcon
