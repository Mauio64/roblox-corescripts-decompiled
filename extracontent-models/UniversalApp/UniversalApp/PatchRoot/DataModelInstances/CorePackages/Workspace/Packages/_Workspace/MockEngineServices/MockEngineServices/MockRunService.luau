local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		RenderStepped = {
			callCallbacksWith = function(p2, p3) -- line: 7
				for _, v7 in p2.callbacks do
					v7(p3)
				end
			end,
			callbacks = {},
			Connect = function(p4, p5) -- line: 13
				local callbacks = p4.callbacks

				table.insert(callbacks, p5)

				return {
					Disconnect = function() -- line: 17
						-- upvalues: callbacks (copy), p5 (copy)
						for v11, v12 in callbacks do
							if v12 == p5 then
								table.remove(callbacks, v11)
							end
						end
					end
				}
			end
		},
		Heartbeat = game:GetService("RunService").Heartbeat
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end

return t1
