local function makeGlobalNavAnalytics(p1, p2) -- line: 1
	local EventStream = p1.EventStream

	return {
		ButtonActivated = function(s1: string, s2: string) -- line: 6
			-- upvalues: p2 (copy), EventStream (copy)
			p2(EventStream, "TenFootUiGlobalNav", s1, s2)
		end
	}
end

return makeGlobalNavAnalytics
