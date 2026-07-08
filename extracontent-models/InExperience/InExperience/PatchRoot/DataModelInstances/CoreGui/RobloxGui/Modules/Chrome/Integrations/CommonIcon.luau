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
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local UnibarStyle = Chrome2.UnibarStyle

local function isFoundationIconName(p1) -- line: 27
	-- upvalues: IconName (copy)
	return IconName[p1] ~= nil
end

function CommonIconComponent(p2) -- line: 33
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useMappedSignal (copy), useStyle (copy), React (copy), SubMenuContext (copy), IconName (copy), Foundation (copy), IconSize (copy), IconVariant (copy), Images (copy), ImageSetLabel (copy)
	local v21 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_SIZE else UnibarStyle.use().ICON_SIZE
	local v22 = not not p2.activeSignalValue and (useMappedSignal(p2.activeSignalValue) or false)
	local icon = p2.icon

	if v22 and p2.iconOn then
		icon = p2.iconOn
	end

	local v24 = useStyle()
	local v25 = React.useContext(SubMenuContext)
	local IconEmphasisColor = v24.Theme.IconEmphasis.Color
	local IconEmphasisTransparency = v24.Theme.IconEmphasis.Transparency

	if IconName[p2.icon] ~= nil then
		local v28 = if not v25 then {
			Color3 = IconEmphasisColor,
			Transparency = IconEmphasisTransparency
		} else v25:map(function(p3) -- line: 56
			-- upvalues: IconEmphasisColor (copy), IconEmphasisTransparency (copy)
			return {
				Color3 = IconEmphasisColor,
				Transparency = IconEmphasisTransparency + (1 - IconEmphasisTransparency) * (1 - p3)
			}
		end)

		return React.createElement(Foundation.Icon, {
			name = IconName[p2.icon],
			size = IconSize.Large,
			style = v28,
			variant = if not v22 then IconVariant.Regular else IconVariant.Filled
		})
	end

	if typeof(icon) == "string" and icon:sub(1, 11) ~= "rbxasset://" then
		icon = Images[icon]
	end

	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Image = icon,
		Size = UDim2.new(0, v21, 0, v21),
		ImageColor3 = IconEmphasisColor,
		ImageTransparency = if not v25 then IconEmphasisTransparency else v25:map(function(p4) -- line: 87
			-- upvalues: IconEmphasisTransparency (copy)
			return IconEmphasisTransparency + (1 - IconEmphasisTransparency) * (1 - p4)
		end)
	})
end
function CommonIcon(p5, p6, p7) -- line: 94
	-- upvalues: React (copy)
	return React.createElement(CommonIconComponent, {
		icon = p5,
		iconOn = p6,
		activeSignalValue = p7
	})
end

return CommonIcon
