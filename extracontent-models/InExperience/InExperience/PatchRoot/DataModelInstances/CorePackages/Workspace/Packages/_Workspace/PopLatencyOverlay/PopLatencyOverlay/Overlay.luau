local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local React = require(parent.React)

local canToggleForProbe = require(script.Parent.canToggleForProbe)
local format = require(script.Parent.format)
local isToggleChord = require(script.Parent.isToggleChord)

local function PopLatencyOverlay(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("Waiting for first probe round…")
	local failClosedOnProbeCheck = props.failClosedOnProbeCheck == true
	local authorizeToggle = props.authorizeToggle
	local authorizationVersion = props.authorizationVersion
	local deferServiceUntilToggle = props.deferServiceUntilToggle == true

	local ref = React.useRef(nil)

	local ref2 = React.useRef(os.clock())

	local v = React.useCallback(function()
		if ref.current then
			return ref.current
		end

		local success, result = pcall(function()
			return game:GetService("PopLatencyService")
		end)

		if success and result then
			ref.current = result
		else
			warn("[PopLatencyOverlay] PopLatencyService not available in this build")
		end

		return ref.current
	end, {})

	React.useEffect(function()
		if not deferServiceUntilToggle then
			v()
		end
	end, { v, deferServiceUntilToggle })

	React.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			if not isToggleChord(input) then
				return
			end

			local current = ref.current or v()

			if not canToggleForProbe(current, failClosedOnProbeCheck) then
				return
			end

			local function toggle()
				if canToggleForProbe(ref.current, failClosedOnProbeCheck) then
					setState(function(p): boolean
						return not p
					end)
				end
			end

			if authorizeToggle then
				task.spawn(function()
					if authorizeToggle() and canToggleForProbe(ref.current, failClosedOnProbeCheck) then
						setState(function(p): boolean
							return not p
						end)
					end
				end)
			elseif canToggleForProbe(ref.current, failClosedOnProbeCheck) then
				setState(function(p): boolean
					return not p
				end)
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v, authorizeToggle, failClosedOnProbeCheck })

	React.useEffect(function()
		setState(false)
	end, { authorizationVersion })

	React.useEffect(function()
		if not state then
			return
		end

		local current = ref.current

		if not current then
			setState2(format.colorTag(
				format.COLOR_RED,
				format.escapeRich("PopLatencyService not available in this build.")
			))

			return
		end

		local flag = true
		task.spawn(function()
			while flag do
				local success, result = pcall(function()
					return current:GetSnapshot()
				end)

				if flag then
					if success and result then
						local intervalMs = result[1] and result[1].intervalMs or 0
						local roundCount = result[1] and result[1].roundCount or 0
						setState2(format.renderSnapshot(result, roundCount, os.clock() - ref2.current, intervalMs))
					elseif not success then
						setState2(format.colorTag(format.COLOR_RED, format.escapeRich("error: " .. tostring(result))))
					end
				end

				task.wait(format.POLL_INTERVAL_SECONDS)
			end
		end)
		return function()
			flag = false
		end
	end, { state })

	if not state then
		return nil
	end

	return React.createElement("Frame", {
		Name = "Container",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 960, 0, 660),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = format.COLOR_BG,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 6)
		}),
		Stroke = React.createElement("UIStroke", { Color = format.COLOR_BORDER, Thickness = 1 }),
		Panel = React.createElement("TextLabel", {
			Name = "Panel",
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, 8, 0, 6),
			Size = UDim2.new(0, 944, 0, 648),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			TextSize = format.TEXT_SIZE,
			TextColor3 = format.COLOR_HEADER,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = state2
		}),
		Close = React.createElement("TextButton", {
			Name = "Close",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -2, 0, 4),
			Size = UDim2.new(0, 22, 0, 22),
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			TextSize = 18,
			TextColor3 = format.COLOR_CLOSE,
			Text = "×",
			AutoButtonColor = false,
			[React.Event.Activated] = function()
				setState(false)
			end
		})
	})
end

return PopLatencyOverlay
