local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local videoPlaybackCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/VideoUtils").VideoPlaybackCoordinator

local observeGuiOnScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/observeGuiOnScreen")

local function useAvatarMomentFramerateHold(p2)
	local v5 = React.useMemo(function()
		local v6 = videoPlaybackCoordinator.new()
		local v7 = false
		local v8 = false
		local v9 = nil

		local function setShown(p3)
			v7 = p3
			local current = v7 and p2.current

			if current == v8 then
				return
			end

			v8 = current

			if current then
				v6:requestPlayback("AvatarMomentScene", false, 0)
			else
				v6:cancelPlayback("AvatarMomentScene", "AvatarMomentSceneStopped")
			end
		end

		return {
			setShown = setShown,
			trackPage = function(p3)
				if v9 ~= nil then
					v9()
					v9 = nil
					v7 = false
					local current = v7 and p2.current

					if current ~= v8 then
						v8 = current

						if current then
							v6:requestPlayback("AvatarMomentScene", false, 0)
						else
							v6:cancelPlayback("AvatarMomentScene", "AvatarMomentSceneStopped")
						end
					end
				end

				v9 = observeGuiOnScreen(p3, setShown)
			end,
			untrackPage = function()
				if v9 == nil then
					return
				end

				v9()
				v9 = nil
				v7 = false
				local current = v7 and p2.current

				if current == v8 then
					return
				end

				v8 = current

				if current then
					v6:requestPlayback("AvatarMomentScene", false, 0)
				else
					v6:cancelPlayback("AvatarMomentScene", "AvatarMomentSceneStopped")
				end
			end,
			refresh = function()
				local current = v7 and p2.current

				if current == v8 then
					return
				end

				v8 = current

				if current then
					v6:requestPlayback("AvatarMomentScene", false, 0)
				else
					v6:cancelPlayback("AvatarMomentScene", "AvatarMomentSceneStopped")
				end
			end
		}
	end, { p2 })

	React.useEffect(function()
		return function()
			v5.untrackPage()
			v5.setShown(false)
		end
	end, { v5 })

	return v5
end

return useAvatarMomentFramerateHold
