local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local VideoUtils = require(parent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator

local observeGuiOnScreen = require(script.Parent.observeGuiOnScreen)

local function useAvatarMomentFramerateHold(p)
	local v = React.useMemo(function()
		local v = VideoPlaybackCoordinator.new()
		local v2 = false
		local v3 = false
		local v4 = nil

		local function refresh() -- 1 equivalent call inferred from this helper
			local current = v2 and p.current

			if current == v3 then
				return
			end

			v3 = current

			if current then
				v:requestPlayback("AvatarMomentScene", false, 0)
			else
				v:cancelPlayback("AvatarMomentScene", "AvatarMomentSceneStopped")
			end
		end

		local function setShown(flag: boolean) -- 1 equivalent call inferred from this helper
			v2 = flag
			refresh() -- inferred equivalent call
		end

		local function untrackPage() -- 1 equivalent call inferred from this helper
			if v4 == nil then
				return
			end

			v4()
			v4 = nil
			setShown(false) -- inferred equivalent call
		end

		return {
			setShown = setShown,
			trackPage = function(p2)
				untrackPage() -- inferred equivalent call
				v4 = observeGuiOnScreen(p2, setShown)
			end,
			untrackPage = untrackPage,
			refresh = refresh
		}
	end, { p })

	React.useEffect(function()
		return function()
			v.untrackPage()
			v.setShown(false)
		end
	end, { v })

	return v
end

return useAvatarMomentFramerateHold
