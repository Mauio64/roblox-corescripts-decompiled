local function sampleVideoFrames(p1, n1: number, p2: ((...any) -> ...any)) -- line: 17
	task.spawn(function() -- line: 18
		-- upvalues: p1 (copy), n1 (copy), p2 (copy)
		local ok, result = pcall(function() -- line: 19
			-- upvalues: p1 (copy), n1 (copy)
			local v7 = game:GetService("VideoService"):CreateVideoSamplerAsync(p1)
			local t1 = {}

			for i = 0, math.floor(n1) - 1 do
				table.insert(t1, i)
			end

			return v7:GetSamplesAtTimesAsync(t1)
		end)

		if ok then
			p2(result)

			return
		end

		p2({})
	end)
end

return sampleVideoFrames
