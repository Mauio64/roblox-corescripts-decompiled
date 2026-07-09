local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ManageOutfitsPage = require(script.Parent.ManageOutfitsPage)
local useManageOutfitsPageProps = require(script.Parent.useManageOutfitsPageProps)

local function ManageOutfitsPageContainer() -- line: 8
	-- upvalues: useManageOutfitsPageProps (copy), React (copy), ManageOutfitsPage (copy)
	local v6 = useManageOutfitsPageProps()

	return React.createElement(ManageOutfitsPage, v6)
end

return ManageOutfitsPageContainer
