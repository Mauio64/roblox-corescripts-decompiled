local function isSuccess(p: number): boolean
	return p == 304 or p >= 200 and p < 300
end

return { isSuccess = isSuccess }
