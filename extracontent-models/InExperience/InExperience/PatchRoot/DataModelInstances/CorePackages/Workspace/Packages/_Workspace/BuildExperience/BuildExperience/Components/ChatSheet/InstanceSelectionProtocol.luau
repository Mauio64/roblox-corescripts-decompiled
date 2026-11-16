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
		publishRequest = function(p)
			MessageBusService:Publish(messageId, p)
		end,
		publishResult = function(p)
			MessageBusService:Publish(messageId2, p)
		end,
		subscribeToResult = function(p)
			return MessageBusService:Subscribe(messageId2, p, false, false)
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

local InstanceSelectionProtocol = {}

function InstanceSelectionProtocol.beginSelection(callback, p)
	local v = p or defaultDependencies()

	if not v.canEnterCaptureMode() then
		return false
	end

	local requestId = v.createRequestId()
	local connection = nil
	local connection2 = nil
	local function disconnect() -- 3 equivalent calls inferred from this helper
		connection:Disconnect()

		if connection2 ~= nil then
			connection2:Disconnect()
		end
	end

	connection = v.subscribeToResult(function(p2)
		if typeof(p2) ~= "table" or p2.requestId ~= requestId then
			return
		end

		disconnect() -- inferred equivalent call
		callback(p2)
	end)

	connection2 = v.subscribeToCaptureModeExit(function()
		local activeRequest = v.getActiveRequest()

		if activeRequest == nil or activeRequest.requestId ~= requestId then
			connection2:Disconnect()
			return
		end

		disconnect() -- inferred equivalent call
		v.publishRequest({ active = false, requestId = requestId })

		callback({ requestId = requestId, status = "cancelled" })
	end)
	v.publishRequest({ active = true, requestId = requestId })

	local v2 = pcall(v.toggleCaptureMode)

	if not v2 then
		disconnect() -- inferred equivalent call
		v.publishRequest({ active = false, requestId = requestId })
	end

	return v2
end

function InstanceSelectionProtocol.finishSelection(data, p): boolean
	local v = p or defaultDependencies()
	local activeRequest = v.getActiveRequest()

	if activeRequest == nil then
		return false
	end

	v.publishResult({
		requestId = activeRequest.requestId,
		status = data.status,
		path = data.path,
		displayName = data.displayName,
		className = data.className
	})

	v.publishRequest({ active = false, requestId = activeRequest.requestId })

	v.toggleCaptureMode()
	return true
end

InstanceSelectionProtocol.getActiveRequest = getActiveRequest
return InstanceSelectionProtocol
