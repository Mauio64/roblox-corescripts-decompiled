local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)

require(MomentsCommon.Media.MediaTypes)

local function useHasPresentedFrame(p1, b1: boolean?) -- line: 19
	-- upvalues: React (copy), Signals (copy)
	local v8, v9 = React.useState(false)

	React.useEffect(function() -- line: 21
		-- upvalues: b1 (copy), p1 (copy), v9 (copy), Signals (copy)
		if not b1 or p1 == nil then
			return
		end

		v9(false)

		local u10 = false
		local u11 = nil

		u11 = Signals.createEffect(function(p2) -- line: 28
			-- upvalues: p1 (copy), u10 (ref), v9 (copy), u11 (ref)
			if p1.getPosition(p2) > 0 and not u10 then
				u10 = true
				v9(true)
				task.defer(function() -- line: 33
					-- upvalues: u11 (ref)
					if u11 ~= nil then
						u11()
					end
				end)
			end
		end)

		return function() -- line: 40
			-- upvalues: u10 (ref), u11 (ref)
			u10 = true

			if u11 ~= nil then
				u11()
			end
		end
	end, {
		p1,
		b1
	})

	return v8
end

return useHasPresentedFrame
