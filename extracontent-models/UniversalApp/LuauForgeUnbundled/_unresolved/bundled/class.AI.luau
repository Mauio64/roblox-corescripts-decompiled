require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local class = {}
class.__index = class

function class.new()
	local v5 = { pageObjectMap = {} }
	setmetatable(v5, class)

	return v5
end

function class:storePageObject(p3, p4)
	self.pageObjectMap[p3] = p4
end

function class:getPageObject(p3)
	return self.pageObjectMap[p3]
end

return class
