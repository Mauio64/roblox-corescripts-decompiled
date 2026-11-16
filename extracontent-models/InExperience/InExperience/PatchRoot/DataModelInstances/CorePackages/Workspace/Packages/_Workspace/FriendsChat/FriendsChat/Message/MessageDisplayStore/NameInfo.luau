return {
	isNameLoading = function(p): boolean
		local name

		if p ~= nil then
			name = p.name
		end

		return name == nil or name == ""
	end
}
