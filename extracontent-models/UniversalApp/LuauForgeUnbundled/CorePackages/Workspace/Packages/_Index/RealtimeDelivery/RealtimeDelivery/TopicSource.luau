local class = {}
class.__index = class

local function pcallOrWarn(p2, callback, ...)
	local success, result = pcall(callback, ...)

	if not success then
		warn(`TopicSource: {p2} failed: {result}`)
	end
end

local function connectIfPresent(connections, p2, p3, p4)
	local success, result = pcall(function()
		return p2[p3]
	end)

	if success and result then
		table.insert(connections, result:Connect(p4))
	end
end

local function isTokenExpiry(data): boolean
	return type(data) == "table"
		and type(data.token) == "string"
		and type(data.shouldExchange) == "boolean"
		and type(data.isSubscribable) == "boolean"
end

local function isSubscriptionError(data): boolean
	return type(data) == "table"
		and type(data.token) == "string"
		and type(data.errorCode) == "string"
		and type(data.shouldRetry) == "boolean"
end

function class.new(p2)
	return (setmetatable({ _notificationService = p2, _connections = nil }, class))
end

function class:subscribe(p3, value)
	local notificationService = self._notificationService

	pcallOrWarn("SubscribeToTopic", function()
		notificationService:SubscribeToTopic(p3, value or "")
	end)
end

function class:unsubscribe(p3)
	local notificationService = self._notificationService
	pcallOrWarn("UnsubscribeFromTopic", function()
		notificationService:UnsubscribeFromTopic(p3)
	end)
end

function class:startListening(data)
	if self._connections then
		return
	end

	local onNotification = data.onNotification
	local onConnected = data.onConnected
	local onTokenExpiry = data.onTokenExpiry
	local onSubscriptionError = data.onSubscriptionError
	local notificationService = self._notificationService
	local connections = {
		notificationService.TopicNotificationReceived:Connect(function(p2)
			if type(p2) == "table" and type(p2.topicId) == "string" then
				local v5 = type(p2.detail) ~= "string" and "" or p2.detail
				pcallOrWarn("onNotification", onNotification, p2.topicId, v5)
			end
		end),
		notificationService.RobloxConnectionChanged:Connect(function(p2, p3)
			if p2 == "signalR" and p3 == Enum.ConnectionState.Connected then
				pcallOrWarn("onConnected", onConnected)
			end
		end)
	}

	self._connections = connections

	if onTokenExpiry then
		local function fn(data2)
			local v5

			if
				type(data2) == "table"
				and type(data2.token) == "string"
				and type(data2.shouldExchange) == "boolean"
			then
				v5 = type(data2.isSubscribable) == "boolean"
			else
				v5 = false
			end

			if v5 then
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

		local v5 = "TopicTokenExpiry"
		local success, result = pcall(function()
			return notificationService[v5]
		end)

		if success and result then
			table.insert(connections, result:Connect(fn))
		end
	end

	if onSubscriptionError then
		local function fn(data2)
			local v5

			if
				type(data2) == "table"
				and type(data2.token) == "string"
				and type(data2.errorCode) == "string"
			then
				v5 = type(data2.shouldRetry) == "boolean"
			else
				v5 = false
			end

			if v5 then
				pcallOrWarn(
					"onSubscriptionError",
					onSubscriptionError,
					data2.token,
					data2.errorCode,
					data2.shouldRetry
				)
			end
		end

		local v5 = "TopicSubscriptionError"
		local success, result = pcall(function()
			return notificationService[v5]
		end)

		if success and result then
			table.insert(connections, result:Connect(fn))
		end
	end
end

function class:stopListening()
	local connections = self._connections

	if connections == nil then
		return
	end

	self._connections = nil

	for k, connection in connections do
		connection:Disconnect()
	end
end

return class
