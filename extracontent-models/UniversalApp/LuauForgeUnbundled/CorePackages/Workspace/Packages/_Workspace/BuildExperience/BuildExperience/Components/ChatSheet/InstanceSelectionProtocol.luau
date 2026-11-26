local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")

local messageId = MessageBusService:GetMessageId("BuildExperience", "instanceSelectionRequest")
local messageId2 = MessageBusService:GetMessageId("BuildExperience", "instanceSelectionResult")

local function getActiveRequest()
	local last = MessageBusService:GetLast(messageId)

	if
		typeof(last) == "table"
		and last.active == true
		and typeof(last.requestId) == "string"
		and last.requestId ~= ""
	then
		return last
	end

	return nil
end

local function defaultDependencies()
	local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
	return {
		canEnterCaptureMode = function()
			return not game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
				or ExperienceStateCaptureService:CanEnterCaptureMode()
		end,
		createRequestId = function()
			return HttpService:GenerateGUID(false)
		end,
		getActiveRequest = getActiveRequest,
		publishRequest = function(p2)
			MessageBusService:Publish(messageId, p2)
		end,
		publishResult = function(p2)
			MessageBusService:Publish(messageId2, p2)
		end,
		subscribeToResult = function(p2)
			return MessageBusService:Subscribe(messageId2, p2, false, false)
		end,
		subscribeToCaptureModeExit = function(callback)
			if game:GetEngineFeature("ExperienceStateCaptureIsInBackground") then
				return ExperienceStateCaptureService:GetPropertyChangedSignal("IsInBackground"):Connect(function()
					if not ExperienceStateCaptureService.IsInBackground then
						callback()
					end
				end)
			end

			return nil
		end,
		toggleCaptureMode = function()
			ExperienceStateCaptureService:ToggleCaptureMode()
		end
	}
end

return {
	beginSelection = function(callback, p2)
		local v5 = p2 or defaultDependencies()

		if not v5.canEnterCaptureMode() then
			return false
		end

		local requestId = v5.createRequestId()
		local connection = nil
		local connection2 = nil
		local function disconnect()
			connection:Disconnect()

			if connection2 ~= nil then
				connection2:Disconnect()
			end
		end

		connection = v5.subscribeToResult(function(p3)
			if typeof(p3) ~= "table" or p3.requestId ~= requestId then
				return
			end

			connection:Disconnect()

			if connection2 ~= nil then
				connection2:Disconnect()
			end

			callback(p3)
		end)

		connection2 = v5.subscribeToCaptureModeExit(function()
			local activeRequest = v5.getActiveRequest()

			if activeRequest == nil or activeRequest.requestId ~= requestId then
				connection2:Disconnect()
				return
			end

			connection:Disconnect()

			if connection2 ~= nil then
				connection2:Disconnect()
			end

			v5.publishRequest({ active = false, requestId = requestId })

			callback({ requestId = requestId, status = "cancelled" })
		end)
		v5.publishRequest({ active = true, requestId = requestId })

		local v6 = pcall(v5.toggleCaptureMode)

		if v6 then
			return v6
		end

		connection:Disconnect()

		if connection2 ~= nil then
			connection2:Disconnect()
		end

		v5.publishRequest({ active = false, requestId = requestId })

		return v6
	end,
	finishSelection = function(data, p2): boolean
		local v5 = p2 or defaultDependencies()
		local activeRequest = v5.getActiveRequest()

		if activeRequest == nil then
			return false
		end

		v5.publishResult({
			requestId = activeRequest.requestId,
			status = data.status,
			path = data.path,
			displayName = data.displayName,
			className = data.className
		})

		v5.publishRequest({ active = false, requestId = activeRequest.requestId })

		v5.toggleCaptureMode()
		return true
	end,
	getActiveRequest = getActiveRequest
}
