local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Hooks.useTokens
local getPageMargin = UIBlox.App.Container.getPageMargin
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useIsMeTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsMeTab")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab

return function()
	local v5 = if fFlagAXEnableProfileTab then useTokens() else nil
	local v6 = if fFlagAXEnableProfileTab then useIsMeTab() else nil
	local v7

	if fFlagAXEnableProfileTab then
		v7 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	end

	local state, setState = React.useState(24)

	local v8 = React.useCallback(function(p2)
		setState((getPageMargin(p2.AbsoluteSize.X)))
	end, {})
	local v9

	if fFlagAXEnableProfileTab then
		v9 = if v7 then v5.Margin.Large else v5.Padding.Large
	end

	if fFlagAXEnableProfileTab then
		if not v6 then
			v9 = state
		end
	else
		v9 = state
	end

	return v9, v8
end
