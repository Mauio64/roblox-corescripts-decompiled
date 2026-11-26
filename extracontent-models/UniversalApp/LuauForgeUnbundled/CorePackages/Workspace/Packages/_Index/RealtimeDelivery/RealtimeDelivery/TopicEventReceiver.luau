local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/UrlBuilder").UrlBase

require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/RealtimeTypes")
local TopicSource = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/TopicSource")

local frozen = table.freeze({ maxRetries = 3, firstDelaySeconds = 1 })

local function getRetryDelaySeconds(p2)
	return frozen.firstDelaySeconds * 2 ^ (p2 - 1) * (0.5 + math.random() / 2)
end

local function cancelPendingRetry(p2)
	if p2.retryThread then
		task.cancel(p2.retryThread)
		p2.retryThread = nil
	end
end

local class = {}
class.__index = class

local v5 = {
	disconnect = function() end
}

local function getTopicId(value)
	if type(value) ~= "string" then
		return nil
	end

	local v6 = string.match(value, "^([^%.]+)%.")

	if v6 == nil or string.find(v6, "!", 1, true) == nil then
		return nil
	end

	return v6
end

local function decodeDetail(p2)
	if p2 == "" then
		return {}
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

	if success then
		return result
	end

	return nil
end

local function requestExchange(token, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = urlBase.APIS .. "/topic-token-exchange-service/v1/exchange",
		body = { token = token },
		analyticsKey = "RealtimeDelivery.TopicTokenExchange",
		network = network,
		decode = function(p2)
			return p2
		end
	}))
end

local function callObserver(p2, p3, p4)
	local success, result = pcall(p3.callback, p4)

	if not success then
		warn(`TopicEventReceiver: a callback for {p2} failed: {result}`)
	end
end

local function callErrorHandler(p2, p3, p4)
	local onError = p3.onError

	if onError == nil then
		return
	end

	local success, result = pcall(onError, p4)

	if not success then
		warn(`TopicEventReceiver: an error handler for {p2} failed: {result}`)
	end
end

function class.new(p2, p3)
	local v6 = { _source = TopicSource.new(p2), _topics = {}, _network = 0 }
	local v7 = if p3 then p3.network else nil
	v6._network = v7

	return (setmetatable(v6, class))
end

function class:observeTopic(value, callback, p2)
	assert(type(callback) == "function", "Expected a topic callback")
	local v6

	if type(value) == "string" then
		v6 = string.match(value, "^([^%.]+)%.")

		if v6 == nil or string.find(v6, "!", 1, true) == nil then
			v6 = nil
		end
	else
		v6 = nil
	end

	if v6 == nil then
		warn("TopicEventReceiver: ignoring a malformed topic token")
		return v5
	end

	if next(self._topics) == nil then
		self:_startListening()
	end

	local trackToken, v7 = self:_trackToken(v6, value)
	local v8 = { callback = callback, onError = 0 }
	local v9 = if p2 then p2.onError else nil
	v8.onError = v9
	table.insert(trackToken.observers, v8)

	if trackToken.retryThread then
		task.cancel(trackToken.retryThread)
		trackToken.retryThread = nil
	end

	self._source:subscribe(trackToken.token, v7)

	return {
		disconnect = function()
			self:_removeObserver(v6, trackToken, v8)
		end
	}
end

function class:_startListening()
	self._source:startListening({
		onNotification = function(p2, p3)
			self:_dispatch(p2, p3)
		end,
		onConnected = function()
			self:_resubscribeAll()
		end,
		onTokenExpiry = function(p2, p3, p4, p5)
			self:_onTokenExpiry(p2, p3, p4, p5)
		end,
		onSubscriptionError = function(p2, p3, p4)
			self:_onSubscriptionError(p2, p3, p4)
		end
	})
end

function class:_trackToken(p3, token)
	local topic = self._topics[p3]

	if topic == nil then
		local v6 = { token = token, observers = {} }
		self._topics[p3] = v6
		return v6, nil
	else
		if topic.token == token then
			return topic, nil
		end

		local token2 = topic.token
		topic.token = token
		topic.previousToken = token2
		return topic, token2
	end
end

function class:_removeObserver(p3, p4, p5)
	local index = table.find(p4.observers, p5)

	if index == nil then
		return
	end

	table.remove(p4.observers, index)

	if #p4.observers > 0 or self._topics[p3] ~= p4 then
		return
	end

	self._topics[p3] = nil
	self._source:unsubscribe(p4.token)

	if next(self._topics) == nil then
		self._source:stopListening()
	end
end

function class:_dispatch(p3, p4)
	local topic = self._topics[p3]

	if topic == nil then
		return
	end

	local result

	if p4 == "" then
		result = {}
	else
		local success
		success, result = pcall(HttpService.JSONDecode, HttpService, p4)

		if not success then
			result = nil
		end
	end

	if result == nil then
		warn(`TopicEventReceiver: dropped a notification for {p3} whose detail is not valid JSON`)
		return
	end

	for k, v6 in table.clone(topic.observers) do
		if not table.find(topic.observers, v6) then
			continue
		end

		local success, result2 = pcall(v6.callback, result)

		if not success then
			warn(`TopicEventReceiver: a callback for {p3} failed: {result2}`)
		end
	end
end

function class:_resubscribeAll()
	for k, topic in self._topics do
		topic.previousToken = nil

		if topic.retryThread then
			task.cancel(topic.retryThread)
			topic.retryThread = nil
		end

		self._source:subscribe(topic.token)
	end
end

function class:_findCurrentTopic(value)
	local v6

	if type(value) == "string" then
		v6 = string.match(value, "^([^%.]+)%.")

		if v6 == nil or string.find(v6, "!", 1, true) == nil then
			v6 = nil
		end
	end

	local v7 = if v6 then self._topics[v6] else nil

	if v7 == nil or v7.token ~= value then
		return nil, nil
	end

	return v6, v7
end

function class:_onTokenExpiry(p2, p3, p4, p5)
	local currentTopic, v6 = self:_findCurrentTopic(p2)

	if currentTopic == nil or v6 == nil then
		return
	end

	v6.previousToken = nil

	if p4 then
		if v6.retryThread then
			task.cancel(v6.retryThread)
			v6.retryThread = nil
		end

		self._source:subscribe(p2)
	else
		if not p5 then
			self:_endTopic(currentTopic, v6, { type = "expired", shouldExchange = p3 })
			return
		end

		if v6.retryThread then
			task.cancel(v6.retryThread)
			v6.retryThread = nil
		end

		if p3 then
			self:_exchange(currentTopic, v6)
		end
	end
end

function class:_exchange(p2, p3)
	local token = p3.token
	requestExchange(token, self._network):andThen(function(p4)
		local token2 = p4.token

		if self._topics[p2] ~= p3 or p3.token ~= token or (type(token2) ~= "string" or token2 == token) then
			return
		end

		p3.token = token2
		p3.previousToken = token
		local v6 = p3

		if v6.retryThread then
			task.cancel(v6.retryThread)
			v6.retryThread = nil
		end

		self._source:subscribe(token2, token)
	end):catch(function(p4)
		if type(p4) == "table" then
			p4 = p4.errorMessage
		end

		warn(`TopicEventReceiver: token exchange for {p2} failed: {p4}`)
	end)
end

function class:_onSubscriptionError(p2, p3, p4)
	local currentTopic, v6 = self:_findCurrentTopic(p2)

	if currentTopic == nil or v6 == nil then
		return
	end

	if v6.previousToken then
		v6.token = v6.previousToken
		v6.previousToken = nil
	else
		if p4 and self:_retrySubscribe(currentTopic, v6) then
			return
		end

		self:_endTopic(currentTopic, v6, {
			type = "error",
			errorCode = p3,
			shouldRetry = p4
		})
	end
end

function class:_retrySubscribe(p3, state): boolean
	if state.retryThread then
		return true
	end

	local v6 = (state.retryAttempts or 0) + 1

	if frozen.maxRetries < v6 then
		return false
	end

	state.retryAttempts = v6
	state.retryThread = task.delay(
		frozen.firstDelaySeconds * 2 ^ (v6 - 1) * (0.5 + math.random() / 2),
		function()
			state.retryThread = nil

			if self._topics[p3] == state then
				self._source:subscribe(state.token)
			end
		end
	)
	return true
end

function class:_endTopic(p3, p4, p5)
	self._topics[p3] = nil

	if next(self._topics) == nil then
		self._source:stopListening()
	end

	for k, v6 in table.clone(p4.observers) do
		if not table.find(p4.observers, v6) then
			continue
		end

		local onError = v6.onError

		if onError == nil then
			continue
		end

		local success, result = pcall(onError, p5)

		if not success then
			warn(`TopicEventReceiver: an error handler for {p3} failed: {result}`)
		end
	end
end

return class
