local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local New = {}

require(parent.Shared)

require(script.Parent.ReactInternalTypes)

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local isPrimaryRenderer = ReactFiberHostConfig.isPrimaryRenderer

local v = {}

local v2 = ReactGlobals.__DEV__ and {} or nil

function New.markSourceAsDirty(p)
	table.insert(v, p)
end

function New.resetWorkInProgressVersions()
	for _, v3 in v do
		if isPrimaryRenderer then
			v3._workInProgressVersionPrimary = nil
		else
			v3._workInProgressVersionSecondary = nil
		end
	end

	table.clear(v)
end

function New:getWorkInProgressVersion()
	if isPrimaryRenderer then
		return self._workInProgressVersionPrimary
	end

	return self._workInProgressVersionSecondary
end

function New:setWorkInProgressVersion(p)
	if isPrimaryRenderer then
		self._workInProgressVersionPrimary = p
	else
		self._workInProgressVersionSecondary = p
	end

	table.insert(v, self)
end

function New:warnAboutMultipleRenderersDEV()
	if ReactGlobals.__DEV__ then
		if isPrimaryRenderer then
			if self._currentPrimaryRenderer == nil then
				self._currentPrimaryRenderer = v2
			elseif self._currentPrimaryRenderer ~= v2 then
				console.error("Detected multiple renderers concurrently rendering the same mutable source. This is currently unsupported.")
			end
		elseif self._currentSecondaryRenderer == nil then
			self._currentSecondaryRenderer = v2
		elseif self._currentSecondaryRenderer ~= v2 then
			console.error("Detected multiple renderers concurrently rendering the same mutable source. This is currently unsupported.")
		end
	end
end

function New:registerMutableSourceForHydration(p)
	local version = p._getVersion(p._source)

	if self.mutableSourceEagerHydrationData ~= nil then
		return
	end

	self.mutableSourceEagerHydrationData = { p, version }
end

return New
