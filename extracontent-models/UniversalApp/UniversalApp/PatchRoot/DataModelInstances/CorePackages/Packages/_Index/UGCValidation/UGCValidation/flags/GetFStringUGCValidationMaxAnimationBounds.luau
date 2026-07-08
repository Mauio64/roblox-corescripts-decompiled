game:DefineFastString("UGCValidationMaxAnimationBounds", "25")

local t1 = {
	asString = function() -- line: 9
		return game:GetFastString("UGCValidationMaxAnimationBounds")
	end
}

function t1.asNumber() -- line: 13
	-- upvalues: t1 (copy)
	return (tonumber(t1.asString()))
end

return t1
