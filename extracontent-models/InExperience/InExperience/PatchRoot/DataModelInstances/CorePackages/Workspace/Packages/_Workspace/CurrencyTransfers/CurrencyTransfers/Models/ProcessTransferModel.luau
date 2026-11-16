local parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local t = require(parent.t)

local ProcessTransferModel = {}

function ProcessTransferModel.new(p)
	assert(ProcessTransferModel.isValid(p))

	ProcessTransferModel.__index = ProcessTransferModel

	setmetatable(p, ProcessTransferModel)

	return p
end

function ProcessTransferModel.mock(options)
	return (ProcessTransferModel.new({
		success = (options or {}).success or true
	}))
end

function ProcessTransferModel.format(p)
	return (ProcessTransferModel.new({ success = p.success }))
end

ProcessTransferModel.isValid = t.strictInterface({ success = t.boolean })

return ProcessTransferModel
