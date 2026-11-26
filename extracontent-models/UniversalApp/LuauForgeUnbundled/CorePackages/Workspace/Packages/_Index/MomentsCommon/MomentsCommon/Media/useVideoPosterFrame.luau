local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local VideoService = game:GetService("VideoService")

local full = Enum.VideoSampleSize.Full

local function useVideoPosterFrame(p2)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		setState(nil)

		if p2 == nil then
			return
		end

		local flag = false
		task.spawn(function()
			local v5 = nil
			local success, result = pcall(function()
				v5 = VideoService:CreateVideoSamplerAsync(p2, { Size = full })

				return v5:GetSamplesAtTimesAsync({ 0 })
			end)

			if v5 ~= nil then
				pcall(function()
					v5:Destroy()
				end)
			end

			if flag then
				return
			end

			local v6 = if success then result[1] else nil

			if v6 ~= nil and v6.Image ~= nil then
				setState(v6.Image)
			end
		end)

		return function()
			flag = true
		end
	end, { p2 })

	return state
end

return useVideoPosterFrame
