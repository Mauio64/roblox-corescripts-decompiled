return function(flag: boolean, flag2: boolean)
	if flag or flag2 then
		return Enum.SelectionBehavior.Escape
	end

	return Enum.SelectionBehavior.Stop
end
