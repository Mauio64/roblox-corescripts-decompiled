local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local getPageMargin = UIBlox.App.Container.getPageMargin
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local Enums = require(ProfilePlatform.Common.Enums)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return function()
	local v

	if FFlagAXEnableProfileTab then
		v = useTokens()
	end

	local v2

	if FFlagAXEnableProfileTab then
		v2 = useIsMeTab()
	end

	local v3

	if FFlagAXEnableProfileTab then
		v3 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	end

	local state, setState = React.useState(24)

	local v4 = React.useCallback(function(p)
		setState((getPageMargin(p.AbsoluteSize.X)))
	end, {})
	local v5

	if FFlagAXEnableProfileTab then
		v5 = if v3 then v.Margin.Large else v.Padding.Large
	end

	if FFlagAXEnableProfileTab then
		if not v2 then
			v5 = state
		end
	else
		v5 = state
	end

	return v5, v4
end
