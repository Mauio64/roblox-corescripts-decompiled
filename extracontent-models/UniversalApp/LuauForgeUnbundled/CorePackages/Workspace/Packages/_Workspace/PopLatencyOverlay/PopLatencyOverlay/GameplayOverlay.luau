local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/React")

local format = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/format")
local gameplay = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/gameplay")
local isToggleChord = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/isToggleChord")

local v5 = {
	"RRakRecvToAppPop",
	"RAppPopToDeserialize",
	"RDeserializeToPBQ",
	"RQToS",
	"RBscQ"
}
local v6 = {
	"LQToS",
	"LBcsQ",
	"LRakRecvToAppPop",
	"LAppPopToSerialize",
	"LDeserializeToProcess"
}

local function stageValue(instance, childName)
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

local function sumStages(result, items, result2)
	local total = 0

	for k, childName in items do
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

local function readSplit(p2)
	local success, result = pcall(function()
		return p2.Network.ServerStatsItem.DataPingDetails
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

	local v7 = sumStages(result, v5, result2)
	local v8 = sumStages(result, v6, result2)
	local rakPing = result:FindFirstChild("RakPing")

	if not rakPing then
		return result2, v7, v8, nil
	end

	local success2, result3 = pcall(function()
		return rakPing:GetValue()
	end)

	if success2 and typeof(result3) == "number" then
		return result2, v7, v8, result3
	end

	return result2, v7, v8, nil
end

local function readPings(stats)
	local success, result = pcall(function()
		return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)

	local v7, v8, v9, v10 = readSplit(stats)

	local success2, result2 = pcall(function()
		return Players.LocalPlayer:GetNetworkPing()
	end)

	local serverStatsItem = stats.Network:FindFirstChild("ServerStatsItem")

	local stats2 = if serverStatsItem then serverStatsItem:FindFirstChild("Stats") else nil
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

	local v11 = if success2 and typeof(result2) == "number" and result2 >= 0 then result2 * 1000 else nil

	if not peerStatsPlausible then
		v10 = nil
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

	local v12 = if result3 and peerStatsPlausible then result3 ~= 0 else nil
	return {
		dataMs = result,
		rakMs = v11,
		lastMs = v7,
		serverMs = v8,
		clientMs = v9,
		splitRakMs = v10,
		loss = result4,
		resendMsgs = result5,
		resendBytes = result6,
		sendKbps = result7,
		receiveKbps = result8,
		congested = v12,
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
				setState(function(p2): boolean
					return not p2
				end)
			end

			if authorizeToggle then
				task.spawn(function()
					if authorizeToggle() then
						setState(function(p2): boolean
							return not p2
						end)
					end
				end)
			else
				setState(function(p2): boolean
					return not p2
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
		local v7 = {}
		local v8 = os.clock() - 1
		task.spawn(function()
			local function poll()
				local now = os.clock()
				local v9 = readPings(stats)
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

				local v10 = success2 and result2 or {}
				local currentRegion = gameplay.currentRegion(result)
				local v11 = if currentRegion then gameplay.recentProbe(v10, currentRegion, 5) else nil
				local v12 = if v11 then v11.loss else nil
				v9.probeLoss = v12
				local v13 = if v11 then v11.silentPops else nil
				v9.probeSilentPops = v13
				local v14 = if v11 then v11.allSilent else nil
				v9.probeDown = v14
				local popCodes = {}

				for k, v15 in v10 do
					local popCode = v15.popCode

					if not (currentRegion and typeof(popCode) == "string" and string.upper((string.sub(popCode, 1, 3))) == currentRegion) then
						continue
					end

					table.insert(popCodes, popCode)
					local lastSampleEpochMs = v15.lastSampleEpochMs
					local v16 = lastSampleEpochMsByPopCode[popCode]

					if not (typeof(lastSampleEpochMs) == "number" and lastSampleEpochMs > 0 and lastSampleEpochMs ~= v16) then
						continue
					end

					if v16 and v16 < lastSampleEpochMs then
						table.insert(v7, lastSampleEpochMs - v16)

						if #v7 > 20 then
							table.remove(v7, 1)
						end
					end

					lastSampleEpochMsByPopCode[popCode] = lastSampleEpochMs
				end

				v9.probeIntervalMs = format.historyMedian(v7)
				v9.probeTargets = popCodes

				local v15 = now - v8

				if flag and v15 >= 1 then
					local v16 = if count > 0 then count / v15 else nil
					v9.fps = v16
					local v17 = if count > 0 then maxValue * 1000 else nil
					v9.worstFrameMs = v17
					count = 0
					maxValue = 0
					v8 = now
					local render = gameplay.render
					local success3, result3 = pcall(function()
						return workspace.AuthorityMode
					end)

					local v19 = if success3 and typeof(result3) == "EnumItem" then result3.Name else nil

					setState2(render(result, v10, v9, v19))
				end
			end

			local v9 = false

			while flag do
				local success, result = pcall(poll)

				if not (success or v9) then
					warn("[GameplayPopOverlay] poll failed: " .. tostring(result))
					v9 = true
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
			Stroke = React.createElement("UIStroke", {
				Color = format.COLOR_BORDER,
				Thickness = 1
			}),
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
