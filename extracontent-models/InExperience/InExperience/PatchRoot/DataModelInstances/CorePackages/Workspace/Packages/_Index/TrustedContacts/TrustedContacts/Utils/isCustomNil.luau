return function(items): boolean
	if items == nil or items == "" or items == -1 then
		return true
	elseif typeof(items) == "table" then
		return next(items) == nil
	else
		return false
	end
end
