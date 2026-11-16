local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

return {
	didYouMean = function(p, list)
		if not list then
			list = p
			p = nil
		end

		local v = " Did you mean "

		if p then
			v ..= p .. " "
		end

		local v2 = {}

		for i = 1, #list do
			v2[i] = ("%q"):format(list[i])
		end

		local count = #v2

		if count == 0 then
			return ""
		elseif count == 1 then
			return v .. v2[1] .. "?"
		elseif count == 2 then
			return v .. v2[1] .. " or " .. v2[2] .. "?"
		end

		local v3 = {}
		table.move(v2, 1, 5, 1, v3)
		local v4 = table.remove(v3)

		return v .. table.concat(v3, ", ") .. ", or " .. tostring(v4) .. "?"
	end
}
