local function EmptyBanner(): nil
	return nil
end

local v5 = EmptyBanner

return {
	set = function(p2)
		v5 = p2 or EmptyBanner
	end,
	get = function()
		return v5
	end
}
