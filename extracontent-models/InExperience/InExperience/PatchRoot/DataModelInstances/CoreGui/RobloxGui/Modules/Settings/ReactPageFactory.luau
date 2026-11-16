local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local ReactPageFactory = {}

local function createNewPage(name: string)
	local newPage = { name = name, page = nil, hubRef = nil }

	function newPage.setPage(_, page)
		newPage.page = page
	end

	function newPage.createPage(_, p)
		if newPage.page then
			return React.createElement(newPage.page, p)
		end

		return nil
	end

	return newPage
end

function ReactPageFactory.createNewPage(_, name: string)
	return createNewPage(name)
end

return ReactPageFactory
