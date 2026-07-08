local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)
local VideoService = game:GetService("VideoService")
local Full = Enum.VideoSampleSize.Full

local function useVideoPosterFrame(p1) -- line: 18
	-- upvalues: React (copy), VideoService (copy), Full (copy)
	local v7, v8 = React.useState(nil)

	React.useEffect(function() -- line: 21
		-- upvalues: v8 (copy), p1 (copy), VideoService (copy), Full (copy)
		v8(nil)

		if p1 == nil then
			return
		end

		local u9 = false

		task.spawn(function() -- line: 28
			-- upvalues: VideoService (copy), p1 (copy), Full (copy), u9 (ref), v8 (copy)
			local u10 = nil
			local ok, result = pcall(function() -- line: 30
				-- upvalues: u10 (ref), VideoService (copy), p1 (copy), Full (copy)
				u10 = VideoService:CreateVideoSamplerAsync(p1, {
					Size = Full
				})

				return u10:GetSamplesAtTimesAsync({ 0 })
			end)

			if u10 ~= nil then
				pcall(function() -- line: 37
					-- upvalues: u10 (ref)
					u10:Destroy()
				end)
			end

			if u9 then
				return
			end

			local v13 = if not ok then nil else result[1]

			if v13 ~= nil and v13.Image ~= nil then
				v8(v13.Image)
			end
		end)

		return function() -- line: 50
			-- upvalues: u9 (ref)
			u9 = true
		end
	end, { p1 })

	return v7
end

return useVideoPosterFrame
