local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
require(parent.MomentsCommon)

local sampleWindow = require(script.Parent.sampleWindow)

local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")

local defaultConfig = sampleWindow.defaultConfig

local function useVideoScrubPreview(p, flag: boolean, callback)
	local contentA, v = React.useBinding(nil)
	local contentB, v2 = React.useBinding(nil)
	local frontIsA, v3 = React.useBinding(true)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(true)

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(false)
	local ref7 = React.useRef(false)
	local ref8 = React.useRef(0)
	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(false)
	local ref11 = React.useRef(0)
	local ref12 = React.useRef({})

	local ref13 = React.useRef(nil)

	if ref13.current == nil then
		ref13.current = { byTime = {}, set = {}, times = {} }
	end

	local current = ref13.current

	local function rebuildCache()
		local set = {}
		local times = {}

		for k in current.byTime do
			set[k] = true
			table.insert(times, k)
		end

		table.sort(times)
		current.set = set
		current.times = times
	end

	local function getRange()
		if p == nil or p.region == nil then
			return { min = 0, max = ref5.current }
		end

		return { min = p.region.startTime, max = p.region.endTime }
	end

	local function ensureSampler() -- 1 equivalent call inferred from this helper
		if ref3.current ~= nil or ref4.current or p == nil then
			return
		end

		ref4.current = true
		local current2 = ref8.current
		local content = p.content
		task.spawn(function()
			local success, result = pcall(function()
				return VideoService:CreateVideoSamplerAsync(content, {
					Size = Enum.VideoSampleSize.Small
				})
			end)

			if current2 ~= ref8.current then
				return
			end

			ref4.current = false

			if not success then
				warn(`[moments] scrub preview sampler failed: {tostring(result)}`)
				return
			end

			ref3.current = result
			ref5.current = result.TimeLength or 0
		end)
	end

	local function runFetch(fetch) -- 1 equivalent call inferred from this helper
		ref6.current = true
		local current2 = ref8.current
		task.spawn(function()
			local current3 = ref3.current
			local success, result = pcall(function()
				return current3:GetSamplesAtTimesAsync(fetch)
			end)

			if current2 ~= ref8.current then
				return
			end

			ref6.current = false

			if not success then
				return
			end

			for k, item in fetch do
				local v4 = result[k]

				if v4 ~= nil and v4.Image ~= nil then
					current.byTime[item] = v4.Image
				end
			end

			rebuildCache()
		end)
	end

	local function tick()
		local v4 = callback()

		if v4 == nil then
			return
		end

		local range = getRange()

		if range.max <= range.min then
			return
		end

		local position = range.min + v4 * (range.max - range.min)

		local now = os.clock()
		local current2 = ref12.current
		table.insert(current2, { time = now, position = position })

		while #current2 > 1 and now - current2[1].time > 0.12 do
			table.remove(current2, 1)
		end

		local estimateVelocity = sampleWindow.estimateVelocity(current2)

		local planTargets = sampleWindow.planTargets(position, estimateVelocity, range, defaultConfig)
		local diff = sampleWindow.diff(planTargets, current.set)

		if #diff.evict > 0 then
			for _, v5 in diff.evict do
				current.byTime[v5] = nil
			end

			rebuildCache()
		end

		if not ref6.current and #diff.fetch > 0 and ref3.current ~= nil then
			runFetch(diff.fetch) -- inferred equivalent call
		end

		if ref10.current then
			local v5 = not frontIsA:getValue()
			local current3 = if v5 then ref.current else ref2.current
			local v6 = os.clock() - ref11.current

			if current3 == nil or current3.IsLoaded or v6 >= 0.2 then
				v3(v5)
				ref10.current = false

				if not ref7.current then
					ref7.current = true
					setState(false)
				end
			end
		end

		local frameTime = sampleWindow.selectFrameTime(position, current.times)
		local current3

		if frameTime ~= nil then
			current3 = current.byTime[frameTime]
		end

		if current3 ~= nil and current3 ~= ref9.current then
			ref9.current = current3

			if frontIsA:getValue() then
				v2(current3)
			else
				v(current3)
			end

			ref11.current = os.clock()
			ref10.current = true
		end
	end

	React.useEffect(function()
		if not flag or p == nil then
			return
		end

		ensureSampler() -- inferred equivalent call
		ref12.current = {}
		local renderSteppedConnection = RunService.RenderStepped:Connect(tick)
		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { flag, p })

	React.useEffect(function()
		return function()
			ref8.current += 1
			local current2 = ref3.current

			if current2 ~= nil then
				pcall(function()
					current2:Destroy()
				end)
			end

			ref3.current = nil
			ref13.current = { byTime = {}, set = {}, times = {} }
		end
	end, {})

	return {
		contentA = contentA,
		contentB = contentB,
		frontIsA = frontIsA,
		imageARef = ref,
		imageBRef = ref2,
		isLoading = state
	}
end

return useVideoScrubPreview
