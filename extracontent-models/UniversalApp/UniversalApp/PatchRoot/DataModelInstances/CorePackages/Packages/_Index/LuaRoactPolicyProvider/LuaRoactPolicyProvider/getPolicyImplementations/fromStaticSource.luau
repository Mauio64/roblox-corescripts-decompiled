local function noOpt() -- line: 1
end

return function() -- line: 3
	-- upvalues: noOpt (copy)
	return function(p1) -- line: 4
		-- upvalues: noOpt (copy)
		assert(p1, "expected externalPolicy")

		return {
			read = function() -- line: 8
				-- upvalues: p1 (copy)
				return p1
			end,
			onPolicyChanged = function(p2) -- line: 12
				-- upvalues: noOpt (copy)
				local v4 = p2 or noOpt

				return Instance.new("BindableEvent").Event:Connect(v4)
			end
		}
	end
end
