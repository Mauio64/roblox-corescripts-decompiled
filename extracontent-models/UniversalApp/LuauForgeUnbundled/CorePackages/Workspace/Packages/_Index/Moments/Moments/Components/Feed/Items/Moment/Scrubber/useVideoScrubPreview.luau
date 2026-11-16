local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local sampleWindow = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/sampleWindow")

local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")

local defaultConfig = sampleWindow.defaultConfig

local function useVideoScrubPreview(p2, p3, callback)
	local v5, v6 = React.useBinding(nil)
	local v7, v8 = React.useBinding(nil)
	local v9, v10 = React.useBinding(true)
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
		local v11 = {}

		for k in current.byTime do
			set[k] = true
			table.insert(v11, k)
		end

		table.sort(v11)
		current.set = set
		current.times = v11
	end

	local function getRange()
		if p2 == nil or p2.region == nil then
			return { min = 0, max = ref5.current }
		end

		return { min = p2.region.startTime, max = p2.region.endTime }
	end

	local function ensureSampler()
		if ref3.current ~= nil or ref4.current or p2 == nil then
			return
		end

		ref4.current = true
		local current2 = ref8.current
		local content = p2.content
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

	local function runFetch(items)
		ref6.current = true
		local current2 = ref8.current
		task.spawn(function()
			local current3 = ref3.current
			local success, result = pcall(function()
				return current3:GetSamplesAtTimesAsync(items)
			end)

			if current2 ~= ref8.current then
				return
			end

			ref6.current = false

			if not success then
				return
			end

			for k, item in items do
				local v11 = result[k]

				if v11 ~= nil and v11.Image ~= nil then
					current.byTime[item] = v11.Image
				end
			end

			rebuildCache()
		end)
	end

	local function tick2()
		local v11 = callback()

		if v11 == nil then
			return
		end

		local range = getRange()

		if range.max <= range.min then
			return
		end

		local v12 = range.min + v11 * (range.max - range.min)

		local now = os.clock()
		local current2 = ref12.current
		table.insert(current2, { time = now, position = v12 })

		while #current2 > 1 and now - current2[1].time > 0.12 do
			table.remove(current2, 1)
		end

		local estimateVelocity = sampleWindow.estimateVelocity(current2)

		local planTargets = sampleWindow.planTargets(v12, estimateVelocity, range, defaultConfig)
		local diff = sampleWindow.diff(planTargets, current.set)

		if #diff.evict > 0 then
			for k, v13 in diff.evict do
				current.byTime[v13] = nil
			end

			rebuildCache()
		end

		if not ref6.current and #diff.fetch > 0 and ref3.current ~= nil then
			local fetch = diff.fetch
			ref6.current = true
			local current3 = ref8.current
			task.spawn(function()
				local current4 = ref3.current
				local success, result = pcall(function()
					return current4:GetSamplesAtTimesAsync(fetch)
				end)

				if current3 ~= ref8.current then
					return
				end

				ref6.current = false

				if not success then
					return
				end

				for k, v13 in fetch do
					local v14 = result[k]

					if v14 ~= nil and v14.Image ~= nil then
						current.byTime[v13] = v14.Image
					end
				end

				rebuildCache()
			end)
		end

		if ref10.current then
			local v13 = not v9:getValue()
			local current3 = if v13 then ref.current else ref2.current
			local v14 = os.clock() - ref11.current

			if current3 == nil or current3.IsLoaded or v14 >= 0.2 then
				v10(v13)
				ref10.current = false

				if not ref7.current then
					ref7.current = true
					setState(false)
				end
			end
		end

		local frameTime = sampleWindow.selectFrameTime(v12, current.times)
		local v13 = if frameTime ~= nil then current.byTime[frameTime] else nil

		if v13 ~= nil and v13 ~= ref9.current then
			ref9.current = v13

			if v9:getValue() then
				v8(v13)
			else
				v6(v13)
			end

			ref11.current = os.clock()
			ref10.current = true
		end
	end

	React.useEffect(function()
		if not p3 or p2 == nil then
			return
		end

		if ref3.current == nil and not ref4.current and p2 ~= nil then
			ref4.current = true
			local current2 = ref8.current
			local content = p2.content
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

		ref12.current = {}
		local renderSteppedConnection = RunService.RenderStepped:Connect(tick2)
		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { p3, p2 })

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
		contentA = v5,
		contentB = v7,
		frontIsA = v9,
		imageARef = ref,
		imageBRef = ref2,
		isLoading = state
	}
end

return useVideoScrubPreview
