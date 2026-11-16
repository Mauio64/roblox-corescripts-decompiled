local function devAssert(p, p2: string)
	if _G.__DEV__ == true then
		assert(p, p2)
	end
end

return devAssert
