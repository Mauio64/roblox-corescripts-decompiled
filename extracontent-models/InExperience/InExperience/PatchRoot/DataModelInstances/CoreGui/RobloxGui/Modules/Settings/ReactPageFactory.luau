local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local t1 = {}

local function createNewPage(s1: string) -- line: 19
	-- upvalues: React (copy)
	local t2 = {
		page = nil,
		hubRef = nil,
		name = s1
	}

	function t2.setPage(_, p2) -- line: 26
		-- upvalues: t2 (copy)
		t2.page = p2
	end
	function t2.createPage(_, p4) -- line: 30
		-- upvalues: t2 (copy), React (copy)
		if not t2.page then
			return nil
		end

		return React.createElement(t2.page, p4)
	end

	return t2
end

function t1.createNewPage(_: {[any]: any}, s2: string) -- line: 41
	-- upvalues: createNewPage (copy)
	return (createNewPage(s2))
end

return t1
