local ShowToast = require(script.Parent.Actions.ShowToast)
local ToastComplete = require(script.Parent.Actions.ToastComplete)

return function(p1, p2) -- line: 5
	-- upvalues: ShowToast (copy), ToastComplete (copy)
	local v5 = p1 or nil

	if p2.type == ShowToast.name then
		return p2.toast
	end

	if p2.type == ToastComplete.name then
		v5 = nil
	end

	return v5
end
