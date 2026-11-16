local MockAppStorageService = {}
MockAppStorageService.__index = MockAppStorageService

function MockAppStorageService.new(p)
	return (setmetatable({ _privateValues = table.clone(p) }, MockAppStorageService))
end

function MockAppStorageService:GetItem(p)
	return self._privateValues[p]
end

function MockAppStorageService:SetItem(p, p2)
	self._privateValues[p] = p2
end

function MockAppStorageService.Flush(_) end

function MockAppStorageService:_DeepEquals(items): boolean
	for k, item in items do
		if self._privateValues[k] ~= item then
			return false
		end
	end

	return true
end

return MockAppStorageService
