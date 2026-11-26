local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local sampleMomentShareCardVideoFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/sampleMomentShareCardVideoFrame")

local function useMomentShareCardVideoFrame(p2)
	local state, setState = React.useState(function(): nil
		return nil
	end)

	React.useEffect(function()
		setState(nil)

		if p2 == nil then
			return
		end

		local v5 = false
		task.spawn(function()
			local v6 = sampleMomentShareCardVideoFrame(p2)

			if not v5 and v6 ~= nil then
				setState(v6)
			end
		end)

		return function()
			v5 = true
		end
	end, { p2 })

	return state
end

return useMomentShareCardVideoFrame
