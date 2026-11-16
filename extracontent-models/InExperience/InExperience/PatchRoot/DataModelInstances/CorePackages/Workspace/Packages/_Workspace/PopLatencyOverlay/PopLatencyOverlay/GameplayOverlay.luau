local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local React = require(parent.React)

local format = require(script.Parent.format)
local gameplay = require(script.Parent.gameplay)
local isToggleChord = require(script.Parent.isToggleChord)

local v = { "RRakRecvToAppPop", "RAppPopToDeserialize", "RDeserializeToPBQ", "RQToS", "RBscQ" }
local v2 = { "LQToS", "LBcsQ", "LRakRecvToAppPop", "LAppPopToSerialize", "LDeserializeToProcess" }

local function stageValue(instance, childName: string)
	local child = instance:FindFirstChild(childName)

	if not child then
		return nil
	end

	local success, result = pcall(function()
		return child:GetValue()
	end)

	if success and typeof(result) == "number" then
		return result
	end

	return nil
end

local function sumStages(result, items, result2: number)
	local total = 0

	for _, childName in items do
		local child = result:FindFirstChild(childName)
		local result3

		if child then
			local success
			success, result3 = pcall(function()
				return child:GetValue()
			end)

			if not success or typeof(result3) ~= "number" then
				result3 = nil
			end
		end

		if result3 and result3 >= 0 and result3 <= result2 then
			total += result3
		end
	end

	return total
end

local function readSplit(p)
	local success, result = pcall(function()
		return p.Network.ServerStatsItem.DataPingDetails
	end)

	if not (success and result) then
		return nil, nil, nil, nil
	end

	local measuredTotal = result:FindFirstChild("MeasuredTotal")
	local result2

	if measuredTotal then
		local success2
		success2, result2 = pcall(function()
			return measuredTotal:GetValue()
		end)

		if not success2 or typeof(result2) ~= "number" then
			result2 = nil
		end
	end

	if not result2 or result2 <= 0 then
		return nil, nil, nil, nil
	end

	local v3 = sumStages(result, v, result2)
	local v4 = sumStages(result, v2, result2)
	local rakPing = result:FindFirstChild("RakPing")

	if not rakPing then
		return result2, v3, v4, nil
	end

	local success2, result3 = pcall(function()
		return rakPing:GetValue()
	end)

	if success2 and typeof(result3) == "number" then
		return result2, v3, v4, result3
	end

	return result2, v3, v4, nil
end

local function readPings(stats)
	local success, result = pcall(function()
		return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)

	local lastMs, serverMs, clientMs, splitRakMs = readSplit(stats)

	local success2, result2 = pcall(function()
		return Players.LocalPlayer:GetNetworkPing()
	end)

	local serverStatsItem = stats.Network:FindFirstChild("ServerStatsItem")
	local stats2

	if serverStatsItem then
		stats2 = serverStatsItem:FindFirstChild("Stats")
	end

	local result3

	if stats2 then
		local isLimitedByCongestionControl = stats2:FindFirstChild("isLimitedByCongestionControl")

		if isLimitedByCongestionControl then
			local success3
			success3, result3 = pcall(function()
				return isLimitedByCongestionControl:GetValue()
			end)

			if not success3 or typeof(result3) ~= "number" then
				result3 = nil
			end
		end
	end

	local result4

	if stats2 then
		local packetlossLastSecond = stats2:FindFirstChild("packetlossLastSecond")

		if packetlossLastSecond then
			local success3
			success3, result4 = pcall(function()
				return packetlossLastSecond:GetValue()
			end)

			if not success3 or typeof(result4) ~= "number" then
				result4 = nil
			end
		end
	end

	local result5

	if stats2 then
		local messagesInResendQueue = stats2:FindFirstChild("messagesInResendQueue")

		if messagesInResendQueue then
			local success3
			success3, result5 = pcall(function()
				return messagesInResendQueue:GetValue()
			end)

			if not success3 or typeof(result5) ~= "number" then
				result5 = nil
			end
		end
	end

	local peerStatsPlausible = gameplay.peerStatsPlausible(result4, result5)

	if not success or typeof(result) ~= "number" then
		result = nil
	end

	local rakMs

	if success2 and typeof(result2) == "number" and result2 >= 0 then
		rakMs = result2 * 1000
	end

	if not peerStatsPlausible then
		splitRakMs = nil
	end

	if not peerStatsPlausible then
		result4 = nil
	end

	if not peerStatsPlausible then
		result5 = nil
	end

	local result6

	if stats2 and peerStatsPlausible then
		local bytesInResendQueue = stats2:FindFirstChild("bytesInResendQueue")

		if bytesInResendQueue then
			local success3
			success3, result6 = pcall(function()
				return bytesInResendQueue:GetValue()
			end)

			if not success3 or typeof(result6) ~= "number" then
				result6 = nil
			end
		end
	end

	local result7

	if serverStatsItem then
		local sendkBps = serverStatsItem:FindFirstChild("Send kBps")

		if sendkBps then
			local success3
			success3, result7 = pcall(function()
				return sendkBps:GetValue()
			end)

			if not success3 or typeof(result7) ~= "number" then
				result7 = nil
			end
		end
	end

	local result8

	if serverStatsItem then
		local receivekBps = serverStatsItem:FindFirstChild("Receive kBps")

		if receivekBps then
			local success3
			success3, result8 = pcall(function()
				return receivekBps:GetValue()
			end)

			if not success3 or typeof(result8) ~= "number" then
				result8 = nil
			end
		end
	end

	local congested

	if result3 and peerStatsPlausible then
		congested = result3 ~= 0
	end

	return {
		dataMs = result,
		rakMs = rakMs,
		lastMs = lastMs,
		serverMs = serverMs,
		clientMs = clientMs,
		splitRakMs = splitRakMs,
		loss = result4,
		resendMsgs = result5,
		resendBytes = result6,
		sendKbps = result7,
		receiveKbps = result8,
		congested = congested,
		peerStatsInvalid = not peerStatsPlausible
	}
end

local function readAuthorityMode()
	local success, result = pcall(function()
		return workspace.AuthorityMode
	end)

	if success and typeof(result) == "EnumItem" then
		return result.Name
	end

	return nil
end

local function GameplayPopLatencyOverlay(props)
	local experienceService = props.experienceService

	local authorizeToggle = props.authorizeToggle
	local authorizationVersion = props.authorizationVersion

	local userInputService = props.userInputService or UserInputService
	local stats = props.stats or Stats
	local runService = props.runService or RunService
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("")

	React.useEffect(function()
		local inputBeganConnection = userInputService.InputBegan:Connect(function(input)
			if not isToggleChord(input, userInputService) or userInputService:GetFocusedTextBox() ~= nil then
				return
			end

			local function toggle()
				setState(function(p): boolean
					return not p
				end)
			end

			if authorizeToggle then
				task.spawn(function()
					if authorizeToggle() then
						setState(function(p): boolean
							return not p
						end)
					end
				end)
			else
				setState(function(p): boolean
					return not p
				end)
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { authorizeToggle, userInputService })

	React.useEffect(function()
		setState(false)
	end, { authorizationVersion })

	React.useEffect(function()
		if not state then
			return
		end

		local flag = true

		local count = 0
		local maxValue = 0
		local heartbeatConnection = runService.Heartbeat:Connect(function(dt)
			count += 1
			maxValue = math.max(maxValue, dt)
		end)

		local lastSampleEpochMsByPopCode = {}
		local v3 = {}
		local v4 = os.clock() - 1
		task.spawn(function()
			local function poll()
				local now = os.clock()
				local v5 = readPings(stats)
				local success, result = pcall(function()
					return experienceService:GetConnectedServerInfo()
				end)

				local success2, result2 = pcall(function()
					return experienceService:GetConnectedServerProbeSnapshot()
				end)

				if not success then
					result = nil
				end

				if result and result.popCode then
					pcall(function()
						experienceService:SetConnectedServerProbingActive(true)
					end)
				end

				local v6 = success2 and result2 or {}
				local currentRegion = gameplay.currentRegion(result)
				local v7

				if currentRegion then
					v7 = gameplay.recentProbe(v6, currentRegion, 5)
				end

				local probeLoss

				if v7 then
					probeLoss = v7.loss
				end

				v5.probeLoss = probeLoss
				local probeSilentPops

				if v7 then
					probeSilentPops = v7.silentPops
				end

				v5.probeSilentPops = probeSilentPops
				local probeDown

				if v7 then
					probeDown = v7.allSilent
				end

				v5.probeDown = probeDown
				local popCodes = {}

				for _, v8 in v6 do
					local popCode = v8.popCode

					if not (currentRegion and typeof(popCode) == "string" and string.upper((string.sub(popCode, 1, 3))) == currentRegion) then
						continue
					end

					table.insert(popCodes, popCode)
					local lastSampleEpochMs = v8.lastSampleEpochMs
					local v9 = lastSampleEpochMsByPopCode[popCode]

					if not (typeof(lastSampleEpochMs) == "number" and lastSampleEpochMs > 0 and lastSampleEpochMs ~= v9) then
						continue
					end

					if v9 and v9 < lastSampleEpochMs then
						table.insert(v3, lastSampleEpochMs - v9)

						if #v3 > 20 then
							table.remove(v3, 1)
						end
					end

					lastSampleEpochMsByPopCode[popCode] = lastSampleEpochMs
				end

				v5.probeIntervalMs = format.historyMedian(v3)
				v5.probeTargets = popCodes

				local v8 = now - v4

				if flag and v8 >= 1 then
					local fps

					if count > 0 then
						fps = count / v8
					end

					v5.fps = fps
					local worstFrameMs

					if count > 0 then
						worstFrameMs = maxValue * 1000
					end

					v5.worstFrameMs = worstFrameMs
					count = 0
					maxValue = 0
					v4 = now
					local render = gameplay.render
					local success3, result3 = pcall(function()
						return workspace.AuthorityMode
					end)
					local v9

					if success3 and typeof(result3) == "EnumItem" then
						v9 = result3.Name
					end

					setState2(render(result, v6, v5, v9))
				end
			end

			local v5 = false

			while flag do
				local success, result = pcall(poll)

				if not (success or v5) then
					warn("[GameplayPopOverlay] poll failed: " .. tostring(result))
					v5 = true
				end

				task.wait(0.2)
			end
		end)
		return function()
			flag = false
			heartbeatConnection:Disconnect()
			pcall(function()
				experienceService:SetConnectedServerProbingActive(false)
			end)
		end
	end, { state })

	if state then
		return React.createElement("Frame", {
			Name = "GameplayPopOverlay",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 64),
			Size = UDim2.fromOffset(460, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = format.COLOR_BG,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
			Stroke = React.createElement("UIStroke", { Color = format.COLOR_BORDER, Thickness = 1 }),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			}),
			Panel = React.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font = Enum.Font.Code,
				TextSize = format.TEXT_SIZE,
				TextColor3 = format.COLOR_HEADER,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				RichText = true,
				TextWrapped = true,
				Text = state2
			})
		})
	end

	return nil
end

return GameplayPopLatencyOverlay
