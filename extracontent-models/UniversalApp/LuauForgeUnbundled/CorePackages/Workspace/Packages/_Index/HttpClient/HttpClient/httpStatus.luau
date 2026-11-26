local function isSuccess(p2): boolean
	if p2 == 304 then
		return true
	end

	return p2 >= 200 and p2 < 300
end

return { isSuccess = isSuccess }
