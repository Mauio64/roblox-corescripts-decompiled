local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)

local defineFastFlag = game:DefineFastFlag("ExpChatWaveformStaleWidthFix", false)

local WaveformAudio = require(script.Parent.WaveformAudio)
local useTickClock = require(script.Parent.useTickClock)
local useTickClock2 = useTickClock.useTickClock

local BAR_WIDTH = WaveformAudio.BAR_WIDTH
local ITEM_WIDTH = WaveformAudio.ITEM_WIDTH
local RENDER_INTERVAL = WaveformAudio.RENDER_INTERVAL

local v = { itemIdx = 0, height = 0.2, age = nil }

local function Waveform(props)
	local v2 = props.normalize == nil or props.normalize
	local bindBarStyle = props.bindBarStyle
	local onSample = props.onSample

	local state, setState = React.useState(0)

	local v3 = not (props.isActive and state > 0) and 0 or math.ceil(state / ITEM_WIDTH) + 1

	local v4, v5 = React.useBinding(0)
	local v6, v7 = React.useBinding(0)

	local v8 = WaveformAudio.useAudioAnalyzer(props.audioDeviceInput)
	local ref = React.useRef(0)
	local ref2 = React.useRef({})

	React.useEffect(function()
		table.clear(ref2.current)
		ref.current = 0
		v5(0)
		v7(0)
	end, { props.isActive, v3, v5, v7 })

	useTickClock2({
		intervalSec = RENDER_INTERVAL,
		enabled = props.isActive and v3 > 0,
		onTick = function()
			local v9 = v4:getValue() + 1
			local height = 0.2 + WaveformAudio.sampleVolume(v8.current, ref, v2) * 0.8

			local current = ref2.current
			current[v9] = { height = height }
			current[v9 - v3] = nil

			v5(v9)

			if onSample then
				onSample(v9, height)
			end
		end,
		onFrame = function(p)
			v7(p)
		end
	})

	local v9 = React.useMemo(function()
		local current = ref2.current
		local children = {}

		for i = 1, v3 do
			local age = v3 - i
			local v9 = (i - 1) * ITEM_WIDTH

			local mapped = v4:map(function(p: number)
				local itemIdx = p - age

				if itemIdx <= 0 then
					return v
				end

				local v10 = current[itemIdx]

				if v10 == nil then
					return v
				end

				return { itemIdx = itemIdx, height = v10.height, age = age }
			end)

			local v10 = bindBarStyle(mapped)

			children["Bar" .. i] = React.createElement("Frame", {
				Position = v6:map(function(p: number)
					return UDim2.new(0, v9 - p * ITEM_WIDTH, 0.5, 0)
				end),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = mapped:map(function(p)
					return UDim2.new(0, BAR_WIDTH, p.height, 0)
				end),
				BackgroundColor3 = v10:map(function(p)
					return p.color
				end),
				BackgroundTransparency = v10:map(function(p)
					return p.transparency
				end),
				BorderSizePixel = 0
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
			})
		end

		return children
	end, { v3, v4, v6, bindBarStyle })

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		[React.Change.AbsoluteSize] = function(p)
			local x = p.AbsoluteSize.X

			if defineFastFlag then
				setState(x)
			elseif x ~= state then
				setState(x)
			end
		end
	}, v9)
end

return React.memo(Waveform)
