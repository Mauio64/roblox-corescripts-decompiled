local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local WaveformAudio = require(script.Parent.WaveformAudio)
local useTickClock = require(script.Parent.useTickClock).useTickClock
local BAR_WIDTH = WaveformAudio.BAR_WIDTH
local ITEM_WIDTH = WaveformAudio.ITEM_WIDTH
local RENDER_INTERVAL = WaveformAudio.RENDER_INTERVAL
local t1 = {
	itemIdx = 0,
	height = 0.2,
	age = nil
}

local function Waveform(t2: {[any]: any}) -- line: 66
	-- upvalues: React (copy), ITEM_WIDTH (copy), WaveformAudio (copy), useTickClock (copy), RENDER_INTERVAL (copy), t1 (copy), BAR_WIDTH (copy)
	local v11 = t2.normalize == nil or t2.normalize
	local bindBarStyle = t2.bindBarStyle
	local onSample = t2.onSample
	local v14, v15 = React.useState(0)
	local v16 = (not t2.isActive or not (v14 > 0)) and 0 or math.ceil(v14 / ITEM_WIDTH) + 1
	local v17, v18 = React.useBinding(0)
	local v19, v20 = React.useBinding(0)
	local v21 = WaveformAudio.useAudioAnalyzer(t2.audioDeviceInput)
	local v22 = React.useRef(0)
	local v23 = React.useRef({})

	React.useEffect(function() -- line: 82
		-- upvalues: v23 (copy), v22 (copy), v18 (copy), v20 (copy)
		table.clear(v23.current)
		v22.current = 0
		v18(0)
		v20(0)
	end, {
		t2.isActive,
		v16,
		v18,
		v20
	})
	useTickClock({
		intervalSec = RENDER_INTERVAL,
		enabled = t2.isActive and v16 > 0,
		onTick = function() -- line: 92
			-- upvalues: v17 (copy), WaveformAudio (copy), v21 (copy), v22 (copy), v11 (copy), v23 (copy), v16 (copy), v18 (copy), onSample (copy)
			local v25 = v17:getValue() + 1
			local v26 = 0.2 + WaveformAudio.sampleVolume(v21.current, v22, v11) * 0.8
			local current = v23.current

			current[v25] = {
				height = v26
			}
			current[v25 - v16] = nil
			v18(v25)

			if onSample then
				onSample(v25, v26)
			end
		end,
		onFrame = function(p1) -- line: 108
			-- upvalues: v20 (copy)
			v20(p1)
		end
	})

	local v24 = React.useMemo(function() -- line: 113
		-- upvalues: v23 (copy), v16 (copy), ITEM_WIDTH (copy), v17 (copy), t1 (copy), bindBarStyle (copy), React (copy), v19 (copy), BAR_WIDTH (copy)
		local t3 = {}
		local current = v23.current

		for i = 1, v16 do
			local v32 = v16 - i
			local v33 = (i - 1) * ITEM_WIDTH
			local v34 = v17:map(function(n1: number) -- line: 120
				-- upvalues: v32 (copy), t1 (copy), current (copy)
				local v39 = n1 - v32

				if v39 <= 0 then
					return t1
				end

				local v40 = current[v39]

				if v40 == nil then
					return t1
				end

				return {
					itemIdx = v39,
					height = v40.height,
					age = v32
				}
			end)
			local v35 = bindBarStyle(v34)

			t3["Bar" .. i] = React.createElement("Frame", {
				BorderSizePixel = 0,
				Position = v19:map(function(n2: number) -- line: 139
					-- upvalues: v33 (copy), ITEM_WIDTH (copy)
					return UDim2.new(0, v33 - n2 * ITEM_WIDTH, 0.5, 0)
				end),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = v34:map(function(t4: {[any]: any}) -- line: 143
					-- upvalues: BAR_WIDTH (copy)
					return UDim2.new(0, BAR_WIDTH, t4.height, 0)
				end),
				BackgroundColor3 = v35:map(function(t5: {[any]: any}) -- line: 146
					return t5.color
				end),
				BackgroundTransparency = v35:map(function(t6: {[any]: any}) -- line: 149
					return t6.transparency
				end)
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			})
		end

		return t3
	end, {
		v16,
		v17,
		v19,
		bindBarStyle
	})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		[React.Change.AbsoluteSize] = function(p2) -- line: 165
			-- upvalues: v14 (copy), v15 (copy)
			local AbsoluteSizeX = p2.AbsoluteSize.X

			if AbsoluteSizeX ~= v14 then
				v15(AbsoluteSizeX)
			end
		end
	}, v24)
end

return React.memo(Waveform)
