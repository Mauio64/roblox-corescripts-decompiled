game:DefineFastString("UGCValidationMaxAnimationDeltas", "1.5")

local t1 = {
	asString = function() -- line: 9
		return game:GetFastString("UGCValidationMaxAnimationDeltas")
	end
}

function t1.asNumber() -- line: 13
	-- upvalues: t1 (copy)
	return (tonumber(t1.asString()))
end

return t1
