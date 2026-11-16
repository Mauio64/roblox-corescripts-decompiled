local MockAppStorageService = {}
MockAppStorageService.__index = MockAppStorageService

function MockAppStorageService.new(options)
	local selected = options or {}

	setmetatable(selected, { __index = MockAppStorageService })

	return selected
end

function MockAppStorageService.GetItem(p, p2)
	return p[p2]
end

function MockAppStorageService:SetItem(p, p2)
	self[p] = tostring(p2)
end

function MockAppStorageService.flush(_) end

return MockAppStorageService
