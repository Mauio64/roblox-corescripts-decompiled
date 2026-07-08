local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getColorFromUserId = require(CorePackages.Workspace.Packages.SquadsCore.getColorFromUserId)
local useLastActiveParticipant = CrossExperienceVoice.Hooks.useLastActiveParticipant
local useSequentialAnimation = CrossExperienceVoice.Hooks.useSequentialAnimation
local usePrevious = RoactUtils.Hooks.usePrevious
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local v11 = game:DefineFastInt("PartyVoiceTopbarActivityIndicatorAnimationMs", 50)
local v12 = game:DefineFastInt("PartyVoiceTopbarActivityIndicatorDebounceMs", 50)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

function createAnimations(n1: number, n2: number) -- line: 32
	-- upvalues: v11 (copy)
	return {
		ICON_OUT_ANIMATION = {
			value = 0,
			durationInMs = v11,
			easingStyle = Enum.EasingStyle.Linear
		},
		ICON_IN_ANIMATION = {
			value = n1,
			durationInMs = v11,
			easingStyle = Enum.EasingStyle.Linear
		},
		AVATAR_IN_ANIMATION = {
			value = n2,
			durationInMs = v11,
			easingStyle = Enum.EasingStyle.Linear
		},
		AVATAR_OUT_ANIMATION = {
			value = 0,
			durationInMs = v11,
			easingStyle = Enum.EasingStyle.Linear
		}
	}
end
function getDisplayImage(n3: number, s1: string) -- line: 57
	-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy), getColorFromUserId (copy)
	return {
		thumbnail = if n3 == -1 then s1 else getStandardSizeAvatarHeadShotRbxthumb((tostring(n3))),
		backgroundColor = if n3 == -1 then nil else getColorFromUserId(n3)
	}
end
function usePartyIcon(n4: number, n5: number, s2: string) -- line: 64
	-- upvalues: GetFFlagEnableCrossExpVoice (copy), useLastActiveParticipant (copy), usePrevious (copy), React (copy), useSequentialAnimation (copy), CrossExperienceVoice (copy), v12 (copy)
	if GetFFlagEnableCrossExpVoice() then
		local v21 = useLastActiveParticipant()
		local v22 = v21 and v21.userId or -1
		local v23 = usePrevious(v22)
		local v24, v25 = React.useState(getDisplayImage(v22, s2))
		local v26, v27 = useSequentialAnimation(if v22 ~= -1 then n5 else n4)
		local v28 = React.useMemo(function() -- line: 75
			-- upvalues: n4 (copy), n5 (copy)
			return createAnimations(n4, n5)
		end, {
			n4,
			n5
		})
		local v29 = React.useCallback(function(n6: number) -- line: 79
			-- upvalues: v25 (copy), s2 (copy)
			v25(function(p1) -- line: 80
				-- upvalues: n6 (copy), s2 (copy)
				local v35 = getDisplayImage(n6, s2)

				if p1.thumbnail == v35.thumbnail and p1.backgroundColor == v35.backgroundColor then
					return p1
				end

				return v35
			end)
		end, {
			s2,
			v25
		})
		local v30 = React.useMemo(function() -- line: 93
			-- upvalues: CrossExperienceVoice (copy), v27 (copy), v12 (copy)
			return CrossExperienceVoice.Utils.debounce(function(t1: {[any]: any}, p2: ((...any) -> ...any)) -- line: 95
				-- upvalues: v27 (copy)
				v27(t1, p2)
			end, v12)
		end, {})

		React.useEffect(function() -- line: 103
			-- upvalues: v23 (copy), v22 (copy), v30 (copy), v28 (copy), v29 (copy), v27 (copy)
			if v23 ~= nil and v22 ~= v23 then
				v30.cancel()

				if v22 == -1 then
					v30.call({
						v28.AVATAR_OUT_ANIMATION,
						v28.ICON_IN_ANIMATION
					}, function() -- line: 110
						-- upvalues: v29 (copy)
						v29(-1)
					end)

					return
				end

				if v23 == -1 then
					v27({
						v28.ICON_OUT_ANIMATION,
						v28.AVATAR_IN_ANIMATION
					}, function() -- line: 118
						-- upvalues: v29 (copy), v22 (copy)
						v29(v22)
					end)

					return
				end

				v29(v22)

				return
			end

			v29(v22)
		end, {
			v22,
			v29,
			v30,
			v28
		})

		return {
			image = v24,
			size = v26
		}
	end

	local v31, _ = React.createBinding(n4)

	return {
		image = getDisplayImage(-1, s2),
		size = v31
	}
end

return usePartyIcon
