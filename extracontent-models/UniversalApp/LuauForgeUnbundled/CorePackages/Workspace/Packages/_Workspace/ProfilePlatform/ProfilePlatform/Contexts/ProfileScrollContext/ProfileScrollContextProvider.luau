local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useTopBarHeight

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local FFlagFixCommunityProfileWideCoverLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagFixCommunityProfileWideCoverLayout")
local fFlagProfileInspectAvatarSlideIn = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarSlideIn
local fFlagProfileInspectAvatarShopChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarShopChip

local ProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/ProfileScrollContext")

return function(p2)
	local v5 = useProfileFormFactor()

	local state, setState = React.useState(v5.formFactor == Enums.ProfileFormFactor.PeekView and 0 or 1)
	local setState2, v6

	if fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip then
		local state2
		state2, setState2 = React.useState(false)

		v6 = v5.formFactor ~= Enums.ProfileFormFactor.PeekView or (v5.isFullView or state2)
	else
		v6 = nil
		setState2 = nil
	end

	local state2, setState3 = React.useState(0)
	local v7 = useTopBarHeight()

	local v8 = React.useMemo(function()
		local v9

		if FFlagFixCommunityProfileWideCoverLayout then
			v9 = (v5.isFullView or v5.formFactor == Enums.ProfileFormFactor.Wide) and 0 or v7
		else
			v9 = v5.isFullView and 0 or v7
		end

		if v5.formFactor == Enums.ProfileFormFactor.PeekView and not v5.isFullView then
			v9 += 25
		end

		return (math.max(v9 - state2, 0))
	end, { v7, state2, v5 })

	local v9 = React.useMemo(function()
		local v10 = {
			scrollY = v8,
			setAbsoluteYPosition = setState3,
			peekViewOpenPercent = state,
			setPeekViewOpenPercent = setState,
			isPeekViewFullyOpen = nil,
			setIsPeekViewFullyOpen = nil
		}
		local v11 = if fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip then v6 else nil
		v10.isPeekViewFullyOpen = v11
		local v12 = if fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip then setState2 else nil
		v10.setIsPeekViewFullyOpen = v12
		return v10
	end, { v8, setState3, state, setState, v6, setState2 })

	return React.createElement(ProfileScrollContext.Provider, { value = v9 }, p2.children)
end
