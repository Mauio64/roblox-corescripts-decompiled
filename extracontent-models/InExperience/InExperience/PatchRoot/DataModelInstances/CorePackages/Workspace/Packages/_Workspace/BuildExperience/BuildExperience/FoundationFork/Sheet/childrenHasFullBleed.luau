local FoundationParent = game:GetService("CorePackages").Packages._Index.Foundation.Foundation.Parent
local React = require(FoundationParent.React)
local FullBleed = require(script.Parent.FullBleed)

local function getElementType(p1) -- line: 8
	if type(p1) ~= "table" then
		return nil
	end

	return p1.type
end
local function childrenHasFullBleed(p2) -- line: 15
	-- upvalues: React (copy), FullBleed (copy)
	local u8 = false

	React.Children.forEach(p2, function(p3) -- line: 17
		-- upvalues: FullBleed (copy), u8 (ref)
		if ((if type(p3) == "table" then p3.type else nil)) == FullBleed then
			u8 = true
		end
	end)

	return u8
end

return childrenHasFullBleed
