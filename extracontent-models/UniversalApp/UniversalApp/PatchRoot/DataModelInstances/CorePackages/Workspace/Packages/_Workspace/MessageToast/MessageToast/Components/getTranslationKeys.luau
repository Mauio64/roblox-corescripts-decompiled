local ParentParent = script.Parent.Parent
local TextKeys = require(ParentParent.Common.TextKeys)
local Types = require(ParentParent.Common.Types)
local t1 = {
	[Types.DefaultError] = {
		toastTitle = TextKeys.DefaultErrorTitle,
		toastSubtitle = TextKeys.DefaultErrorSubtitle
	}
}

return function(p1, t2: {[any]: any}?) -- line: 12
	-- upvalues: Types (copy), t1 (copy)
	if p1 == Types.Custom and t2 then
		return t2
	end

	return t1[p1]
end
