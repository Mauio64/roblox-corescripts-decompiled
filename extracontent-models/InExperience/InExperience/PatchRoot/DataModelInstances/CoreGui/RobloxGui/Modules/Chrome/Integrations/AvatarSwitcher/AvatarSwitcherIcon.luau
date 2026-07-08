local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

require(Chrome.ChromeShared.Service.ChromeUtils)

local useMappedSignal = require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)

local function AvatarSwitcherIcon(t1: {[any]: any}) -- line: 20
	-- upvalues: useMappedSignal (copy), React (copy), SubMenuContext (copy), useTokens (copy), Foundation (copy), IconName (copy), IconSize (copy), IconVariant (copy)
	local v13 = useMappedSignal(t1.isActive)
	local v14 = React.useContext(SubMenuContext)
	local v15 = useTokens()
	local v16 = if not v14 then v15.Color.Content.Default else v14:map(function(p1) -- line: 26
		-- upvalues: v15 (copy)
		return {
			Color3 = v15.Color.Content.Default.Color3,
			Transparency = math.lerp(1, v15.Color.Content.Default.Transparency, p1)
		}
	end)

	return React.createElement(Foundation.Icon, {
		name = IconName.CirclePerson,
		size = IconSize.Large,
		variant = if not v13 then IconVariant.Regular else IconVariant.Filled,
		style = v16
	})
end

return AvatarSwitcherIcon
