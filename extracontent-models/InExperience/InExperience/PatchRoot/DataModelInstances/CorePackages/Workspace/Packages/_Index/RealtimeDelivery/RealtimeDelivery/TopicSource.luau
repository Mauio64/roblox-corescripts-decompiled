local TopicSource = {}
TopicSource.__index = TopicSource

local function pcallOrWarn(p: string, callback, ...)
	local success, result = pcall(callback, ...)

	if not success then
		warn(`TopicSource: {p} failed: {result}`)
	end
end

local function connectIfPresent(connections, notificationService, p: string, fn) -- 2 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return notificationService[p]
	end)

	if success and result then
		table.insert(connections, result:Connect(fn))
	end
end

local function isTokenExpiry(data): boolean -- 1 equivalent call inferred from this helper
	return type(data) == "table"
		and type(data.token) == "string"
		and type(data.shouldExchange) == "boolean"
		and type(data.isSubscribable) == "boolean"
end

local function isSubscriptionError(data): boolean -- 1 equivalent call inferred from this helper
	return type(data) == "table"
		and type(data.token) == "string"
		and type(data.errorCode) == "string"
		and type(data.shouldRetry) == "boolean"
end

function TopicSource.new(notificationService)
	return (setmetatable({ _notificationService = notificationService, _connections = nil }, TopicSource))
end

function TopicSource:subscribe(p: string, value: string?)
	local notificationService = self._notificationService

	pcallOrWarn("SubscribeToTopic", function()
		notificationService:SubscribeToTopic(p, value or "")
	end)
end

function TopicSource:unsubscribe(p: string)
	local notificationService = self._notificationService
	pcallOrWarn("UnsubscribeFromTopic", function()
		notificationService:UnsubscribeFromTopic(p)
	end)
end

function TopicSource:startListening(data)
	if self._connections then
		return
	end

	local onNotification = data.onNotification
	local onConnected = data.onConnected
	local onTokenExpiry = data.onTokenExpiry
	local onSubscriptionError = data.onSubscriptionError
	local notificationService = self._notificationService
	local connections = {
		notificationService.TopicNotificationReceived:Connect(function(p)
			if type(p) == "table" and type(p.topicId) == "string" then
				local v = type(p.detail) ~= "string" and "" or p.detail
				pcallOrWarn("onNotification", onNotification, p.topicId, v)
			end
		end),
		notificationService.RobloxConnectionChanged:Connect(function(p, p2)
			if p == "signalR" and p2 == Enum.ConnectionState.Connected then
				pcallOrWarn("onConnected", onConnected)
			end
		end)
	}

	self._connections = connections

	if onTokenExpiry then
		local function fn(data2)
			if isTokenExpiry(data2) then -- inferred equivalent call
				pcallOrWarn(
					"onTokenExpiry",
					onTokenExpiry,
					data2.token,
					data2.shouldExchange,
					data2.isSubscribable,
					data2.subscriptionActive == true
				)
			end
		end

		connectIfPresent(connections, notificationService, "TopicTokenExpiry", fn) -- inferred equivalent call
	end

	if onSubscriptionError then
		local function fn(data2)
			if isSubscriptionError(data2) then -- inferred equivalent call
				pcallOrWarn("onSubscriptionError", onSubscriptionError, data2.token, data2.errorCode, data2.shouldRetry)
			end
		end

		connectIfPresent(connections, notificationService, "TopicSubscriptionError", fn) -- inferred equivalent call
	end
end

function TopicSource:stopListening()
	local connections = self._connections

	if connections == nil then
		return
	end

	self._connections = nil

	for _, connection in connections do
		connection:Disconnect()
	end
end

return TopicSource
