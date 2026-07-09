local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local isAppNavEnabled = require(Parent.SharedFlags).isAppNavEnabled
local GlobalNav = require(script.GlobalNav)
local GlobalNavAppHeaderBar = require(script.GlobalNavAppHeaderBar)

if isAppNavEnabled() then
	return GlobalNavAppHeaderBar
end

return GlobalNav
