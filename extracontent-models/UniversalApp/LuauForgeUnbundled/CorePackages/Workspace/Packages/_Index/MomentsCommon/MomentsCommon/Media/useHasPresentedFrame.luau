local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")

local function useHasPresentedFrame(p2, p3)
	local state, setState = React.useState(false)
	React.useEffect(function()
		if not p3 or p2 == nil then
			return
		end

		setState(false)
		local v5 = false
		local v6 = nil
		v6 = Signals.createEffect(function(p4)
			if p2.getPosition(p4) > 0 and not v5 then
				v5 = true
				setState(true)

				task.defer(function()
					if v6 ~= nil then
						v6()
					end
				end)
			end
		end)
		return function()
			v5 = true

			if v6 ~= nil then
				v6()
			end
		end
	end, { p2, p3 })
	return state
end

return useHasPresentedFrame
