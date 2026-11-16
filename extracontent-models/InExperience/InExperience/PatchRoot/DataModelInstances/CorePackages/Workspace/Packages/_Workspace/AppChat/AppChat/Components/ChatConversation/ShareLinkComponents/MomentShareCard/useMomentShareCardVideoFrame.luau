local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

local sampleMomentShareCardVideoFrame = require(script.Parent.sampleMomentShareCardVideoFrame)

local function useMomentShareCardVideoFrame(p)
	local state, setState = React.useState(function(): nil
		return nil
	end)

	React.useEffect(function()
		setState(nil)

		if p == nil then
			return
		end

		local v = false
		task.spawn(function()
			local v2 = sampleMomentShareCardVideoFrame(p)

			if not v and v2 ~= nil then
				setState(v2)
			end
		end)

		return function()
			v = true
		end
	end, { p })

	return state
end

return useMomentShareCardVideoFrame
