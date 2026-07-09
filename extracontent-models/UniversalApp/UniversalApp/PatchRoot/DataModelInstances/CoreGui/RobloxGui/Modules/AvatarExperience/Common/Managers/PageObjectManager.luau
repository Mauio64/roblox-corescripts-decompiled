local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local t1 = {}

t1.__index = t1

function t1.new() -- line: 20
	-- upvalues: t1 (copy)
	local t2 = {
		pageObjectMap = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.storePageObject(p1, p2, p3) -- line: 28
	p1.pageObjectMap[p2] = p3
end
function t1.getPageObject(p4, p5) -- line: 32
	return p4.pageObjectMap[p5]
end

return t1
