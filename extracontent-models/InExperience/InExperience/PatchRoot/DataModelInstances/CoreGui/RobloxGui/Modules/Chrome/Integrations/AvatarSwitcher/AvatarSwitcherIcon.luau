local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

require(Chrome.ChromeShared.Service.ChromeUtils)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)

local function AvatarSwitcherIcon(p)
	local v = useMappedSignal(p.isActive)
	local v2 = React.useContext(SubMenuContext)
	local v3 = useTokens()
	local style

	if v2 then
		style = v2:map(function(p2)
			return {
				Color3 = v3.Color.Content.Default.Color3,
				Transparency = math.lerp(1, v3.Color.Content.Default.Transparency, p2)
			}
		end)
	else
		style = v3.Color.Content.Default
	end

	local createElement = React.createElement
	local icon = Foundation.Icon
	local v4 = { name = IconName.CirclePerson, size = IconSize.Large, variant = 0, style = 0 }
	local variant

	if v then
		variant = IconVariant.Filled
	else
		variant = IconVariant.Regular
	end

	v4.variant = variant
	v4.style = style
	return createElement(icon, v4)
end

return AvatarSwitcherIcon
