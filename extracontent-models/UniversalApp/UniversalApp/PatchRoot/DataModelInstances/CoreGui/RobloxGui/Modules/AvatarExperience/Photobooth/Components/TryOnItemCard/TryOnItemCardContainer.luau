local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local TryOnItemCard = require(script.Parent.TryOnItemCard)
local useTryOnItemCardProps = require(script.Parent.useTryOnItemCardProps)

local function TryOnItemCardContainer(p1) -- line: 14
	-- upvalues: useTryOnItemCardProps (copy), React (copy), TryOnItemCard (copy)
	local v7 = useTryOnItemCardProps(p1)

	return React.createElement(TryOnItemCard, v7)
end

return React.memo(TryOnItemCardContainer)
