local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local useGlobalNavProps = require(TenFootUiGlobalNav.Components.GlobalNavContainer.useGlobalNavProps)
local useGlobalNavDisplayOptions = require(TenFootUiGlobalNav.Components.GlobalNavContainer.useGlobalNavDisplayOptions)
local getActiveChildNavigationOptionsRecursively = require(Parent.Navigation).getActiveChildNavigationOptionsRecursively
local GlobalNav = require(TenFootUiGlobalNav.Components.GlobalNav)

local function GlobalNavContainer() -- line: 11
	-- upvalues: useNavigation (copy), useGlobalNavDisplayOptions (copy), getActiveChildNavigationOptionsRecursively (copy), useGlobalNavProps (copy), React (copy), GlobalNav (copy)
	local v10 = useNavigation()
	local v11 = useGlobalNavDisplayOptions(v10, getActiveChildNavigationOptionsRecursively)
	local v12 = useGlobalNavProps(v10, v11)

	return React.createElement(GlobalNav, v12)
end

return GlobalNavContainer
