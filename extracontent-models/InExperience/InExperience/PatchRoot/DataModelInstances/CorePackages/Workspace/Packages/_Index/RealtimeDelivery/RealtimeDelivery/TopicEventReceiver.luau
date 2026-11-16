local HttpService = game:GetService("HttpService")

local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local HttpClient = require(RealtimeDelivery.Parent.HttpClient)
local UrlBuilder = require(RealtimeDelivery.Parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.RealtimeTypes)
local TopicSource = require(script.Parent.TopicSource)

local frozen = table.freeze({ maxRetries = 3, firstDelaySeconds = 1 })

local function getRetryDelaySeconds(p: number) -- 1 equivalent call inferred from this helper
	return frozen.firstDelaySeconds * 2 ^ (p - 1) * (0.5 + math.random() / 2)
end

local function cancelPendingRetry(p) -- 5 equivalent calls inferred from this helper
	if p.retryThread then
		task.cancel(p.retryThread)
		p.retryThread = nil
	end
end

local TopicEventReceiver = {}
TopicEventReceiver.__index = TopicEventReceiver

local v = {
	disconnect = function() end
}

local function getTopicId(value) -- 1 equivalent call inferred from this helper
	if type(value) ~= "string" then
		return nil
	end

	local v2 = string.match(value, "^([^%.]+)%.")

	if v2 == nil or string.find(v2, "!", 1, true) == nil then
		return nil
	end

	return v2
end

local function decodeDetail(p: string)
	if p == "" then
		return {}
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p)
	return if success then result else nil
end

local function requestExchange(token: string, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = UrlBase.APIS .. "/topic-token-exchange-service/v1/exchange",
		body = { token = token },
		analyticsKey = "RealtimeDelivery.TopicTokenExchange",
		network = network,
		decode = function(p)
			return p
		end
	}))
end

local function callObserver(p: string, p2, result) -- 1 equivalent call inferred from this helper
	local success, result2 = pcall(p2.callback, result)

	if not success then
		warn(`TopicEventReceiver: a callback for {p} failed: {result2}`)
	end
end

local function callErrorHandler(p: string, p2, p3) -- 1 equivalent call inferred from this helper
	local onError = p2.onError

	if onError == nil then
		return
	end

	local success, result = pcall(onError, p3)

	if not success then
		warn(`TopicEventReceiver: an error handler for {p} failed: {result}`)
	end
end

function TopicEventReceiver.new(p, p2)
	local v2 = { _source = TopicSource.new(p), _topics = {}, _network = 0 }
	local network

	if p2 then
		network = p2.network
	end

	v2._network = network

	return (setmetatable(v2, TopicEventReceiver))
end

function TopicEventReceiver:observeTopic(value: string, callback, p)
	assert(type(callback) == "function", "Expected a topic callback")
	local v2

	if type(value) == "string" then
		v2 = string.match(value, "^([^%.]+)%.")

		if v2 == nil or string.find(v2, "!", 1, true) == nil then
			v2 = nil
		end
	else
		v2 = nil
	end

	if v2 == nil then
		warn("TopicEventReceiver: ignoring a malformed topic token")
		return v
	end

	if next(self._topics) == nil then
		self:_startListening()
	end

	local trackToken, v3 = self:_trackToken(v2, value)
	local v4 = { callback = callback, onError = 0 }
	local onError

	if p then
		onError = p.onError
	end

	v4.onError = onError
	table.insert(trackToken.observers, v4)
	cancelPendingRetry(trackToken) -- inferred equivalent call
	self._source:subscribe(trackToken.token, v3)

	return {
		disconnect = function()
			self:_removeObserver(v2, trackToken, v4)
		end
	}
end

function TopicEventReceiver:_startListening()
	self._source:startListening({
		onNotification = function(p, p2)
			self:_dispatch(p, p2)
		end,
		onConnected = function()
			self:_resubscribeAll()
		end,
		onTokenExpiry = function(p, p2, p3, p4)
			self:_onTokenExpiry(p, p2, p3, p4)
		end,
		onSubscriptionError = function(p, p2, p3)
			self:_onSubscriptionError(p, p2, p3)
		end
	})
end

function TopicEventReceiver:_trackToken(p: string, token: string)
	local topic = self._topics[p]

	if topic == nil then
		local v2 = { token = token, observers = {} }
		self._topics[p] = v2
		return v2, nil
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

function TopicEventReceiver:_removeObserver(p: string, p2, p3)
	local index = table.find(p2.observers, p3)

	if index == nil then
		return
	end

	table.remove(p2.observers, index)

	if #p2.observers > 0 or self._topics[p] ~= p2 then
		return
	end

	self._topics[p] = nil
	self._source:unsubscribe(p2.token)

	if next(self._topics) == nil then
		self._source:stopListening()
	end
end

function TopicEventReceiver:_dispatch(p: string, p2: string)
	local topic = self._topics[p]

	if topic == nil then
		return
	end

	local result

	if p2 == "" then
		result = {}
	else
		local success
		success, result = pcall(HttpService.JSONDecode, HttpService, p2)

		if not success then
			result = nil
		end
	end

	if result == nil then
		warn(`TopicEventReceiver: dropped a notification for {p} whose detail is not valid JSON`)
		return
	end

	for _, v2 in table.clone(topic.observers) do
		if table.find(topic.observers, v2) then
			callObserver(p, v2, result) -- inferred equivalent call
		end
	end
end

function TopicEventReceiver:_resubscribeAll()
	for _, topic in self._topics do
		topic.previousToken = nil
		cancelPendingRetry(topic) -- inferred equivalent call
		self._source:subscribe(topic.token)
	end
end

function TopicEventReceiver:_findCurrentTopic(value: string)
	local topicId = getTopicId(value) -- inferred equivalent call
	local selected

	if topicId then
		selected = self._topics[topicId]
	end

	if selected == nil or selected.token ~= value then
		return nil, nil
	end

	return topicId, selected
end

function TopicEventReceiver:_onTokenExpiry(p: string, shouldExchange: boolean, flag: boolean, flag2: boolean)
	local currentTopic, v2 = self:_findCurrentTopic(p)

	if currentTopic == nil or v2 == nil then
		return
	end

	v2.previousToken = nil

	if flag then
		cancelPendingRetry(v2) -- inferred equivalent call
		self._source:subscribe(p)
	else
		if not flag2 then
			self:_endTopic(currentTopic, v2, { type = "expired", shouldExchange = shouldExchange })
			return
		end

		cancelPendingRetry(v2) -- inferred equivalent call

		if shouldExchange then
			self:_exchange(currentTopic, v2)
		end
	end
end

function TopicEventReceiver:_exchange(p: string, p2)
	local token = p2.token
	requestExchange(token, self._network):andThen(function(p3)
		local token2 = p3.token

		if self._topics[p] ~= p2 or p2.token ~= token or (type(token2) ~= "string" or token2 == token) then
			return
		end

		p2.token = token2
		p2.previousToken = token
		cancelPendingRetry(p2) -- inferred equivalent call
		self._source:subscribe(token2, token)
	end):catch(function(p3)
		if type(p3) == "table" then
			p3 = p3.errorMessage
		end

		warn(`TopicEventReceiver: token exchange for {p} failed: {p3}`)
	end)
end

function TopicEventReceiver:_onSubscriptionError(p: string, errorCode: string, shouldRetry: boolean)
	local currentTopic, v2 = self:_findCurrentTopic(p)

	if currentTopic == nil or v2 == nil then
		return
	end

	if v2.previousToken then
		v2.token = v2.previousToken
		v2.previousToken = nil
	else
		if shouldRetry and self:_retrySubscribe(currentTopic, v2) then
			return
		end

		self:_endTopic(currentTopic, v2, {
			type = "error",
			errorCode = errorCode,
			shouldRetry = shouldRetry
		})
	end
end

function TopicEventReceiver:_retrySubscribe(p: string, state): boolean
	if state.retryThread then
		return true
	end

	local retryAttempts = (state.retryAttempts or 0) + 1

	if frozen.maxRetries < retryAttempts then
		return false
	end

	state.retryAttempts = retryAttempts
	state.retryThread = task.delay(getRetryDelaySeconds(retryAttempts), function() -- inferred equivalent call
		state.retryThread = nil

		if self._topics[p] == state then
			self._source:subscribe(state.token)
		end
	end)
	return true
end

function TopicEventReceiver:_endTopic(p: string, p2, p3)
	self._topics[p] = nil

	if next(self._topics) == nil then
		self._source:stopListening()
	end

	for _, v2 in table.clone(p2.observers) do
		if table.find(p2.observers, v2) then
			callErrorHandler(p, v2, p3) -- inferred equivalent call
		end
	end
end

return TopicEventReceiver
