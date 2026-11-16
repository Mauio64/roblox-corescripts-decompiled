local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

require(MomentsCommon.Media.MediaTypes)

local function useHasPresentedFrame(p, flag: boolean?)
	local state, setState = React.useState(false)
	React.useEffect(function()
		if not flag or p == nil then
			return
		end

		setState(false)
		local v = false
		local v2 = nil
		v2 = Signals.createEffect(function(p2)
			if p.getPosition(p2) > 0 and not v then
				v = true
				setState(true)

				task.defer(function()
					if v2 ~= nil then
						v2()
					end
				end)
			end
		end)
		return function()
			v = true

			if v2 ~= nil then
				v2()
			end
		end
	end, { p, flag })
	return state
end

return useHasPresentedFrame
