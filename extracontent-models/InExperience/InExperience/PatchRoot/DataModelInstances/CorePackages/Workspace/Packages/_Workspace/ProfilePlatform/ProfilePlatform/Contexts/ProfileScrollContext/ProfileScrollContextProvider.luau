local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useTopBarHeight = RobloxAppHooks.useTopBarHeight

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local FFlagFixCommunityProfileWideCoverLayout = require(ProfilePlatform.Flags.FFlagFixCommunityProfileWideCoverLayout)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileInspectAvatarSlideIn = SharedFlags.FFlagProfileInspectAvatarSlideIn
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInspectAvatarShopChip = SharedFlags2.FFlagProfileInspectAvatarShopChip

local ProfileScrollContext = require(script.Parent.ProfileScrollContext)

return function(p)
	local v = useProfileFormFactor()

	local state, setState = React.useState(v.formFactor == Enums.ProfileFormFactor.PeekView and 0 or 1)
	local setState2, v2

	if FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip then
		local state2
		state2, setState2 = React.useState(false)

		v2 = v.formFactor ~= Enums.ProfileFormFactor.PeekView or (v.isFullView or state2)
	else
		v2 = nil
		setState2 = nil
	end

	local state2, setState3 = React.useState(0)
	local v3 = useTopBarHeight()

	local scrollY = React.useMemo(function()
		local v4

		if FFlagFixCommunityProfileWideCoverLayout then
			v4 = (v.isFullView or v.formFactor == Enums.ProfileFormFactor.Wide) and 0 or v3
		else
			v4 = v.isFullView and 0 or v3
		end

		if v.formFactor == Enums.ProfileFormFactor.PeekView and not v.isFullView then
			v4 += 25
		end

		return (math.max(v4 - state2, 0))
	end, { v3, state2, v })

	local v4 = React.useMemo(function()
		local v4 = {
			scrollY = scrollY,
			setAbsoluteYPosition = setState3,
			peekViewOpenPercent = state,
			setPeekViewOpenPercent = setState,
			isPeekViewFullyOpen = nil,
			setIsPeekViewFullyOpen = nil
		}
		local isPeekViewFullyOpen

		if FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip then
			isPeekViewFullyOpen = v2
		end

		v4.isPeekViewFullyOpen = isPeekViewFullyOpen
		local setIsPeekViewFullyOpen

		if FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip then
			setIsPeekViewFullyOpen = setState2
		end

		v4.setIsPeekViewFullyOpen = setIsPeekViewFullyOpen
		return v4
	end, { scrollY, setState3, state, setState, v2, setState2 })

	return React.createElement(ProfileScrollContext.Provider, { value = v4 }, p.children)
end
