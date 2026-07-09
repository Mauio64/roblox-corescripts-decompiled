local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local useTokens = require(ProfilePlatformParent.Foundation).Hooks.useTokens
local getPageMargin = UIBlox.App.Container.getPageMargin
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab

return function() -- line: 16
	-- upvalues: FFlagAXEnableProfileTab (copy), useTokens (copy), useIsMeTab (copy), useProfileFormFactor (copy), Enums (copy), React (copy), getPageMargin (copy)
	local v11 = if not FFlagAXEnableProfileTab then nil else useTokens()
	local v12 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()
	local v13 = if not FFlagAXEnableProfileTab then nil else useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v14, v15 = React.useState(24)
	local v16 = React.useCallback(function(p1) -- line: 25
		-- upvalues: getPageMargin (copy), v15 (copy)
		local v19 = getPageMargin(p1.AbsoluteSize.X)

		v15(v19)
	end, {})
	local v17 = if not FFlagAXEnableProfileTab then nil else if not v13 then v11.Padding.Large else v11.Margin.Large

	return if not FFlagAXEnableProfileTab or not v12 then v14 else v17, v16
end
