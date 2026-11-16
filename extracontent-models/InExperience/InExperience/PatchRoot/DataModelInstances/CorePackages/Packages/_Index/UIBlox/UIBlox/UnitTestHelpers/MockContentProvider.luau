local parent = script.Parent.Parent.Parent
local Roact = require(parent.Roact)

local v = {}
v.__index = v
function v.new(callback)
	local v2 = {}

	setmetatable(v2, { __index = v })

	v2.callback = callback
	v2.connected = true
	v2.isMock = 231
	return v2
end

function v:Fire(p)
	if self.connected then
		self.callback(p)
	end
end

function v:Disconnect()
	self.connected = false
end

local v2 = {}
v2.__index = v2
function v2.new()
	local v3 = {}

	setmetatable(v3, { __index = v2 })

	v3.connections = {}
	return v3
end

function v2.Connect(p, p2)
	local v3 = v.new(p2)
	table.insert(p.connections, v3)
	return v3
end

function v2:Fire(p)
	for _, connection in self.connections do
		connection:Fire(p)
	end
end

local MockContentProvider = {}
MockContentProvider.__index = MockContentProvider
function MockContentProvider.new(options, options2, options3)
	local v3 = {}

	setmetatable(v3, { __index = MockContentProvider })

	v3.mockContentProviderProceedWithLoad = false
	v3.contentResolved = false
	v3.assetFetchStatuses = {}
	v3.signals = {}
	v3.preloadAsyncCalled = false
	v3.isMock = true
	v3.ultimatelySuccessfulContentIds = options or {}
	v3.ultimatelyTimedOutContentIds = options2 or {}
	v3.ultimatelyFailedContentIds = options3 or {}
	return v3
end

function MockContentProvider:mockReload(p, p2)
	self.mockContentProviderProceedWithLoad = false
	self:_staggeredProgress(nil, p, p2 or Enum.AssetFetchStatus.Success)
end

function MockContentProvider:proceedWithLoad()
	self.mockContentProviderProceedWithLoad = true
	Roact.act(function()
		task.wait(0.1)
	end)
end

function MockContentProvider:_setAssetFetchStatus(p, p2)
	self.assetFetchStatuses[p] = p2

	if self.signals[p] then
		self.signals[p]:Fire(p2)
	end
end

function MockContentProvider:_staggeredProgress(callback, p, p2)
	self.contentResolved = false

	task.spawn(function()
		while true do
			if self.mockContentProviderProceedWithLoad then
				if self.contentResolved then
					break
				end

				self:_setAssetFetchStatus(p, Enum.AssetFetchStatus.Loading)

				if callback then
					callback(p, Enum.AssetFetchStatus.Loading)
				end

				self.contentResolved = true
				self.mockContentProviderProceedWithLoad = false
			end

			task.wait()
		end

		self:_setAssetFetchStatus(p, p2)

		if callback then
			callback(p, p2)
		end

		self.mockContentProviderProceedWithLoad = false
	end)
end

function MockContentProvider:_makeMockSignal()
	return (v2.new())
end

function MockContentProvider:GetAssetFetchStatusChangedSignal(p)
	if self.signals[p] == nil then
		self.signals[p] = self:_makeMockSignal()
	end

	return self.signals[p]
end

function MockContentProvider.GetAssetFetchStatus(p, p2)
	if p.assetFetchStatuses[p2] == nil then
		return Enum.AssetFetchStatus.None
	end

	return p.assetFetchStatuses[p2]
end

function MockContentProvider:PreloadAsync(list, callback)
	self.preloadAsyncCalled = true

	for _, item in ipairs(list) do
		if self.ultimatelySuccessfulContentIds[item] then
			self:_staggeredProgress(callback, item, Enum.AssetFetchStatus.Success)
		elseif self.ultimatelyTimedOutContentIds[item] then
			self:_staggeredProgress(callback, item, Enum.AssetFetchStatus.TimedOut)
		elseif self.ultimatelyFailedContentIds[item] then
			self:_staggeredProgress(callback, item, Enum.AssetFetchStatus.Failure)
		else
			task.delay(0, function()
				self:_setAssetFetchStatus(item, Enum.AssetFetchStatus.Success)

				if callback then
					callback(item, Enum.AssetFetchStatus.Success)
				end
			end)
		end
	end
end

return MockContentProvider
