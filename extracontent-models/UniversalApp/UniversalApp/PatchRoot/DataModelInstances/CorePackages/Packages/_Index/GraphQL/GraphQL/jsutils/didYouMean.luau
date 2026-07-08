local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

return {
	didYouMean = function(p1, p2) -- line: 20
		local v4 = nil

		if p2 then
			v4 = p1
		else
			p2 = p1
		end

		local s1 = " Did you mean "

		if v4 then
			s1 ..= v4 .. " "
		end

		local t1 = {}

		for i = 1, #p2 do
			t1[i] = ("%q"):format(p2[i])
		end

		local v8 = #t1

		if v8 == 0 then
			return ""
		end

		if v8 == 1 then
			return s1 .. t1[1] .. "?"
		end

		if v8 == 2 then
			return s1 .. t1[1] .. " or " .. t1[2] .. "?"
		end

		local t2 = {}

		table.move(t1, 1, 5, 1, t2)

		local v10 = table.remove(t2)

		return s1 .. table.concat(t2, ", ") .. ", or " .. tostring(v10) .. "?"
	end
}
