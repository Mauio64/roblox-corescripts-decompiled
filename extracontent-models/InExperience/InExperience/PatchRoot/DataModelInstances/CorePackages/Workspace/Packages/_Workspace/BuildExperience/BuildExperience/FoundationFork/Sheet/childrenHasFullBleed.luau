local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

local FullBleed = require(script.Parent.FullBleed)

local function getElementType(p) -- 1 equivalent call inferred from this helper
	return if type(p) == "table" then p.type else nil
end

local function childrenHasFullBleed(p)
	local v = false
	React.Children.forEach(p, function(p2)
		if getElementType(p2) == FullBleed then -- inferred equivalent call
			v = true
		end
	end)
	return v
end

return childrenHasFullBleed
