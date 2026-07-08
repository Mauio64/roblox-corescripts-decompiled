local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)

require(Parent.MomentsCommon)

local sampleWindow = require(script.Parent.sampleWindow)
local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")
local defaultConfig = sampleWindow.defaultConfig

local function useVideoScrubPreview(p1, b1: boolean, p2: ((...any) -> ...any)) -- line: 59
	-- upvalues: React (copy), VideoService (copy), sampleWindow (copy), defaultConfig (copy), RunService (copy)
	local v11, v12 = React.useBinding(nil)
	local v13, v14 = React.useBinding(nil)
	local v15, v16 = React.useBinding(true)
	local v17 = React.useRef(nil)
	local v18 = React.useRef(nil)
	local v19, v20 = React.useState(true)
	local v21 = React.useRef(nil)
	local v22 = React.useRef(false)
	local v23 = React.useRef(0)
	local v24 = React.useRef(false)
	local v25 = React.useRef(false)
	local v26 = React.useRef(0)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(false)
	local v29 = React.useRef(0)
	local v30 = React.useRef({})
	local v31 = React.useRef(nil)

	if v31.current == nil then
		v31.current = {
			byTime = {},
			set = {},
			times = {}
		}
	end

	local current = v31.current

	local function rebuildCache() -- line: 89
		-- upvalues: current (copy)
		local t1 = {}
		local t2 = {}

		for v40 in current.byTime do
			t1[v40] = true
			table.insert(t2, v40)
		end

		table.sort(t2)
		current.set = t1
		current.times = t2
	end
	local function getRange() -- line: 103
		-- upvalues: p1 (copy), v23 (copy)
		if p1 ~= nil and p1.region ~= nil then
			return {
				min = p1.region.startTime,
				max = p1.region.endTime
			}
		end

		return {
			min = 0,
			max = v23.current
		}
	end
	local function ensureSampler() -- line: 110
		-- upvalues: v21 (copy), v22 (copy), p1 (copy), v26 (copy), VideoService (copy), v23 (copy)
		if v21.current ~= nil or (v22.current or p1 == nil) then
			return
		end

		v22.current = true

		local current2 = v26.current
		local content = p1.content

		task.spawn(function() -- line: 117
			-- upvalues: VideoService (copy), content (copy), current2 (copy), v26 (copy), v22 (copy), v21 (copy), v23 (copy)
			local ok, result = pcall(function() -- line: 118
				-- upvalues: VideoService (copy), content (copy)
				return VideoService:CreateVideoSamplerAsync(content, {
					Size = Enum.VideoSampleSize.Small
				})
			end)

			if current2 ~= v26.current then
				return
			end

			v22.current = false

			if not ok then
				warn(`[moments] scrub preview sampler failed: { tostring(result) }`)

				return
			end

			v21.current = result
			v23.current = result.TimeLength or 0
		end)
	end
	local function runFetch(t3: {[any]: any}) -- line: 136
		-- upvalues: v24 (copy), v26 (copy), v21 (copy), current (copy), rebuildCache (copy)
		v24.current = true

		local current3 = v26.current

		task.spawn(function() -- line: 139
			-- upvalues: v21 (copy), t3 (copy), current3 (copy), v26 (copy), v24 (copy), current (copy), rebuildCache (copy)
			local current4 = v21.current
			local ok, result = pcall(function() -- line: 141
				-- upvalues: current4 (copy), t3 (copy)
				return current4:GetSamplesAtTimesAsync(t3)
			end)

			if current3 ~= v26.current then
				return
			end

			v24.current = false

			if not ok then
				return
			end

			for v70, v71 in t3 do
				local v72 = result[v70]

				if v72 ~= nil and v72.Image ~= nil then
					current.byTime[v71] = v72.Image
				end
			end

			rebuildCache()
		end)
	end
	local function tick() -- line: 161
		-- upvalues: p2 (copy), getRange (copy), v30 (copy), sampleWindow (copy), defaultConfig (copy), current (copy), rebuildCache (copy), v24 (copy), v21 (copy), v26 (copy), v28 (copy), v15 (copy), v17 (copy), v18 (copy), v29 (copy), v16 (copy), v25 (copy), v20 (copy), v27 (copy), v12 (copy), v14 (copy)
		local v45 = p2()

		if v45 == nil then
			return
		end

		local v46 = getRange()

		if v46.max <= v46.min then
			return
		end

		local v47 = v46.min + v45 * (v46.max - v46.min)
		local elapsed = os.clock()
		local current5 = v30.current

		table.insert(current5, {
			time = elapsed,
			position = v47
		})

		while #current5 > 1 and elapsed - current5[1].time > 0.12 do
			table.remove(current5, 1)
		end

		local v50 = sampleWindow.estimateVelocity(current5)
		local v51 = sampleWindow.planTargets(v47, v50, v46, defaultConfig)
		local v52 = sampleWindow.diff(v51, current.set)

		if #v52.evict > 0 then
			for _, v54 in v52.evict do
				current.byTime[v54] = nil
			end

			rebuildCache()
		end

		if not v24.current and #v52.fetch > 0 and v21.current ~= nil then
			local fetch = v52.fetch

			v24.current = true

			local current6 = v26.current

			task.spawn(function() -- line: 139
				-- upvalues: v21 (copy), fetch (copy), current6 (copy), v26 (copy), v24 (copy), current (copy), rebuildCache (copy)
				local current7 = v21.current
				local ok, result = pcall(function() -- line: 141
					-- upvalues: current7 (copy), fetch (copy)
					return current7:GetSamplesAtTimesAsync(fetch)
				end)

				if current6 ~= v26.current then
					return
				end

				v24.current = false

				if not ok then
					return
				end

				for v76, v77 in fetch do
					local v78 = result[v76]

					if v78 ~= nil and v78.Image ~= nil then
						current.byTime[v77] = v78.Image
					end
				end

				rebuildCache()
			end)
		end

		if v28.current then
			local v57 = not v15:getValue()
			local v58 = if not v57 then v18.current else v17.current
			local v59 = os.clock() - v29.current

			if v58 == nil or v58.IsLoaded or v59 >= 0.2 then
				v16(v57)
				v28.current = false

				if not v25.current then
					v25.current = true
					v20(false)
				end
			end
		end

		local v60 = sampleWindow.selectFrameTime(v47, current.times)
		local v61 = if v60 == nil then nil else current.byTime[v60]

		if v61 ~= nil and v61 ~= v27.current then
			v27.current = v61

			if not v15:getValue() then
				v12(v61)
			else
				v14(v61)
			end

			v29.current = os.clock()
			v28.current = true
		end
	end

	React.useEffect(function() -- line: 231
		-- upvalues: b1 (copy), p1 (copy), v21 (copy), v22 (copy), v26 (copy), VideoService (copy), v23 (copy), v30 (copy), RunService (copy), tick (copy)
		if not b1 or p1 == nil then
			return
		end

		if v21.current == nil and not v22.current and p1 ~= nil then
			v22.current = true

			local current8 = v26.current
			local content = p1.content

			task.spawn(function() -- line: 117
				-- upvalues: VideoService (copy), content (copy), current8 (copy), v26 (copy), v22 (copy), v21 (copy), v23 (copy)
				local ok, result = pcall(function() -- line: 118
					-- upvalues: VideoService (copy), content (copy)
					return VideoService:CreateVideoSamplerAsync(content, {
						Size = Enum.VideoSampleSize.Small
					})
				end)

				if current8 ~= v26.current then
					return
				end

				v22.current = false

				if not ok then
					warn(`[moments] scrub preview sampler failed: { tostring(result) }`)

					return
				end

				v21.current = result
				v23.current = result.TimeLength or 0
			end)
		end

		v30.current = {}

		local connection = RunService.RenderStepped:Connect(tick)

		return function() -- line: 238
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		b1,
		p1
	})
	React.useEffect(function() -- line: 244
		-- upvalues: v26 (copy), v21 (copy), v31 (copy)
		return function() -- line: 245
			-- upvalues: v26 (copy), v21 (copy), v31 (copy)
			local v81 = v26

			v81.current = v81.current + 1

			local current9 = v21.current

			if current9 ~= nil then
				pcall(function() -- line: 249
					-- upvalues: current9 (copy)
					current9:Destroy()
				end)
			end

			v21.current = nil
			v31.current = {
				byTime = {},
				set = {},
				times = {}
			}
		end
	end, {})

	return {
		contentA = v11,
		contentB = v13,
		frontIsA = v15,
		imageARef = v17,
		imageBRef = v18,
		isLoading = v19
	}
end

return useVideoScrubPreview
