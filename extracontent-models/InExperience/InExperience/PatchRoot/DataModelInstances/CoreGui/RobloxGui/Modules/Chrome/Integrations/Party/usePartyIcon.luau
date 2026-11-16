local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local getColorFromUserId = require(CorePackages.Workspace.Packages.SquadsCore.getColorFromUserId)
local useLastActiveParticipant = CrossExperienceVoice.Hooks.useLastActiveParticipant
local useSequentialAnimation = CrossExperienceVoice.Hooks.useSequentialAnimation

local usePrevious = RoactUtils.Hooks.usePrevious

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local defineFastInt = game:DefineFastInt("PartyVoiceTopbarActivityIndicatorAnimationMs", 50)
local defineFastInt2 = game:DefineFastInt("PartyVoiceTopbarActivityIndicatorDebounceMs", 50)

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

function createAnimations(p: number, p2: number)
	return {
		ICON_OUT_ANIMATION = {
			value = 0,
			durationInMs = defineFastInt,
			easingStyle = Enum.EasingStyle.Linear
		},
		ICON_IN_ANIMATION = {
			value = p,
			durationInMs = defineFastInt,
			easingStyle = Enum.EasingStyle.Linear
		},
		AVATAR_IN_ANIMATION = {
			value = p2,
			durationInMs = defineFastInt,
			easingStyle = Enum.EasingStyle.Linear
		},
		AVATAR_OUT_ANIMATION = {
			value = 0,
			durationInMs = defineFastInt,
			easingStyle = Enum.EasingStyle.Linear
		}
	}
end

function getDisplayImage(p: number, thumbnail: string)
	if p ~= -1 then
		thumbnail = getStandardSizeAvatarHeadShotRbxthumb((tostring(p)))
	end

	local backgroundColor

	if p ~= -1 then
		backgroundColor = getColorFromUserId(p)
	end

	return { thumbnail = thumbnail, backgroundColor = backgroundColor }
end

function usePartyIcon(p: number, p2: number, p3: string)
	if not GetFFlagEnableCrossExpVoice() then
		local binding, _ = React.createBinding(p)
		return { image = getDisplayImage(-1, p3), size = binding }
	end

	local v = useLastActiveParticipant()

	local userId = v and v.userId or -1

	local v2 = usePrevious(userId)
	local state, setState = React.useState(getDisplayImage(userId, p3))

	local v3 = if userId == -1 then p else p2
	local size, v4 = useSequentialAnimation(v3)

	local v5 = React.useMemo(function()
		return createAnimations(p, p2)
	end, { p, p2 })

	local v6 = React.useCallback(function(p4: number)
		setState(function(p5)
			local displayImage = getDisplayImage(p4, p3)

			if p5.thumbnail == displayImage.thumbnail and p5.backgroundColor == displayImage.backgroundColor then
				return p5
			end

			return displayImage
		end)
	end, { p3, setState })

	local v7 = React.useMemo(function()
		return CrossExperienceVoice.Utils.debounce(function(p4, callback)
			v4(p4, callback)
		end, defineFastInt2)
	end, {})

	React.useEffect(function()
		if v2 == nil or userId == v2 then
			v6(userId)

			return
		end

		v7.cancel()

		if userId == -1 then
			v7.call({ v5.AVATAR_OUT_ANIMATION, v5.ICON_IN_ANIMATION }, function()
				v6(-1)
			end)
		elseif v2 == -1 then
			v4({ v5.ICON_OUT_ANIMATION, v5.AVATAR_IN_ANIMATION }, function()
				v6(userId)
			end)
		else
			v6(userId)
		end
	end, { userId, v6, v7, v5 })

	return { image = state, size = size }
end

return usePartyIcon
