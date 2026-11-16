local function noOpt() end

return function()
	return function(p)
		assert(p, "expected externalPolicy")

		return {
			read = function()
				return p
			end,
			onPolicyChanged = function(p2)
				return Instance.new("BindableEvent").Event:Connect(p2 or noOpt)
			end
		}
	end
end
