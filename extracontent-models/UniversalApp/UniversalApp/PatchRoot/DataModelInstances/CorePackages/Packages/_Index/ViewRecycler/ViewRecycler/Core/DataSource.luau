local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Types)

local ReconcileSnapshot = require(script.ReconcileSnapshot)
local ArrayDataSource = require(script.ArrayDataSource)
local ConcatDataSource = require(script.ConcatDataSource)
local DequeDataSource = require(script.DequeDataSource)
local MapDataSource = require(script.MapDataSource)
local ReverseDataSource = require(script.ReverseDataSource)
local RingBufferDataSource = require(script.RingBufferDataSource)
local SequenceDataSource = require(script.SequenceDataSource)
local DataSource = {}

function DataSource.snapshot(p, callback)
	return ArrayDataSource(p, callback)
end

function DataSource.sequence(p, callback)
	return SequenceDataSource(p, callback)
end

function DataSource.deque(p, callback)
	return DequeDataSource(p, callback)
end

function DataSource.ringBuffer(p: number, p2, callback)
	return RingBufferDataSource(p, p2, callback)
end

function DataSource.map(p, callback)
	return MapDataSource(p, callback)
end

function DataSource.concat(...)
	return ConcatDataSource(...)
end

function DataSource.reverse(p)
	return ReverseDataSource(p)
end

function DataSource.reconcileSnapshot(p, p2, p3, callback)
	ReconcileSnapshot(p, p2, p3, callback)
end

return DataSource
