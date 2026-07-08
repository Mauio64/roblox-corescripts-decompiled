game:DefineFastString("UGCValidateFrameDeltaKeyTimeTol", "0.85")

local t1 = {
	asString = function() -- line: 9
		return game:GetFastString("UGCValidateFrameDeltaKeyTimeTol")
	end
}

function t1.asNumber() -- line: 13
	-- upvalues: t1 (copy)
	return (tonumber(t1.asString()))
end

return t1
