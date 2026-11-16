local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)

local VideoService = game:GetService("VideoService")

local Full = Enum.VideoSampleSize.Full

local function useVideoPosterFrame(p)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		setState(nil)

		if p == nil then
			return
		end

		local flag = false
		task.spawn(function()
			local v = nil
			local success, result = pcall(function()
				v = VideoService:CreateVideoSamplerAsync(p, { Size = Full })

				return v:GetSamplesAtTimesAsync({ 0 })
			end)

			if v ~= nil then
				pcall(function()
					v:Destroy()
				end)
			end

			if flag then
				return
			end

			local v2

			if success then
				v2 = result[1]
			end

			if v2 ~= nil and v2.Image ~= nil then
				setState(v2.Image)
			end
		end)

		return function()
			flag = true
		end
	end, { p })

	return state
end

return useVideoPosterFrame
